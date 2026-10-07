# AWS ECR (Elastic Container Registry) Setup Guide

## 🎯 What is AWS ECR?

AWS ECR is Amazon's fully-managed Docker container registry that:
- ✅ Stores and manages Docker images
- ✅ Integrates seamlessly with AWS services (EKS, ECS, Lambda)
- ✅ Provides image scanning for vulnerabilities
- ✅ Encrypts images at rest
- ✅ Offers fine-grained access control via IAM
- ✅ Pay only for storage and data transfer

---

## 🚀 Quick Setup Guide

### Prerequisites

- AWS Account (free tier available)
- AWS CLI installed on your local machine
- GitHub repository with Docker image

### Step 1: Create AWS Account (if needed)

1. Go to https://aws.amazon.com
2. Click **"Create an AWS Account"**
3. Follow the signup process
4. **Note:** Requires credit card, but ECR free tier includes 500 MB/month storage

### Step 2: Install AWS CLI

**Windows (PowerShell):**
```powershell
# Download and install MSI installer
# https://awscli.amazonaws.com/AWSCLIV2.msi

# Verify installation
aws --version
```

**Alternative (via Chocolatey):**
```powershell
choco install awscli -y
```

**Verify installation:**
```bash
aws --version
# Should show: aws-cli/2.x.x Python/3.x.x Windows/10
```

### Step 3: Configure AWS Credentials

#### Option A: Create IAM User (Recommended)

1. **Login to AWS Console**: https://console.aws.amazon.com
2. **Go to IAM**: Search "IAM" in services
3. **Create User**:
   - Click **"Users"** → **"Add users"**
   - Username: `github-actions-ecr`
   - Access type: **"Programmatic access"** ✅
4. **Set Permissions**:
   - Click **"Attach policies directly"**
   - Search and select:
     - `AmazonEC2ContainerRegistryPowerUser` (for ECR)
     - Or create custom policy (see below)
5. **Review and Create**
6. **⚠️ IMPORTANT**: Copy and save:
   - Access Key ID
   - Secret Access Key
   - You won't see the secret again!

#### Custom IAM Policy (Minimum Permissions):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource": "*"
    }
  ]
}
```

#### Option B: Use Root Credentials (Not Recommended)

Only for learning/testing. Never use in production!

### Step 4: Configure AWS CLI Locally

```bash
aws configure

# Provide:
# AWS Access Key ID: [your-access-key]
# AWS Secret Access Key: [your-secret-key]
# Default region name: us-east-1  (or your preferred region)
# Default output format: json
```

### Step 5: Create ECR Repository

**Via AWS CLI:**
```bash
# Create repository
aws ecr create-repository \
    --repository-name devops-springboot-app \
    --region us-east-1 \
    --image-scanning-configuration scanOnPush=true \
    --encryption-configuration encryptionType=AES256

# Output will show repository URI:
# {account-id}.dkr.ecr.us-east-1.amazonaws.com/devops-springboot-app
```

**Via AWS Console:**
1. Go to: https://console.aws.amazon.com/ecr
2. Click **"Create repository"**
3. Settings:
   - Visibility: **Private**
   - Repository name: `devops-springboot-app`
   - Tag immutability: **Disabled** (can change versions)
   - Scan on push: **Enabled** ✅
   - Encryption: **AES-256**
4. Click **"Create repository"**

**Save your ECR URI:**
```
{account-id}.dkr.ecr.{region}.amazonaws.com/devops-springboot-app
```
Example: `123456789012.dkr.ecr.us-east-1.amazonaws.com/devops-springboot-app`

### Step 6: Add Secrets to GitHub

1. Go to your repository: https://github.com/ShehanFdoking/devops-project
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Add these secrets:

   **Secret 1:**
   - Name: `AWS_ACCESS_KEY_ID`
   - Value: Your AWS Access Key ID

   **Secret 2:**
   - Name: `AWS_SECRET_ACCESS_KEY`
   - Value: Your AWS Secret Access Key

   **Secret 3:**
   - Name: `AWS_REGION`
   - Value: `us-east-1` (or your chosen region)

   **Secret 4:**
   - Name: `ECR_REPOSITORY`
   - Value: `devops-springboot-app`

### Step 7: Push and Deploy! 🚀

```bash
# Commit and push (workflow already configured)
git push origin main

