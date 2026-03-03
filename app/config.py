from pydantic_settings import BaseSettings
from typing import Dict, Optional
import os

class Settings(BaseSettings):
    azure_openai_api_key: Optional[str] = None
    azure_openai_endpoint: Optional[str] = None
    azure_openai_deployment: Optional[str] = "gpt-4o-mini"
    azure_openai_api_version: Optional[str] = "2025-04-01-preview"
    
    tavily_api_key: Optional[str] = None
    use_tavily: bool = False
    
    langchain_api_key: Optional[str] = None
    langchain_tracing_v2: bool = False
    langchain_project: str = "db_chat"
    
    log_level: str = "INFO"
    
    postgres_ecommerce_host: str = "localhost"
    postgres_ecommerce_port: int = 5432
    postgres_ecommerce_db: str = "ecommerce_db"
    postgres_ecommerce_user: str = "dbuser"
    postgres_ecommerce_password: str = "dbpass123"
    
    postgres_finance_host: str = "localhost"
    postgres_finance_port: int = 5433
    postgres_finance_db: str = "finance_db"
    postgres_finance_user: str = "dbuser"
    postgres_finance_password: str = "dbpass123"
    
    postgres_healthcare_host: str = "localhost"
    postgres_healthcare_port: int = 5434
    postgres_healthcare_db: str = "healthcare_db"
    postgres_healthcare_user: str = "dbuser"
    postgres_healthcare_password: str = "dbpass123"
    
    postgres_logistics_host: str = "localhost"
    postgres_logistics_port: int = 5435
    postgres_logistics_db: str = "logistics_db"
    postgres_logistics_user: str = "dbuser"
    postgres_logistics_password: str = "dbpass123"
    
    postgres_hr_host: str = "localhost"
    postgres_hr_port: int = 5436
    postgres_hr_db: str = "hr_db"
    postgres_hr_user: str = "dbuser"
    postgres_hr_password: str = "dbpass123"
    
    mysql_crm_host: str = "localhost"
    mysql_crm_port: int = 3306
    mysql_crm_db: str = "crm_db"
    mysql_crm_user: str = "dbuser"
    mysql_crm_password: str = "dbpass123"
    
    mysql_inventory_host: str = "localhost"
    mysql_inventory_port: int = 3307
    mysql_inventory_db: str = "inventory_db"
    mysql_inventory_user: str = "dbuser"
    mysql_inventory_password: str = "dbpass123"
    
    mysql_sales_host: str = "localhost"
    mysql_sales_port: int = 3308
    mysql_sales_db: str = "sales_db"
    mysql_sales_user: str = "dbuser"
    mysql_sales_password: str = "dbpass123"
    
    mysql_marketing_host: str = "localhost"
    mysql_marketing_port: int = 3309
    mysql_marketing_db: str = "marketing_db"
    mysql_marketing_user: str = "dbuser"
    mysql_marketing_password: str = "dbpass123"
    
    mysql_support_host: str = "localhost"
    mysql_support_port: int = 3310
    mysql_support_db: str = "support_db"
    mysql_support_user: str = "dbuser"
    mysql_support_password: str = "dbpass123"
    
    mariadb_education_host: str = "localhost"
    mariadb_education_port: int = 3311
    mariadb_education_db: str = "education_db"
    mariadb_education_user: str = "dbuser"
    mariadb_education_password: str = "dbpass123"
    
    mariadb_gaming_host: str = "localhost"
    mariadb_gaming_port: int = 3312
    mariadb_gaming_db: str = "gaming_db"
    mariadb_gaming_user: str = "dbuser"
    mariadb_gaming_password: str = "dbpass123"
    
    mariadb_travel_host: str = "localhost"
    mariadb_travel_port: int = 3313
    mariadb_travel_db: str = "travel_db"
    mariadb_travel_user: str = "dbuser"
    mariadb_travel_password: str = "dbpass123"
    
    mariadb_realestate_host: str = "localhost"
    mariadb_realestate_port: int = 3314
    mariadb_realestate_db: str = "realestate_db"
    mariadb_realestate_user: str = "dbuser"
    mariadb_realestate_password: str = "dbpass123"
    
    mariadb_events_host: str = "localhost"
    mariadb_events_port: int = 3315
    mariadb_events_db: str = "events_db"
    mariadb_events_user: str = "dbuser"
    mariadb_events_password: str = "dbpass123"
    
    mongodb_analytics_host: str = "localhost"
    mongodb_analytics_port: int = 27017
    mongodb_analytics_db: str = "analytics_db"
    mongodb_analytics_user: str = "dbuser"
    mongodb_analytics_password: str = "dbpass123"
    
    mongodb_logs_host: str = "localhost"
    mongodb_logs_port: int = 27018
    mongodb_logs_db: str = "logs_db"
    mongodb_logs_user: str = "dbuser"
    mongodb_logs_password: str = "dbpass123"
    
    mongodb_social_host: str = "localhost"
    mongodb_social_port: int = 27019
    mongodb_social_db: str = "social_db"
    mongodb_social_user: str = "dbuser"
    mongodb_social_password: str = "dbpass123"
    
    mongodb_iot_host: str = "localhost"
    mongodb_iot_port: int = 27020
    mongodb_iot_db: str = "iot_db"
    mongodb_iot_user: str = "dbuser"
    mongodb_iot_password: str = "dbpass123"
    
    mongodb_content_host: str = "localhost"
    mongodb_content_port: int = 27021
    mongodb_content_db: str = "content_db"
    mongodb_content_user: str = "dbuser"
    mongodb_content_password: str = "dbpass123"
    
    class Config:
        env_file = ".env"
        case_sensitive = False

