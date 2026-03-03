#!/usr/bin/env python3
"""
Script to split INSERT statements from schema files into separate data files
This keeps schema files clean for vector DB indexing
"""

import os
import re

# Define all database directories
SQL_DATABASES = [
    'postgres-ecommerce', 'postgres-finance', 'postgres-healthcare', 'postgres-logistics', 'postgres-hr',
    'mysql-crm', 'mysql-inventory', 'mysql-sales', 'mysql-marketing', 'mysql-support',
    'mariadb-education', 'mariadb-gaming', 'mariadb-travel', 'mariadb-realestate', 'mariadb-events'
]

MONGO_DATABASES = [
    'mongodb-analytics', 'mongodb-logs', 'mongodb-social', 'mongodb-iot', 'mongodb-content'
]

def split_sql_file(db_dir):
    """Split SQL file into schema and data files"""
    schema_file = os.path.join(db_dir, '01-init.sql')
    data_file = os.path.join(db_dir, '02-data.sql')
    
    if not os.path.exists(schema_file):
        print(f"⚠️  {schema_file} not found, skipping...")
        return
    
    with open(schema_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Split content into lines
    lines = content.split('\n')
    
    schema_lines = []
    data_lines = []
    in_insert_section = False
    in_create_index = False
    
    for line in lines:
        stripped = line.strip()
        
        # Check if we're starting an INSERT statement
        if stripped.startswith('INSERT INTO'):
            in_insert_section = True
            data_lines.append(line)
        # Check if we're starting CREATE INDEX
        elif stripped.startswith('CREATE INDEX'):
            in_create_index = True
            schema_lines.append(line)
        # Continue INSERT block
        elif in_insert_section:
            data_lines.append(line)
            # End of INSERT when we hit a semicolon at end of line or empty line after semicolon
            if ';' in line:
                in_insert_section = False
        # Continue CREATE INDEX block
        elif in_create_index:
            schema_lines.append(line)
            if ';' in line:
                in_create_index = False
        # Regular schema lines
        else:
            schema_lines.append(line)
    
    # Write schema file (only CREATE TABLE and CREATE INDEX)
    with open(schema_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(schema_lines).rstrip() + '\n')
    
    # Write data file (only INSERT statements)
    if data_lines:
        with open(data_file, 'w', encoding='utf-8') as f:
            f.write('-- Sample data for database\n')
            f.write('-- This file is loaded after schema creation\n\n')
            f.write('\n'.join(data_lines).strip() + '\n')
        print(f"✅ Split {db_dir}: schema -> 01-init.sql, data -> 02-data.sql")
    else:
        print(f"ℹ️  {db_dir}: No INSERT statements found")

def split_mongo_file(db_dir):
    """Split MongoDB JS file into schema and data files"""
    schema_file = os.path.join(db_dir, 'init.js')
    data_file = os.path.join(db_dir, 'data.js')
    
    if not os.path.exists(schema_file):
        print(f"⚠️  {schema_file} not found, skipping...")
        return
    
    with open(schema_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    lines = content.split('\n')
    
    schema_lines = []
    data_lines = []
    in_insert_section = False
    
    for line in lines:
        stripped = line.strip()
        
        # Check if we're starting an insertMany or insertOne
        if 'insertMany' in stripped or 'insertOne' in stripped:
            in_insert_section = True
            data_lines.append(line)
        # Continue insert block
        elif in_insert_section:
            data_lines.append(line)
            # End of insert when we hit closing parenthesis and semicolon
            if ']);' in line or ');' in line:
                in_insert_section = False
        # Schema lines (comments, db.createCollection, createIndex)
        else:
            schema_lines.append(line)
    
    # Write schema file (only createCollection and createIndex)
    with open(schema_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(schema_lines).rstrip() + '\n')
    
    # Write data file (only insert statements)
    if data_lines:
        with open(data_file, 'w', encoding='utf-8') as f:
            f.write('// Sample data for database\n')
            f.write('// This file is loaded after schema creation\n\n')
            f.write('\n'.join(data_lines).strip() + '\n')
        print(f"✅ Split {db_dir}: schema -> init.js, data -> data.js")
    else:
        print(f"ℹ️  {db_dir}: No insert statements found")

def main():
    """Main function to split all database files"""
    print("=" * 60)
    print("Splitting Schema and Data Files")
    print("=" * 60)
    
    base_dir = os.path.join(os.path.dirname(__file__), '..', 'init-scripts')
    
    # Process SQL databases
    print("\n📊 Processing SQL databases...")
    for db_name in SQL_DATABASES:
        db_dir = os.path.join(base_dir, db_name)
        split_sql_file(db_dir)
    
    # Process MongoDB databases
    print("\n📊 Processing MongoDB databases...")
    for db_name in MONGO_DATABASES:
        db_dir = os.path.join(base_dir, db_name)
        split_mongo_file(db_dir)
    
    print("\n" + "=" * 60)
    print("✅ Split complete!")
    print("=" * 60)
    print("\nSchema files now contain only:")
    print("  - Table/collection definitions")
    print("  - Column comments")
    print("  - Indexes")
    print("\nData files contain:")
    print("  - INSERT statements (SQL)")
    print("  - insertMany/insertOne (MongoDB)")

if __name__ == '__main__':
    main()
