#!/bin/bash

set -e

USERID=$(id -u)

VALIDATE(){
if [ $1 -ne 0 ]; then
    echo "$2 ... FAILURE"
    exit 1
else
    echo "$2 ... SUCCESS"
fi
}

# Root check
if [ $USERID -ne 0 ]; then
    echo "You need to be root user to execute this script"
    exit 1
fi

echo "🚀 Starting Jenkins Setup..."

# Update system
yum update -y
VALIDATE $? "Updating YUM"

# Install dependencies
yum install -y fontconfig wget firewalld
VALIDATE $? "Installing dependencies"

# Enable & start firewalld
systemctl enable firewalld
systemctl start firewalld
VALIDATE $? "Starting firewalld"

# Open port 8080
firewall-cmd --permanent --add-port=8080/tcp
VALIDATE $? "Opening port 8080"

firewall-cmd --reload
VALIDATE $? "Reloading firewall"

# Add Jenkins key
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
VALIDATE $? "Adding Jenkins GPG Key"

# Create repo
cat <<EOF > /etc/yum.repos.d/jenkins.repo
[jenkins]
name=Jenkins
baseurl=https://pkg.jenkins.io/redhat-stable/
enabled=1
gpgcheck=1
gpgkey=https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
EOF

VALIDATE $? "Adding Jenkins Repo"

# Clean cache
yum clean all
rm -rf /var/cache/yum

# Install Java 17
yum install -y java-17-openjdk
VALIDATE $? "Installing Java 17"

# Verify Java
java -version
VALIDATE $? "Verifying Java"

# Install Jenkins
yum install -y jenkins
VALIDATE $? "Installing Jenkins"

# Reload systemd
systemctl daemon-reexec

# Enable Jenkins
systemctl enable jenkins
VALIDATE $? "Enable Jenkins"

# Start Jenkins
systemctl start jenkins
VALIDATE $? "Starting Jenkins"

# Status
systemctl status jenkins --no-pager

# Password
echo "Jenkins Initial Admin Password:"
cat /var/lib/jenkins/secrets/initialAdminPassword

echo "--------------------------------------------------"
echo "Access Jenkins: http://<EC2-IP>:8080"
echo "--------------------------------------------------"
