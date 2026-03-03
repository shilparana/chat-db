import requests
import json
import time

BASE_URL = "http://localhost:8001"

def print_header(text):
    print("\n" + "=" * 70)
    print(f"  {text}")
    print("=" * 70)

def print_result(response):
    if response.status_code == 200:
        result = response.json()
        print(f"\n✅ Response:")
        print(result['response'])
        if result.get('tool_calls'):
            print(f"\n🔧 Tools used: {len(result['tool_calls'])}")
            for tool in result['tool_calls']:
                print(f"   - {tool['tool']}")
    else:
        print(f"\n❌ Error: {response.text}")

def example_1_list_databases():
    print_header("Example 1: List All Available Databases")
    
    question = "What databases are available?"
    print(f"\n📝 Question: {question}")
    
    response = requests.post(f"{BASE_URL}/query", json={"question": question})
    print_result(response)
    time.sleep(2)

def example_2_ecommerce_products():
    print_header("Example 2: E-commerce - Top Products by Price")
    
    question = "Show me the top 5 most expensive products in the ecommerce database"
    print(f"\n📝 Question: {question}")
    
    response = requests.post(f"{BASE_URL}/query", json={"question": question})
    print_result(response)
    time.sleep(2)

def example_3_crm_customers():
    print_header("Example 3: CRM - Customer Count")
    
    question = "How many customers are in the CRM database?"
    print(f"\n📝 Question: {question}")
    
    response = requests.post(f"{BASE_URL}/query", json={"question": question})
    print_result(response)
    time.sleep(2)

def example_4_hr_employees():
    print_header("Example 4: HR - Active Employees")
    
    question = "List all active employees in the HR database with their departments"
    print(f"\n📝 Question: {question}")
    
    response = requests.post(f"{BASE_URL}/query", json={"question": question})
    print_result(response)
    time.sleep(2)

def example_5_sales_analysis():
    print_header("Example 5: Sales - Top Sales Representatives")
    
    question = "Who are the top 3 sales representatives by total sales in the sales database?"
    print(f"\n📝 Question: {question}")
    
    response = requests.post(f"{BASE_URL}/query", json={"question": question})
    print_result(response)
    time.sleep(2)

def example_6_mongodb_analytics():
    print_header("Example 6: MongoDB - User Sessions Analysis")
    
    question = "Show me user sessions from the analytics database where users spent more than 30 minutes"
    print(f"\n📝 Question: {question}")
    
    response = requests.post(f"{BASE_URL}/query", json={"question": question})
    print_result(response)
    time.sleep(2)

def example_7_education_courses():
    print_header("Example 7: Education - Popular Courses")
    
    question = "What are the courses with the most enrollments in the education database?"
    print(f"\n📝 Question: {question}")
    
    response = requests.post(f"{BASE_URL}/query", json={"question": question})
    print_result(response)
    time.sleep(2)

def example_8_healthcare_appointments():
    print_header("Example 8: Healthcare - Upcoming Appointments")
    
    question = "Show me upcoming appointments in the healthcare database"
    print(f"\n📝 Question: {question}")
    
    response = requests.post(f"{BASE_URL}/query", json={"question": question})
    print_result(response)
    time.sleep(2)

def main():
    print("\n" + "=" * 70)
    print("  TEXT-TO-SQL AGENT - EXAMPLE QUERIES")
    print("=" * 70)
    print("\n🚀 Starting example queries...")
    print("⏱️  Each query will run with a 2-second delay\n")
    
    try:
        print_header("Testing API Connection")
        response = requests.get(f"{BASE_URL}/health")
        if response.status_code == 200:
            print(f"\n✅ API is running: {response.json()}")
        else:
            print(f"\n❌ API connection failed")
            return
        
        time.sleep(2)
        
        example_1_list_databases()
        example_2_ecommerce_products()
        example_3_crm_customers()
        example_4_hr_employees()
        example_5_sales_analysis()
        example_6_mongodb_analytics()
        example_7_education_courses()
        example_8_healthcare_appointments()
        
        print_header("All Examples Completed Successfully! 🎉")
        print("\n💡 Try your own queries at: http://localhost:8000/docs")
        print("📚 Or use the API directly with POST requests to /query\n")
        
    except requests.exceptions.ConnectionError:
        print("\n❌ ERROR: Cannot connect to the API server.")
        print("Make sure the server is running with: run_app.bat")
    except KeyboardInterrupt:
        print("\n\n⚠️  Examples interrupted by user")
    except Exception as e:
        print(f"\n❌ ERROR: {str(e)}")

if __name__ == "__main__":
    main()
