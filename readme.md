# 🚀 Jenkins Infrastructure Automation on AWS

This repository provides a **complete Infrastructure as Code (IaC) solution** to deploy and manage a **Jenkins CI/CD environment on AWS** using **Terraform and Shell scripting**.

It automates the provisioning of:

* Jenkins Master
* Jenkins Agent(s)
* SonarQube (for code quality analysis)

---

## 🧱 Architecture Overview

The setup follows a **distributed Jenkins architecture**:

* 🧠 **Jenkins Master**

  * Manages pipelines, jobs, and plugins
* ⚙️ **Jenkins Agent**

  * Executes builds and workloads
* 🔍 **SonarQube**

  * Performs static code analysis and quality checks

---

## 📂 Project Structure

```id="m3z8hz"
Jenkins/
│
├── main.tf              # Core Terraform resources
├── variables.tf         # Input variables
├── data.tf              # Fetch existing AWS resources
├── provider.tf          # AWS provider & backend config
│
├── jenkins-master.sh    # Jenkins Master setup script
├── jenkins-agent.sh     # Jenkins Agent setup script
├── sonar.sh             # SonarQube installation script
│
├── Jenkins-Eks.md       # Jenkins on EKS guide
├── Jenkins-remove.md    # Cleanup instructions
```

---

## ⚙️ Key Features

### ✅ Infrastructure as Code

* Fully automated provisioning using Terraform
* Remote state management using S3 backend

---

### ✅ Automated Jenkins Setup

* Installs:

  * Java
  * Jenkins
  * Required dependencies
* Configures Jenkins Master & Agent via shell scripts

---

### ✅ Distributed Build Architecture

* Separates Master and Agent nodes
* Improves:

  * Scalability
  * Performance
  * Fault isolation

---

### ✅ SonarQube Integration

* Enables **code quality analysis**
* Supports CI/CD pipelines with quality gates

---

### ✅ Kubernetes (EKS) Support

* Documentation available for running Jenkins on Amazon EKS
* Useful for containerized CI/CD workflows

---

## 🚀 Getting Started

### 🔧 Prerequisites

* Terraform installed
* AWS CLI configured
* IAM permissions for:

  * EC2
  * VPC
  * S3 (for backend)
* Existing S3 bucket for Terraform state

---

## ☁️ Deployment Steps

### 1️⃣ Initialize Terraform

```bash id="jq0fsy"
terraform init
```

### 2️⃣ Review Execution Plan

```bash id="5d6o0k"
terraform plan
```

### 3️⃣ Apply Infrastructure

```bash id="9q84kj"
terraform apply --auto-approve
```

---

## 🔐 Configuration Details

* **Cloud Provider:** AWS
* **Languages Used:**

  * Terraform (HCL)
  * Shell scripting
* **State Management:**

  * Remote backend using S3 (`provider.tf`)
* **Dynamic Data:**

  * `data.tf` fetches:

    * AMI IDs
    * Networking details (VPC, subnets)

---

## 🧪 What This Project Demonstrates

This project showcases real-world DevOps skills:

* ✔️ Infrastructure automation
* ✔️ CI/CD pipeline setup
* ✔️ Distributed system design
* ✔️ Cloud resource provisioning
* ✔️ Integration of quality tools (SonarQube)

---

## ⚠️ Important Notes

* Ensure proper security group configuration (SSH, Jenkins ports)
* Protect Jenkins with authentication (not exposed publicly)
* Use key pairs securely for EC2 access

---

## 🧹 Cleanup

To destroy all resources:

```bash id="ymq0fq"
terraform destroy
```

Or refer to:

```
Jenkins-remove.md
```

---

## 📘 Additional Documentation

* 📄 Jenkins deployment on Kubernetes → `Jenkins-Eks.md`
* 🧾 Root Cause Analysis → Refer to RCA document in repo

---

## 📈 Benefits

* ⚙️ Fully automated CI/CD infrastructure
* 🚀 Faster environment setup
* 📉 Reduced manual configuration errors
* 🔄 Scalable build system

---


