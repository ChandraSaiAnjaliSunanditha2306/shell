#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
LOG_FOLDER="/var/log/shell.logs"
LOG_FILE=$(echo $0)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME=$LOG_FOLDER/$LOG_FILE-$TIMESTAMP.log
VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 is $R FAILURE"
        exit 1
    else
        echo -e "$2 is $G SUCCESS"
    fi
}

CHECK_ROOT(){
if [ $USERID -ne 0 ]
then
    echo " ERROR: you must have sudo access to execute the script"
    exit 1
fi
}

echo "script executing at : $TIMESTAMP" &>>LOG_FILE_NAME

CHECK_ROOT

dnf install mysql-server -y &>>LOG_FILE_NAME
VALIDATE $? "Installing mysql server"

systemctl enable mysqld &>>LOG_FILE_NAME
VALIDATE $? "enabling mysql server"

systemctl start mysqld &>>LOG_FILE_NAME
VALIDATE $? "starting mysql server"

mysql -h <host-address> -u root -p<password>
VALIDATE $? "setting root password"
