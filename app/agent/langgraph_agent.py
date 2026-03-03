"""
LangGraph Multi-Agent Architecture for Text-to-SQL System

This module implements a multi-agent system using LangGraph where each step
in the query processing pipeline is handled by a specialized sub-agent.
"""

from typing import TypedDict, Annotated, Literal
from langchain_core.messages import SystemMessage, HumanMessage, AIMessage
from langgraph.graph import StateGraph, END
from app.llm_manager import llm_manager
import operator
from app.agent.query_preprocessor import lightweight_preprocess
from app.agent.vector_context import get_vector_enhanced_context
from app.agent.tools import (
    get_available_databases,
    get_database_schema,
    execute_sql_query,
    execute_mongodb_query,
    validate_sql_query
)
from app.vector_store import vector_store
import json
import logging
import time
import re

logger = logging.getLogger(__name__)

# ============================================================================
# STATE DEFINITION
# ============================================================================

class AgentState(TypedDict):
    """Shared state passed between all agents in the graph"""
    
    # Input
    original_query: str
    
    # Preprocessing
    preprocessed_query: str
    original_language: str
    is_english: bool
    corrections_made: Annotated[list[str], operator.add]
    
    # Intent Classification
    intent: str  # database_query, casual_conversation, off_topic
    intent_confidence: float
    intent_reason: str
    
    # Database Selection
    complexity: str  # simple, complex
    selected_databases: Annotated[list[str], operator.add]
    requires_join: bool
    database_reasoning: str
    
    # Schema Retrieval
    schemas: dict[str, str]
    
    # Query Generation
    generated_queries: Annotated[list[dict], operator.add]  # [{db, query, type}]
    
    # Execution
    query_results: Annotated[list[dict], operator.add]  # [{db, result, success}]
    execution_errors: Annotated[list[str], operator.add]
    
    # Response
    final_response: str
    
    # Metadata
    tool_calls: Annotated[list[dict], operator.add]
    current_step: str
    errors: Annotated[list[str], operator.add]
    start_time: float


# ============================================================================
# AGENT 1: PREPROCESSING AGENT
# ============================================================================

def preprocessing_agent(state: AgentState) -> dict:
    """
    Agent 1: Handles language detection, translation, and typo correction
    """
    logger.info("🔄 PreprocessingAgent: Starting")
    
    original_query = state["original_query"]
    
    # Use lightweight preprocessing
    result = lightweight_preprocess(original_query)
    
    preprocessed_query = result.get("corrected_query", original_query)
    original_language = result.get("original_language", "English")
    is_english = result.get("is_english", True)
    corrections_made = result.get("corrections_made", [])
    
    logger.info(f"✅ PreprocessingAgent: Query preprocessed - {preprocessed_query}")
    
    return {
        "preprocessed_query": preprocessed_query,
        "original_language": original_language,
        "is_english": is_english,
        "corrections_made": corrections_made,
        "current_step": "preprocessing_complete",
        "tool_calls": [{
            "agent": "PreprocessingAgent",
            "action": "lightweight_preprocess",
            "result": {
                "language": original_language,
                "corrections": len(corrections_made)
            }
        }]
    }


# ============================================================================
# AGENT 2: INTENT CLASSIFIER AGENT
# ============================================================================

