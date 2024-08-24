#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo  -e "$G Script started executing at:$TIMESTAMP $N"

VALIDATE(){
if [ $1 -ne 0 ]
then 
   echo -e "$2...$R FAITURE $N"
   exit 1
else
   echo -e "$2.. $G SUCCESS $N"
fi
}

if [ $USERID -ne 0 ]
then
   echo -e "$R Please run this script with root access $N"
   exit 1
else
   echo -e "$G You are super user. $SCRIPT_NAME"

fi 

yum install yum-utils -y &>>$LOGFILE
VALIDATE $? "Installing utils packages"

yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo &>>$LOGFILE
VALIDATE $? "adding Docker repo"

yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y &>>$LOGFILE
VALIDATE $? "Installing docker"

systemctl start docker &>>$LOGFILE
VALIDATE $? "Starting docker"

systemctl enable docker &>>$LOGFILE
VALIDATE $? "Enabling Docker"

usermod -aG docker ec2-user &>>$LOGFILE
VALIDATE $? "Adding ec2-user to docker group as secondary group"

echo -e "$G Logout and login again $N"