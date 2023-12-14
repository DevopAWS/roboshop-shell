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


dnf module disable nodejs -y &>> $LOG
VALIDATE $? "disable nodejs"


dnf module enable nodejs:18 -y &>> $LOG
VALIDATE $? "enable nodejs 18"

dnf install nodejs -y &>> $LOG
VALIDATE $? "install nodejs"

useradd roboshop &>> $LOG
VALIDATE $? "adding roboshop user"

mkdir /app &>> $LOG
VALIDATE $? "crete dirctory app"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOG
VALIDATE $? "application download is"

cd /app &>> $LOG
VALIDATE $? "change app"

unzip /tmp/catalogue.zip &>> $LOG
VALIDATE $? "unzip file is"

npm install &>> $LOG
VALIDATE $? "npm install is"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOG
VALIDATE $? "copied catalogue service"

systemctl daemon-reload &>> $LOG
VALIDATE $? "deamon reload"

systemctl enable catalogue &>> $LOG
VALIDATE $? "catalogue enabled"

systemctl start catalogue &>> $LOG
VALIDATE $? "catalogue start"

cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>> $LOG
VALIDATE $? "copied mongodb repo"

dnf install mongodb-org-shell -y &>> $LOG
VALIDATE $? "install mongodb"

mongo --host mongodb.daws76.online </app/schema/catalogue.js
VALIDATE $? "connected mongodb"










