@echo off
setlocal
set "DEST_DIR=C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\KwaBookmarker"
if not exist "%DEST_DIR%" (
    mkdir "%DEST_DIR%"
)
copy "%~dp0KwaBookmarker.toc" "%DEST_DIR%\"
copy "%~dp0KwaBookmarker.lua" "%DEST_DIR%\"

echo Files copied successfully to %DEST_DIR%
timeout /t 3
