import requests
import json
import time

BASE_URL = "http://localhost:8001"

def print_header(text):
    print("\n" + "=" * 80)
    print(f"  {text}")
    print("=" * 80)

def test_complex_query(question, description):
    print_header(description)
    print(f"\n📝 Question: {question}\n")
    
    start = time.time()
    response = requests.post(f"{BASE_URL}/query", json={"question": question})
    elapsed = time.time() - start
    
    if response.status_code == 200:
        result = response.json()
        print(f"✅ Response (took {elapsed:.2f}s):")
        print(result['response'])
        
        if 'complexity' in result:
            print(f"\n📊 Query Stats:")
            print(f"   - Complexity: {result.get('complexity', 'N/A')}")
            print(f"   - Execution time: {result.get('execution_time', 0):.2f}s")
            
            if result.get('complexity') == 'complex':
                print(f"   - Databases queried: {result.get('databases_queried', 0)}")
                print(f"   - Total queries: {result.get('total_queries', 0)}")
                print(f"   - Successful queries: {result.get('successful_queries', 0)}")
                print(f"   - Schema fetch time: {result.get('schema_fetch_time', 0):.2f}s")
                print(f"   - Query execution time: {result.get('query_execution_time', 0):.2f}s")
        
        print(f"\n🔧 Tool calls: {len(result.get('tool_calls', []))}")
    else:
        print(f"❌ Error: {response.text}")

def main():
    print("\n" + "=" * 80)
    print("  COMPLEX MULTI-DATABASE QUERY TESTS")
    print("=" * 80)
    print("\n🚀 Testing concurrent multi-database queries...\n")
    
    # Test 1: Simple single-database query
    test_complex_query(
        "What are the top 5 products by price in the ecommerce database?",
        "Test 1: Simple Query (Single Database)"
    )
    
    time.sleep(2)
    
    # Test 2: Complex query requiring multiple databases
    test_complex_query(
        "Show me a summary of our business: total sales revenue, number of support tickets, and active marketing campaigns",
        "Test 2: Complex Query (Sales + Support + Marketing)"
    )
    
    time.sleep(2)
    
    # Test 3: Cross-database analytics
    test_complex_query(
        "Compare our e-commerce orders with CRM opportunities - how many customers have both orders and opportunities?",
        "Test 3: Cross-Database Analysis (E-commerce + CRM)"
    )
    
    time.sleep(2)
    
    # Test 4: Multi-source aggregation
    test_complex_query(
        "Give me an overview of our workforce: total employees from HR, open support tickets, and active sales representatives",
        "Test 4: Multi-Source Aggregation (HR + Support + Sales)"
    )
    
    time.sleep(2)
    
    # Test 5: MongoDB + SQL combination
    test_complex_query(
        "Show me user engagement: active user sessions from analytics and recent customer orders from ecommerce",
        "Test 5: MongoDB + SQL Combination (Analytics + E-commerce)"
    )
    
    print("\n" + "=" * 80)
    print("  ALL COMPLEX QUERY TESTS COMPLETED")
    print("=" * 80)
    print("\n💡 The multi-database agent can:")
    print("   ✅ Detect query complexity automatically")
    print("   ✅ Execute queries concurrently for speed")
    print("   ✅ Combine results from multiple databases")
    print("   ✅ Provide unified, non-technical responses\n")

if __name__ == "__main__":
    try:
        print("\nChecking API connection...")
        response = requests.get(f"{BASE_URL}/health")
        if response.status_code == 200:
            print(f"✅ API is running: {response.json()}\n")
            main()
        else:
            print("❌ API connection failed")
    except requests.exceptions.ConnectionError:
        print("❌ ERROR: Cannot connect to the API server.")
        print("Make sure the server is running with: .\\run_app.bat")
    except Exception as e:
        print(f"❌ ERROR: {str(e)}")
