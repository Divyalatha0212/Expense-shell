#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


if [ $USERID -ne 0 ]
then
echo " Run this script with root user"
exit 1
else
echo "Yoo Are the Root User"
fi

VALIDATE(){
if [ $? -ne 0 ]
then
echo -e "$2...$R FAILURE $N"
exit 1
else
echo -e "$2...$G SUCCESS $N"
fi

}

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing Nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling the Nginx"


systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting the Nginx"



rm -rf /usr/share/nginx/html/*
VALIDATE $? "Removing the Default content in the Nginx"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading the Frontend code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Unzipping the Frontend Code"

cp /root/Expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copying expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restart the Nginx"