def intent_classifier_agent(state: AgentState) -> dict:
    """
    Agent 2: Classifies user intent using vector search + LLM
    """
    logger.info("🔄 IntentClassifierAgent: Starting")
    
    processed_query = state["preprocessed_query"]
    
    # Vector search for database context
    vector_results = vector_store.search_schemas(processed_query, n_results=5)
    
    # Structure the context for better LLM understanding
    if vector_results:
        # Group results by database
        db_contexts = {}
        for result in vector_results:
            metadata = result.get('metadata', {})
            doc = result.get('document', '')
            db_name = metadata.get('database', 'unknown')
            
            if db_name not in db_contexts:
                db_contexts[db_name] = {
                    'tables': set(),
                    'columns': set(),
                    'descriptions': []
                }
            
            # Extract table and column info
            if 'Table:' in doc:
                table_match = re.search(r'Table:\s*(\w+)', doc)
                if table_match:
                    db_contexts[db_name]['tables'].add(table_match.group(1))
            
            if 'Column:' in doc:
                col_match = re.search(r'Column:\s*(\w+)', doc)
                if col_match:
                    db_contexts[db_name]['columns'].add(col_match.group(1))
            
            # Store description
            if 'Context:' in doc or 'Description:' in doc:
                db_contexts[db_name]['descriptions'].append(doc)
        
        # Format structured context
        context_lines = []
        for db_name, info in list(db_contexts.items())[:3]:  # Top 3 databases
            context_lines.append(f"\nDatabase: {db_name}")
            if info['tables']:
                context_lines.append(f"   Tables: {', '.join(list(info['tables'])[:5])}")
            if info['columns']:
                context_lines.append(f"   Relevant Columns: {', '.join(list(info['columns'])[:8])}")
            if info['descriptions']:
                # Get first meaningful description
                for desc in info['descriptions'][:2]:
                    if 'Context:' in desc:
                        context_text = desc.split('Context:')[1].strip()[:100]
                        context_lines.append(f"   Context: {context_text}")
                        break
            context_lines.append("")
        
        context = "\n".join(context_lines) if context_lines else "No relevant database context found"
    else:
        context = "No relevant database context found"
    
    # LLM classification
    translation_note = ""
    if not state["is_english"]:
        translation_note = f"\n(Translated from {state['original_language']})"
    
    classification_prompt = f"""You are an intent classifier for a database query chatbot with access to 20+ databases.

# USER QUERY
"{processed_query}"{translation_note}

# AVAILABLE DATABASE CONTEXT (from vector search)
{context}

# CLASSIFICATION TASK
Classify the user's intent into ONE of these categories:

## 1. "database_query"
- User is asking for data that exists in our databases
- Query mentions specific entities (employees, products, customers, orders, etc.)
- Query asks for counts, aggregations, comparisons, or specific records
- Query references database concepts (tables, fields, relationships)

Examples:
- "who is the highest earning employee" → database_query
- "show me top 5 products by sales" → database_query
- "how many customers are in the CRM" → database_query
- "list all orders from last month" → database_query

## 2. "casual_conversation"
- Simple greetings or pleasantries
- Thanks or acknowledgments
- Farewells
- Very short social interactions

Examples:
- "hi" → casual_conversation
- "hello there" → casual_conversation
- "thanks" → casual_conversation
- "bye" → casual_conversation

## 3. "off_topic"
- Questions about topics NOT in our databases
- Requests for general knowledge, weather, news, etc.
- Coding help or technical questions unrelated to our data
- Questions that cannot be answered with database queries

Examples:
- "what's the weather today" → off_topic
- "how do I write Python code" → off_topic
- "tell me a joke" → off_topic
- "what is the capital of France" → off_topic

# DECISION CRITERIA
1. If vector search found relevant database context (tables/columns matching the query) → likely "database_query"
2. If query mentions specific data entities and vector search found context → definitely "database_query"
3. If query is 1-2 words and a greeting → "casual_conversation"
4. If query asks about external knowledge or unrelated topics → "off_topic"

# RESPONSE FORMAT
Respond with ONLY a JSON object (no markdown, no explanation):
{{"intent": "database_query|casual_conversation|off_topic", "confidence": 0.0-1.0, "reason": "brief explanation"}}

Confidence levels:
- 0.9-1.0: Very certain (clear match to category)
- 0.7-0.89: Confident (good indicators present)
- 0.5-0.69: Moderate (some ambiguity)
- Below 0.5: Uncertain (use fallback logic)"""
    
    intent = "off_topic"
    intent_confidence = 0.5
    intent_reason = "Unknown"
    errors = []
    
    try:
        response = llm_manager.invoke([SystemMessage(content=classification_prompt)])
        json_match = re.search(r'\{.*\}', response.content, re.DOTALL)
        
        if json_match:
            result = json.loads(json_match.group())
            intent = result.get("intent", "off_topic")
            intent_confidence = float(result.get("confidence", 0.5))
            intent_reason = result.get("reason", "LLM classification")
        else:
            # Fallback
            intent = "database_query" if context_parts else "off_topic"
            intent_confidence = 0.7 if context_parts else 0.3
            intent_reason = "Fallback classification"
    except Exception as e:
        logger.error(f"Intent classification error: {e}")
        intent = "off_topic"
        intent_confidence = 0.4
        intent_reason = "Error fallback"
        errors = [f"Intent classification error: {str(e)}"]
    
    logger.info(f"✅ IntentClassifierAgent: Intent='{intent}' (type={type(intent).__name__}, confidence={intent_confidence})")
    logger.info(f"   Intent reason: {intent_reason}")
    
    return {
        "intent": intent,
        "intent_confidence": intent_confidence,
        "intent_reason": intent_reason,
        "current_step": "intent_classified",
        "tool_calls": [{
            "agent": "IntentClassifierAgent",
            "action": "classify_intent",
            "result": {
                "intent": intent,
                "confidence": intent_confidence
            }
        }],
        "errors": errors
    }


