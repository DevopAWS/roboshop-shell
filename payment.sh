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

dnf install python36 gcc python3-devel -y &>> $LOG
VALIDATE $? "install python"

id roboshop
if [ $? -ne 0 ];then
    useradd roboshop 
    VALIDATE $? "roboshop user creation"
    else
        echo -e "roboshop user aleready exists $Y Skipping $N"
fi

mkdir /app &>> $LOG
VALIDATE $? "change app"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip  &>> $LOG
VALIDATE $? "payment zip folder"

unzip -o /tmp/payment.zip &>> $LOG
VALIDATE $? "unzip it "

pip3.6 install -r requirements.txt  &>> $LOG
VALIDATE $? "install pip"

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>> $LOG
VALIDATE $? "copied payment service"

systemctl daemon-reload &>> $LOG
VALIDATE $? "deamon reload"

systemctl enable payment &>> $LOG
VALIDATE $? "payment enabled"

systemctl start payment &>> $LOG
VALIDATE $? "payment start"












