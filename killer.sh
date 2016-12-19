#!/bin/sh


OLDPID=`ps -ef | grep mpiexec | grep cjarcher| grep -v grep | awk '{print $2}'`
while true
do
    sleep 5
    PID=`ps -ef | grep mpiexec | grep cjarcher| grep -v grep | awk '{print $2}'`
    if [ "x$PID" == "x$OLDPID" ]
    then
        echo "Killing $PID"
        kill -9 $PID
        sleep 5
    fi
    OLDPID=`ps -ef | grep mpiexec | grep cjarcher| grep -v grep | awk '{print $2}'`

done
