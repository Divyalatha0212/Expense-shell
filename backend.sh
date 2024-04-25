#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Please Enter the DB Password:"
read mysql_root_password

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then

    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi


dnf module disable nodejs -y &>>L$OGFILE
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs:20 version"

dnf module install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"



id expense &>>$LOGFILE
if [ $? -ne 0 ]
then 
useradd expense &>>$LOGFILE
VALIDATE $? "Creating expense user"
else
echo -e "Expense user already created...$Y SKIPPING $N"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "Creating the Directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "Downloading the backend code"

cd /app &>>$LOGFILE
rm -rf /app/*
VALIDATE $? "Changing the Directory"

unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Unziping the backned code"

npm install &>>$LOGFILE
VALIDATE $? "Installing the  nodejs Dependencies"


#because we are perform all our  operations from the EC2 server. So you specify the absolute path of the file
#Also the file should be present at that location

cp /root/Expense-shell/backend.service /etc/systemd/system/backend.service
VALIDATE $? "Copied Backend Service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Reloading the Backend Service"

systemctl start backend &>>$LOGFILE
VALIDATE $? "Start the Backend Service"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enabling the Backend Service"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing the MYSQL Client"

mysql -h db.asadi-devops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Load the Schema"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting the Backend"


















