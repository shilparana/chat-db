from langchain_core.messages import SystemMessage, HumanMessage
from app.agent.tools import (
    get_available_databases, 
    get_database_schema, 
    execute_sql_query,
    execute_mongodb_query,
    validate_sql_query
)
from app.agent.query_preprocessor import preprocess_query, enhance_query_with_context
from app.agent.vector_context import get_vector_enhanced_context, get_top_databases_for_query
from app.llm_manager import llm_manager
from app.config import settings
import json
import re
import asyncio
from typing import List, Dict, Any
from concurrent.futures import ThreadPoolExecutor
import time
import logging

logger = logging.getLogger(__name__)

def execute_query_safe(db_name: str, query: str, is_mongodb: bool = False, collection: str = None, operation: str = None) -> Dict[str, Any]:
    """Thread-safe query execution wrapper"""
    try:
        if is_mongodb:
            result = execute_mongodb_query(db_name, collection, operation, query)
        else:
            result = execute_sql_query(db_name, query)
        
        return {
            "database": db_name,
            "success": "Error" not in result,
            "result": result,
            "query": query
        }
    except Exception as e:
        return {
            "database": db_name,
            "success": False,
            "result": f"Error: {str(e)}",
            "query": query
        }

def process_query(user_query: str) -> dict:
    """Enhanced agent with multi-database support and concurrent execution"""
    
    tool_calls_made = []
    start_time = time.time()
    
    # Step 0: Preprocess query (handle typos, translations, etc.)
    preprocessing_result = preprocess_query(user_query)
    tool_calls_made.append({"tool": "query_preprocessing", "args": {
        "original_language": preprocessing_result.get('original_language'),
        "corrections_made": preprocessing_result.get('corrections_made', []),
        "is_english": preprocessing_result.get('is_english', True)
    }})
    
    # Use corrected query for processing
    processed_query = preprocessing_result.get('corrected_query', user_query)
    
    # Step 1: Analyze query complexity and identify required databases
    databases_info = get_available_databases()
    
    # Get vector-enhanced context for better database selection
    vector_context = get_vector_enhanced_context(processed_query)
    
    analysis_prompt = f"""Analyze this question and determine if it requires data from multiple databases: "{processed_query}"

Original query: "{user_query}"
Preprocessed query: "{processed_query}"

{vector_context}

Available databases:
{databases_info}

Respond in JSON format:
{{
    "complexity": "simple" or "complex",
    "databases_needed": ["db1", "db2", ...],
    "reasoning": "brief explanation",
    "requires_join": true/false
}}

If the question can be answered from a single database, mark as "simple".
If it requires combining data from multiple databases, mark as "complex"."""
    
    analysis_response = llm_manager.invoke([SystemMessage(content=analysis_prompt)])
    
    try:
        analysis = json.loads(analysis_response.content.strip().replace('```json', '').replace('```', ''))
    except:
        # Fallback to simple processing
        analysis = {
            "complexity": "simple",
            "databases_needed": [],
            "reasoning": "Could not parse analysis",
            "requires_join": False
        }
    
    tool_calls_made.append({"tool": "query_analysis", "args": analysis})
    
    # Handle simple queries (single database)
    if analysis["complexity"] == "simple" or len(analysis.get("databases_needed", [])) <= 1:
        result = process_simple_query(processed_query, analysis, tool_calls_made, start_time)
        result['original_query'] = user_query
        result['preprocessing'] = preprocessing_result
        return result
    
    # Handle complex queries (multiple databases)
    result = process_complex_query(processed_query, analysis, tool_calls_made, start_time)
    result['original_query'] = user_query
    result['preprocessing'] = preprocessing_result
    return result

