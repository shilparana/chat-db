#!/usr/bin/env python3
"""
Schema indexing script for vector store
Run this after database initialization to populate ChromaDB
"""

import sys
import os
import time

# Add parent directory to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.vector_store import vector_store
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def main():
    """Index all database schemas into vector store"""
    logger.info("=" * 60)
    logger.info("Schema Indexing for Vector Store")
    logger.info("=" * 60)
    
    # Index schemas (ChromaDB uses local file-based storage)
    try:
        if not vector_store.client:
            logger.error("❌ ChromaDB client not initialized")
            return 1
            
        vector_store.index_all_schemas()
        logger.info("=" * 60)
        logger.info("✅ Schema indexing complete!")
        logger.info("=" * 60)
        return 0
    except Exception as e:
        logger.error(f"❌ Schema indexing failed: {e}")
        import traceback
        logger.error(traceback.format_exc())
        return 1

if __name__ == "__main__":
    sys.exit(main())
