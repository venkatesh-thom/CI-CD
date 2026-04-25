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
# Install Java + tools
# =========================

dnf install -y curl fontconfig java-21-openjdk


# =========================
# Install Jenkins
# =========================

curl -fsSL https://pkg.jenkins.io/rpm-stable/jenkins.repo \
 -o /etc/yum.repos.d/jenkins.repo

rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2023.key

dnf install -y jenkins

systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins