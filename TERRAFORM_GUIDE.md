# Terraform Guide - Infrastructure as Code

## 🎯 What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool that allows you to:
- ✅ Define infrastructure in code (declarative)
- ✅ Version control your infrastructure
- ✅ Create reproducible environments
- ✅ Manage multi-cloud resources
- ✅ Plan changes before applying
- ✅ Track infrastructure state
- ✅ Collaborate with teams

**Analogy**: Terraform is to infrastructure what Docker is to applications - it packages everything into reusable, shareable code.

---

## 📁 Project Structure

```
terraform/
├── main.tf                     # Main configuration & providers
├── variables.tf                # Input variables
├── outputs.tf                  # Output values
├── vpc.tf                      # VPC & networking
├── eks.tf                      # EKS cluster configuration
├── ecr.tf                      # ECR repository
├── terraform.tfvars.example    # Example variables (copy to terraform.tfvars)
└── .gitignore                  # Files to ignore in git
```

---

## 🚀 Quick Start (Learning Mode)

### Step 1: Install Terraform

**Windows:**
```powershell
choco install terraform -y
```

**Or download from:** https://www.terraform.io/downloads

**Verify:**
```bash
terraform version
```

### Step 2: Initialize Terraform

```bash
cd terraform
terraform init
```

This downloads required providers (AWS, Kubernetes).

### Step 3: View What Will Be Created (Dry Run)

```bash
terraform plan
```

This shows you exactly what resources Terraform will create **without actually creating them**.

### Step 4: Validate Configuration

```bash
terraform validate
terraform fmt
```

- `validate`: Checks syntax errors
- `fmt`: Formats code consistently

---

## 📚 Understanding the Configuration

### main.tf - Core Configuration

```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

**What it does:**
- Declares Terraform version requirement
- Specifies AWS provider and version
- Configures AWS region from variables

### variables.tf - Input Variables

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}
```

**What it does:**
- Defines configurable parameters
- Sets default values
- Documents what each variable does
- Enforces types (string, number, bool, map, list)

### vpc.tf - Networking

```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr
  
  azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}
```

**What it does:**
- Creates VPC (Virtual Private Cloud)
- Creates 3 public subnets (for load balancers)
- Creates 3 private subnets (for EKS nodes)
- Creates NAT gateways for internet access
- Tags resources for EKS

### eks.tf - Kubernetes Cluster

```hcl
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  
  cluster_name    = var.cluster_name
  cluster_version = "1.28"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  eks_managed_node_groups = {
    primary = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 4
      desired_size   = 2
    }
  }
}
```

**What it does:**
- Creates EKS control plane
- Creates managed node group (worker nodes)
- Configures networking
- Sets up IAM roles and policies
- Installs EKS add-ons

### ecr.tf - Container Registry

```hcl
resource "aws_ecr_repository" "app" {
  name                 = "devops-springboot-app"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }
}
```

**What it does:**
- Creates ECR repository
- Enables vulnerability scanning
- Configures lifecycle policy (delete old images)
- Sets up repository permissions

### outputs.tf - Output Values

```hcl
output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}
```

**What it does:**
- Exports useful information after creation
- Shows connection commands
- Provides AWS Console URLs
- Estimates monthly costs

---

## 🎮 Terraform Commands

### Essential Commands

```bash
# Initialize (run first, and after adding new providers)
terraform init

# Format code
terraform fmt

# Validate configuration
terraform validate

# Plan changes (dry run)
terraform plan

# Apply changes (creates resources) - DON'T RUN if avoiding costs
terraform apply

# Show current state
terraform show

# List resources
terraform state list

# Destroy all resources (cleanup)
terraform destroy
```

### Advanced Commands

```bash
# Plan and save to file
terraform plan -out=tfplan

# Apply saved plan
terraform apply tfplan

# Target specific resource
terraform apply -target=module.vpc

# Import existing resources
terraform import aws_instance.example i-1234567890abcdef0

# Refresh state
terraform refresh

# Output specific value
terraform output cluster_endpoint

# Format all files in directory
terraform fmt -recursive
```

