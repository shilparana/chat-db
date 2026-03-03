import psycopg2
import pymysql
from pymongo import MongoClient
from typing import Dict, List, Any, Optional
from app.config import DATABASE_CONFIGS

class DatabaseConnector:
    def __init__(self, db_name: str):
        self.db_name = db_name
        self.config = DATABASE_CONFIGS.get(db_name)
        if not self.config:
            raise ValueError(f"Database {db_name} not found in configuration")
        
        self.db_type = self.config["type"]
        self.connection = None
    
    def connect(self):
        if self.db_type == "postgresql":
            self.connection = psycopg2.connect(
                host=self.config["host"],
                port=self.config["port"],
                database=self.config["database"],
                user=self.config["user"],
                password=self.config["password"]
            )
        elif self.db_type == "mysql":
            self.connection = pymysql.connect(
                host=self.config["host"],
                port=self.config["port"],
                database=self.config["database"],
                user=self.config["user"],
                password=self.config["password"],
                cursorclass=pymysql.cursors.DictCursor
            )
        elif self.db_type == "mongodb":
            connection_string = f"mongodb://{self.config['user']}:{self.config['password']}@{self.config['host']}:{self.config['port']}/{self.config['database']}?authSource=admin"
            self.connection = MongoClient(connection_string)
    
    def execute_query(self, query: str, params: Optional[tuple] = None) -> List[Dict[str, Any]]:
        if not self.connection:
            self.connect()
        
        if self.db_type in ["postgresql", "mysql"]:
            cursor = self.connection.cursor()
            try:
                if params:
                    cursor.execute(query, params)
                else:
                    cursor.execute(query)
                
                if cursor.description:
                    if self.db_type == "postgresql":
                        # PostgreSQL needs manual dict conversion
                        columns = [desc[0] for desc in cursor.description]
                        results = [dict(zip(columns, row)) for row in cursor.fetchall()]
                    else:
                        # MySQL with DictCursor already returns dicts
                        results = cursor.fetchall()
                    return results
                else:
                    self.connection.commit()
                    return [{"affected_rows": cursor.rowcount}]
            except Exception as e:
                self.connection.rollback()
                raise e
            finally:
                cursor.close()
        
        elif self.db_type == "mongodb":
            raise ValueError("MongoDB queries should use execute_mongodb_query method")
    
    def execute_mongodb_query(self, collection: str, operation: str, query: Dict = None, projection: Dict = None, limit: int = 100) -> List[Dict[str, Any]]:
        if not self.connection:
            self.connect()
        
        db = self.connection[self.config["database"]]
        coll = db[collection]
        
        if operation == "find":
            cursor = coll.find(query or {}, projection)
            if limit:
                cursor = cursor.limit(limit)
            results = list(cursor)
            for result in results:
                if '_id' in result:
                    result['_id'] = str(result['_id'])
            return results
        
        elif operation == "aggregate":
            results = list(coll.aggregate(query or []))
            for result in results:
                if '_id' in result:
                    result['_id'] = str(result['_id'])
            return results
        
        elif operation == "count":
            count = coll.count_documents(query or {})
            return [{"count": count}]
        
        else:
            raise ValueError(f"Unsupported MongoDB operation: {operation}")
    
    def get_schema(self) -> Dict[str, Any]:
        if not self.connection:
            self.connect()
        
        if self.db_type == "postgresql":
            query = """
                SELECT 
                    table_name,
                    column_name,
                    data_type,
                    is_nullable
                FROM information_schema.columns
                WHERE table_schema = 'public'
                ORDER BY table_name, ordinal_position
            """
            results = self.execute_query(query)
            
            schema = {}
            for row in results:
                table = row['table_name']
                if table not in schema:
                    schema[table] = []
                schema[table].append({
                    'column': row['column_name'],
                    'type': row['data_type'],
                    'nullable': row['is_nullable'] == 'YES'
                })
            return schema
        
        elif self.db_type == "mysql":
            query = """
                SELECT 
                    TABLE_NAME,
                    COLUMN_NAME,
                    DATA_TYPE,
                    IS_NULLABLE
                FROM information_schema.columns
                WHERE table_schema = %s
                ORDER BY TABLE_NAME, ORDINAL_POSITION
            """
            results = self.execute_query(query, (self.config["database"],))
            
            schema = {}
            for row in results:
                table = row['TABLE_NAME']
                if table not in schema:
                    schema[table] = []
                schema[table].append({
                    'column': row['COLUMN_NAME'],
                    'type': row['DATA_TYPE'],
                    'nullable': row['IS_NULLABLE'] == 'YES'
                })
            return schema
        
        elif self.db_type == "mongodb":
            db = self.connection[self.config["database"]]
            collections = db.list_collection_names()
            
            schema = {}
            for collection in collections:
                sample = db[collection].find_one()
                if sample:
                    schema[collection] = list(sample.keys())
            return schema
    
    def close(self):
        if self.connection:
            if self.db_type in ["postgresql", "mysql"]:
                self.connection.close()
            elif self.db_type == "mongodb":
                self.connection.close()
            self.connection = None

class DatabaseManager:
    def __init__(self):
        self.connectors: Dict[str, DatabaseConnector] = {}
    
    def get_connector(self, db_name: str) -> DatabaseConnector:
        if db_name not in self.connectors:
            self.connectors[db_name] = DatabaseConnector(db_name)
        return self.connectors[db_name]
    
    def get_all_databases(self) -> List[Dict[str, str]]:
        return [
            {
                "name": name,
                "type": config["type"],
                "description": config["description"]
            }
            for name, config in DATABASE_CONFIGS.items()
        ]
    
    def close_all(self):
        for connector in self.connectors.values():
            connector.close()
        self.connectors.clear()

db_manager = DatabaseManager()
