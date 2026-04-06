@echo off
REM Deployment script for Windows (PowerShell recommended, but this is batch)

setlocal enabledelayedexpansion

set ENVIRONMENT=%1
set TAG=%2

if "%ENVIRONMENT%"=="" set ENVIRONMENT=production
if "%TAG%"=="" set TAG=latest

echo.
echo ====================================
echo 🚀 KrishiSarthi Deployment
echo ====================================
echo Environment: %ENVIRONMENT%
echo Tag: %TAG%
echo.

REM Build images
echo Building Docker images...
docker-compose build --no-cache

if errorlevel 1 (
    echo Error: Build failed
    exit /b 1
)

echo.
echo Deployment completed!
echo.
echo Services:
docker-compose ps
echo.
