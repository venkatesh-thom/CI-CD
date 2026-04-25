# Connecting Jenkins to EKS in Different VPCs (Private Endpoint)

When your **Jenkins server is in one VPC** and your **EKS cluster is in another VPC**, and the EKS endpoint is **private-only**, Jenkins cannot connect unless networking and security are configured properly.

---

## 📍 Problem Summary
You may see this error:
```
kubectl get nodes
Unable to connect to the server: dial tcp <private-ip>:443: i/o timeout
```

### ❌ Root Cause
- Jenkins VPC and EKS VPC were **not connected**
- No route for traffic between VPCs
- Security Group didn’t allow port **443**
- EKS endpoint was **private only**

✅ 1️⃣ Check Endpoint Type (Public/Private)
# Run on your local machine (with AWS auth):
``` bash
aws eks describe-cluster --name <your-cluster-name> --query "cluster.resourcesVpcConfig"
```
  ✔ If Output shows "endpointPublicAccess": false, then the cluster is private only, and Jenkins MUST access via VPC Peering/Transit Gateway.

   ```
  endpointPublicAccess: false
  endpointPrivateAccess: true
   ```

---

## 🧱 Architecture (Before & After)

Before (Not Working):
```
[Jenkins VPC - 172.31.0.0/16]  ----X---->  [EKS VPC - 10.1.0.0/16]
              (No Route / No Permission)
```

After (Working):
```
[Jenkins VPC] -- VPC Peering --> [EKS VPC]
       Route Tables + Security Groups allow traffic
```

---

## 🚀 Solution Steps

### 1️⃣ Create VPC Peering
**AWS Console → VPC → Peering Connections → Create Peering**

Requester: Jenkins VPC (172.31.0.0/16)  
Accepter:  EKS VPC (10.1.0.0/16)

**CLI (Optional):**
```bash
aws ec2 create-vpc-peering-connection  --vpc-id <jenkins-vpc-id>  --peer-vpc-id vpc-09a27a87606dd488b

aws ec2 accept-vpc-peering-connection  --vpc-peering-connection-id pcx-0b7d2f12ec603c075
```

---

### 2️⃣ Update Route Tables

**Jenkins VPC Route Table**
```
Destination: 10.1.0.0/16
Target: pcx-0b7d2f12ec603c075
```

**EKS VPC Route Table**
```
Destination: 172.31.0.0/16
Target: pcx-0b7d2f12ec603c075
```

---

### 3️⃣ Update Security Groups
Edit SG: `sg-0cdc938c5b8133ae3` (Cluster SG)
```
> Inbound  ➜ HTTPS | 443 | Source: 172.31.0.0/16 
  <Jenkins VPC CIDR> OR <Jenkins SG ID>

> Outbound ➜ All Traffic | Destination: 172.31.0.0/16
  Destination: <EKS cluster SG> or <Cluster VPC CIDR>
```

---

### 4️⃣ Validate from Jenkins

```bash
nc -zv 10.1.11.43 443       # Test port
curl -vk https://<private-eks-endpoint>  # Test API reach
kubectl get nodes           # Confirm connection
```

Example successful output:
```
NAME                          STATUS   ROLES    AGE   VERSION
ip-10-1-11-187.ec2.internal   Ready    <none>   30m   v1.32.9
ip-10-1-12-232.ec2.internal   Ready    <none>   30m   v1.32.9
```

---

## ⚙️ Optional: Temporarily Enable Public EKS Endpoint (Testing Only)
```bash
aws eks update-cluster-config  --name roboshop-dev  --resources-vpc-config endpointPublicAccess=true
```
Disable later for security.

---

# ✔️ Summary of Fixes
| Fix Applied | Why It Was Needed |
|-------------|-------------------|
| VPC Peering | Connect networks |
| Route Tables | Create communication path |
| SG Update (443) | Allow API access |
| Validation Commands | Ensure success |

---



