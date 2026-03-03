"""Final comprehensive test for logs database queries"""
import requests
import json

BASE_URL = "http://localhost:8001"

def test_query(question, expected_success=True):
    """Test a single query"""
    print(f"\n{'='*80}")
    print(f"Query: {question}")
    print('-'*80)
    
    try:
        response = requests.post(
            f"{BASE_URL}/query",
            json={"question": question},
            timeout=30
        )
        
        if response.status_code == 200:
            result = response.json()
            answer = result.get('response', '')
            
            # Check for actual data
            has_data = (
                'log_id' in answer or 'error_id' in answer or 
                'audit_id' in answer or 'security_id' in answer or
                'application_logs' in answer or 'error_logs' in answer or
                'mongodb-logs' in answer
            )
            
            if has_data:
                print(f"✅ PASS: Got logs data")
                print(f"Answer preview: {answer[:300]}...")
                return True
            else:
                print(f"❌ FAIL: No logs data found")
                print(f"Answer: {answer[:300]}")
                return False
        else:
            print(f"❌ FAIL: HTTP {response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ FAIL: Exception - {e}")
        return False

def main():
    """Run all logs query tests"""
    print("\n" + "="*80)
    print("Comprehensive Logs Database Query Testing")
    print("="*80)
    
    test_cases = [
        "show me recent application logs",
        "what are the latest error logs",
        "list security logs",
        "show me audit logs",
        "what error logs are there",
        "show performance logs",
        "tell me about logs database",
        "what collections are in mongodb-logs",
        "show me logs with errors",
        "list all log types in the logs database"
    ]
    
    results = []
    for question in test_cases:
        success = test_query(question)
        results.append((question, success))
    
    # Summary
    print("\n" + "="*80)
    print("Test Summary")
    print("="*80)
    
    passed = sum(1 for _, success in results if success)
    total = len(results)
    
    for question, success in results:
        status = "✅ PASS" if success else "❌ FAIL"
        print(f"{status}: {question}")
    
    print(f"\nTotal: {passed}/{total} tests passed")
    
    if passed == total:
        print("\n🎉 All logs queries working correctly!")
    elif passed > 0:
        print(f"\n⚠️  {total - passed} test(s) failed, but {passed} working")
    else:
        print(f"\n❌ All tests failed")
    
    return passed > 0

if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)
