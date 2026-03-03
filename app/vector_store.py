"""
Vector store for schema context using ChromaDB
Enables semantic search for database/table/column discovery
"""

import chromadb
import logging
from typing import List, Dict, Any
from app.config import DATABASE_CONFIGS
from app.database.connectors import db_manager
import os
import warnings

# Disable ChromaDB telemetry to suppress warnings
os.environ["ANONYMIZED_TELEMETRY"] = "False"
os.environ["CHROMA_TELEMETRY_IMPL"] = "none"

# Suppress ChromaDB warnings
warnings.filterwarnings("ignore", category=UserWarning, module="chromadb")
logging.getLogger("chromadb.telemetry.product.posthog").setLevel(logging.CRITICAL)
logging.getLogger("chromadb.segment.impl.vector.local_persistent_hnsw").setLevel(logging.ERROR)
logging.getLogger("chromadb.segment.impl.metadata.sqlite").setLevel(logging.ERROR)

logger = logging.getLogger(__name__)

class SchemaVectorStore:
    """Manages vector embeddings for database schema context"""
    
    def __init__(self, persist_directory: str = "./chroma_db"):
        """Initialize ChromaDB client with local persistence"""
        try:
            # Use simple embedding function to avoid onnxruntime DLL issues on Windows
            from chromadb.utils import embedding_functions
            
            # Create persistent client (new API for ChromaDB 0.4.22+)
            self.client = chromadb.PersistentClient(path=persist_directory)
            
            # Use default embedding function (will use onnxruntime if available)
            self.embedding_function = embedding_functions.DefaultEmbeddingFunction()
            
            # Get or create collection
            try:
                self.collection = self.client.get_collection(
                    name="schema_context",
                    embedding_function=self.embedding_function
                )
                logger.info("✅ Loaded existing ChromaDB collection")
            except:
                self.collection = self.client.create_collection(
                    name="schema_context",
                    embedding_function=self.embedding_function,
                    metadata={"hnsw:space": "cosine"}
                )
                logger.info("✅ Created new ChromaDB collection")
            
        except Exception as e:
            logger.error(f"❌ Failed to initialize ChromaDB: {e}")
            import traceback
            logger.error(traceback.format_exc())
            self.client = None
            self.collection = None
    
    def _parse_schema_comments(self, db_name: str) -> Dict[str, str]:
        """Parse comments from init script files"""
        comments = {}
        init_script_path = f"./init-scripts/{db_name}"
        
        if not os.path.exists(init_script_path):
            return comments
        
        try:
            # Find schema files only (exclude data files)
            for filename in os.listdir(init_script_path):
                # Only read schema files: 01-init.sql or init.js
                # Skip data files: 02-data.sql or data.js
                if filename in ['01-init.sql', 'init.js']:
                    filepath = os.path.join(init_script_path, filename)
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # Extract table/collection comments (lines starting with --)
                    lines = content.split('\n')
                    current_comment = []
                    for i, line in enumerate(lines):
                        stripped = line.strip()
                        
                        # Collect comment lines
                        if stripped.startswith('--'):
                            comment_text = stripped[2:].strip()
                            # Skip separator lines
                            if not all(c in '-=' for c in comment_text):
                                current_comment.append(comment_text)
                        
                        # When we hit CREATE TABLE/COLLECTION, save the comment
                        elif stripped.startswith('CREATE TABLE') or stripped.startswith('db.createCollection'):
                            if current_comment:
                                # Extract table/collection name
                                if 'CREATE TABLE' in stripped:
                                    table_name = stripped.split('CREATE TABLE')[1].split('(')[0].strip()
                                    comments[f"table_{table_name}"] = ' '.join(current_comment)
                                current_comment = []
                        
                        # Reset comment buffer on non-comment, non-CREATE lines
                        elif not stripped.startswith('--') and stripped and not stripped.startswith('CREATE'):
                            current_comment = []
        
        except Exception as e:
            logger.warning(f"Could not parse comments from {db_name}: {e}")
        
        return comments
    
    def index_all_schemas(self):
        """Index all database schemas with rich context"""
        if not self.collection:
            logger.error("ChromaDB not available, skipping indexing")
            return
        
        logger.info("Starting schema indexing...")
        documents = []
        metadatas = []
        ids = []
        
        for db_name, db_config in DATABASE_CONFIGS.items():
            try:
                # Get schema from database (structure only, no data)
                connector = db_manager.get_connector(db_name)
                schema = connector.get_schema()
                
                # Parse comments from init scripts
                schema_comments = self._parse_schema_comments(db_name)
                
                db_type = db_config.get("type", "unknown")
                db_description = db_config.get("description", "")
                
                # Index database-level context
                db_doc = f"Database: {db_name}\nType: {db_type}\nDescription: {db_description}"
                documents.append(db_doc)
                metadatas.append({
                    "type": "database",
                    "database": db_name,
                    "db_type": db_type
                })
                ids.append(f"db_{db_name}")
                
                # Index table and column context
                if db_type == "mongodb":
                    # MongoDB collections - schema is a dict of collection_name -> list of field names
                    if isinstance(schema, dict):
                        for collection_name, fields in schema.items():
                            if not isinstance(fields, list):
                                continue
                            
                            # Create rich collection context with all fields
                            field_list = ', '.join(fields)
                            comment_key = f"table_{collection_name}"
                            table_comment = schema_comments.get(comment_key, self._infer_table_purpose(collection_name, fields))
                            
                            coll_doc = f"""Database: {db_name}
Collection: {collection_name}
Type: MongoDB
Description: {db_description}
Fields: {field_list}
Context: {table_comment}"""
                            
                            documents.append(coll_doc)
                            metadatas.append({
                                "type": "collection",
                                "database": db_name,
                                "collection": collection_name,
                                "field_count": len(fields)
                            })
                            ids.append(f"{db_name}_coll_{collection_name}")
                            
                            # Index individual fields for detailed queries
                            for field_name in fields:
                                if not field_name or field_name == '_id':  # Skip MongoDB's internal _id
                                    continue
                                    
                                field_doc = f"""Database: {db_name}
Collection: {collection_name}
Field: {field_name}
Type: MongoDB
Context: {self._infer_column_purpose(field_name, collection_name)}"""
                                
                                documents.append(field_doc)
                                metadatas.append({
                                    "type": "field",
                                    "database": db_name,
                                    "collection": collection_name,
                                    "field": field_name
                                })
                                ids.append(f"{db_name}_{collection_name}_{field_name}")
                else:
                    # SQL tables - schema is a dict of table_name -> list of column dicts
                    if isinstance(schema, dict):
                        for table_name, columns in schema.items():
                            if not isinstance(columns, list):
                                continue
                                
                            column_names = [col.get("column", col.get("name", col.get("COLUMN_NAME", col.get("TABLE_NAME", "")))) for col in columns if isinstance(col, dict)]
                            column_types = [f"{col.get('column', col.get('name', col.get('COLUMN_NAME', col.get('TABLE_NAME', ''))))} ({col.get('type', col.get('DATA_TYPE', ''))})" 
                                          for col in columns if isinstance(col, dict)]
                            
                            # Create rich table context
                            comment_key = f"table_{table_name}"
                            table_comment = schema_comments.get(comment_key, self._infer_table_purpose(table_name, column_names))
                            
                            table_doc = f"""Database: {db_name}
Table: {table_name}
Type: {db_type}
Description: {db_description}
Columns: {', '.join(column_types)}
Context: {table_comment}"""
                            
                            documents.append(table_doc)
                            metadatas.append({
                                "type": "table",
                                "database": db_name,
                                "table": table_name,
                                "column_count": len(column_names)
                            })
                            ids.append(f"{db_name}_table_{table_name}")
                            
                            # Index individual columns for detailed queries
                            for col in columns:
                                if not isinstance(col, dict):
                                    continue
                                col_name = col.get("column", col.get("name", col.get("COLUMN_NAME", col.get("TABLE_NAME", ""))))
                                col_type = col.get("type", col.get("DATA_TYPE", ""))
                                if not col_name:
                                    continue
                                    
                                col_doc = f"""Database: {db_name}
Table: {table_name}
Column: {col_name}
Type: {col_type}
Context: {self._infer_column_purpose(col_name, table_name)}"""
                                
                                documents.append(col_doc)
                                metadatas.append({
                                    "type": "column",
                                    "database": db_name,
                                    "table": table_name,
                                    "column": col_name,
                                    "data_type": col_type
                                })
                                ids.append(f"{db_name}_{table_name}_{col_name}")
                
                logger.info(f"✅ Indexed schema for {db_name}")
                
            except Exception as e:
                logger.error(f"❌ Failed to index {db_name}: {e}")
                continue
        
        # Batch insert all documents
        if documents:
            try:
                self.collection.add(
                    documents=documents,
                    metadatas=metadatas,
                    ids=ids
                )
                logger.info(f"✅ Indexed {len(documents)} schema elements in vector store")
            except Exception as e:
                logger.error(f"❌ Failed to add documents to ChromaDB: {e}")
    
    def search_schemas(self, query: str, n_results: int = 5) -> List[Dict[str, Any]]:
        """Search for relevant schemas using semantic similarity"""
        if not self.collection:
            logger.warning("ChromaDB not available, returning empty results")
            return []
        
        try:
            results = self.collection.query(
                query_texts=[query],
                n_results=n_results
            )
            
            # Format results
            formatted_results = []
            if results and results['metadatas'] and len(results['metadatas']) > 0:
                for i, metadata in enumerate(results['metadatas'][0]):
                    formatted_results.append({
                        "metadata": metadata,
                        "document": results['documents'][0][i] if results['documents'] else "",
                        "distance": results['distances'][0][i] if results.get('distances') else 0
                    })
            
            return formatted_results
            
        except Exception as e:
            logger.error(f"❌ Vector search failed: {e}")
            return []
    
    def get_database_context(self, query: str) -> str:
        """Get enriched database context for a query"""
        results = self.search_schemas(query, n_results=10)
        
        if not results:
            return ""
        
        # Group by database
        db_contexts = {}
        for result in results:
            metadata = result['metadata']
            db_name = metadata.get('database', '')
            
            if db_name not in db_contexts:
                db_contexts[db_name] = {
                    'tables': set(),
                    'columns': set(),
                    'relevance': result.get('distance', 1.0)
                }
            
            if metadata.get('type') == 'table':
                db_contexts[db_name]['tables'].add(metadata.get('table', ''))
            elif metadata.get('type') == 'column':
                db_contexts[db_name]['columns'].add(
                    f"{metadata.get('table', '')}.{metadata.get('column', '')}"
                )
        
        # Format context
        context_parts = []
        for db_name, info in sorted(db_contexts.items(), key=lambda x: x[1]['relevance']):
            context = f"**{db_name}**"
            if info['tables']:
                context += f"\n  Tables: {', '.join(sorted(info['tables']))}"
            if info['columns']:
                context += f"\n  Relevant columns: {', '.join(sorted(list(info['columns']))[:5])}"
            context_parts.append(context)
        
        return "\n\n".join(context_parts[:5])
    
    def _infer_table_purpose(self, table_name: str, columns: List[str]) -> str:
        """Infer table purpose from name and columns"""
        table_lower = table_name.lower()
        cols_lower = [c.lower() for c in columns]
        
        # Common patterns
        if 'employee' in table_lower or 'staff' in table_lower:
            return "Stores employee/staff information including personal details, roles, and employment data"
        elif 'customer' in table_lower or 'client' in table_lower:
            return "Stores customer/client information and contact details"
        elif 'product' in table_lower or 'item' in table_lower:
            return "Stores product/item catalog with pricing and inventory"
        elif 'order' in table_lower or 'purchase' in table_lower:
            return "Stores order/purchase transactions and details"
        elif 'attendance' in table_lower:
            return "Tracks employee attendance, check-in/out times, and work hours"
        elif 'payroll' in table_lower or 'salary' in table_lower:
            return "Manages payroll, salary payments, and compensation"
        elif 'leave' in table_lower or 'vacation' in table_lower:
            return "Manages leave requests, vacation days, and time off"
        elif 'department' in table_lower:
            return "Stores organizational department information"
        elif 'user' in table_lower or 'account' in table_lower:
            return "Stores user accounts and authentication data"
        else:
            return f"Stores {table_name} related data"
    
    def _infer_column_purpose(self, column_name: str, table_name: str) -> str:
        """Infer column purpose from name"""
        col_lower = column_name.lower()
        
        if 'email' in col_lower:
            return "Email address for contact"
        elif 'phone' in col_lower:
            return "Phone number for contact"
        elif 'name' in col_lower:
            return "Name identifier"
        elif 'date' in col_lower:
            return "Date/timestamp field"
        elif 'salary' in col_lower or 'pay' in col_lower:
            return "Compensation/payment amount"
        elif 'status' in col_lower:
            return "Status indicator"
        elif 'department' in col_lower:
            return "Department/division identifier"
        elif 'manager' in col_lower:
            return "Manager/supervisor reference"
        elif 'title' in col_lower or 'position' in col_lower:
            return "Job title/position"
        else:
            return f"Field in {table_name} table"

# Global instance
vector_store = SchemaVectorStore()
