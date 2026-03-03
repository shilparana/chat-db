from langchain_core.messages import SystemMessage
from app.llm_manager import llm_manager
from app.config import settings
from app.vector_store import vector_store
import re

def lightweight_preprocess(user_query: str) -> dict:
    """
    Lightweight preprocessing for pre-intent classification:
    - Language detection and translation
    - Basic typo fixes
    - NO synonym expansion or context enhancement
    
    This runs BEFORE intent classification to handle foreign languages and typos.
    """
    
    preprocessing_prompt = f"""You are a query preprocessor. Normalize the user's query for database querying.

# USER QUERY
"{user_query}"

# TASKS
1. **Detect language**: Identify if the query is in English or another language
2. **Translate**: If not English, translate to English while preserving intent
3. **Fix typos**: Correct obvious spelling and grammar errors
4. **Normalize**: Standardize common phrases (e.g., "most earning" → "highest earning")
5. **Preserve intent**: Keep the original meaning and question type

# IMPORTANT
- Do NOT expand synonyms (e.g., don't change "HR" to "Human Resources")
- Do NOT add extra context or assumptions
- Do NOT change technical terms or proper nouns
- ONLY fix language and typos

# EXAMPLES

**Input:** "wat r the top prodcts?"
**Output:** {{"original_language": "English", "is_english": true, "corrected_query": "what are the top products?", "corrections_made": ["wat→what", "r→are", "prodcts→products"]}}

**Input:** "muéstrame los clientes"
**Output:** {{"original_language": "Spanish", "is_english": false, "corrected_query": "show me the customers", "corrections_made": ["translated from Spanish"]}}

**Input:** "कितने कर्मचारी हैं?"
**Output:** {{"original_language": "Hindi", "is_english": false, "corrected_query": "how many employees are there?", "corrections_made": ["translated from Hindi"]}}

**Input:** "who is the most earning employee"
**Output:** {{"original_language": "English", "is_english": true, "corrected_query": "who is the highest earning employee", "corrections_made": ["most earning→highest earning"]}}

# RESPONSE FORMAT
Respond with ONLY a JSON object (no markdown, no explanation):
{{
    "original_language": "language name",
    "is_english": true|false,
    "corrected_query": "normalized English query",
    "corrections_made": ["list of changes made"],
    "confidence": "high|medium|low"
}}"""
    
    try:
        response = llm_manager.invoke([SystemMessage(content=preprocessing_prompt)])
        result = response.content.strip().replace('```json', '').replace('```', '')
        
        import json
        preprocessed = json.loads(result)
        preprocessed['original_query'] = user_query
        return preprocessed
        
    except Exception as e:
        return {
            "original_query": user_query,
            "original_language": "unknown",
            "is_english": True,
            "corrected_query": user_query,
            "corrections_made": [],
            "confidence": "low",
            "error": str(e)
        }

def preprocess_query(user_query: str) -> dict:
    """
    Full preprocessing with synonym expansion and context enhancement.
    This runs AFTER intent classification for confirmed database queries.
    
    - Expands synonyms (HR → Human Resources)
    - Adds domain-specific context
    - Enhances query clarity
    """
    
    # First, expand common synonyms and abbreviations
    expanded_query = user_query
    synonym_replacements = {
        r'\bHR\s+team\b': 'Human Resources department',
        r'\bHR\s+staff\b': 'Human Resources employees',
        r'\bHR\s+department\b': 'Human Resources department',
        r'\bhuman\s+resource\s+team\b': 'Human Resources department',
        r'\bin\s+HR\b': 'in Human Resources department',
        r'\bfrom\s+HR\b': 'from Human Resources department',
        r'\bmongo\s*db\s+logs\b': 'show collections in mongodb-logs database',
        r'\blogs\s+database\b': 'show collections in mongodb-logs database',
        r'\bwhat.*in\s+logs\b': 'show collections in mongodb-logs database',
        r'\btell.*about\s+logs\b': 'show me the collections and data in mongodb-logs database',
        r'\bmore.*about\s+logs\b': 'show me the collections and data in mongodb-logs database',
        r'\bshow.*logs\b': 'show recent logs from mongodb-logs database',
    }
    
    for pattern, replacement in synonym_replacements.items():
        expanded_query = re.sub(pattern, replacement, expanded_query, flags=re.IGNORECASE)
    
    # Use lightweight preprocessing first (translation + typo fixes)
    lightweight_result = lightweight_preprocess(user_query)
    
    # Apply synonym expansion to the corrected query
    corrected = lightweight_result.get('corrected_query', user_query)
    for pattern, replacement in synonym_replacements.items():
        corrected = re.sub(pattern, replacement, corrected, flags=re.IGNORECASE)
    
    # Return enhanced result
    lightweight_result['corrected_query'] = corrected
    lightweight_result['synonym_expansion_applied'] = True
    
    return lightweight_result

