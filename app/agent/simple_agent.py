from langchain_core.messages import SystemMessage, HumanMessage, AIMessage
from app.agent.tools import (
    get_available_databases, 
    get_database_schema, 
    execute_sql_query,
    execute_mongodb_query,
    validate_sql_query
)
from app.llm_manager import llm_manager
import json
import re

SYSTEM_PROMPT = """You are an expert SQL assistant that helps users query data from 20+ databases.

Available databases:
- PostgreSQL: postgres-ecommerce, postgres-finance, postgres-healthcare, postgres-logistics, postgres-hr
- MySQL: mysql-crm, mysql-inventory, mysql-sales, mysql-marketing, mysql-support
- MariaDB: mariadb-education, mariadb-gaming, mariadb-travel, mariadb-realestate, mariadb-events
- MongoDB: mongodb-analytics, mongodb-logs, mongodb-social, mongodb-iot, mongodb-content

Your workflow:
1. Identify which database(s) the user needs
2. Get the schema for that database
3. Generate the appropriate SQL or MongoDB query
4. Execute the query and return results

Important:
- Only use SELECT queries (read-only)
- For MongoDB, use format: database|||collection|||operation|||query
- For SQL, use format: database|||query
- Always validate SQL queries before execution
- Present results clearly

When responding, follow this structure:
1. Explain which database you're querying
2. Show the query you're executing
3. Present the results in a clear format
"""

def process_query(user_query: str) -> dict:
    conversation = [
        SystemMessage(content=SYSTEM_PROMPT),
        HumanMessage(content=user_query)
    ]
    
    max_iterations = 5
    iteration = 0
    tool_calls_made = []
    
    while iteration < max_iterations:
        iteration += 1
        
        response = llm_manager.invoke(conversation)
        conversation.append(response)
        
        content = response.content.lower()
        
        if "list" in content and "database" in content and iteration == 1:
            databases = get_available_databases()
            tool_calls_made.append({"tool": "get_available_databases", "args": {}})
            conversation.append(HumanMessage(content=f"Available databases:\n{databases}"))
            continue
        
        if "schema" in content or "table" in content or "structure" in content:
            db_match = re.search(r'(postgres-\w+|mysql-\w+|mariadb-\w+|mongodb-\w+)', content)
            if db_match:
                db_name = db_match.group(1)
                schema = get_database_schema(db_name)
                tool_calls_made.append({"tool": "get_database_schema", "args": {"database_name": db_name}})
                conversation.append(HumanMessage(content=f"Schema for {db_name}:\n{schema[:2000]}"))
                continue
        
        if "select" in content and ("from" in content or "|||" in content):
            query_match = re.search(r'```(?:sql)?\s*(.*?)\s*```', response.content, re.DOTALL | re.IGNORECASE)
            if query_match:
                query_text = query_match.group(1).strip()
                
                if "|||" in query_text:
                    parts = query_text.split("|||")
                    if len(parts) >= 2:
                        db_name = parts[0].strip()
                        sql_query = parts[1].strip()
                        
                        validation = validate_sql_query(sql_query)
                        if "VALID" in validation:
                            result = execute_sql_query(db_name, sql_query)
                            tool_calls_made.append({
                                "tool": "execute_sql_query",
                                "args": {"database": db_name, "query": sql_query}
                            })
                            conversation.append(HumanMessage(content=f"Query results:\n{result[:3000]}"))
                            continue
        
        if "find" in content or "aggregate" in content:
            if "|||" in response.content:
                query_match = re.search(r'```\s*(.*?)\s*```', response.content, re.DOTALL)
                if query_match:
                    query_parts = query_match.group(1).strip().split("|||")
                    if len(query_parts) >= 3:
                        db_name = query_parts[0].strip()
                        collection = query_parts[1].strip()
                        operation = query_parts[2].strip()
                        query_json = query_parts[3].strip() if len(query_parts) > 3 else "{}"
                        
                        result = execute_mongodb_query(db_name, collection, operation, query_json)
                        tool_calls_made.append({
                            "tool": "execute_mongodb_query",
                            "args": {
                                "database": db_name,
                                "collection": collection,
                                "operation": operation
                            }
                        })
                        conversation.append(HumanMessage(content=f"Query results:\n{result[:3000]}"))
                        continue
        
        return {
            "query": user_query,
            "response": response.content,
            "tool_calls": tool_calls_made,
            "iterations": iteration
        }
    
    return {
        "query": user_query,
        "response": "Maximum iterations reached. Please try a more specific question.",
        "tool_calls": tool_calls_made,
        "iterations": iteration
    }
