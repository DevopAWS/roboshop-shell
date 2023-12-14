#!/bin/bash

ID=($id -u)

TIMESTAMP=$(date +%F)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "excuting scrpit start $TIMESTAMP"  &>> $LOGFILE

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2....$R FAILURE.. $N"
            exit 1
            else 
                echo -e "$2....$G SUCCESS.. $N"
    fi
}


if [ $ID -ne 0 ]; then
    echo -e "ERROR::$R script excuting with root user $N"
        exit 1
             else
                echo "yor are root user"
    fi
