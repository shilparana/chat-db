"""Test script to verify MongoDB fields are indexed in vector store"""
from app.vector_store import vector_store

# Test 1: Search for MongoDB logs collections
print("="*80)
print("Test 1: Search for 'application logs'")
print("="*80)
results = vector_store.search_schemas('application logs', n_results=5)
print(f"Total results: {len(results)}\n")
for i, r in enumerate(results):
    print(f"{i+1}. Type: {r['metadata'].get('type')}")
    print(f"   Database: {r['metadata'].get('database')}")
    print(f"   Collection/Table: {r['metadata'].get('collection', r['metadata'].get('table'))}")
    print(f"   Field/Column: {r['metadata'].get('field', r['metadata'].get('column', 'N/A'))}")
    print(f"   Document: {r['document'][:120]}...")
    print()

# Test 2: Search for specific MongoDB field
print("="*80)
print("Test 2: Search for 'log_id field'")
print("="*80)
results = vector_store.search_schemas('log_id field', n_results=5)
print(f"Total results: {len(results)}\n")
for i, r in enumerate(results):
    print(f"{i+1}. Type: {r['metadata'].get('type')}")
    print(f"   Database: {r['metadata'].get('database')}")
    print(f"   Collection: {r['metadata'].get('collection')}")
    print(f"   Field: {r['metadata'].get('field', 'N/A')}")
    print(f"   Document: {r['document'][:120]}...")
    print()

# Test 3: Search for error logs
print("="*80)
print("Test 3: Search for 'error logs'")
print("="*80)
results = vector_store.search_schemas('error logs', n_results=5)
print(f"Total results: {len(results)}\n")
for i, r in enumerate(results):
    print(f"{i+1}. Type: {r['metadata'].get('type')}")
    print(f"   Database: {r['metadata'].get('database')}")
    print(f"   Collection: {r['metadata'].get('collection')}")
    if r['metadata'].get('type') == 'field':
        print(f"   Field: {r['metadata'].get('field')}")
    print(f"   Document: {r['document'][:120]}...")
    print()

# Test 4: Count total indexed elements
print("="*80)
print("Test 4: Verify total indexed elements")
print("="*80)
results_all = vector_store.search_schemas('database', n_results=100)
print(f"Sample of indexed elements: {len(results_all)}")

# Count by type
from collections import Counter
types = Counter([r['metadata'].get('type') for r in results_all])
print(f"\nBreakdown by type:")
for type_name, count in types.items():
    print(f"  {type_name}: {count}")
