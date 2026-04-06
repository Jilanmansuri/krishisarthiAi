@echo off
REM Batch script for Windows .env setup

setlocal enabledelayedexpansion

REM Generate random JWT Secret (using Python for better randomness)
for /f "tokens=*" %%i in ('python -c "import os; print(os.urandom(32).hex())"') do set JWT_SECRET=%%i

REM Create .env file
(
    echo # Generated on %date% %time%
    echo # Environment: production
    echo.
    echo NODE_ENV=production
    echo BACKEND_PORT=5000
    echo FRONTEND_PORT=3000
    echo.
    echo MONGODB_URI=mongodb://admin:admin123@localhost:27017/krishiai?authSource=admin
    echo MONGO_ROOT_USER=admin
    echo MONGO_ROOT_PASSWORD=admin123
    echo MONGO_PORT=27017
    echo.
    echo JWT_SECRET=%JWT_SECRET%
    echo CORS_ORIGIN=http://localhost:3000
    echo.
    echo GOOGLE_GENAI_API_KEY=
    echo OPENAI_API_KEY=
    echo GROK_API_KEY=
    echo.
    echo REACT_APP_API_URL=http://localhost:5000
    echo.
    echo LOG_LEVEL=info
) > .env

echo.
echo Checkmark .env file created successfully!
echo Please update API keys in .env file:
echo - GOOGLE_GENAI_API_KEY
echo - OPENAI_API_KEY
echo - GROK_API_KEY
echo.
echo To start deployment:
echo docker-compose up -d