def fuzzy_match_database(query: str, available_databases: list) -> dict:
    """
    Fuzzy match database names from query
    Handles typos like "ecomerce" → "ecommerce", "finace" → "finance"
    """
    
    query_lower = query.lower()
    
    # Common typo patterns and synonyms
    typo_mappings = {
        'ecomerce': 'ecommerce',
        'ecomm': 'ecommerce',
        'finace': 'finance',
        'financ': 'finance',
        'helthcare': 'healthcare',
        'healthcar': 'healthcare',
        'logistic': 'logistics',
        'employe': 'employee',
        'human resource': 'hr',
        'human resources': 'hr',
        'hr team': 'hr department',
        'hr staff': 'hr employees',
        'employes': 'employees',
        'custmer': 'customer',
        'custmers': 'customers',
        'cours': 'course',
        'corses': 'courses',
        'enrollmnt': 'enrollment',
        'enrollmnts': 'enrollments',
        'prodct': 'product',
        'prodcts': 'products',
        'inventry': 'inventory',
        'inventroy': 'inventory',
        'markting': 'marketing',
        'suport': 'support',
        'educaton': 'education',
        'gamming': 'gaming',
        'travl': 'travel',
        'realestat': 'realestate',
        'evnts': 'events',
        'analytic': 'analytics',
        'analitics': 'analytics',
        'socail': 'social',
        'conten': 'content'
    }
    
    # Check for typos and correct
    corrected_query = query_lower
    corrections = []
    
    for typo, correct in typo_mappings.items():
        if typo in corrected_query:
            corrected_query = corrected_query.replace(typo, correct)
            corrections.append(f"{typo}→{correct}")
    
    # Try to match database names
    matched_databases = []
    
    for db_info in available_databases:
        db_name = db_info.get('name', '')
        db_desc = db_info.get('description', '').lower()
        
        # Check if database name or key terms appear in query
        db_parts = db_name.split('-')
        if len(db_parts) > 1:
            db_type = db_parts[1]  # e.g., "ecommerce", "finance"
            
            if db_type in corrected_query or db_type in query_lower:
                matched_databases.append({
                    'database': db_name,
                    'confidence': 'high',
                    'reason': f'Found "{db_type}" in query'
                })
    
    return {
        'corrected_query': corrected_query,
        'corrections': corrections,
        'matched_databases': matched_databases
    }

def enhance_query_with_context(query: str, preprocessing_result: dict) -> str:
    """
    Enhance query with helpful context based on preprocessing
    """
    
    corrected = preprocessing_result.get('corrected_query', query)
    
    # If language was translated, add note
    if not preprocessing_result.get('is_english', True):
        original_lang = preprocessing_result.get('original_language', 'unknown')
        return f"{corrected} (translated from {original_lang})"
    
    # If corrections were made, use corrected version
    if preprocessing_result.get('corrections_made'):
        return corrected
    
    return query
