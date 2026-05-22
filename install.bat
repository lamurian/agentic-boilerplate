@echo off
setlocal
set "BASE_URL=https://raw.githubusercontent.com/lamurian/agentic-boilerplate/master"
set "PS=%TEMP%\agentic-install.ps1"

echo agentic-boilerplate -- downloading installer...
echo.

REM Download the PowerShell installer script
curl.exe -fsSLo "%PS%" "%BASE_URL%/install.ps1"
if errorlevel 1 (
    echo Failed to download installer from GitHub.
    echo Check your internet connection and try again.
    pause
    exit /b 1
)

REM Run it
powershell -ExecutionPolicy Bypass -File "%PS%"
set "EXITCODE=%errorlevel%"

del "%PS%" 2>nul

if %EXITCODE% neq 0 (
    echo.
    echo Installation encountered errors. Check messages above.
    pause
    exit /b %EXITCODE%
)

endlocal
