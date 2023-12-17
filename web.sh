#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

DATE=$(date +%F)

LOG="/tmp/$0-$DATE.log"

VALIDATE() {
	if [ $1 -ne 0 ]; then
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

dnf install nginx -y &>>$LOG
VALIDATE $? "install nginx"

systemctl enable nginx &>>$LOG
VALIDATE $? "enable nginx"

systemctl start nginx &>>$LOG
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG
VALIDATE $? "remove html"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOG
VALIDATE $? "web repo"

cd /usr/share/nginx/html &>>$LOG
VALIDATE $? "change user html"

unzip /tmp/web.zip &>>$LOG
VALIDATE $? "unzip web"

cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
VALIDATE $? "copied roboshopconf"

systemctl restart nginx &>>$LOG
VALIDATE $? "restart nginx"