def process_simple_query(user_query: str, analysis: Dict, tool_calls_made: List, start_time: float) -> dict:
    """Process queries requiring single database"""
    
    databases_info = get_available_databases()
    max_retries = 3
    
    # Identify database
    db_prompt = f"""Based on this question: "{user_query}"

Available databases:
{databases_info}

Which database should be queried? Respond with ONLY the database name (e.g., postgres-ecommerce, mariadb-education).

Examples:
- "courses" or "enrollments" → mariadb-education
- "products" or "orders" → postgres-ecommerce
- "customers" or "contacts" → mysql-crm
- "employees" → postgres-hr
- "user sessions" → mongodb-analytics

If listing databases, respond with: LIST_ALL"""
    
    db_response = llm_manager.invoke([SystemMessage(content=db_prompt)])
    db_name = db_response.content.strip()
    
    if "LIST" in db_name.upper():
        return {
            "query": user_query,
            "response": databases_info,
            "tool_calls": tool_calls_made,
            "execution_time": time.time() - start_time,
            "complexity": "simple"
        }
    
    # Extract database name
    match = re.search(r'(postgres-\w+|mysql-\w+|mariadb-\w+|mongodb-\w+)', db_name)
    if not match:
        return {
            "query": user_query,
            "response": "Could not determine which database to use.",
            "tool_calls": tool_calls_made,
            "execution_time": time.time() - start_time,
            "complexity": "simple"
        }
    
    db_name = match.group(1)
    schema_info = get_database_schema(db_name)
    tool_calls_made.append({"tool": "get_database_schema", "args": {"database": db_name}})
    
    # Generate and execute query with retries
    for retry in range(max_retries):
        if db_name.startswith('mongodb-'):
            result = execute_mongodb_with_retry(user_query, db_name, schema_info, retry, tool_calls_made)
        else:
            result = execute_sql_with_retry(user_query, db_name, schema_info, retry, tool_calls_made)
        
        if result["success"]:
            # Format response
            format_prompt = f"""Format this for a non-technical user:

Question: {user_query}
Results: {result['data'][:2000]}

Use simple language, clear formatting, and focus on answering the question directly."""
            
            formatted = llm_manager.invoke([SystemMessage(content=format_prompt)])
            
            return {
                "query": user_query,
                "response": formatted.content,
                "tool_calls": tool_calls_made,
                "execution_time": time.time() - start_time,
                "complexity": "simple",
                "retries": retry
            }
    
    return {
        "query": user_query,
        "response": "I'm having trouble finding that information. Could you try rephrasing your question?",
        "tool_calls": tool_calls_made,
        "execution_time": time.time() - start_time,
        "complexity": "simple"
    }

def process_complex_query(user_query: str, analysis: Dict, tool_calls_made: List, start_time: float) -> dict:
    """Process queries requiring multiple databases with concurrent execution"""
    
    databases_needed = analysis.get("databases_needed", [])
    
    # Step 1: Get schemas concurrently
    schema_start = time.time()
    schemas = {}
    
    with ThreadPoolExecutor(max_workers=min(len(databases_needed), 5)) as executor:
        future_to_db = {
            executor.submit(get_database_schema, db): db 
            for db in databases_needed
        }
        
        for future in future_to_db:
            db = future_to_db[future]
            try:
                schemas[db] = future.result()
                tool_calls_made.append({"tool": "get_database_schema", "args": {"database": db}})
            except Exception as e:
                schemas[db] = f"Error: {str(e)}"
    
    schema_time = time.time() - schema_start
    
    # Step 2: Generate query plan for each database
    plan_prompt = f"""Create a query plan for this complex question: "{user_query}"

Databases and their schemas:
{json.dumps({db: schemas[db][:500] for db in databases_needed}, indent=2)}

Generate queries for each database. Respond in JSON:
{{
    "queries": [
        {{
            "database": "db_name",
            "purpose": "what data to get",
            "query": "SQL or MongoDB query",
            "is_mongodb": false,
            "collection": null,
            "operation": null
        }}
    ],
    "combination_strategy": "how to combine results"
}}"""
    
    plan_response = llm_manager.invoke([SystemMessage(content=plan_prompt)])
    
    try:
        plan = json.loads(plan_response.content.strip().replace('```json', '').replace('```', ''))
    except:
        return {
            "query": user_query,
            "response": "I'm having trouble planning how to answer this complex question.",
            "tool_calls": tool_calls_made,
            "execution_time": time.time() - start_time,
            "complexity": "complex"
        }
    
    tool_calls_made.append({"tool": "query_planning", "args": {"num_queries": len(plan.get("queries", []))}})
    
    # Step 3: Execute queries concurrently
    exec_start = time.time()
    results = []
    
    with ThreadPoolExecutor(max_workers=min(len(plan["queries"]), 5)) as executor:
        futures = []
        
        for query_plan in plan["queries"]:
            db = query_plan["database"]
            query = query_plan["query"]
            is_mongodb = query_plan.get("is_mongodb", False)
            
            if is_mongodb:
                future = executor.submit(
                    execute_query_safe,
                    db,
                    query,
                    True,
                    query_plan.get("collection"),
                    query_plan.get("operation", "find")
                )
            else:
                future = executor.submit(execute_query_safe, db, query, False)
            
            futures.append(future)
        
        for future in futures:
            try:
                result = future.result(timeout=30)
                results.append(result)
                tool_calls_made.append({
                    "tool": "execute_query_concurrent",
                    "args": {"database": result["database"], "success": result["success"]}
                })
            except Exception as e:
                results.append({"success": False, "result": f"Timeout or error: {str(e)}"})
    
    exec_time = time.time() - exec_start
    
    # Step 4: Combine and format results
    successful_results = [r for r in results if r["success"]]
    
    if not successful_results:
        return {
            "query": user_query,
            "response": "I encountered errors while querying the databases. Please try again.",
            "tool_calls": tool_calls_made,
            "execution_time": time.time() - start_time,
            "complexity": "complex",
            "schema_fetch_time": schema_time,
            "query_execution_time": exec_time
        }
    
    # Combine results
    combined_data = "\n\n".join([
        f"From {r['database']}:\n{r['result'][:1000]}"
        for r in successful_results
    ])
    
    final_prompt = f"""Combine these results to answer the user's question in a friendly, non-technical way:

Question: {user_query}

Results from multiple sources:
{combined_data[:3000]}

Combination strategy: {plan.get('combination_strategy', 'Merge the data logically')}

Instructions:
- Synthesize information from all sources
- Use simple, everyday language
- Present a cohesive answer
- Highlight key insights
- Do not mention databases or technical details"""
    
    final_response = llm_manager.invoke([SystemMessage(content=final_prompt)])
    
    return {
        "query": user_query,
        "response": final_response.content,
        "tool_calls": tool_calls_made,
        "execution_time": time.time() - start_time,
        "complexity": "complex",
        "databases_queried": len(successful_results),
        "schema_fetch_time": schema_time,
        "query_execution_time": exec_time,
        "total_queries": len(plan["queries"]),
        "successful_queries": len(successful_results)
    }

