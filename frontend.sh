#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


if [ $USERID -NE 0 ]
then
echo " Run this script with root user"
exit 1
else
echo "Yoo Are the Root User"
fi

VALIDATE(){
if [ $? -ne 0 ]
then
echo "$2...$R FAILURE $N"
exit 1
else
echo "s2...$G SUCESS $N"
fi

}

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing Nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting the Nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling the Nginx"

































