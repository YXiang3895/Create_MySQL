:: This file will install python and chocolatey

@echo off
:: Enable error handling
setlocal enabledelayedexpansion

:: S1-1. Check if Chocolateyis needed to install
echo Checking if Chocolatey is already installed...
choco -v >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Chocolatey is already installed.
) else (
    echo Installing Chocolatey...
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    if %ERRORLEVEL% neq 0 (
        echo Error occurred while installing Chocolatey. Exiting...
        pause
        exit /b %ERRORLEVEL%
    )
)

:: S1-2. Check if Python is needed to install
echo Checking if Python is already installed...
python --version >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Python is already installed.
) else (
    echo Installing Python...
    choco install python -y
    if %ERRORLEVEL% neq 0 (
        echo Error occurred while installing Python. Exiting...
        pause
        exit /b %ERRORLEVEL%
    )
)

:: S1-3. Show version of Python 
echo Installation completed. Verifying Python version...
python --version
if %ERRORLEVEL% neq 0 (
    echo Error occurred while verifying Python version. Exiting...
    pause
    exit /b %ERRORLEVEL%
)

:: S2-1. Check if mysql-connector-python is needed to install 
echo Checking if mysql-connector-python is installed...
python -m pip show mysql-connector-python >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo mysql-connector-python is already installed.
) else (
    echo mysql-connector-python is not installed. Installing...
    python -m pip install mysql-connector-python
    if %ERRORLEVEL% neq 0 (
        echo Error occurred while installing mysql-connector-python. Exiting...
        pause
        exit /b %ERRORLEVEL%
    )
)

:: S2-2. Check mysql-connector-python's installation
echo Verifying mysql-connector-python installation...
python -m pip show mysql-connector-python
if %ERRORLEVEL% neq 0 (
    echo Error occurred while verifying mysql-connector-python installation. Exiting...
    pause
    exit /b %ERRORLEVEL%
)

:: S3. Run Python
echo Running Python script from the current directory...
python "%~dp0CreateDB.py"
if %ERRORLEVEL% neq 0 (
    echo Error occurred while running the Python script. Exiting...
    pause
    exit /b %ERRORLEVEL%
)

:: S4. Done
echo All tasks completed successfully!
pause
