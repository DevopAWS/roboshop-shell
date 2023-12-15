#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

DATE=$(date +%F)

LOG="/tmp/$0-$DATE.log"

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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOG
VALIDATE $? "install redis repo"

dnf module enable redis:remi-6.2 -y &>> $LOG
VALIDATE $? "enable redis"

dnf install redis -y &>> $LOG
VALIDATE $? "install redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>> $LOG
VALIDATE $? "remote access to redis"

systemctl enable redis &>> $LOG
VALIDATE $? "enable redis"

systemctl start redis &>> $LOG
VALIDATE $? "start redis"

