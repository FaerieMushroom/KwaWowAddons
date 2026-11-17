@echo off
setlocal
set "DEST_DIR=C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\KwaPetSkills"
if not exist "%DEST_DIR%" (
    mkdir "%DEST_DIR%"
)
copy "%~dp0KwaPetSkillsData.lua" "%DEST_DIR%\"
copy "%~dp0KwaPetSkills.lua" "%DEST_DIR%\"
copy "%~dp0KwaPetSkills.toc" "%DEST_DIR%\"

echo Files copied successfully to %DEST_DIR%
timeout /t 3
