from langchain_core.messages import SystemMessage, HumanMessage
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

def process_query(user_query: str) -> dict:
    tool_calls_made = []
    max_retries = 3
    
    databases_info = get_available_databases()
    
    step1_prompt = f"""You are a SQL expert. Based on this question: "{user_query}"

Available databases:
{databases_info}

Which database should be queried? Respond with ONLY the database name (e.g., postgres-ecommerce, mysql-crm, mongodb-analytics).
If listing databases, respond with: LIST_ALL"""
    
    response1 = llm_manager.invoke([SystemMessage(content=step1_prompt)])
    db_choice = response1.content.strip()
    
    if "LIST" in db_choice.upper():
        return {
            "query": user_query,
            "response": databases_info,
            "tool_calls": [{"tool": "get_available_databases", "args": {}}],
            "iterations": 1
        }
    
    db_name = None
    for line in db_choice.split('\n'):
        if any(db in line for db in ['postgres-', 'mysql-', 'mariadb-', 'mongodb-']):
            match = re.search(r'(postgres-\w+|mysql-\w+|mariadb-\w+|mongodb-\w+)', line)
            if match:
                db_name = match.group(1)
                break
    
    if not db_name:
        return {
            "query": user_query,
            "response": f"Could not determine which database to use. Agent suggested: {db_choice}",
            "tool_calls": [],
            "iterations": 1
        }
    
    schema_info = get_database_schema(db_name)
    tool_calls_made.append({"tool": "get_database_schema", "args": {"database_name": db_name}})
    
    if db_name.startswith('mongodb-'):
        error_context = ""
        
        for retry in range(max_retries):
            step2_prompt = f"""Generate a MongoDB query for: "{user_query}"

Database: {db_name}
Schema: {schema_info[:2000]}

{error_context}

Respond with ONLY the query in this exact format:
collection_name|||operation|||query_json

Example: user_sessions|||find|||{{"duration_seconds": {{"$gt": 1800}}}}

Operations: find, aggregate, count"""
            
            response2 = llm_manager.invoke([SystemMessage(content=step2_prompt)])
            query_line = response2.content.strip()
            
            parts = query_line.split('|||')
            if len(parts) >= 3:
                collection = parts[0].strip()
                operation = parts[1].strip()
                query_json = parts[2].strip() if len(parts) > 2 else "{}"
                
                result = execute_mongodb_query(db_name, collection, operation, query_json)
                tool_calls_made.append({
                    "tool": "execute_mongodb_query",
                    "args": {"database": db_name, "collection": collection, "operation": operation, "retry": retry}
                })
                
                if "Error" in result:
                    error_context = f"\nPrevious query failed:\nCollection: {collection}\nOperation: {operation}\nQuery: {query_json}\nError: {result}\n\nPlease fix the query. Check collection name and query syntax."
                    continue
                
                step3_prompt = f"""You are answering a question for a non-technical user. Format these results in a friendly, easy-to-understand way.

Question: {user_query}
Results: {result[:2000]}

Instructions:
- Use simple, everyday language (avoid technical terms)
- Present data in a clear, organized format
- Highlight the key findings first
- Use natural language, as if explaining to a friend
- Do not mention databases, collections, or technical details
- Focus on answering the question directly

Example: I found 2 user sessions over 30 minutes:
1. User from New York - 45 minutes on desktop
2. User from London - 45 minutes on mobile"""
                
                response3 = llm_manager.invoke([SystemMessage(content=step3_prompt)])
                
                return {
                    "query": user_query,
                    "response": response3.content,
                    "tool_calls": tool_calls_made,
                    "iterations": 3 + retry,
                    "retries": retry
                }
        
        return {
            "query": user_query,
            "response": f"I'm having trouble finding that information. Could you try asking in a different way?",
            "tool_calls": tool_calls_made,
            "iterations": 3 + max_retries,
            "retries": max_retries
        }
    
    else:
        error_context = ""
        
        for retry in range(max_retries):
            step2_prompt = f"""Generate a SQL SELECT query for: "{user_query}"

Database: {db_name}
Schema: {schema_info[:2000]}

Important:
- Use JOINs when data is in multiple tables
- Use proper column names from the schema
- Include LIMIT clause for top N queries
- Use aggregate functions (COUNT, SUM, AVG) when needed
- Check column names carefully in the schema

{error_context}

Respond with ONLY the SQL query, no explanations.
Example: SELECT p.product_name, p.price FROM products p ORDER BY p.price DESC LIMIT 5"""
            
            response2 = llm_manager.invoke([SystemMessage(content=step2_prompt)])
            sql_query = response2.content.strip()
            
            sql_query = sql_query.replace('```sql', '').replace('```', '').strip()
            
            validation = validate_sql_query(sql_query)
            if "INVALID" in validation:
                error_context = f"\nPrevious attempt failed validation: {validation}\nPlease fix the query."
                continue
            
            result = execute_sql_query(db_name, sql_query)
            tool_calls_made.append({
                "tool": "execute_sql_query",
                "args": {"database": db_name, "query": sql_query, "retry": retry}
            })
            
            if "Error" in result:
                error_context = f"\nPrevious query failed:\nQuery: {sql_query}\nError: {result}\n\nPlease fix the query based on this error. Check:\n- Column names exist in schema\n- Table names are correct\n- JOINs are needed for related data\n- Aggregate functions used correctly"
                continue
            
            step3_prompt = f"""You are answering a question for a non-technical user. Format these database results in a friendly, easy-to-understand way.

Question: {user_query}
Results: {result[:2000]}

Instructions:
- Use simple, everyday language (avoid technical terms like database, query, table)
- Present data in a clear, organized format (use bullet points or numbered lists)
- Highlight the key findings first
- Use natural language, as if explaining to a friend
- Do not mention SQL, databases, or technical details
- Focus on answering the question directly

Example good response:
Here are the top 5 products by price:
1. Laptop Pro - $1,299.99
2. Smartphone X - $899.99

NOT like this:
The SQL query returned the following results from the products table..."""
            
            response3 = llm_manager.invoke([SystemMessage(content=step3_prompt)])
            
            return {
                "query": user_query,
                "response": response3.content,
                "tool_calls": tool_calls_made,
                "iterations": 3 + retry,
                "retries": retry
            }
        
        return {
            "query": user_query,
            "response": f"I'm having trouble finding that information. Could you try rephrasing your question or being more specific about what you're looking for?",
            "tool_calls": tool_calls_made,
            "iterations": 3 + max_retries,
            "retries": max_retries
        }
    
    return {
        "query": user_query,
        "response": "Unable to process query",
        "tool_calls": tool_calls_made,
        "iterations": 2
    }
