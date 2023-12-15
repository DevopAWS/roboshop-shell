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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOG
VALIDATE $? "erlang repo"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOG
VALIDATE $? "rabbitmq repo"

dnf install rabbitmq-server -y  &>> $LOG
VALIDATE $? "install rabbitmq server"


systemctl enable rabbitmq-server &>> $LOG
VALIDATE $? "enable rabbitmq"

systemctl start rabbitmq-server &>> $LOG
VALIDATE $? "start rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>> $LOG
VALIDATE $? "add user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOG
VALIDATE $? "rabbitmq permission"








