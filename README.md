# DevOps Demo Application

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=ShehanFdoking_devops-project&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=ShehanFdoking_devops-project)
[![Bugs](https://sonarcloud.io/api/project_badges/measure?project=ShehanFdoking_devops-project&metric=bugs)](https://sonarcloud.io/summary/new_code?id=ShehanFdoking_devops-project)
[![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=ShehanFdoking_devops-project&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=ShehanFdoking_devops-project)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=ShehanFdoking_devops-project&metric=coverage)](https://sonarcloud.io/summary/new_code?id=ShehanFdoking_devops-project)

A complete DevOps pipeline project using Spring Boot, Docker, Kubernetes, and CI/CD tools.

## Project Overview

This project demonstrates a full DevOps workflow including:
- Spring Boot REST API
- Git version control
- Maven build tool
- Docker containerization
- GitHub Actions CI/CD
- SonarQube code analysis
- AWS ECR container registry
- Kubernetes deployment (local & EKS)
- Terraform infrastructure as code
- Prometheus & Grafana monitoring
- GitOps with Argo CD (optional)

## Current Status: 🎉 COMPLETE DevOps Pipeline - All Steps Done! 🚀

### API Endpoints

- **GET** `/api/hello` - Returns a welcome message
  ```json
  {
    "message": "Hello from DevOps!",
    "version": "1.0"
  }
  ```

- **GET** `/actuator/health` - Health check endpoint
- **GET** `/actuator/info` - Application info

## Prerequisites

- Java 17 or higher
- Maven 3.6+

## Quick Start

### Running with Docker (Recommended)

1. **Pull and run the container**
   ```bash
   docker run -d -p 8082:8082 --name devops-app devops-springboot-app:1.0
   ```

2. **Test the API**
   ```bash
   curl http://localhost:8082/api/hello
   ```

### Running Locally

1. **Clone the repository**
   ```bash
   git clone https://github.com/ShehanFdoking/devops-project.git
   cd devops-project
   ```

2. **Build the application**
   ```bash
   mvn clean install
   ```

3. **Run the application**
   ```bash
   mvn spring-boot:run
   ```

4. **Test the API**
   ```bash
   curl http://localhost:8082/api/hello
   ```

   Expected response:
   ```json
   {
     "message": "Hello from DevOps!",
     "version": "1.0"
   }
   ```

## Docker

### Build Docker Image

```bash
docker build -t devops-springboot-app:1.0 .
```

### Run Docker Container

```bash
docker run -d -p 8082:8082 --name devops-app devops-springboot-app:1.0
```

### View Container Logs

```bash
docker logs devops-app
```

### Stop and Remove Container

```bash
docker stop devops-app
docker rm devops-app
```

## AWS ECR (Elastic Container Registry)

Your Docker images are automatically pushed to AWS ECR via GitHub Actions.

### Push to ECR Manually

**Windows PowerShell:**
```powershell
.\scripts\push-to-ecr.ps1 -Version "1.0" -Region "eu-north-1"
```

**Linux/Mac:**
```bash
chmod +x scripts/push-to-ecr.sh
./scripts/push-to-ecr.sh 1.0 eu-north-1
```

### Pull from ECR

```bash
# Login to ECR
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 852093845150.dkr.ecr.eu-north-1.amazonaws.com

# Pull image
docker pull 852093845150.dkr.ecr.eu-north-1.amazonaws.com/devops-springboot-app:latest
```

### View Images in AWS Console

https://console.aws.amazon.com/ecr/repositories/devops-springboot-app

### Setup ECR Integration

See [AWS_ECR_SETUP.md](AWS_ECR_SETUP.md) for detailed setup instructions.

## AWS EKS (Elastic Kubernetes Service)

Deploy your application to production-grade managed Kubernetes on AWS.

### Quick Start

**Prerequisites:**
```powershell
# Install eksctl
choco install eksctl -y
```

**Create EKS Cluster:**
```bash
eksctl create cluster -f k8s/eks/cluster-config.yaml
```

**Deploy Application:**
```powershell
.\scripts\deploy-to-eks.ps1
```

### Configuration Files

- `k8s/eks/cluster-config.yaml` - EKS cluster configuration
- `k8s/eks/deployment.yaml` - Production Kubernetes manifests
- `scripts/deploy-to-eks.ps1` - Automated deployment script

### Setup Guides

- Comprehensive: [AWS_EKS_SETUP.md](AWS_EKS_SETUP.md)
- Quick start: [.eks-quickstart.md](.eks-quickstart.md)

### Features

- ✅ Managed Kubernetes control plane
- ✅ Auto-scaling worker nodes (1-4 nodes)
- ✅ AWS Load Balancer integration
- ✅ CloudWatch monitoring & logging
- ✅ High availability across AZs
- ✅ Production-ready security

### Cost Estimate

- Control plane: ~$73/month
- 2x t3.medium nodes: ~$66/month
- Load Balancer: ~$16/month
- **Total: ~$155/month**

Use Spot instances for 70% cost savings!

## CI/CD with GitHub Actions

This project includes automated CI/CD pipelines using GitHub Actions.

### Workflows

1. **ci.yml** - Continuous Integration with Code Quality
   - Triggers: Push to `main`/`develop` branches, Pull Requests to `main`
   - Steps:
     - Build with Maven
     - Run tests with JaCoCo coverage
     - **SonarCloud code quality analysis**
     - Build Docker image
     - Test Docker image (health checks)
   
2. **docker-publish.yml** - Docker Hub Publishing
   - Triggers: Push to `main`, Git tags, Manual dispatch
   - Steps:
     - Build application
     - Run tests
     - Build and push Docker image to Docker Hub
     - Tag with version, branch name, and SHA

3. **aws-ecr.yml** - AWS ECR Deployment
   - Triggers: Push to `main`, Git tags, Manual dispatch
   - Steps:
     - Build application with Maven
     - Configure AWS credentials
     - Login to Amazon ECR
     - Build and tag Docker image
     - Push to ECR with multiple tags
     - Initiate vulnerability scan

### Code Quality with SonarCloud

Every code push is automatically analyzed for:
- 🐛 **Bugs**: Potential runtime errors
- 🔒 **Security Vulnerabilities**: Security hotspots and issues
- 👃 **Code Smells**: Maintainability issues
- 📈 **Code Coverage**: Test coverage metrics
- 📋 **Duplications**: Duplicate code detection

**View Analysis:** https://sonarcloud.io/project/overview?id=ShehanFdoking_devops-project

### Setting Up SonarCloud

See [SONARQUBE_SETUP.md](SONARQUBE_SETUP.md) for detailed instructions.

Quick setup:
1. Sign up at https://sonarcloud.io with GitHub
2. Import your repository
3. Generate token and add as `SONAR_TOKEN` in GitHub Secrets
4. Push code - analysis runs automatically!

### Setting Up Docker Hub Integration

See [GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md) for detailed instructions.

## Running Tests

```bash
mvn test
```

## Project Structure

```
devops-project/
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/devops/
│   │   │       ├── DevOpsApplication.java
│   │   │       └── controller/
│   │   │           └── HelloController.java
│   │   │
│   │   └── resources/
│   │       └── application.properties
│   │
│   └── test/
│       └── java/
│           └── com/example/devops/
│               ├── DevOpsApplicationTests.java
│               └── controller/
│                   └── HelloControllerTest.java
│
├── pom.xml
└── README.md
```

## Roadmap

- [x] Step 1: Build Spring Boot application ✅
- [x] Step 2: Git + GitHub ✅
- [x] Step 3: Maven ✅
- [x] Step 4: Docker ✅
- [x] Step 5: GitHub Actions CI ✅
- [x] Step 6: SonarQube ✅
- [x] Step 7: AWS ECR ✅
- [x] Step 8: Kubernetes locally ✅
- [x] Step 9: AWS EKS ✅
- [x] Step 10: Terraform ✅
- [x] Step 11: Prometheus + Grafana ✅
- [x] Step 12: Full CI/CD pipeline ✅
- [x] Step 13: GitOps with Argo CD ✅

## 🎉 Project Complete!

You've built a **complete, production-ready DevOps pipeline** from scratch!

### What You've Accomplished

**Application Development:**
- ✅ Spring Boot 3.2 REST API
- ✅ 81% test coverage
- ✅ Prometheus metrics integration
- ✅ Health checks & Actuator

**CI/CD Pipeline:**
- ✅ Automated builds & tests
- ✅ Code quality analysis (SonarCloud)
- ✅ Security scanning (Trivy)
- ✅ Multi-stage Docker builds
- ✅ Automated deployments

**Infrastructure:**
- ✅ Kubernetes orchestration
- ✅ AWS EKS configuration
- ✅ Infrastructure as Code (Terraform)
- ✅ Container registry (ECR)

**Observability:**
- ✅ Prometheus metrics
- ✅ Grafana dashboards
- ✅ 7 configured alerts
- ✅ Real-time monitoring

**GitOps:**
- ✅ Declarative deployments
- ✅ Automatic sync from Git
- ✅ Self-healing
- ✅ Easy rollbacks

### Documentation

- 📚 [Complete Architecture](PROJECT_SUMMARY.md) - Coming next!
- 📚 [CI/CD Pipeline Guide](CICD_PIPELINE_GUIDE.md)
- 📚 [GitOps Guide](ARGOCD_GUIDE.md)
- 📚 [Monitoring Guide](MONITORING_GUIDE.md)
- 📚 [Terraform Guide](TERRAFORM_GUIDE.md)
- 📚 [Kubernetes Guide](KUBERNETES_SETUP.md)
- 📚 [AWS EKS Setup](AWS_EKS_SETUP.md)
- 📚 [GitHub Actions Setup](GITHUB_ACTIONS_SETUP.md)

## Monitoring (Prometheus + Grafana)

Complete observability for your application with metrics, dashboards, and alerts.

### Quick Start

**Install monitoring stack:**
```powershell
.\scripts\setup-monitoring.ps1
```

**Access Grafana:**
```bash
# Port forward
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# Open browser: http://localhost:3000
# Username: admin
# Password: admin123
```

### Features

- ✅ Prometheus metrics collection
- ✅ Grafana dashboards (4 pre-configured)
- ✅ Spring Boot metrics (HTTP, JVM, Tomcat)
- ✅ Kubernetes cluster metrics
- ✅ Custom alerts (7 configured)
- ✅ Real-time monitoring

### Pre-configured Dashboards

1. **Spring Boot 2.x** - Application metrics
2. **JVM Micrometer** - Java internals
3. **Kubernetes Cluster** - Cluster health
4. **Node Exporter** - Infrastructure metrics

### Metrics Exposed

- HTTP request rate & response time
- JVM memory & garbage collection
- CPU & thread usage
- Error rates & status codes
- Pod health & restarts
- Resource utilization

### Documentation

- Comprehensive guide: [MONITORING_GUIDE.md](MONITORING_GUIDE.md)
- Configuration: `monitoring/prometheus/values.yaml`
- Alerts: `monitoring/alerts.yaml`

**Test it:** Generate traffic and see real-time metrics in Grafana!

## Terraform (Infrastructure as Code)

Manage your entire AWS infrastructure with code.

### Quick Start

**Install Terraform:**
```powershell
choco install terraform -y
```

**Initialize:**
```bash
cd terraform
terraform init
```

**Preview Changes (Free - No AWS Resources Created):**
```bash
terraform plan
```

**Validate Configuration:**
```bash
terraform validate
terraform fmt
```

### Configuration Files

- `terraform/main.tf` - Main configuration & providers
- `terraform/variables.tf` - Input variables (customize infrastructure)
- `terraform/vpc.tf` - VPC & networking setup
- `terraform/eks.tf` - EKS cluster configuration
- `terraform/ecr.tf` - Container registry
- `terraform/outputs.tf` - Output values & useful commands

### What It Creates

When applied, Terraform creates:
- ✅ VPC with public/private subnets across 3 AZs
- ✅ EKS cluster (managed Kubernetes)
- ✅ 2 worker nodes (auto-scaling 1-4)
- ✅ ECR repository for Docker images
- ✅ NAT gateways for private subnet internet access
- ✅ Security groups and IAM roles
- ✅ CloudWatch logging

### Cost Estimate

- Development: ~$131/month (1 spot instance)
- Production: ~$187/month (2 on-demand instances)

### Documentation

- Comprehensive guide: [TERRAFORM_GUIDE.md](TERRAFORM_GUIDE.md)
- Example variables: `terraform/terraform.tfvars.example`

### Key Features

- 📝 **Infrastructure as Code** - Version control your infrastructure
- 🔄 **Reproducible** - Create identical environments
- 📊 **Plan Before Apply** - See changes before making them
- 🔒 **State Management** - Track what exists
- 🌍 **Multi-Cloud** - Works with AWS, Azure, GCP

**Note:** Running `terraform apply` creates real AWS resources and costs money. Use `terraform plan` to explore without charges!

## License

MIT License
