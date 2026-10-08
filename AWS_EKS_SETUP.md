# AWS EKS (Elastic Kubernetes Service) Setup Guide

## 🎯 What is AWS EKS?

AWS EKS is Amazon's managed Kubernetes service that:
- ✅ Fully managed Kubernetes control plane (master nodes)
- ✅ Automatic updates and patching
- ✅ High availability across multiple AZs
- ✅ Integrated with AWS services (IAM, VPC, ALB, CloudWatch)
- ✅ Auto-scaling for nodes and pods
- ✅ Production-ready security and compliance
- ✅ Pay only for worker nodes (control plane is free in some regions)

---

## 📋 Prerequisites

### Tools Required

1. **AWS CLI** (already installed ✅)
2. **kubectl** (already installed ✅)
3. **eksctl** - EKS management CLI
4. **AWS IAM permissions** for EKS

### Verify Existing Tools

```bash
aws --version
kubectl version --client
```

---

## 🚀 Step 1: Install eksctl

`eksctl` is the official CLI for creating and managing EKS clusters.

### Windows Installation

**Option 1: Chocolatey (Recommended)**
```powershell
choco install eksctl -y
```

**Option 2: Scoop**
```powershell
scoop install eksctl
```

**Option 3: Manual Download**
1. Download from: https://github.com/weaveworks/eksctl/releases
2. Extract to a folder (e.g., `C:\eksctl\`)
3. Add to PATH

### Verify Installation

```bash
eksctl version
```

Expected output: `0.x.x`

---

## 🔐 Step 2: Configure IAM Permissions

Your IAM user needs these permissions:
- EKS full access
- EC2 (for worker nodes)
- CloudFormation (eksctl uses it)
- IAM (to create service roles)

### Add Policies via AWS Console

1. Go to IAM Console: https://console.aws.amazon.com/iam/home#/users/shehan
2. Click **"Add permissions"** → **"Attach policies directly"**
3. Search and attach:
   - `AmazonEKSClusterPolicy`
   - `AmazonEKSWorkerNodePolicy`
   - `AmazonEKS_CNI_Policy`
   - `AmazonEC2ContainerRegistryReadOnly`
   - Or use `AdministratorAccess` for learning (not recommended for production)

---

## 🚀 Step 3: Create EKS Cluster

### Option A: Quick Start (eksctl - Recommended)

Create a cluster with sensible defaults:

```bash
eksctl create cluster \
  --name devops-cluster \
  --region eu-north-1 \
  --nodegroup-name devops-nodes \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 4 \
  --managed
```

**Parameters explained:**
- `--name`: Cluster name
- `--region`: AWS region (eu-north-1 = Stockholm)
- `--node-type`: EC2 instance type (t3.medium = 2 vCPU, 4 GB RAM)
- `--nodes`: Initial node count
- `--managed`: Use managed node groups (AWS handles updates)

**Time:** ~15-20 minutes  
**Cost:** ~$60-80/month (2x t3.medium nodes)

### Option B: Using Configuration File (Recommended for Production)

Create `eks-cluster-config.yaml`:

```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: devops-cluster
  region: eu-north-1
  version: "1.28"

managedNodeGroups:
  - name: devops-nodes
    instanceType: t3.medium
    desiredCapacity: 2
    minSize: 1
    maxSize: 4
    volumeSize: 20
    ssh:
      allow: false
    labels:
      role: worker
      environment: production
    tags:
      Environment: Production
      Project: DevOps-Demo

iam:
  withOIDC: true

addons:
  - name: vpc-cni
    version: latest
  - name: coredns
    version: latest
  - name: kube-proxy
    version: latest

cloudWatch:
  clusterLogging:
    enableTypes: ["api", "audit", "authenticator", "controllerManager", "scheduler"]
```

Create cluster:
```bash
eksctl create cluster -f eks-cluster-config.yaml
```

### What Happens During Creation?

eksctl will:
1. Create VPC with subnets
2. Create IAM roles
3. Launch EKS control plane
4. Create managed node group
5. Configure kubectl context
6. Install add-ons (VPC CNI, CoreDNS, kube-proxy)

---

## ✅ Step 4: Verify Cluster

### Check Cluster Status

```bash
# List clusters
eksctl get cluster --region eu-north-1

# Get nodes
kubectl get nodes

# Get all resources
kubectl get all --all-namespaces
```

Expected output:
```
NAME                                           STATUS   ROLES    AGE   VERSION
ip-192-168-x-x.eu-north-1.compute.internal    Ready    <none>   5m    v1.28.x
ip-192-168-x-x.eu-north-1.compute.internal    Ready    <none>   5m    v1.28.x
```

### View Cluster Info

```bash
# Cluster information
kubectl cluster-info

# EKS cluster details
eksctl get cluster devops-cluster --region eu-north-1

# Node group details
eksctl get nodegroup --cluster devops-cluster --region eu-north-1
```

---

## 🚀 Step 5: Update Kubernetes Manifests for EKS

### Update deployment.yaml

The local deployment uses `imagePullPolicy: IfNotPresent` for local images. For EKS, we need to pull from ECR:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devops-springboot-app
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: devops-springboot-app
        image: 852093845150.dkr.ecr.eu-north-1.amazonaws.com/devops-springboot-app:latest
        imagePullPolicy: Always  # Pull latest from ECR
```

### Service Type for EKS

For EKS, we can use:
- **LoadBalancer** - Creates AWS Classic Load Balancer (CLB)
- **NodePort** - Exposes on node IPs
- **Ingress** - Use AWS Load Balancer Controller for ALB (recommended)

---

## 🚀 Step 6: Install AWS Load Balancer Controller

The AWS Load Balancer Controller manages AWS ALB/NLB for Kubernetes Ingress.

### Create IAM OIDC Provider

```bash
eksctl utils associate-iam-oidc-provider \
  --cluster devops-cluster \
  --region eu-north-1 \
  --approve
```

### Create IAM Policy

```bash
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam-policy.json
```

### Create Service Account

```bash
eksctl create iamserviceaccount \
  --cluster=devops-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::852093845150:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve \
  --region=eu-north-1
```

### Install Controller via Helm

```bash
# Add helm repo
helm repo add eks https://aws.github.io/eks-charts
helm repo update

# Install
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=devops-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

---

## 🚀 Step 7: Deploy Application to EKS

### Create EKS-specific Deployment

Create `k8s/eks-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devops-springboot-app
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: devops-springboot-app
  template:
    metadata:
      labels:
        app: devops-springboot-app
    spec:
      containers:
      - name: devops-springboot-app
        image: 852093845150.dkr.ecr.eu-north-1.amazonaws.com/devops-springboot-app:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 8082
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "1Gi"
            cpu: "1000m"
        livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8082
          initialDelaySeconds: 60
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /actuator/health
            port: 8082
          initialDelaySeconds: 30
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: devops-springboot-app-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
spec:
  type: LoadBalancer
  selector:
    app: devops-springboot-app
  ports:
  - port: 80
    targetPort: 8082
    protocol: TCP
```

### Deploy

```bash
kubectl apply -f k8s/eks-deployment.yaml
```

### Check Status

```bash
kubectl get deployments
kubectl get pods
kubectl get services
```

### Get LoadBalancer URL

```bash
kubectl get service devops-springboot-app-service

# Get external hostname
export LB_URL=$(kubectl get service devops-springboot-app-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Application URL: http://$LB_URL/api/hello"
```

Wait 2-3 minutes for Load Balancer to be ready, then test:

```bash
curl http://$LB_URL/api/hello
curl http://$LB_URL/actuator/health
```

---

## 🎯 Step 8: Configure Auto-Scaling

### Cluster Autoscaler (Node Level)

```bash
# Already configured with eksctl (--nodes-min, --nodes-max)
eksctl get nodegroup --cluster devops-cluster --region eu-north-1
```

### Horizontal Pod Autoscaler (Pod Level)

```bash
# Install metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Apply HPA
kubectl apply -f k8s/hpa.yaml

# Check HPA
kubectl get hpa
```

---

## 📊 Step 9: Monitoring and Logging

### CloudWatch Container Insights

```bash
# Install Container Insights
eksctl utils install-cw-agent \
  --cluster devops-cluster \
  --region eu-north-1
```

### View Logs

**Via kubectl:**
```bash
kubectl logs -l app=devops-springboot-app --tail=50
```

**Via CloudWatch:**
1. Go to: https://console.aws.amazon.com/cloudwatch
2. Navigate to: Log groups → `/aws/eks/devops-cluster/cluster`

### View Metrics

**Via kubectl:**
```bash
kubectl top nodes
kubectl top pods
```

**Via CloudWatch:**
- CPU utilization
- Memory usage
- Network traffic
- Pod count

---

## 💰 Cost Optimization

### EKS Pricing (eu-north-1)

**Control Plane:**
- $0.10/hour = ~$73/month

**Worker Nodes (t3.medium):**
- $0.0456/hour per instance
- 2 nodes = $0.0912/hour = ~$66/month

**Total Estimated Cost:**
- ~$140/month for 2-node cluster
- Additional costs: Load Balancer (~$16/month), Data transfer

### Cost-Saving Tips

1. **Use Spot Instances** (up to 90% cheaper):
```yaml
managedNodeGroups:
  - name: devops-nodes-spot
    instanceTypes: ["t3.medium", "t3a.medium"]
    spot: true
```

2. **Auto-scaling**: Scale down to 1 node during low traffic

3. **Fargate**: Serverless compute (pay per pod)

4. **Reserved Instances**: Commit for 1-3 years for discounts

---

## 🧹 Cleanup (To Avoid Charges)

### Delete Application

```bash
kubectl delete -f k8s/eks-deployment.yaml
```

### Delete Cluster

```bash
# Delete entire cluster (nodes + control plane)
eksctl delete cluster --name devops-cluster --region eu-north-1

# This will:
# - Delete all node groups
# - Delete control plane
# - Delete VPC and subnets
# - Delete IAM roles
# Time: ~10-15 minutes
```

### Verify Deletion

```bash
eksctl get cluster --region eu-north-1
# Should return empty
```

---

## 🔍 Troubleshooting

### Pods not starting

```bash
# Check pod status
kubectl describe pod <pod-name>

# Common issues:
# - Image pull errors: Check ECR permissions
# - Insufficient resources: Scale nodes
# - Health check failing: Increase initialDelaySeconds
```

### Can't access Load Balancer

```bash
# Check service
kubectl get service devops-springboot-app-service

# Check security groups
aws ec2 describe-security-groups --filters "Name=tag:kubernetes.io/cluster/devops-cluster,Values=owned"

# Ensure port 80/443 is open in security group
```

### eksctl command fails

```bash
# Check IAM permissions
aws sts get-caller-identity

# Check eksctl version
eksctl version

# Enable debug logging
eksctl create cluster --help
```

---

## 📚 Useful Commands

### Cluster Management

```bash
# List clusters
eksctl get clusters

# Update cluster
eksctl upgrade cluster --name devops-cluster

# Scale node group
eksctl scale nodegroup --cluster devops-cluster --name devops-nodes --nodes 3

# Delete node group
eksctl delete nodegroup --cluster devops-cluster --name devops-nodes
```

### kubectl Context

```bash
# List contexts
kubectl config get-contexts

# Switch context
kubectl config use-context arn:aws:eks:eu-north-1:852093845150:cluster/devops-cluster

# View current context
kubectl config current-context
```

---

## 🔗 Useful Links

- **EKS Documentation**: https://docs.aws.amazon.com/eks/
- **eksctl Documentation**: https://eksctl.io/
- **EKS Best Practices**: https://aws.github.io/aws-eks-best-practices/
- **AWS Load Balancer Controller**: https://kubernetes-sigs.github.io/aws-load-balancer-controller/
- **EKS Pricing**: https://aws.amazon.com/eks/pricing/
- **EKS Console**: https://console.aws.amazon.com/eks/home?region=eu-north-1

---

## ✅ Verification Checklist

- [ ] eksctl installed
- [ ] IAM permissions configured
- [ ] EKS cluster created
- [ ] Nodes are running
- [ ] kubectl context updated
- [ ] AWS Load Balancer Controller installed (optional)
- [ ] Application deployed
- [ ] LoadBalancer URL accessible
- [ ] Health checks passing
- [ ] Auto-scaling configured
- [ ] Monitoring enabled

---

**Status:** Ready to deploy to production EKS!

**Next Step:** Terraform - Define all infrastructure as code for reproducible environments
