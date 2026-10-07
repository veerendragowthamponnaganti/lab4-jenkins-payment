@echo off

echo ======================================
echo Starting Production Deployment
echo ======================================

if "%~1"=="" (
    echo ERROR: No artifact provided
    exit /b 1
)

if not exist "%~1" (
    echo ERROR: Artifact not found: %~1
    exit /b 1
)

echo Deploying exact artifact:
echo %~1

if not exist deployed mkdir deployed

copy /Y "%~1" "deployed\payment.jar" >nul

if errorlevel 1 (
    echo ERROR: Deployment failed
    exit /b 1
)

echo.
echo Deployed artifact:
dir "deployed\payment.jar"

echo ======================================
echo Production Deployment Successful
echo ======================================