# GitHub Actions will automatically:
# 1. Build your Docker image
# 2. Login to AWS ECR
# 3. Tag the image
# 4. Push to ECR
# 5. Run security scan
```

---

## 🔧 Local Testing (Push to ECR from your machine)

### 1. Authenticate Docker with ECR

```bash
# Get login command
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin {account-id}.dkr.ecr.us-east-1.amazonaws.com

# Should see: "Login Succeeded"
```

### 2. Tag Your Image

```bash
# Tag existing local image
docker tag devops-springboot-app:1.0 {account-id}.dkr.ecr.us-east-1.amazonaws.com/devops-springboot-app:1.0

# Tag as latest
docker tag devops-springboot-app:1.0 {account-id}.dkr.ecr.us-east-1.amazonaws.com/devops-springboot-app:latest
```

### 3. Push to ECR

```bash
# Push specific version
docker push {account-id}.dkr.ecr.us-east-1.amazonaws.com/devops-springboot-app:1.0

# Push latest
docker push {account-id}.dkr.ecr.us-east-1.amazonaws.com/devops-springboot-app:latest
```

### 4. Verify in AWS Console

1. Go to: https://console.aws.amazon.com/ecr
2. Click on `devops-springboot-app` repository
3. See your images with tags and scan results

---

## 📊 Understanding ECR Features

### Image Scanning

ECR automatically scans images for vulnerabilities:
- **CVE Database**: Common Vulnerabilities and Exposures
- **Severity Levels**: Critical, High, Medium, Low, Informational
- **Scan on Push**: Automatic scanning when images are pushed

**View scan results:**
```bash
aws ecr describe-image-scan-findings \
    --repository-name devops-springboot-app \
    --image-id imageTag=latest \
    --region us-east-1
```

### Image Lifecycle Policies

Automatically clean up old images to save costs:

**Example policy (keep last 10 images):**
```json
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 10 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
```

**Apply policy:**
```bash
aws ecr put-lifecycle-policy \
    --repository-name devops-springboot-app \
    --lifecycle-policy-text file://lifecycle-policy.json
```

### Cross-Region Replication

Replicate images to multiple regions for disaster recovery:

```bash
aws ecr put-replication-configuration \
    --replication-configuration file://replication-config.json
```

---

## 🎨 GitHub Actions Workflow Explained

### What the Workflow Does

```yaml
1. Checkout code
2. Configure AWS credentials
3. Login to Amazon ECR
4. Extract metadata (tags)
5. Build Docker image
6. Push to ECR with multiple tags:
   - latest
   - commit SHA
   - branch name
   - semantic version (if tagged)
```

### Tagging Strategy

| Git Action | ECR Tags Created |
|------------|------------------|
| Push to `main` | `latest`, `main-{sha}` |
| Push to `develop` | `develop-{sha}` |
| Create tag `v1.0.0` | `v1.0.0`, `1.0`, `1`, `latest` |
| Pull Request | No push, only build |

---

## 💰 Cost Optimization

### ECR Pricing (as of 2024)

- **Storage**: $0.10 per GB-month
- **Data Transfer**: 
  - OUT to Internet: $0.09 per GB (after free tier)
  - IN: Free
  - Within same region: Free

### Free Tier

- **500 MB** of storage per month (for 12 months)
- **Unlimited** repositories

### Tips to Reduce Costs

1. **Use lifecycle policies** to delete old images
2. **Compress images** - use Alpine base images
3. **Multi-stage builds** - reduce final image size
4. **Tag wisely** - avoid creating too many tags
5. **Use same region** as your EKS cluster

**Example cost for this project:**
- Image size: ~300 MB
- 5 versions kept: 1.5 GB
- Monthly cost: ~$0.15 USD

---

## 🔐 Security Best Practices

### 1. IAM Permissions

✅ **Use least-privilege IAM policies**
✅ **Never commit AWS credentials to Git**
✅ **Rotate access keys regularly**
✅ **Use IAM roles when possible**

### 2. Image Security

✅ **Enable scan on push**
✅ **Review CVE findings**
✅ **Update base images regularly**
✅ **Use official/verified images**

### 3. Repository Settings

✅ **Keep repositories private** (unless public needed)
✅ **Enable tag immutability** for production
✅ **Enable encryption at rest**
✅ **Use VPC endpoints** for private access

---

## 🧪 Useful AWS CLI Commands

### List Repositories
```bash
aws ecr describe-repositories --region us-east-1
```

### List Images in Repository
```bash
aws ecr list-images \
    --repository-name devops-springboot-app \
    --region us-east-1
