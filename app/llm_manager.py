"""
LLM Manager for Azure OpenAI
"""

from langchain_openai import AzureChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage, BaseMessage
from app.config import settings
import logging
from typing import Optional, List

logger = logging.getLogger(__name__)

class LLMManager:
    """
    Manages Azure OpenAI LLM connection
    """

    def __init__(self):
        self.llm = None
        self.available = False

        self._initialize_llm()

    def _initialize_llm(self):
        """Initialize Azure OpenAI LLM"""
        
        # Verify LangSmith environment variables
        import os
        langsmith_enabled = os.getenv("LANGCHAIN_TRACING_V2") == "true"
        langsmith_project = os.getenv("LANGCHAIN_PROJECT")
        
        if langsmith_enabled:
            logger.info(f"🔍 LangSmith tracing is ENABLED for project: {langsmith_project}")
        else:
            logger.warning(f"⚠️  LangSmith tracing is DISABLED (LANGCHAIN_TRACING_V2={os.getenv('LANGCHAIN_TRACING_V2')})")

        try:
            if settings.azure_openai_api_key and settings.azure_openai_endpoint:
                self.llm = AzureChatOpenAI(
                    azure_endpoint=settings.azure_openai_endpoint,
                    azure_deployment=settings.azure_openai_deployment,
                    api_version=settings.azure_openai_api_version,
                    api_key=settings.azure_openai_api_key,
                    temperature=0,
                    timeout=60
                )

                # Test connection
                try:
                    test_response = self.llm.invoke([HumanMessage(content="test")])
                    self.available = True
                    logger.info("✅ Azure OpenAI connected successfully")
                    if langsmith_enabled:
                        logger.info(f"📊 All LLM calls will be traced to LangSmith project: {langsmith_project}")
                except Exception as e:
                    logger.warning(f"⚠️  Azure OpenAI test failed: {str(e)}")
                    self.available = False
            else:
                logger.warning("⚠️  Azure OpenAI credentials not configured")
                self.available = False
        except Exception as e:
            logger.error(f"❌ Failed to initialize Azure OpenAI: {str(e)}")
            self.available = False

        if not self.available:
            logger.error("❌ Azure OpenAI not available! Please configure valid credentials in .env file")

    def invoke(self, messages: List[BaseMessage]) -> str:
        """
        Invoke Azure OpenAI LLM

        Args:
            messages: List of messages to send

        Returns:
            Response content as string
        """

        if not self.available:
            raise Exception("Azure OpenAI not available. Please configure valid credentials in .env file")

        try:
            response = self.llm.invoke(messages)
            return response
        except Exception as e:
            logger.error(f"❌ Azure OpenAI failed: {str(e)}")
            raise e

    def get_status(self) -> dict:
        """Get status of Azure OpenAI connection"""
        return {
            "available": self.available,
            "type": "Azure OpenAI" if self.available else "Not configured"
        }

# Global LLM manager instance
llm_manager = LLMManager()
