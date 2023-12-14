#!/bin/bash

USERID=$(id -u)

DATE=$(date +%F)

LOG="/tmp/$0-$DATE.log"

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"


VALIDATE(){
if	[ $1 -ne 0 ];then
	echo -e "$2.....${R} FAILURE ${N}" 
	exit 1
		else
				echo -e "$2... ${G} SUCCESS ${N}" 

fi
}

if [ $USERID -ne 0 ]; then
	echo -e "${R} if you need to be root user excute this script ${N}"
	exit 1
    else 
    echo -e "$Y you are root user $N"
fi