@echo off
color 0a
cd ..
echo BUILDING GAME
lime build android -release
echo.
echo done.
pause
pwd
explorer.exe export\release\android\bin\app\build\outputs\apk\debug