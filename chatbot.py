#!/usr/bin/env python3
"""
Interactive CLI Chatbot for Text-to-SQL Multi-Database Agent
"""

import requests
import json
import sys
from datetime import datetime
import os
import re

BASE_URL = "http://localhost:8001"

# Global variable to store model name
MODEL_NAME = "Assistant"

def get_model_name():
    """Get the model name from the API"""
    global MODEL_NAME
    try:
        response = requests.get(f"{BASE_URL}/health", timeout=5)
        if response.status_code == 200:
            health_data = response.json()
            model = health_data.get('model', 'gpt-4o-mini')
            # Use exact model name from deployment
            MODEL_NAME = model
    except:
        MODEL_NAME = "Assistant"
    return MODEL_NAME

class Colors:
    """ANSI color codes for terminal output"""
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'

def print_banner():
    """Print welcome banner"""
    banner = f"""
{Colors.CYAN}{'='*80}
{Colors.BOLD}  📊 Text-to-SQL Multi-Database Chatbot{Colors.END}
{Colors.CYAN}{'='*80}{Colors.END}

{Colors.GREEN}Welcome! I can help you query data from 20+ databases using natural language.{Colors.END}

{Colors.YELLOW}Available databases:{Colors.END}
  • PostgreSQL: ecommerce, finance, healthcare, logistics, HR
  • MySQL: CRM, inventory, sales, marketing, support
  • MariaDB: education, gaming, travel, real estate, events
  • MongoDB: analytics, logs, social media, IoT, content

{Colors.CYAN}Commands:{Colors.END}
  • Type your question naturally
  • {Colors.BOLD}/help{Colors.END} - Show this help message
  • {Colors.BOLD}/databases{Colors.END} - List all available databases
  • {Colors.BOLD}/stats{Colors.END} - Show session statistics
  • {Colors.BOLD}/clear{Colors.END} - Clear screen
  • {Colors.BOLD}/exit{Colors.END} or {Colors.BOLD}/quit{Colors.END} - Exit chatbot

{Colors.CYAN}{'='*80}{Colors.END}
"""
    print(banner)

def check_api_connection():
    """Check if API is running"""
    try:
        response = requests.get(f"{BASE_URL}/health", timeout=5)
        if response.status_code == 200:
            return True, response.json()
        return False, None
    except requests.exceptions.ConnectionError:
        return False, None
    except Exception as e:
        return False, str(e)

def send_query(question: str):
    """Send query to API and return response"""
    try:
        response = requests.post(
            f"{BASE_URL}/query",
            json={"question": question},
            timeout=60
        )
        
        if response.status_code == 200:
            return True, response.json()
        else:
            return False, f"Error: {response.text}"
    except requests.exceptions.Timeout:
        return False, "Request timed out. The query might be too complex."
    except requests.exceptions.ConnectionError:
        return False, "Cannot connect to the API server. Make sure it's running."
    except Exception as e:
        return False, f"Error: {str(e)}"

def get_databases():
    """Get list of all databases"""
    try:
        response = requests.get(f"{BASE_URL}/databases", timeout=10)
        if response.status_code == 200:
            return True, response.json()
        return False, None
    except Exception as e:
        return False, str(e)

def format_response(result: dict):
    """Display answer-only output"""
    response_text = str(result.get('response', '')).strip()

    answer_match = re.search(r"\*\*Answer:\*\*\s*(.+)", response_text, flags=re.IGNORECASE | re.DOTALL)
    if answer_match:
        response_text = answer_match.group(1).strip()

    response_text = re.sub(r"^\*\*Question:\*\*.*$", "", response_text, flags=re.IGNORECASE | re.MULTILINE).strip()
    print(f"\n{Colors.GREEN}{Colors.BOLD}Assistant ({MODEL_NAME}):{Colors.END} {response_text}\n")

def extract_context_entity(response_text: str):
    """Extract a likely entity (e.g., product name, price) from model response text."""
    if not response_text:
        return None

    # Try to extract product name from bold text
    bold_match = re.search(r"\*\*(.*?)\*\*", response_text)
    if bold_match:
        candidate = bold_match.group(1).strip()
        if candidate and "question" not in candidate.lower() and "answer" not in candidate.lower():
            return candidate

    # Try to extract product name after "most expensive product is"
    product_match = re.search(
        r"most expensive product is (?:the )?([A-Za-z0-9\-\s]+?)(?:,|\.| which)",
        response_text,
        flags=re.IGNORECASE,
    )
    if product_match:
        return product_match.group(1).strip()
    
    # Try to extract price information for expensive product queries
    price_match = re.search(
        r"(?:most expensive|highest[- ]priced|top[- ]priced).*?(?:priced at|price.*?is|costs?)\s*\$?([\d,]+\.?\d*)",
        response_text,
        flags=re.IGNORECASE,
    )
    if price_match:
        return f"the product priced at ${price_match.group(1)}"

    return None

