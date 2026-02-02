@echo off
setlocal

REM generate GUID
for /f %%G in ('powershell -NoProfile -Command "[guid]::NewGuid()"') do set GUID=%%G

REM git commit
git add .
git commit -m "%GUID%"
git push

REM run remote build
bsd sh ~/mochi-src/build.sh

endlocal
