"""Test script to verify HR query functionality with vector context"""
import requests
import json

BASE_URL = "http://localhost:8001"

def test_query(question):
    """Send a query to the chatbot API and print the response"""
    print(f"\n{'='*80}")
    print(f"Question: {question}")
    print('='*80)
    
    try:
        response = requests.post(
            f"{BASE_URL}/query",
            json={"question": question},
            timeout=30
        )
        
        if response.status_code == 200:
            result = response.json()
            print(f"\n✅ Response received")
            print(f"Answer: {result.get('response', 'No response')}")
            
            # Show which databases were used
            if 'tool_calls' in result:
                print(f"\nTool calls made: {len(result['tool_calls'])}")
                for i, call in enumerate(result['tool_calls'][:3], 1):
                    print(f"  {i}. {call.get('tool', 'unknown')}")
            
            return True
        else:
            print(f"❌ Error: {response.status_code}")
            print(response.text)
            return False
            
    except Exception as e:
        print(f"❌ Exception: {e}")
        return False

if __name__ == "__main__":
    print("\n" + "="*80)
    print("Testing HR Queries with Vector Context")
    print("="*80)
    
    # Test HR-related queries
    test_queries = [
        "who are in our HR team",
        "show me all employees",
        "which employees work in technology department",
        "who is the highest paid employee"
    ]
    
    results = []
    for query in test_queries:
        success = test_query(query)
        results.append((query, success))
    
    # Summary
    print("\n" + "="*80)
    print("Test Summary")
    print("="*80)
    for query, success in results:
        status = "✅ PASS" if success else "❌ FAIL"
        print(f"{status}: {query}")
    
    passed = sum(1 for _, s in results if s)
    print(f"\nTotal: {passed}/{len(results)} tests passed")
