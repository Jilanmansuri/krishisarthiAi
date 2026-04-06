@echo off
REM Windows Pre-Deployment Checklist

setlocal enabledelayedexpansion

echo.
echo ========================================
echo  KrishiSarthi Pre-Deployment Checklist
echo ========================================
echo.

set PASS=0
set FAIL=0

REM 1. Check if .env exists
if exist ".env" (
    echo [✓] .env file found
    set /a PASS+=1
) else (
    echo [✗] .env file not found - run: copy .env.example .env
    set /a FAIL+=1
)

REM 2. Check if docker-compose.yml exists
if exist "docker-compose.yml" (
    echo [✓] docker-compose.yml found
    set /a PASS+=1
) else (
    echo [✗] docker-compose.yml not found
    set /a FAIL+=1
)

REM 3. Check Dockerfiles
if exist "backend\Dockerfile" (
    echo [✓] backend/Dockerfile found
    set /a PASS+=1
) else (
    echo [✗] backend/Dockerfile not found
    set /a FAIL+=1
)

if exist "frontend\Dockerfile" (
    echo [✓] frontend/Dockerfile found
    set /a PASS+=1
) else (
    echo [✗] frontend/Dockerfile not found
    set /a FAIL+=1
)

REM 4. Check nginx.conf
if exist "nginx.conf" (
    echo [✓] nginx.conf found
    set /a PASS+=1
) else (
    echo [✗] nginx.conf not found
    set /a FAIL+=1
)

echo.
echo ========================================
echo  Results: PASS: %PASS%, FAIL: %FAIL%
echo ========================================
echo.

if %FAIL% equ 0 (
    echo [✓] Ready for deployment!
    echo.
    echo Next steps:
    echo 1. Edit .env with your configuration
    echo 2. Run: docker-compose up -d
    echo 3. Check: http://localhost
) else (
    echo [✗] Please fix errors above
    exit /b 1
)