def execute_sql_with_retry(user_query: str, db_name: str, schema: str, retry: int, tool_calls: List) -> Dict:
    """Execute SQL with retry logic"""
    
    error_context = ""
    if retry > 0:
        error_context = "\nPrevious attempt failed. Check column names and use JOINs if needed."
    
    query_prompt = f"""Generate SQL for: "{user_query}"

Database: {db_name}
Schema: {schema[:2000]}

Important:
- Use JOINs when data is in multiple tables
- Use proper column names from the schema
- Use aggregate functions (COUNT, SUM, GROUP BY) when needed
- Include ORDER BY and LIMIT for "top" or "highest" queries

{error_context}

Respond with ONLY the SQL query."""
    
    response = llm_manager.invoke([SystemMessage(content=query_prompt)])
    sql_query = response.content.strip().replace('```sql', '').replace('```', '').strip()
    
    validation = validate_sql_query(sql_query)
    if "INVALID" in validation:
        return {"success": False, "data": validation}
    
    result = execute_sql_query(db_name, sql_query)
    tool_calls.append({"tool": "execute_sql_query", "args": {"database": db_name, "retry": retry}})
    
    return {
        "success": "Error" not in result,
        "data": result
    }

def execute_mongodb_with_retry(user_query: str, db_name: str, schema: str, retry: int, tool_calls: List) -> Dict:
    """Execute MongoDB with retry logic"""
    
    query_prompt = f"""Generate MongoDB query for: "{user_query}"

Database: {db_name}
Schema: {schema[:2000]}

Format: collection|||operation|||query_json"""
    
    response = llm_manager.invoke([SystemMessage(content=query_prompt)])
    parts = response.content.strip().split('|||')
    
    if len(parts) < 3:
        return {"success": False, "data": "Invalid MongoDB query format"}
    
    collection = parts[0].strip()
    operation = parts[1].strip()
    query_json = parts[2].strip() if len(parts) > 2 else "{}"
    
    result = execute_mongodb_query(db_name, collection, operation, query_json)
    tool_calls.append({"tool": "execute_mongodb_query", "args": {"database": db_name, "retry": retry}})
    
    return {
        "success": "Error" not in result,
        "data": result
    }
