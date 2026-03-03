from typing import Dict, List, Any, Optional
from langchain.tools import Tool
from app.database.connectors import db_manager
import json

def get_available_databases() -> str:
    databases = db_manager.get_all_databases()
    result = "Available databases:\n\n"
    for db in databases:
        result += f"- **{db['name']}** ({db['type']}): {db['description']}\n"
    return result

def get_database_schema(database_name: str) -> str:
    try:
        connector = db_manager.get_connector(database_name)
        schema = connector.get_schema()
        
        result = f"Schema for {database_name}:\n\n"
        for table, columns in schema.items():
            result += f"Table: {table}\n"
            if isinstance(columns, list) and len(columns) > 0 and isinstance(columns[0], dict):
                for col in columns:
                    result += f"  - {col['column']} ({col['type']})\n"
            else:
                result += f"  Fields: {', '.join(columns)}\n"
            result += "\n"
        
        return result
    except Exception as e:
        return f"Error getting schema for {database_name}: {str(e)}"

def execute_sql_query(database_name: str, query: str) -> str:
    try:
        connector = db_manager.get_connector(database_name)
        results = connector.execute_query(query)
        
        if not results:
            return "Query executed successfully. No results returned."
        
        return json.dumps(results, indent=2, default=str)
    except Exception as e:
        return f"Error executing query: {str(e)}"

def execute_mongodb_query(database_name: str, collection: str, operation: str, query: str = None, limit: int = 100) -> str:
    try:
        connector = db_manager.get_connector(database_name)
        
        query_dict = json.loads(query) if query else {}
        
        results = connector.execute_mongodb_query(
            collection=collection,
            operation=operation,
            query=query_dict,
            limit=limit
        )
        
        return json.dumps(results, indent=2, default=str)
    except Exception as e:
        return f"Error executing MongoDB query: {str(e)}"

def validate_sql_query(query: str) -> str:
    dangerous_keywords = ['DROP', 'DELETE', 'TRUNCATE', 'ALTER', 'CREATE', 'INSERT', 'UPDATE']
    
    query_upper = query.upper()
    for keyword in dangerous_keywords:
        if keyword in query_upper:
            return f"INVALID: Query contains dangerous keyword '{keyword}'. Only SELECT queries are allowed."
    
    if not query_upper.strip().startswith('SELECT'):
        return "INVALID: Only SELECT queries are allowed."
    
    return "VALID"

database_list_tool = Tool(
    name="get_available_databases",
    func=get_available_databases,
    description="Get a list of all available databases with their descriptions. Use this to understand which databases are available and what data they contain."
)

schema_tool = Tool(
    name="get_database_schema",
    func=get_database_schema,
    description="Get the schema (tables and columns) for a specific database. Input should be the database name (e.g., 'postgres-ecommerce'). Use this to understand the structure of a database before writing queries."
)

sql_query_tool = Tool(
    name="execute_sql_query",
    func=lambda input_str: execute_sql_query(*input_str.split('|||', 1)),
    description="Execute a SQL query on a specific database. Input format: 'database_name|||SELECT query'. Example: 'postgres-ecommerce|||SELECT * FROM customers LIMIT 10'. Only SELECT queries are allowed."
)

mongodb_query_tool = Tool(
    name="execute_mongodb_query",
    func=lambda input_str: execute_mongodb_query(*input_str.split('|||')),
    description="Execute a MongoDB query. Input format: 'database_name|||collection|||operation|||query_json'. Example: 'mongodb-analytics|||user_sessions|||find|||{\"user_id\": \"user_12345\"}'. Operations: find, aggregate, count."
)

query_validator_tool = Tool(
    name="validate_sql_query",
    func=validate_sql_query,
    description="Validate a SQL query to ensure it's safe to execute. Input should be the SQL query string. Returns VALID or INVALID with reason."
)

AGENT_TOOLS = [
    database_list_tool,
    schema_tool,
    sql_query_tool,
    mongodb_query_tool,
    query_validator_tool
]