# ============================================================================
# AGENT 3: DATABASE SELECTOR AGENT
# ============================================================================

def database_selector_agent(state: AgentState) -> dict:
    """
    Agent 3: Analyzes query and selects relevant databases
    """
    logger.info("🔄 DatabaseSelectorAgent: Starting")
    
    processed_query = state["preprocessed_query"]
    
    # Get available databases
    databases_info = get_available_databases()
    
    # Get vector-enhanced context
    vector_context = get_vector_enhanced_context(processed_query)
    
    # LLM analysis
    analysis_prompt = f"""You are a database selection expert. Analyze the user's query and determine which database(s) to use.

# USER QUERY
"{processed_query}"

# RELEVANT SCHEMA CONTEXT (from vector search)
{vector_context}

# AVAILABLE DATABASES
{databases_info}

# TASK
Determine which database(s) are needed to answer this query.

## Complexity Assessment
- **simple**: Query can be answered with data from a SINGLE database
- **complex**: Query requires data from MULTIPLE databases (needs joins across DBs)

## Selection Criteria
1. **Match entities**: Which database contains the entities mentioned in the query?
2. **Check schema context**: Does the vector search show relevant tables/columns?
3. **Consider relationships**: Does the query need data from multiple databases?
4. **Prefer single DB**: If possible, use one database to keep it simple

## Examples

**Simple Query:**
- Query: "who is the highest earning employee"
- Schema shows: postgres-hr has employees table with salary column
- Decision: {{"complexity": "simple", "databases_needed": ["postgres-hr"], "requires_join": false}}

**Complex Query:**
- Query: "compare employee salaries with product sales revenue"
- Schema shows: postgres-hr has employees/salary, mysql-sales has orders/revenue
- Decision: {{"complexity": "complex", "databases_needed": ["postgres-hr", "mysql-sales"], "requires_join": true}}

# RESPONSE FORMAT
Respond with ONLY a JSON object (no markdown, no explanation):
{{
    "complexity": "simple|complex",
    "databases_needed": ["db1", "db2", ...],
    "reasoning": "brief explanation of why these databases were selected",
    "requires_join": true|false
}}"""
    
    complexity = "simple"
    selected_databases = []
    requires_join = False
    database_reasoning = ""
    errors = []
    
    try:
        response = llm_manager.invoke([SystemMessage(content=analysis_prompt)])
        analysis = json.loads(response.content.strip().replace('```json', '').replace('```', ''))
        
        complexity = analysis.get("complexity", "simple")
        selected_databases = analysis.get("databases_needed", [])
        requires_join = analysis.get("requires_join", False)
        database_reasoning = analysis.get("reasoning", "")
    except Exception as e:
        logger.error(f"Database selection error: {e}")
        errors = [f"Database selection error: {str(e)}"]
    
    logger.info(f"✅ DatabaseSelectorAgent: Selected {len(selected_databases)} databases - {selected_databases}")
    
    return {
        "complexity": complexity,
        "selected_databases": selected_databases,
        "requires_join": requires_join,
        "database_reasoning": database_reasoning,
        "current_step": "databases_selected",
        "tool_calls": [{
            "agent": "DatabaseSelectorAgent",
            "action": "select_databases",
            "result": {
                "complexity": complexity,
                "databases": selected_databases
            }
        }],
        "errors": errors
    }


