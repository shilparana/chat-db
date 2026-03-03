"""Test script to verify HR query handling and intent detection"""
import requests
import json

BASE_URL = "http://localhost:8001"

def test_hr_query(question, expected_success=True):
    """Test a single HR query"""
    print(f"\n{'='*80}")
    print(f"Query: {question}")
    print('-'*80)
    
    try:
        # Test intent detection first
        intent_response = requests.post(
            f"{BASE_URL}/detect-intent",
            json={"text": question},
            timeout=5
        )
        
        if intent_response.status_code == 200:
            intent_data = intent_response.json()
            intent = intent_data.get("intent", "unknown")
            confidence = intent_data.get("confidence", 0)
            print(f"Intent: {intent} (confidence: {confidence:.2f})")
            
            if intent == "off_topic":
                print("❌ FAIL: Query incorrectly classified as off-topic")
                return False
        
        # Test actual query
        response = requests.post(
            f"{BASE_URL}/query",
            json={"question": question},
            timeout=30
        )
        
        if response.status_code == 200:
            result = response.json()
            answer = result.get('response', '')
            
            # Check if we got actual results
            has_results = "Emma Davis" in answer or "HR Manager" in answer
            
            if expected_success:
                if has_results:
                    print(f"✅ PASS: Got HR employee details")
                    print(f"Answer preview: {answer[:200]}...")
                    return True
                else:
                    print(f"❌ FAIL: No HR employee details found")
                    print(f"Answer: {answer[:300]}")
                    return False
            else:
                return True
        else:
            print(f"❌ FAIL: HTTP {response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ FAIL: Exception - {e}")
        return False

def main():
    """Run all HR query tests"""
    print("\n" + "="*80)
    print("HR Query Testing Suite")
    print("="*80)
    
    test_cases = [
        ("who are in the HR team", True),
        ("human resource team", True),
        ("show me HR staff", True),
        ("employees in Human Resources department", True),
        ("who works in HR", True),
        ("HR department employees", True),
        ("list all HR team members", True),
    ]
    
    results = []
    for question, expected_success in test_cases:
        success = test_hr_query(question, expected_success)
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
        print("\n🎉 All HR queries working correctly!")
    else:
        print(f"\n⚠️  {total - passed} test(s) failed")
    
    return passed == total

if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)
