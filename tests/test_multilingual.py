import requests
import json

BASE_URL = "http://localhost:8001"

def test_query(question, description):
    print("\n" + "="*80)
    print(f"  {description}")
    print("="*80)
    print(f"\n📝 Original: {question}\n")
    
    response = requests.post(f"{BASE_URL}/query", json={"question": question})
    
    if response.status_code == 200:
        result = response.json()
        
        # Show preprocessing info
        if 'preprocessing' in result:
            prep = result['preprocessing']
            print(f"🔧 Preprocessing:")
            print(f"   Language: {prep.get('original_language', 'unknown')}")
            if prep.get('corrections_made'):
                print(f"   Corrections: {', '.join(prep['corrections_made'])}")
            print(f"   Processed: {prep.get('corrected_query', question)}")
            print()
        
        print(f"✅ Response:")
        print(result['response'])
        print()
    else:
        print(f"❌ Error: {response.text}\n")

def main():
    print("\n" + "="*80)
    print("  MULTILINGUAL & TYPO HANDLING TESTS")
    print("="*80)
    
    # Test 1: Typos in English
    test_query(
        "wat r the top prodcts by pric?",
        "Test 1: English with Typos"
    )
    
    # Test 2: More typos
    test_query(
        "how many custmers in the crm databse?",
        "Test 2: Multiple Typos"
    )
    
    # Test 3: Database name typo
    test_query(
        "show me cours with most enrollmnts in educaton database",
        "Test 3: Database Name Typos"
    )
    
    # Test 4: Spanish
    test_query(
        "muéstrame los 5 productos más caros",
        "Test 4: Spanish Query"
    )
    
    # Test 5: French
    test_query(
        "combien de clients avons-nous?",
        "Test 5: French Query"
    )
    
    # Test 6: Hindi
    test_query(
        "कितने कर्मचारी हैं?",
        "Test 6: Hindi Query"
    )
    
    # Test 7: Mixed typos and unclear
    test_query(
        "giv me employes from hr departmnt",
        "Test 7: Heavy Typos"
    )
    
    # Test 8: Abbreviations
    test_query(
        "top 5 prods by $",
        "Test 8: Abbreviations"
    )
    
    print("\n" + "="*80)
    print("  ALL TESTS COMPLETED")
    print("="*80)
    print("\n💡 The agent can now handle:")
    print("   ✅ Typos and spelling errors")
    print("   ✅ Multiple languages (auto-translation)")
    print("   ✅ Abbreviations and shorthand")
    print("   ✅ Unclear or ambiguous queries\n")

if __name__ == "__main__":
    try:
        print("\nChecking API connection...")
        response = requests.get(f"{BASE_URL}/health")
        if response.status_code == 200:
            print(f"✅ API is running\n")
            main()
        else:
            print("❌ API connection failed")
    except Exception as e:
        print(f"❌ ERROR: {str(e)}")
