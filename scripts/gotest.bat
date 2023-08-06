@echo off
SETLOCAL EnableDelayedExpansion
set files=
cd ..\rabbitmq
FOR %%F IN (*.go) DO (
    set fileName=%%~nF
    call :IsValidFileName !fileName!
    if !_returnValue!==1 (
        set files=!files!!fileName!.go 
    )
)
echo Executing tests. . .
echo.
echo go test -v !files!
go test -v !files!
echo Test execution ended
echo.
echo Press any key to exit. . .
pause>nul
exit

::IsValidFileName(fileName)
:IsValidFileName
    call :strbegins %1 import_
    if !_returnValue!==1 (
        set _returnValue=0
        goto :EOF
    )

    call :strbegins %1 data_source_
    if !_returnValue!==1 (
        call :strends %1 _test
        if !_returnValue!==1 (
            set _returnValue=0
            goto :EOF
        )
    )

    call :strbegins %1 resource_
    if !_returnValue!==1 (
        call :strends %1 _test
        if !_returnValue!==1 (
            set _returnValue=0
            goto :EOF
        )
    )

    set _returnValue=1
goto :EOF

::strbegins(text, value)
:strbegins
    set __text=%~1
    call :strlen %2
    set __substring=!__text:~0,%_returnValue%!
    if "!__substring!"=="%~2" (
        set _returnValue=1
        goto :EOF
    )
    set _returnValue=0
goto :EOF

::strends(text, value)
:strends
    set __text=%~1
    call :strlen %1
    set __textLength=!_returnValue!
    
    call :strlen %2
    set /a __substringStart=!__textLength! - !_returnValue!

    set __substring=!__text:~%__substringStart%!
    if "!__substring!"=="%~2" (
        set _returnValue=1
        goto :EOF
    )
    set _returnValue=0
goto :EOF

::https://stackoverflow.com/a/5841587
::strlen(string)
:strlen
    (set^ __currString=%1)
    if NOT defined __currString (
        set _returnValue=0
        goto :EOF
    )
    set _returnValue=1
    FOR %%P IN (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) DO (
        if NOT "!__currString:~%%P,1!"=="" (
            set /a _returnValue+=%%P
            set __currString=!__currString:~%%P!
        )
    )
goto :EOF
