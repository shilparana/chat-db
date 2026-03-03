@echo off
echo ========================================
echo Text-to-SQL Multi-Database Chatbot
echo ========================================
echo.

REM Activate virtual environment
call .venv\Scripts\activate.bat

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Docker is not running!
    echo Starting Docker databases is recommended.
    echo.
    choice /C YN /M "Continue anyway"
    if errorlevel 2 exit /b 1
) else (
    REM Start databases if not running
    echo Starting databases...
    docker-compose up -d >nul 2>&1
    timeout /t 5 /nobreak >nul
)

REM Start FastAPI server in background
echo Starting API server...
start /B cmd /c "call .venv\Scripts\activate.bat && python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8001 --log-level warning --no-access-log >nul 2>&1"

REM Wait for server to start
echo Waiting for server to start...
timeout /t 10 /nobreak >nul

REM Start chatbot
echo.
echo ========================================
echo Starting Interactive Chatbot
echo ========================================
echo.
call .venv\Scripts\activate.bat
python chatbot.py

REM Auto-terminate batch job when chatbot exits
exit /b 0
