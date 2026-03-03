@echo off
echo ========================================
echo Text-to-SQL Multi-Database Agent Setup
echo ========================================
echo.
echo This will set up everything you need:
echo   - Python virtual environment
echo   - All dependencies
echo   - Docker databases
echo.
pause

REM ============================================
REM Step 1: Python Environment
REM ============================================
echo.
echo ========================================
echo Step 1/3: Python Environment
echo ========================================
echo.

REM Install UV if needed
where uv >nul 2>&1
if errorlevel 1 (
    echo Installing UV...
    pip install uv
)

REM Remove old venv if exists
if exist .venv (
    echo Removing old virtual environment...
    powershell -Command "Remove-Item -Path .venv -Recurse -Force -ErrorAction SilentlyContinue"
    timeout /t 2 /nobreak >nul
)

REM Create fresh venv
echo Creating virtual environment...
uv venv --clear
if errorlevel 1 (
    echo Failed to create virtual environment
    pause
    exit /b 1
)

REM Activate venv
call .venv\Scripts\activate.bat

REM Install dependencies from requirements.txt
echo Installing dependencies (this may take a few minutes)...
uv pip install -r requirements.txt
if errorlevel 1 (
    echo Failed to install dependencies from requirements.txt
    pause
    exit /b 1
)

echo [OK] Python environment ready!

REM ============================================
REM Step 2: Docker Databases
REM ============================================
echo.
echo ========================================
echo Step 2/3: Docker Databases
echo ========================================
echo.

docker info >nul 2>&1
if errorlevel 1 (
    echo [!] Docker is not running!
    echo.
    echo Please start Docker Desktop, then run this setup again.
    echo Or you can start it later before running the app.
    echo.
) else (
    echo [OK] Docker is running!
    echo.
    echo Starting all 20 databases...
    docker-compose up -d
    if errorlevel 1 (
        echo [!] Failed to start containers
        echo Make sure docker-compose.yml exists
    ) else (
        echo [OK] All databases started!
    )
)

REM ============================================
REM Step 3: Index Schemas into Vector Store
REM ============================================
echo.
echo ========================================
echo Step 3/3: Indexing Database Schemas
echo ========================================
echo.

REM Clean up old vector store data to prevent duplicate warnings
if exist chroma_db (
    echo Cleaning up old vector store data...
    rmdir /s /q chroma_db 2>nul
)

REM Index schemas into ChromaDB (local file-based storage)
echo Indexing schemas into vector store...
.venv\Scripts\python.exe scripts\index_schemas.py
if errorlevel 1 (
    echo [!] Schema indexing had some issues, but continuing...
) else (
    echo [OK] Schema indexing complete!
)

REM ============================================
REM Configuration
REM ============================================
echo.
echo ========================================
echo Configuration
echo ========================================
echo.

if not exist .env (
    echo Creating .env file from template...
    copy .env.example .env >nul
    echo.
    echo [!] IMPORTANT: Edit .env and add your Azure OpenAI API key
    echo.
    choice /C YN /M "Open .env file in notepad now"
    if errorlevel 2 goto skip_env
    if errorlevel 1 notepad .env
) else (
    echo [OK] .env file already exists
)

:skip_env

REM ============================================
REM Setup Complete
REM ============================================
echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo What's ready:
if exist .venv\Scripts\activate.bat (
    echo   [OK] Python environment
) else (
    echo   [X] Python environment
)

docker info >nul 2>&1
if errorlevel 1 (
    echo   [!] Docker not running
) else (
    echo   [OK] Docker databases
)

if exist .env (
    echo   [OK] Configuration file
) else (
    echo   [X] Configuration file
)

echo.
echo Next steps:
echo   1. Make sure Docker Desktop is running
echo   2. Edit .env with your Azure OpenAI key (if using)
echo   3. Run: chatbot.bat
echo.
echo For more information, see: README.md
echo.
pause