def rewrite_with_context(user_input: str, last_entity: str, last_query: str = None):
    """Rewrite follow-up references like 'this product' using prior context."""
    if not last_entity and not last_query:
        return user_input

    rewritten = user_input
    
    # Check if this is a follow-up query
    follow_up_patterns = [
        r"\bthis\s+product\b",
        r"\bthat\s+product\b",
        r"\bthis\s+item\b",
        r"\bthat\s+item\b",
        r"\bthis\s+one\b",
        r"\bthat\s+one\b",
        r"\bit\b",
        r"\bthem\b",
    ]
    
    is_follow_up = any(re.search(pattern, user_input, flags=re.IGNORECASE) for pattern in follow_up_patterns)
    
    if is_follow_up:
        # If we have an entity, use it
        if last_entity:
            for pattern in follow_up_patterns[:6]:  # Don't replace "it" or "them" with entity
                rewritten = re.sub(pattern, last_entity, rewritten, flags=re.IGNORECASE)
        
        # Add context from previous query
        if last_query and "expensive" in last_query.lower():
            rewritten = f"{rewritten} (referring to the most expensive product from previous query)"

    return rewritten

def show_databases():
    """Display all available databases"""
    success, databases = get_databases()
    
    if not success:
        print(f"{Colors.RED}Error fetching databases{Colors.END}\n")
        return
    
    print(f"\n{Colors.CYAN}{Colors.BOLD}📚 Available Databases:{Colors.END}\n")
    
    # Group by type
    db_types = {}
    for db in databases:
        db_type = db['type']
        if db_type not in db_types:
            db_types[db_type] = []
        db_types[db_type].append(db)
    
    for db_type, dbs in db_types.items():
        print(f"{Colors.YELLOW}{db_type.upper()}:{Colors.END}")
        for db in dbs:
            print(f"  • {Colors.BOLD}{db['name']}{Colors.END}")
            print(f"    {db['description']}")
        print()

def show_stats(session_stats: dict):
    """Display session statistics"""
    print(f"\n{Colors.CYAN}{Colors.BOLD}📊 Session Statistics:{Colors.END}\n")
    print(f"  • Queries asked: {session_stats['queries_count']}")
    print(f"  • Simple queries: {session_stats['simple_queries']}")
    print(f"  • Complex queries: {session_stats['complex_queries']}")
    print(f"  • Total execution time: {session_stats['total_time']:.2f}s")
    if session_stats['queries_count'] > 0:
        avg_time = session_stats['total_time'] / session_stats['queries_count']
        print(f"  • Average query time: {avg_time:.2f}s")
    print(f"  • Session started: {session_stats['start_time']}")
    print()

def clear_screen():
    """Clear terminal screen"""
    os.system('cls' if os.name == 'nt' else 'clear')

def main():
    """Main chatbot loop"""
    global MODEL_NAME
    
    # Check API connection
    print(f"{Colors.YELLOW}Checking API connection...{Colors.END}")
    connected, health = check_api_connection()
    
    if not connected:
        print(f"{Colors.RED}{Colors.BOLD}❌ Cannot connect to the API server!{Colors.END}")
        print(f"\n{Colors.YELLOW}Please make sure the server is running:{Colors.END}")
        print(f"  {Colors.CYAN}.\\run_app.bat{Colors.END}\n")
        sys.exit(1)
    
    print(f"{Colors.GREEN}✅ Connected to API{Colors.END}")
    print(f"   Databases configured: {health.get('databases_configured', 0)}\n")
    
    # Detect model name
    get_model_name()
    
    # Print banner
    print_banner()
    
    # Session statistics
    session_stats = {
        'queries_count': 0,
        'simple_queries': 0,
        'complex_queries': 0,
        'total_time': 0,
        'start_time': datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }
    last_context_entity = None
    last_query = None
    
    # Main loop
    while True:
        try:
            # Get user input
            user_input = input(f"{Colors.BOLD}{Colors.BLUE}You: {Colors.END}").strip()
            
            if not user_input:
                continue

            # Handle commands first
            if user_input.lower() in ['/exit', '/quit', 'exit', 'quit']:
                print(f"\n{Colors.CYAN}Thank you for using the chatbot! Goodbye! 👋{Colors.END}\n")
                break
            
            elif user_input.lower() in ['/help', 'help']:
                print_banner()
                continue
            
            elif user_input.lower() in ['/databases', '/db']:
                show_databases()
                continue
            
            elif user_input.lower() in ['/stats', '/statistics']:
                show_stats(session_stats)
                continue
            
            elif user_input.lower() in ['/clear', 'clear']:
                clear_screen()
                print_banner()
                continue
            
            # Process query - send directly to API, LangGraph agent handles everything
            contextual_input = rewrite_with_context(user_input, last_context_entity, last_query)
            success, result = send_query(contextual_input)
            
            if success:
                format_response(result)
                last_context_entity = extract_context_entity(str(result.get('response', '')))
                last_query = user_input  # Store original query for context
                
                # Update statistics
                session_stats['queries_count'] += 1
                session_stats['total_time'] += result.get('execution_time', 0)
                
                if result.get('complexity') == 'complex':
                    session_stats['complex_queries'] += 1
                else:
                    session_stats['simple_queries'] += 1
            else:
                print(f"\n{Colors.RED}{Colors.BOLD}❌ Error:{Colors.END} {result}\n")
        
        except KeyboardInterrupt:
            print(f"\n\n{Colors.CYAN}Goodbye! 👋{Colors.END}\n")
            break
        
        except Exception as e:
            print(f"\n{Colors.RED}{Colors.BOLD}❌ Unexpected error:{Colors.END} {str(e)}\n")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n\n{Colors.CYAN}Goodbye! 👋{Colors.END}\n")
        sys.exit(0)
