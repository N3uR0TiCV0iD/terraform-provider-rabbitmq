@echo off

::init
set TF_ACC=1
set RABBITMQ_ENDPOINT=http://localhost:15673
set RABBITMQ_USERNAME=guest
set RABBITMQ_PASSWORD=guest

::setup
start docker-compose -f "docker-compose.yml" up
set waitTime=15
:Loop
    cls
    echo Waiting for RabbitMQ. . . [%waitTime%s]
    ping -n 2 127.0.0.1>nul
    set /A waitTime-=1
if NOT %waitTime%==0 goto :Loop

::run
cls
echo Waiting for RabbitMQ. . . [DONE]
echo Executing tests. . .
cd ..
go test -count=1 ./rabbitmq -v -timeout 120m

::cleanup
::docker-compose -f "scripts\docker-compose.yml" down

::end
echo Test execution ended
echo.
echo Press any key to exit. . .
pause>nul
