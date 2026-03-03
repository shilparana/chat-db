from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, ConfigDict
from typing import Optional, List, Dict, Any
from app.agent.multi_db_agent import process_query
from app.database.connectors import db_manager
from app.llm_manager import llm_manager
from app.config import DATABASE_CONFIGS
import logging

logging.basicConfig(level=logging.INFO, force=True)
for noisy_logger in ["uvicorn", "uvicorn.error", "uvicorn.access", "httpx", "openai", "httpcore"]:
    logging.getLogger(noisy_logger).setLevel(logging.WARNING)
logger = logging.getLogger(__name__)
logger.info("🚀 Starting Text-to-SQL Multi-Database Agent")

app = FastAPI(
    title="Text-to-SQL Multi-Database Agent",
    description="Natural language interface to query 20+ databases using LangGraph",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class QueryRequest(BaseModel):
    question: str

class IntentRequest(BaseModel):
    text: str

class IntentResponse(BaseModel):
    intent: str  # "database_query", "casual_conversation", "off_topic"
    confidence: float
    reason: str

class QueryResponse(BaseModel):
    query: str
    response: str
    tool_calls: List[Dict[str, Any]]
    execution_time: Optional[float] = 0
    complexity: Optional[str] = "simple"
    databases_queried: Optional[int] = 0
    total_queries: Optional[int] = 0
    successful_queries: Optional[int] = 0
    schema_fetch_time: Optional[float] = 0
    query_execution_time: Optional[float] = 0

class DatabaseInfo(BaseModel):
    name: str
    type: str
    description: str

class SchemaResponse(BaseModel):
    database: str
    db_schema: Dict[str, Any]  # Renamed from 'schema' to avoid pydantic conflict

@app.get("/")
async def root():
    return {
        "message": "Text-to-SQL Multi-Database Agent API",
        "version": "1.0.0",
        "databases": len(DATABASE_CONFIGS),
        "endpoints": {
            "POST /query": "Submit a natural language query",
            "GET /databases": "List all available databases",
            "GET /schema/{database_name}": "Get schema for a specific database",
            "GET /health": "Health check"
        }
    }

@app.get("/health")
async def health_check():
    from app.config import settings
    llm_status = llm_manager.get_status()
    
    return {
        "status": "healthy",
        "databases_configured": len(DATABASE_CONFIGS),
        "llm_status": llm_status,
        "model": settings.azure_openai_deployment if llm_status.get("available") else "none"
    }

@app.get("/databases", response_model=List[DatabaseInfo])
async def list_databases():
    try:
        databases = db_manager.get_all_databases()
        return databases
    except Exception as e:
        logger.error(f"Error listing databases: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/schema/{database_name}", response_model=SchemaResponse)
async def get_schema(database_name: str):
    try:
        if database_name not in DATABASE_CONFIGS:
            raise HTTPException(status_code=404, detail=f"Database {database_name} not found")
        
        connector = db_manager.get_connector(database_name)
        schema = connector.get_schema()
        
        return {
            "database": database_name,
            "db_schema": schema
        }
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting schema for {database_name}: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/detect-intent", response_model=IntentResponse)
async def detect_intent(request: IntentRequest):
    """
    Detect user intent using vector store search + LLM classification
    Applies lightweight preprocessing (translation + typo fixes) before classification
    """
    try:
        user_input = request.text.strip()
        
        # Apply lightweight preprocessing for translation and typo fixes
        from app.agent.query_preprocessor import lightweight_preprocess
        preprocessed = lightweight_preprocess(user_input)
        processed_input = preprocessed.get('corrected_query', user_input)
        
        # Input validation (check original input length)
        if len(user_input) > 500:
            return IntentResponse(
                intent="off_topic",
                confidence=1.0,
                reason="Input too long"
            )
        
        # Prompt injection detection patterns
        injection_patterns = [
            "ignore previous", "ignore all", "disregard", "forget",
            "new instructions", "system:", "assistant:", "you are now",
            "pretend", "act as", "roleplay", "jailbreak"
        ]
        
        # Quick pattern-based detection for common cases (use processed input)
        lower_input = processed_input.lower()

        # Quick checks for casual conversation
        casual_phrases = [
            "hi", "hello", "hey", "how are you", "thanks", "thank you",
            "bye", "goodbye", "good morning", "good afternoon", "good evening"
        ]
        
        import re
        def contains_phrase(text: str, phrase: str) -> bool:
            pattern = r"\b" + re.escape(phrase) + r"\b"
            return re.search(pattern, text) is not None

        if len(lower_input) <= 3 or any(contains_phrase(lower_input, p) for p in casual_phrases):
            return IntentResponse(
                intent="casual_conversation",
                confidence=0.95,
                reason="Casual greeting detected"
            )

        if any(pattern in lower_input for pattern in injection_patterns):
            logger.warning(f"Potential prompt injection detected: {user_input[:100]}")
            return IntentResponse(
                intent="off_topic",
                confidence=1.0,
                reason="Suspicious input detected"
            )
        
        # Search vector store for relevant database context (use processed input)
        from app.vector_store import vector_store
        vector_results = vector_store.search_schemas(processed_input, n_results=5)
        
        # Build context from vector search results
        context_parts = []
        if vector_results:
            for result in vector_results:
                metadata = result.get('metadata', {})
                doc = result.get('document', '')
                context_parts.append(doc)
        
        context = "\n".join(context_parts[:3]) if context_parts else "No relevant database context found"
        
        # Use LLM to determine if query can be answered based on available context
        translation_note = ""
        if not preprocessed.get('is_english', True):
            original_lang = preprocessed.get('original_language', 'unknown')
            translation_note = f"\n(Original query in {original_lang}: \"{user_input}\")"
        
        classification_prompt = f"""You are an intent classifier for a database query chatbot.

User query: "{processed_input}"{translation_note}

Available database context from vector search:
{context}

Based on the query and available database context, classify into one of these:

1. "database_query" - The query asks about data that exists in our databases (based on the context above)
2. "casual_conversation" - Greetings, thanks, small talk
3. "off_topic" - The query cannot be answered with our database data (coding help, general knowledge, weather, etc.)

IMPORTANT: If the context shows relevant tables/collections/fields that could answer the query, classify as "database_query".
If no relevant context was found or the query is about something completely unrelated to databases, classify as "off_topic".

Respond with ONLY a JSON object:
{{"intent": "database_query|casual_conversation|off_topic", "confidence": 0.0-1.0, "reason": "brief explanation"}}"""

        from langchain_core.messages import SystemMessage
        response = llm_manager.invoke([SystemMessage(content=classification_prompt)])
        
        # Parse LLM response
        import json
        
        # Extract JSON from response
        json_match = re.search(r'\{.*\}', response.content, re.DOTALL)
        if json_match:
            result = json.loads(json_match.group())
            return IntentResponse(
                intent=result.get("intent", "off_topic"),
                confidence=float(result.get("confidence", 0.5)),
                reason=result.get("reason", "Vector-based classification")
            )
        else:
            # Fallback: if we found relevant context, assume database query
            if context_parts:
                return IntentResponse(
                    intent="database_query",
                    confidence=0.7,
                    reason="Relevant database context found"
                )
            else:
                return IntentResponse(
                    intent="off_topic",
                    confidence=0.6,
                    reason="No relevant database context"
                )
            
    except Exception as e:
        logger.error(f"Intent detection error: {str(e)}")
        # Safe fallback on errors
        return IntentResponse(
            intent="casual_conversation" if len(request.text.strip()) <= 5 else "off_topic",
            confidence=0.4,
            reason="Error fallback classification"
        )

@app.post("/query", response_model=QueryResponse)
async def query(request: QueryRequest):
    """
    Process natural language query using LangGraph multi-agent system
    """
    try:
        from app.agent.langgraph_agent import process_query_with_agents
        
        result = process_query_with_agents(request.question)
        
        return QueryResponse(**result)
    except Exception as e:
        logger.error(f"Query processing error: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.on_event("shutdown")
async def shutdown_event():
    db_manager.close_all()
    logger.info("Database connections closed")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