# ============================================================================
# AGENT 4: SCHEMA RETRIEVER AGENT
# ============================================================================

def schema_retriever_agent(state: AgentState) -> AgentState:
    """
    Agent 4: Retrieves schemas for selected databases
    """
    logger.info("🔄 SchemaRetrieverAgent: Starting")
    
    schemas = {}
    
    for db_name in state["selected_databases"]:
        try:
            schema = get_database_schema(db_name)
            schemas[db_name] = schema
            logger.info(f"✅ Retrieved schema for {db_name}")
        except Exception as e:
            logger.error(f"Failed to get schema for {db_name}: {e}")
            state["errors"].append(f"Schema retrieval error for {db_name}: {str(e)}")
    
    state["schemas"] = schemas
    state["current_step"] = "schemas_retrieved"
    state["tool_calls"].append({
        "agent": "SchemaRetrieverAgent",
        "action": "retrieve_schemas",
        "result": {
            "databases": list(schemas.keys()),
            "count": len(schemas)
        }
    })
    
    logger.info(f"✅ SchemaRetrieverAgent: Retrieved {len(schemas)} schemas")
    return state


# ============================================================================
# AGENT 5: QUERY GENERATOR AGENT
# ============================================================================

def query_generator_agent(state: AgentState) -> AgentState:
    """
    Agent 5: Generates SQL/MongoDB queries for each database
    """
    logger.info("🔄 QueryGeneratorAgent: Starting")
    
    processed_query = state["preprocessed_query"]
    schemas = state["schemas"]
    generated_queries = []
    
    for db_name, schema in schemas.items():
        try:
            # Determine database type
            db_type = "sql"  # Default
            if "mongodb" in db_name.lower():
                db_type = "mongodb"
            
            if db_type == "sql":
                query_prompt = f"""You are an expert SQL query generator. Generate a precise SQL query to answer the user's question.

# USER QUESTION
"{processed_query}"

# DATABASE
{db_name}

# SCHEMA
{schema}

# REQUIREMENTS
1. **Read-only**: Use ONLY SELECT statements (no INSERT, UPDATE, DELETE, DROP, ALTER, CREATE)
2. **Accurate**: Query must directly answer the question
3. **Efficient**: Use appropriate JOINs, WHERE clauses, and indexes
4. **Complete**: Include all necessary columns to answer the question
5. **Safe**: No SQL injection vulnerabilities, use proper syntax

# SQL BEST PRACTICES
- Use explicit column names (avoid SELECT *)
- Use table aliases for clarity (e.g., e for employees)
- Add ORDER BY for "top", "highest", "best" queries
- Use LIMIT for "top N" queries
- Use aggregate functions (COUNT, SUM, AVG, MAX, MIN) when appropriate
- Join tables when data spans multiple tables
- Use WHERE clauses to filter data

# EXAMPLES

**Question:** "who is the highest earning employee"
**Schema:** employees table with columns: employee_id, first_name, last_name, salary
**Query:**
```sql
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 1;
```

**Question:** "how many orders were placed last month"
**Schema:** orders table with columns: order_id, customer_id, order_date, total
**Query:**
```sql
SELECT COUNT(*) as order_count
FROM orders
WHERE order_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
  AND order_date < DATE_TRUNC('month', CURRENT_DATE);
```

# RESPONSE FORMAT
Respond with ONLY the SQL query (no markdown, no explanation, no code blocks):"""
                
                response = llm_manager.invoke([SystemMessage(content=query_prompt)])
                sql_query = response.content.strip().replace('```sql', '').replace('```', '').strip()
                
                # Validate SQL
                validation = validate_sql_query(sql_query)
                if "Error" not in validation:
                    generated_queries.append({
                        "database": db_name,
                        "type": "sql",
                        "query": sql_query
                    })
                else:
                    state["errors"].append(f"Invalid SQL for {db_name}: {validation}")
            else:
                # Generate MongoDB query
                query_prompt = f"""You are an expert MongoDB query generator. Generate a MongoDB query to answer the user's question.

# USER QUESTION
"{processed_query}"

# DATABASE
{db_name}

# SCHEMA
{schema}

# REQUIREMENTS
- Use appropriate MongoDB operations: find, aggregate, count, distinct
- Use proper query syntax with operators like $gt, $lt, $eq, $in, etc.
- For aggregations, use pipeline stages: $match, $group, $sort, $limit, $project

# RESPONSE FORMAT
Respond in this format: collection|||operation|||query_json
Example: users|||find|||{{"age": {{"$gt": 18}}}}"""
                
                response = llm_manager.invoke([SystemMessage(content=query_prompt)])
                parts = response.content.strip().split('|||')
                
                if len(parts) >= 3:
                    generated_queries.append({
                        "database": db_name,
                        "type": "mongodb",
                        "collection": parts[0].strip(),
                        "operation": parts[1].strip(),
                        "query": parts[2].strip()
                    })
                else:
                    state["errors"].append(f"Invalid MongoDB query format for {db_name}")
        
        except Exception as e:
            logger.error(f"Query generation error for {db_name}: {e}")
            state["errors"].append(f"Query generation error for {db_name}: {str(e)}")
    
    state["generated_queries"] = generated_queries
    state["current_step"] = "queries_generated"
    state["tool_calls"].append({
        "agent": "QueryGeneratorAgent",
        "action": "generate_queries",
        "result": {
            "count": len(generated_queries),
            "databases": [q["database"] for q in generated_queries]
        }
    })
    
    logger.info(f"✅ QueryGeneratorAgent: Generated {len(generated_queries)} queries")
    return state


