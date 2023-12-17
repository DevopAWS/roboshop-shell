#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

DATE=$(date +%F)

LOG="/tmp/$0-$DATE.log"

MONGODB_HOST=mongodb.daws76.online

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
VALIDATE $? "install nodejs:18"

id roboshop
if [ $? -ne 0 ];then
        useradd roboshop 
        VALIDATE $? "roboshop user creation"
            else
            echo -e "roboshop user aleready exists.. $Y Skipping $N"
fi

mkdir -p /app &>> $LOG
VALIDATE $? "crete dirctory app"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip  &>> $LOG
VALIDATE $? "installing cart repo"

cd /app &>> $LOG
VALIDATE $? "change app"

unzip -o /tmp/cart.zip &>> $LOG
VALIDATE $? "unzip file is"

npm install &>> $LOG
VALIDATE $? "installing dependencies"

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>> $LOG
VALIDATE $? "copied cart service"


systemctl daemon-reload &>> $LOG
VALIDATE $? "deamon reload"

systemctl enable cart  &>> $LOG
VALIDATE $? "cart enabled"

systemctl start cart &>> $LOG
VALIDATE $? "cart start"




