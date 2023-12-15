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

dnf install maven -y &>> $LOG
VALIDATE $? "install maven"

id roboshop
if [ $? -ne 0 ];then
    useradd roboshop 
    VALIDATE $?"roboshop user creation"
    else
        echo -e "roboshop user aleready exists $Y Skipping $N"
fi

mkdir -p /app &>> $LOG
VALIDATE $? "crete dirctory app"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOG
VALIDATE $? "install shipping repo"

cd /app &>> $LOG
VALIDATE $? "change app"

unzip -o /tmp/shipping.zip &>> $LOG
VALIDATE $? "unzip file is"

mvn clean package &>> $LOG
VALIDATE $? "mvn clean"

mv target/shipping-1.0.jar shipping.jar &>> $LOG
VALIDATE $? "mvn target jar"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>> $LOG
VALIDATE $? "copied shipping service"

systemctl daemon-reload &>> $LOG
VALIDATE $? "deamon reload"

systemctl enable shipping &>> $LOG
VALIDATE $? "shipping enabled"

systemctl start shipping &>> $LOG
VALIDATE $? "shipping start"

dnf install mysql -y &>> $LOG
VALIDATE $? "install mysql"

mysql -h mysql.daws76.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOG
VALIDATE $? "mysql schema"

systemctl restart shipping &>> $LOG
VALIDATE $? "mysql restart"

























