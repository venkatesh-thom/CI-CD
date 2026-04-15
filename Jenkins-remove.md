# 🧹 Jenkins Cleanup Guide 

This guide helps you completely remove Jenkins and related configurations from your EC2 instance to start fresh.

---

## 🔴 Step 1: Stop Jenkins Service

```bash
sudo systemctl stop jenkins
```

---

## 🔴 Step 2: Remove Jenkins Package

```bash
sudo yum remove jenkins -y
```

---

## 🔴 Step 3: Delete Jenkins Data & Configuration

> ⚠️ This will permanently delete all Jenkins jobs, builds, and configurations.

```bash
sudo rm -rf /var/lib/jenkins
sudo rm -rf /etc/sysconfig/jenkins
sudo rm -rf /var/log/jenkins
```

---

## 🔴 Step 4: Remove Jenkins Repository

```bash
sudo rm -f /etc/yum.repos.d/jenkins.repo
```

---

## 🔴 Step 5: Clean YUM Cache

```bash
sudo yum clean all
sudo rm -rf /var/cache/yum
```

---

## 🔴 Step 6: Remove Java (Optional but Recommended)

Check installed Java version:

```bash
java -version
```

Remove Java:

```bash
sudo yum remove java-21-openjdk -y
sudo yum remove java-17-amazon-corretto -y
```

---

## 🔴 Step 7: Verify Complete Cleanup

Check if Jenkins is removed:

```bash
rpm -qa | grep jenkins
```

Check if repo file exists:

```bash
ls /etc/yum.repos.d/ | grep jenkins
```

> ✅ Both commands should return **no output**

---

## ✅ Result

Your system is now completely clean and ready for a fresh Jenkins installation.

---

## 🚀 Next Steps

* Install Jenkins using Docker (Recommended)
* OR reinstall Jenkins via package manager with proper repo setup

---