settings = Settings()

# Set LangSmith environment variables immediately for tracing
# This must happen before any LangChain imports
import logging
logger = logging.getLogger(__name__)

if settings.langchain_api_key:
    os.environ["LANGCHAIN_API_KEY"] = settings.langchain_api_key
    logger.info(f"✅ LangSmith API key configured")
if settings.langchain_tracing_v2:
    os.environ["LANGCHAIN_TRACING_V2"] = "true"
    logger.info(f"✅ LangSmith tracing enabled: LANGCHAIN_TRACING_V2=true")
if settings.langchain_project:
    os.environ["LANGCHAIN_PROJECT"] = settings.langchain_project
    logger.info(f"✅ LangSmith project: {settings.langchain_project}")

DATABASE_CONFIGS = {
    "postgres-ecommerce": {
        "type": "postgresql",
        "host": settings.postgres_ecommerce_host,
        "port": settings.postgres_ecommerce_port,
        "database": settings.postgres_ecommerce_db,
        "user": settings.postgres_ecommerce_user,
        "password": settings.postgres_ecommerce_password,
        "description": "E-commerce database with products, orders, customers"
    },
    "postgres-finance": {
        "type": "postgresql",
        "host": settings.postgres_finance_host,
        "port": settings.postgres_finance_port,
        "database": settings.postgres_finance_db,
        "user": settings.postgres_finance_user,
        "password": settings.postgres_finance_password,
        "description": "Finance database with accounts, transactions, loans"
    },
    "postgres-healthcare": {
        "type": "postgresql",
        "host": settings.postgres_healthcare_host,
        "port": settings.postgres_healthcare_port,
        "database": settings.postgres_healthcare_db,
        "user": settings.postgres_healthcare_user,
        "password": settings.postgres_healthcare_password,
        "description": "Healthcare database with patients, doctors, appointments"
    },
    "postgres-logistics": {
        "type": "postgresql",
        "host": settings.postgres_logistics_host,
        "port": settings.postgres_logistics_port,
        "database": settings.postgres_logistics_db,
        "user": settings.postgres_logistics_user,
        "password": settings.postgres_logistics_password,
        "description": "Logistics database with warehouses, shipments, deliveries"
    },
    "postgres-hr": {
        "type": "postgresql",
        "host": settings.postgres_hr_host,
        "port": settings.postgres_hr_port,
        "database": settings.postgres_hr_db,
        "user": settings.postgres_hr_user,
        "password": settings.postgres_hr_password,
        "description": "HR database with employees, attendance, payroll"
    },
    "mysql-crm": {
        "type": "mysql",
        "host": settings.mysql_crm_host,
        "port": settings.mysql_crm_port,
        "database": settings.mysql_crm_db,
        "user": settings.mysql_crm_user,
        "password": settings.mysql_crm_password,
        "description": "CRM database with contacts, companies, opportunities"
    },
    "mysql-inventory": {
        "type": "mysql",
        "host": settings.mysql_inventory_host,
        "port": settings.mysql_inventory_port,
        "database": settings.mysql_inventory_db,
        "user": settings.mysql_inventory_user,
        "password": settings.mysql_inventory_password,
        "description": "Inventory database with items, suppliers, purchase orders"
    },
    "mysql-sales": {
        "type": "mysql",
        "host": settings.mysql_sales_host,
        "port": settings.mysql_sales_port,
        "database": settings.mysql_sales_db,
        "user": settings.mysql_sales_user,
        "password": settings.mysql_sales_password,
        "description": "Sales database with orders, customers, sales reps"
    },
    "mysql-marketing": {
        "type": "mysql",
        "host": settings.mysql_marketing_host,
        "port": settings.mysql_marketing_port,
        "database": settings.mysql_marketing_db,
        "user": settings.mysql_marketing_user,
        "password": settings.mysql_marketing_password,
        "description": "Marketing database with campaigns, subscribers, analytics"
    },
    "mysql-support": {
        "type": "mysql",
        "host": settings.mysql_support_host,
        "port": settings.mysql_support_port,
        "database": settings.mysql_support_db,
        "user": settings.mysql_support_user,
        "password": settings.mysql_support_password,
        "description": "Support database with tickets, agents, knowledge base"
    },
    "mariadb-education": {
        "type": "mysql",
        "host": settings.mariadb_education_host,
        "port": settings.mariadb_education_port,
        "database": settings.mariadb_education_db,
        "user": settings.mariadb_education_user,
        "password": settings.mariadb_education_password,
        "description": "Education database with students, courses, assignments"
    },
    "mariadb-gaming": {
        "type": "mysql",
        "host": settings.mariadb_gaming_host,
        "port": settings.mariadb_gaming_port,
        "database": settings.mariadb_gaming_db,
        "user": settings.mariadb_gaming_user,
        "password": settings.mariadb_gaming_password,
        "description": "Gaming database with players, characters, quests"
    },
    "mariadb-travel": {
        "type": "mysql",
        "host": settings.mariadb_travel_host,
        "port": settings.mariadb_travel_port,
        "database": settings.mariadb_travel_db,
        "user": settings.mariadb_travel_user,
        "password": settings.mariadb_travel_password,
        "description": "Travel database with bookings, hotels, flights"
    },
    "mariadb-realestate": {
        "type": "mysql",
        "host": settings.mariadb_realestate_host,
        "port": settings.mariadb_realestate_port,
        "database": settings.mariadb_realestate_db,
        "user": settings.mariadb_realestate_user,
        "password": settings.mariadb_realestate_password,
        "description": "Real estate database with properties, agents, transactions"
    },
    "mariadb-events": {
        "type": "mysql",
        "host": settings.mariadb_events_host,
        "port": settings.mariadb_events_port,
        "database": settings.mariadb_events_db,
        "user": settings.mariadb_events_user,
        "password": settings.mariadb_events_password,
        "description": "Events database with venues, registrations, speakers"
    },
    "mongodb-analytics": {
        "type": "mongodb",
        "host": settings.mongodb_analytics_host,
        "port": settings.mongodb_analytics_port,
        "database": settings.mongodb_analytics_db,
        "user": settings.mongodb_analytics_user,
        "password": settings.mongodb_analytics_password,
        "description": "Analytics database with user sessions, events, conversions"
    },
    "mongodb-logs": {
        "type": "mongodb",
        "host": settings.mongodb_logs_host,
        "port": settings.mongodb_logs_port,
        "database": settings.mongodb_logs_db,
        "user": settings.mongodb_logs_user,
        "password": settings.mongodb_logs_password,
        "description": "Logs database with application, error, and audit logs"
    },
    "mongodb-social": {
        "type": "mongodb",
        "host": settings.mongodb_social_host,
        "port": settings.mongodb_social_port,
        "database": settings.mongodb_social_db,
        "user": settings.mongodb_social_user,
        "password": settings.mongodb_social_password,
        "description": "Social media database with posts, comments, users"
    },
    "mongodb-iot": {
        "type": "mongodb",
        "host": settings.mongodb_iot_host,
        "port": settings.mongodb_iot_port,
        "database": settings.mongodb_iot_db,
        "user": settings.mongodb_iot_user,
        "password": settings.mongodb_iot_password,
        "description": "IoT database with devices, sensor readings, alerts"
    },
    "mongodb-content": {
        "type": "mongodb",
        "host": settings.mongodb_content_host,
        "port": settings.mongodb_content_port,
        "database": settings.mongodb_content_db,
        "user": settings.mongodb_content_user,
        "password": settings.mongodb_content_password,
        "description": "Content management database with articles, authors, media"
    }
}