---

## 🔧 Customizing Your Infrastructure

### Create Your Variables File

```bash
# Copy example file
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
notepad terraform.tfvars
```

### Example terraform.tfvars

```hcl
# Minimal configuration
aws_region  = "eu-north-1"
environment = "dev"

# Cost optimization
node_desired_capacity = 1       # Start with 1 node
single_nat_gateway    = true    # Use single NAT gateway
enable_spot_instances = true    # Use spot instances for 70% savings

# Application
app_replicas = 2  # Reduce replicas for dev
```

---

## 💰 Cost Management

### Estimated Costs (terraform.tfvars settings)

**Production Configuration (2 nodes):**
- EKS Control Plane: $73/month
- 2x t3.medium nodes: $66/month
- NAT Gateway (single): $32/month
- Network Load Balancer: $16/month
- **Total: ~$187/month**

**Development Configuration (1 node, spot):**
- EKS Control Plane: $73/month
- 1x t3.medium spot: $10/month
- NAT Gateway: $32/month
- Load Balancer: $16/month
- **Total: ~$131/month**

**Free Tier Optimizations:**
- Use t3.micro (2x for $15/month)
- Remove NAT gateway (use public subnets only)
- Estimated: ~$88/month minimum

### Cost-Saving Variables

```hcl
# In terraform.tfvars
node_instance_type     = "t3.small"   # Smaller instance
node_desired_capacity  = 1            # Single node
enable_spot_instances  = true         # 70% discount
single_nat_gateway     = true         # vs 3x NAT gateways
enable_container_insights = false     # Reduce CloudWatch costs
```

---

## 🎯 Terraform Workflow

### 1. Development Workflow

```bash
# 1. Make changes to .tf files
vim terraform/variables.tf

# 2. Format code
terraform fmt

# 3. Validate syntax
terraform validate

# 4. Plan changes
terraform plan

# 5. Review plan output carefully

# 6. Apply if satisfied (or don't apply to avoid costs)
# terraform apply
```

### 2. Team Collaboration Workflow

```bash
# 1. Pull latest code
git pull origin main

# 2. Initialize (get latest provider versions)
terraform init -upgrade

# 3. Plan with output file
terraform plan -out=tfplan

# 4. Review plan with team

# 5. Apply approved plan
terraform apply tfplan

# 6. Commit state (if using git - not recommended for prod)
git add terraform.tfstate
git commit -m "Updated infrastructure"
```

### 3. Production Workflow (with Remote State)

```bash
# 1. Use S3 backend for state
terraform {
  backend "s3" {
    bucket = "company-terraform-state"
    key    = "devops-project/terraform.tfstate"
    region = "eu-north-1"
    encrypt = true
    dynamodb_table = "terraform-locks"
  }
}

# 2. Initialize with backend
terraform init

# 3. Plan
terraform plan

# 4. Apply with approval
terraform apply

# State is automatically saved to S3
# Multiple team members can collaborate safely
```

---

## 🔍 Understanding Terraform State

### What is Terraform State?

`terraform.tfstate` is a JSON file that:
- Maps your configuration to real resources
- Tracks metadata and dependencies
- Enables Terraform to know what exists
- **Contains sensitive data (passwords, keys)**

### State Management

**Local State (Learning):**
```bash
# State is in terraform.tfstate file
# Simple, but doesn't work for teams
```

**Remote State (Production):**
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "eu-north-1"
    encrypt = true
  }
}
```

**State Commands:**
```bash
# List resources in state
terraform state list

# Show resource details
terraform state show aws_instance.example

# Remove resource from state (doesn't delete real resource)
terraform state rm aws_instance.example

# Move resource in state
terraform state mv aws_instance.old aws_instance.new

# Pull remote state to local
terraform state pull
```

---

## 📊 Modules Explained

### What are Modules?

Modules are reusable Terraform configurations. Think of them as functions in programming.

**Using a Module:**
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"
}
```

