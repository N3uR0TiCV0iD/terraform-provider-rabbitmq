@echo off
echo Bulding project. . .
cd ..
go build -ldflags="-w -s"
cls
echo Bulding project. . . [DONE]
echo.
echo Press any key to exit. . .
pause>nul
