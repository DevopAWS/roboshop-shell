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

dnf module disable mysql -y &>> $LOG
VALIDATE $? "disable mysql module"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOG
VALIDATE $? "copied mysql repo"

dnf install mysql-community-server -y  &>> $LOG
VALIDATE $? "install mysql"

systemctl enable mysqld &>> $LOG
VALIDATE $? "enable mysql"

systemctl start mysqld &>> $LOG
VALIDATE $? "start mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOG
VALIDATE $? "mysql secure install"


