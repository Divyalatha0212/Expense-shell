#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Please enter DB password:"
read -s mysql_root_password

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}


    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi


dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Server"
#else
#echo -e "Mysql Installation Already Done...$Y SKIPPING $N"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MySQL Server"
#echo -e "Mysql Enabling Already Done...$Y SKIPPING $N"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySQL Server"
#echo -e "Mysql Started Already Done...$Y SKIPPING $N"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"
mysql -h db.asadi-devops.online -uroot -p${mysql_root_password} -e 'SHOW DATABASES;' &>>$LOGFILE

if [ $? -ne 0 ]
then
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
VALIDATE $? "Setting the root Password for Mysql"
else
echo -e "Mysql Password Already Setup...$Y SKIPPING $N"
fi
