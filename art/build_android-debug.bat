@echo off
color 0a
cd ..
echo BUILDING GAME
lime build android -debug
echo.
echo done.
pause
pwd
explorer.exe export\debug\android\bin\app\build\outputs\apk\debug