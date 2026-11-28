@echo off
setlocal
set "ADDONS_DIR=C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns"
set "DEST_DIR=%ADDONS_DIR%\KwaMiscUtilities"
if exist "%ADDONS_DIR%\KwaXpTracker" rmdir /s /q "%ADDONS_DIR%\KwaXpTracker"
if not exist "%DEST_DIR%" (
    mkdir "%DEST_DIR%"
)
copy "%~dp0KwaMiscUtilities.lua" "%DEST_DIR%\"
copy "%~dp0KwaMiscUtilities.toc" "%DEST_DIR%\"

echo Files copied successfully to %DEST_DIR%
timeout /t 3