```

### Get Image Details
```bash
aws ecr describe-images \
    --repository-name devops-springboot-app \
    --image-ids imageTag=latest \
    --region us-east-1
```

### Delete Image
```bash
aws ecr batch-delete-image \
    --repository-name devops-springboot-app \
    --image-ids imageTag=1.0.0 \
    --region us-east-1
```

### Delete Repository (⚠️ Dangerous!)
```bash
aws ecr delete-repository \
    --repository-name devops-springboot-app \
    --force \
    --region us-east-1
```

### Get Repository Policy
```bash
aws ecr get-repository-policy \
    --repository-name devops-springboot-app \
    --region us-east-1
```

---

## 🔍 Troubleshooting

### Issue 1: "no basic auth credentials"
**Cause:** Not logged in to ECR
**Solution:**
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin {account-id}.dkr.ecr.us-east-1.amazonaws.com
```

### Issue 2: "repository does not exist"
**Cause:** Repository not created in ECR
**Solution:**
```bash
aws ecr create-repository --repository-name devops-springboot-app --region us-east-1
```

### Issue 3: "AccessDeniedException"
**Cause:** IAM user lacks necessary permissions
**Solution:** Add `AmazonEC2ContainerRegistryPowerUser` policy to IAM user

### Issue 4: "RequestError: send request failed"
**Cause:** Network/connectivity issue or wrong region
**Solution:** Check internet connection, verify region in AWS CLI config

### Issue 5: GitHub Actions fails with "error: Cannot perform an interactive login from a non TTY device"
**Cause:** Wrong login method in workflow
**Solution:** Use `aws-actions/amazon-ecr-login@v2` action (already configured)

---

## 📈 Monitoring & Alerts

### CloudWatch Metrics (Free)

ECR automatically sends metrics to CloudWatch:
- **RepositoryPullCount**: Number of image pulls
- **RepositoryImageCount**: Number of images stored

**View metrics:**
```bash
aws cloudwatch get-metric-statistics \
    --namespace AWS/ECR \
    --metric-name RepositoryPullCount \
    --dimensions Name=RepositoryName,Value=devops-springboot-app \
    --start-time 2024-01-01T00:00:00Z \
    --end-time 2024-12-31T23:59:59Z \
    --period 86400 \
    --statistics Sum
```

---

## 🔗 Useful Links

- **AWS ECR Console**: https://console.aws.amazon.com/ecr
- **ECR Documentation**: https://docs.aws.amazon.com/ecr
- **ECR Pricing**: https://aws.amazon.com/ecr/pricing/
- **IAM Console**: https://console.aws.amazon.com/iam
- **AWS CLI Installation**: https://aws.amazon.com/cli/

---

## ✅ Verification Checklist

Before moving to the next step:

- [ ] AWS account created
- [ ] AWS CLI installed and configured
- [ ] IAM user created with ECR permissions
- [ ] ECR repository created
- [ ] AWS credentials added to GitHub Secrets
- [ ] Pushed code triggers ECR upload
- [ ] Can view images in AWS ECR console
- [ ] Image scan completed successfully

---

## 🎓 What You've Learned

✅ **Container Registry**: Centralized storage for Docker images  
✅ **AWS IAM**: Identity and Access Management  
✅ **Image Tagging**: Version management strategies  
✅ **Security Scanning**: Automated vulnerability detection  
✅ **CI/CD Integration**: Automated image publishing  
✅ **AWS CLI**: Infrastructure management via command line  

---

**Status:** ✅ AWS ECR configuration complete!

**Next Step:** Deploy to Kubernetes (locally with Minikube/Kind, then to AWS EKS)
