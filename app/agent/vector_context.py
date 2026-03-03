"""
Vector-enhanced context provider for query processing
"""

from app.vector_store import vector_store
import logging

logger = logging.getLogger(__name__)

def get_vector_enhanced_context(query: str) -> str:
    """
    Get vector-based schema context for a query
    Returns formatted context string with relevant databases, tables, and columns
    """
    try:
        vector_context = vector_store.get_database_context(query)
        
        if vector_context:
            return f"\n**Relevant Schema Context (from vector search):**\n{vector_context}\n"
        
        return ""
    except Exception as e:
        logger.warning(f"Vector context retrieval failed: {e}")
        return ""

def get_top_databases_for_query(query: str, n: int = 3) -> list:
    """
    Get top N most relevant databases for a query using vector search
    Returns list of database names
    """
    try:
        results = vector_store.search_schemas(query, n_results=n * 3)
        
        # Extract unique databases
        databases = []
        seen = set()
        
        for result in results:
            metadata = result.get('metadata', {})
            db_name = metadata.get('database', '')
            
            if db_name and db_name not in seen:
                databases.append(db_name)
                seen.add(db_name)
                
                if len(databases) >= n:
                    break
        
        return databases
    except Exception as e:
        logger.warning(f"Database recommendation failed: {e}")
        return []