# ============================================================================
# AGENT 6: EXECUTION AGENT
# ============================================================================

def execution_agent(state: AgentState) -> AgentState:
    """
    Agent 6: Executes generated queries
    """
    logger.info("🔄 ExecutionAgent: Starting")
    
    query_results = []
    
    for query_info in state["generated_queries"]:
        try:
            db_name = query_info["database"]
            
            if query_info["type"] == "mongodb":
                result = execute_mongodb_query(
                    db_name,
                    query_info["collection"],
                    query_info["operation"],
                    query_info["query"]
                )
            else:
                result = execute_sql_query(db_name, query_info["query"])
            
            query_results.append({
                "database": db_name,
                "result": result,
                "success": "Error" not in str(result),
                "query": query_info.get("query", "")
            })
            
            logger.info(f"✅ Executed query on {db_name}")
        
        except Exception as e:
            logger.error(f"Execution error for {db_name}: {e}")
            query_results.append({
                "database": db_name,
                "result": f"Error: {str(e)}",
                "success": False,
                "query": query_info.get("query", "")
            })
            state["execution_errors"].append(f"{db_name}: {str(e)}")
    
    state["query_results"] = query_results
    state["current_step"] = "queries_executed"
    state["tool_calls"].append({
        "agent": "ExecutionAgent",
        "action": "execute_queries",
        "result": {
            "total": len(query_results),
            "successful": sum(1 for r in query_results if r["success"])
        }
    })
    
    logger.info(f"✅ ExecutionAgent: Executed {len(query_results)} queries")
    return state


# ============================================================================
# AGENT 7: RESPONSE FORMATTER AGENT
# ============================================================================

