#!/bin/bash
set -e

# =========================
# Disk Resize
# =========================

dnf install -y cloud-utils-growpart

growpart /dev/nvme0n1 4 || true
pvresize /dev/nvme0n1p4 || true

lvextend -r -L +10G /dev/mapper/RootVG-varVol || true
lvextend -r -L +10G /dev/mapper/RootVG-rootVol || true
lvextend -r -l +100%FREE /dev/mapper/RootVG-homeVol || true


# =========================
# Install Java + Jenkins
# =========================

dnf install -y curl fontconfig java-21-openjdk

curl -o /etc/yum.repos.d/jenkins.repo \
 https://pkg.jenkins.io/rpm-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2023.key

dnf install -y jenkins

systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins


# =========================
# Install Docker
# =========================

dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

dnf install -y docker-ce docker-ce-cli containerd.io

systemctl enable docker
systemctl start docker

usermod -aG docker ec2-user