**Benefits:**
- DRY (Don't Repeat Yourself)
- Tested and maintained by community
- Consistent patterns across projects
- Easier to update

### Our Modules

1. **VPC Module** (`terraform-aws-modules/vpc/aws`)
   - Creates complete VPC with subnets, NAT, IGW
   - Battle-tested by thousands of users

2. **EKS Module** (`terraform-aws-modules/eks/aws`)
   - Full EKS cluster setup
   - Node groups, IAM, add-ons
   - Production-ready defaults

---

## 🧪 Testing Without AWS Costs

### 1. Terraform Plan (Always Free)

```bash
# See exactly what will be created
terraform plan

# Save plan to file for review
terraform plan -out=tfplan

# Review the plan
less tfplan
```

### 2. Terraform Validate (Always Free)

```bash
# Check syntax and logic
terraform validate

# Check formatting
terraform fmt -check
```

### 3. Use terraform-docs (Document)

```bash
# Install
choco install terraform-docs -y

# Generate documentation
terraform-docs markdown table . > TERRAFORM.md
```

### 4. Static Analysis Tools

```bash
# tflint - Linter for Terraform
choco install tflint -y
tflint

# checkov - Security scanner
pip install checkov
checkov -d terraform/
```

---

## 🎓 Key Concepts

### 1. Resources vs Data Sources

**Resources** - Create/manage infrastructure:
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345"
  instance_type = "t3.micro"
}
```

**Data Sources** - Read existing infrastructure:
```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical
}
```

### 2. Dependencies

**Implicit** (Terraform figures it out):
```hcl
resource "aws_instance" "web" {
  subnet_id = aws_subnet.main.id  # Implicit dependency
}
```

**Explicit** (You specify):
```hcl
resource "aws_instance" "web" {
  # ...
  depends_on = [aws_security_group.allow_http]
}
```

### 3. Count and For_Each

**Count** - Create multiple similar resources:
```hcl
resource "aws_instance" "server" {
  count = 3
  
  ami           = "ami-12345"
  instance_type = "t3.micro"
  
  tags = {
    Name = "Server ${count.index + 1}"
  }
}
```

**For_Each** - Create resources from map/set:
```hcl
resource "aws_instance" "server" {
  for_each = toset(["web", "api", "db"])
  
  ami           = "ami-12345"
  instance_type = "t3.micro"
  
  tags = {
    Name = each.key
  }
}
```

### 4. Lifecycle Rules

```hcl
resource "aws_instance" "web" {
  # ...
  
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes        = [tags]
  }
}
```

---

## 🔐 Security Best Practices

### 1. Never Commit Secrets

```bash
# Use environment variables
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."

# Or AWS CLI profiles
aws configure --profile devops
terraform plan -var="profile=devops"
```

### 2. Use .gitignore

```gitignore
*.tfvars          # Contains secrets
*.tfstate         # Contains secrets
*.tfstate.backup
.terraform/
```

### 3. Encrypt State

```hcl
terraform {
  backend "s3" {
    bucket  = "terraform-state"
    encrypt = true  # Encrypt at rest
  }
}
```

### 4. Use Variables for Secrets

```hcl
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true  # Won't show in logs
}
```

---

## 📚 Additional Resources

- **Terraform Docs**: https://www.terraform.io/docs
- **AWS Provider Docs**: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- **Terraform Registry**: https://registry.terraform.io/ (modules)
- **Learn Terraform**: https://learn.hashicorp.com/terraform
- **Terraform Best Practices**: https://www.terraform-best-practices.com/

---

## ✅ Checklist

- [ ] Terraform installed
- [ ] AWS CLI configured
- [ ] Reviewed terraform.tfvars.example
- [ ] Ran `terraform init`
- [ ] Ran `terraform validate`
- [ ] Ran `terraform plan`
- [ ] Understood what resources will be created
- [ ] Reviewed cost estimates
- [ ] (Optional) Applied configuration: `terraform apply`
- [ ] (Optional) Destroyed resources: `terraform destroy`

---

**Status:** ✅ Terraform configuration complete and ready to use!

**Note:** Running `terraform apply` will create real AWS resources and incur costs (~$130-190/month). Only apply if you're ready to use AWS resources!
