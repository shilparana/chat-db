from typing import TypedDict, Annotated, Sequence
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage, SystemMessage
from langgraph.graph import StateGraph, END
from langgraph.prebuilt import ToolNode
from app.agent.tools import AGENT_TOOLS
from app.llm_manager import llm_manager
import json

class AgentState(TypedDict):
    messages: Annotated[Sequence[BaseMessage], "The messages in the conversation"]

llm_with_tools = llm_manager.primary_llm.bind_tools(AGENT_TOOLS)

tool_node = ToolNode(AGENT_TOOLS)

SYSTEM_PROMPT = """You are an expert SQL assistant that helps users query data from multiple databases. You have access to 20+ databases across different domains (e-commerce, finance, healthcare, logistics, HR, CRM, inventory, sales, marketing, support, education, gaming, travel, real estate, events, analytics, logs, social media, IoT, and content management).

Your workflow:
1. **Understand the question**: Analyze what the user is asking for
2. **Identify relevant databases**: Determine which database(s) contain the needed data
3. **Get schema information**: Retrieve table structures for the relevant databases
4. **Generate query**: Create appropriate SQL or MongoDB queries
5. **Validate query**: Ensure the query is safe (read-only)
6. **Execute query**: Run the query and get results
7. **Format response**: Present results in a clear, user-friendly format

Important guidelines:
- Always start by checking available databases if you're unsure
- Get the schema before writing queries to ensure accuracy
- Only use SELECT queries for SQL databases (no modifications)
- For MongoDB, use find, aggregate, or count operations
- Validate queries before execution
- If a query fails, analyze the error and try again with corrections
- Present results in a clear, formatted way
- If the question is ambiguous, ask for clarification

Available database types:
- PostgreSQL: ecommerce, finance, healthcare, logistics, HR
- MySQL: CRM, inventory, sales, marketing, support
- MariaDB: education, gaming, travel, real estate, events
- MongoDB: analytics, logs, social media, IoT, content
"""

def should_continue(state: AgentState) -> str:
    messages = state["messages"]
    last_message = messages[-1]
    
    if isinstance(last_message, AIMessage) and not last_message.tool_calls:
        return "end"
    
    return "continue"

def call_model(state: AgentState):
    messages = state["messages"]
    
    if not any(isinstance(msg, SystemMessage) for msg in messages):
        messages = [SystemMessage(content=SYSTEM_PROMPT)] + messages
    
    response = llm_with_tools.invoke(messages)
    
    return {"messages": [response]}

workflow = StateGraph(AgentState)

workflow.add_node("agent", call_model)
workflow.add_node("tools", tool_node)

workflow.set_entry_point("agent")

workflow.add_conditional_edges(
    "agent",
    should_continue,
    {
        "continue": "tools",
        "end": END
    }
)

workflow.add_edge("tools", "agent")

graph = workflow.compile()

def process_query(user_query: str) -> dict:
    initial_state = {
        "messages": [HumanMessage(content=user_query)]
    }
    
    result = graph.invoke(initial_state)
    
    messages = result["messages"]
    
    final_response = None
    for msg in reversed(messages):
        if isinstance(msg, AIMessage) and not msg.tool_calls:
            final_response = msg.content
            break
    
    tool_calls_made = []
    for msg in messages:
        if isinstance(msg, AIMessage) and msg.tool_calls:
            for tool_call in msg.tool_calls:
                tool_calls_made.append({
                    "tool": tool_call["name"],
                    "args": tool_call["args"]
                })
    
    return {
        "query": user_query,
        "response": final_response or "No response generated",
        "tool_calls": tool_calls_made,
        "message_count": len(messages)
    }