def response_formatter_agent(state: AgentState) -> AgentState:
    """
    Agent 7: Formats final response for user
    """
    logger.info("🔄 ResponseFormatterAgent: Starting")
    
    # Check if we have successful results
    successful_results = [r for r in state["query_results"] if r["success"]]
    
    if not successful_results:
        state["final_response"] = "I encountered errors while querying the databases. Please try again."
        state["current_step"] = "complete"
        return state
    
    # Combine results
    combined_data = "\n\n".join([
        f"Database: {r['database']}\nResult: {r['result']}"
        for r in successful_results
    ])
    
    # Format response using LLM
    format_prompt = f"""You are a database query response formatter. Convert technical query results into clear, natural language answers.

# USER QUESTION
"{state['original_query']}"

# QUERY RESULTS
{combined_data}

# TASK
Provide a natural language answer that:
1. **Directly answers** the user's question
2. **Is concise** - no unnecessary technical details
3. **Is accurate** - based only on the data provided
4. **Is friendly** - conversational tone
5. **Includes key details** - relevant numbers, names, dates

# FORMATTING GUIDELINES
- For single results: Present the answer directly
- For multiple results: Use numbered lists or bullet points
- For counts/aggregations: State the number clearly
- For comparisons: Highlight key differences
- For empty results: Politely state no data was found

# EXAMPLES

**Question:** "who is the highest earning employee"
**Results:** {{"first_name": "John", "last_name": "Doe", "salary": 150000}}
**Answer:** "The highest earning employee is John Doe with a salary of $150,000."

**Question:** "how many orders were placed last month"
**Results:** {{"order_count": 42}}
**Answer:** "42 orders were placed last month."

**Question:** "list top 3 products by sales"
**Results:** [{{"product": "Laptop", "sales": 50000}}, {{"product": "Phone", "sales": 35000}}, {{"product": "Tablet", "sales": 28000}}]
**Answer:** "The top 3 products by sales are:
1. Laptop - $50,000
2. Phone - $35,000
3. Tablet - $28,000"

# RESPONSE FORMAT
Provide ONLY the natural language answer (no JSON, no technical formatting):"""
    
    try:
        response = llm_manager.invoke([SystemMessage(content=format_prompt)])
        english_response = response.content.strip()
        
        # Translate back to original language if needed
        if not state.get("is_english", True):
            original_language = state.get("original_language", "unknown")
            translation_prompt = f"""Translate this response back to {original_language}.

English response:
{english_response}

Provide ONLY the translated response (no explanations, no English version):"""
            
            try:
                translation_response = llm_manager.invoke([SystemMessage(content=translation_prompt)])
                translated_response = translation_response.content.strip()
                
                # Store both versions
                state["final_response"] = translated_response
                state["english_response"] = english_response
                
                logger.info(f"✅ Response translated back to {original_language}")
            except Exception as trans_error:
                logger.error(f"Translation error: {trans_error}")
                # Fallback to English response
                state["final_response"] = english_response
                state["errors"].append(f"Translation error: {str(trans_error)}")
        else:
            state["final_response"] = english_response
            
    except Exception as e:
        logger.error(f"Response formatting error: {e}")
        state["final_response"] = combined_data
        state["errors"].append(f"Response formatting error: {str(e)}")
    
    state["current_step"] = "complete"
    state["tool_calls"].append({
        "agent": "ResponseFormatterAgent",
        "action": "format_response",
        "result": {"formatted": True}
    })
    
    logger.info("✅ ResponseFormatterAgent: Response formatted")
    return state


# ============================================================================
# ROUTING LOGIC
# ============================================================================

def handle_non_database_query(state: AgentState) -> dict:
    """
    Handler for casual conversation and off-topic queries
    """
    intent = state.get("intent", "off_topic")
    
    if intent == "casual_conversation":
        final_response = "Hello! I'm here to help you query databases. What would you like to know?"
    else:
        final_response = "Sorry, I can only help with database queries. I'm a specialized Text-to-SQL assistant."
    
    logger.info(f"✅ Non-database query handled: {intent}")
    return {
        "final_response": final_response,
        "current_step": "complete"
    }


def handle_no_databases_found(state: AgentState) -> dict:
    """
    Handler when no databases could be identified
    """
    logger.warning("⚠️  No databases found for query")
    return {
        "final_response": "I couldn't identify which database to query. Please be more specific.",
        "current_step": "complete"
    }


