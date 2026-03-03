"""Test script to verify follow-up query context handling"""
import requests
import json

BASE_URL = "http://localhost:8001"

def test_follow_up_context():
    """Test conversational context with follow-up queries"""
    print("\n" + "="*80)
    print("Testing Follow-Up Query Context")
    print("="*80)
    
    # First query - ask about most expensive product
    print("\n[Query 1] which one is the most expensive product")
    print("-" * 80)
    
    response1 = requests.post(
        f"{BASE_URL}/query",
        json={"question": "which one is the most expensive product"},
        timeout=30
    )
    
    if response1.status_code == 200:
        result1 = response1.json()
        answer1 = result1.get('response', '')
        print(f"Response: {answer1[:200]}...")
        
        # Extract context (simulate what chatbot.py does)
        import re
        
        # Try to extract price
        price_match = re.search(
            r"(?:most expensive|highest[- ]priced|top[- ]priced).*?(?:priced at|price.*?is|costs?)\s*\$?([\d,]+\.?\d*)",
            answer1,
            flags=re.IGNORECASE,
        )
        
        if price_match:
            context = f"the product priced at ${price_match.group(1)}"
            print(f"\n✓ Extracted context: {context}")
        else:
            print("\n✗ No context extracted")
            context = None
        
        # Second query - follow up with "tell me more about this product"
        print("\n[Query 2] tell me more about this product")
        print("-" * 80)
        
        # Rewrite query with context (simulate chatbot.py logic)
        if context:
            contextual_query = f"tell me more about {context} (referring to the most expensive product from previous query)"
        else:
            contextual_query = "tell me more about this product (referring to the most expensive product from previous query)"
        
        print(f"Rewritten query: {contextual_query}")
        
        response2 = requests.post(
            f"{BASE_URL}/query",
            json={"question": contextual_query},
            timeout=30
        )
        
        if response2.status_code == 200:
            result2 = response2.json()
            answer2 = result2.get('response', '')
            print(f"\nResponse: {answer2[:500]}...")
            
            # Check if response has actual product details
            if "couldn't find" in answer2.lower() or "don't have" in answer2.lower():
                print("\n❌ FAIL: Follow-up query did not get product details")
                return False
            else:
                print("\n✅ PASS: Follow-up query got product details")
                return True
        else:
            print(f"\n❌ Query 2 failed: {response2.status_code}")
            return False
    else:
        print(f"\n❌ Query 1 failed: {response1.status_code}")
        return False

if __name__ == "__main__":
    success = test_follow_up_context()
    
    print("\n" + "="*80)
    if success:
        print("✅ Context handling test PASSED")
    else:
        print("❌ Context handling test FAILED")
    print("="*80 + "\n")
