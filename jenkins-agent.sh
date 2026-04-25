#!/bin/bash

# Resize disk
growpart /dev/nvme0n1 4

lvextend -L +10G /dev/mapper/RootVG-varVol
lvextend -L +10G /dev/mapper/RootVG-rootVol
lvextend -l +100%FREE /dev/mapper/RootVG-homeVol

xfs_growfs /
xfs_growfs /var
xfs_growfs /home

# Jenkins setup
sudo curl -o /etc/yum.repos.d/jenkins.repo \
   https://pkg.jenkins.io/rpm-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2023.key

sudo dnf install fontconfig java-21-openjdk -y

# ✅ Install Jenkins (missing step)
sudo dnf install jenkins -y

sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins