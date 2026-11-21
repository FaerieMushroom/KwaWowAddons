@echo off
setlocal
set "DEST_DIR=C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\KwaLite"
if not exist "%DEST_DIR%" (
    mkdir "%DEST_DIR%"
)
copy "%~dp0KwaLite.lua" "%DEST_DIR%\"
copy "%~dp0KwaLiteUtil.lua" "%DEST_DIR%\"
copy "%~dp0KwaLite.toc" "%DEST_DIR%\"

echo Files copied successfully to %DEST_DIR%
timeout /t 3