def route_after_intent(state: AgentState) -> Literal["database_selector", "non_database_handler"]:
    """Route based on intent classification"""
    intent = state.get("intent", "off_topic")
    
    logger.info(f"🔀 Routing after intent: intent='{intent}' (type={type(intent).__name__})")
    
    if intent == "database_query":
        logger.info("✅ Routing to database_selector")
        return "database_selector"
    else:
        logger.info(f"⚠️  Routing to non_database_handler (intent was '{intent}')")
        return "non_database_handler"


def route_after_databases(state: AgentState) -> Literal["schema_retriever", "no_databases_handler"]:
    """Route based on database selection"""
    if state.get("selected_databases"):
        return "schema_retriever"
    else:
        return "no_databases_handler"


# ============================================================================
# BUILD LANGGRAPH WORKFLOW
# ============================================================================

def build_agent_graph():
    """Build the LangGraph workflow with all agents"""
    
    workflow = StateGraph(AgentState)
    
    # Add all agent nodes
    workflow.add_node("preprocessing", preprocessing_agent)
    workflow.add_node("intent_classifier", intent_classifier_agent)
    workflow.add_node("non_database_handler", handle_non_database_query)
    workflow.add_node("database_selector", database_selector_agent)
    workflow.add_node("no_databases_handler", handle_no_databases_found)
    workflow.add_node("schema_retriever", schema_retriever_agent)
    workflow.add_node("query_generator", query_generator_agent)
    workflow.add_node("execution", execution_agent)
    workflow.add_node("response_formatter", response_formatter_agent)
    
    # Define workflow edges
    workflow.set_entry_point("preprocessing")
    
    workflow.add_edge("preprocessing", "intent_classifier")
    
    workflow.add_conditional_edges(
        "intent_classifier",
        route_after_intent,
        {
            "database_selector": "database_selector",
            "non_database_handler": "non_database_handler"
        }
    )
    
    workflow.add_edge("non_database_handler", END)
    
    workflow.add_conditional_edges(
        "database_selector",
        route_after_databases,
        {
            "schema_retriever": "schema_retriever",
            "no_databases_handler": "no_databases_handler"
        }
    )
    
    workflow.add_edge("no_databases_handler", END)
    
    workflow.add_edge("schema_retriever", "query_generator")
    workflow.add_edge("query_generator", "execution")
    workflow.add_edge("execution", "response_formatter")
    workflow.add_edge("response_formatter", END)
    
    return workflow.compile()


# ============================================================================
# MAIN ENTRY POINT
# ============================================================================

# Compile the graph once at module load
agent_graph = build_agent_graph()


def process_query_with_agents(user_query: str) -> dict:
    """
    Main entry point for processing queries with the multi-agent system
    """
    logger.info(f"🚀 Starting multi-agent query processing: {user_query}")
    
    # Initialize state
    initial_state: AgentState = {
        "original_query": user_query,
        "preprocessed_query": "",
        "original_language": "",
        "is_english": True,
        "corrections_made": [],
        "intent": "",
        "intent_confidence": 0.0,
        "intent_reason": "",
        "complexity": "",
        "selected_databases": [],
        "requires_join": False,
        "database_reasoning": "",
        "schemas": {},
        "generated_queries": [],
        "query_results": [],
        "execution_errors": [],
        "final_response": "",
        "tool_calls": [],
        "current_step": "start",
        "errors": [],
        "start_time": time.time()
    }
    
    # Run the graph
    final_state = agent_graph.invoke(initial_state)
    
    # Calculate execution time
    execution_time = time.time() - final_state["start_time"]
    
    # Return formatted response
    return {
        "query": user_query,
        "response": final_state["final_response"],
        "tool_calls": final_state["tool_calls"],
        "execution_time": execution_time,
        "complexity": final_state.get("complexity", "unknown"),
        "databases_queried": len(final_state.get("selected_databases", [])),
        "total_queries": len(final_state.get("generated_queries", [])),
        "successful_queries": sum(1 for r in final_state.get("query_results", []) if r.get("success")),
        "errors": final_state.get("errors", []),
        "intent": final_state.get("intent", "unknown"),
        "preprocessing": {
            "original_language": final_state.get("original_language", ""),
            "corrections_made": final_state.get("corrections_made", [])
        }
    }
