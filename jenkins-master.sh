#!/bin/bash

set -e

# =========================
# Disk Resize
# =========================

# Grow partition
growpart /dev/nvme0n1 4

# Resize LVM physical volume (IMPORTANT)
pvresize /dev/nvme0n1p4

# Extend logical volumes and auto-resize filesystem
lvextend -r -L +10G /dev/mapper/RootVG-varVol
lvextend -r -L +10G /dev/mapper/RootVG-rootVol
lvextend -r -l +100%FREE /dev/mapper/RootVG-homeVol


# =========================
# Install Java 21
# =========================

dnf install -y curl fontconfig java-21-openjdk


# =========================
# Install Jenkins
# =========================

curl -fsSL https://pkg.jenkins.io/redhat-stable/jenkins.repo \
-o /etc/yum.repos.d/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

dnf clean all
dnf makecache

dnf install -y jenkins

systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins








