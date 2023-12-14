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

cp mongodb.repo /etc/yum.repos.d/mongo.repo/mongodb.repo &>> $LOG

VALIDATE $? "copied mongodb repo "

dnf install mongodb-org -y &>> $LOG

VALIDATE $? "mongodb installed"

systemctl enable mongod -y &>> $LOG

VALIDATE $? "mongodb enabled"

systemctl start mongod -y &>> $LOG

VALIDATE $? "mongodb started"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOG

VALIDATE $? "remote access to mongodb"

systemctl restart mongod &>> $LOG

VALIDATE $? "mongodb restart'


