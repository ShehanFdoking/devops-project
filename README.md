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

## Current Status: Step 6 - SonarQube Code Quality ✅

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
   
2. **docker-publish.yml** - Docker Image Publishing
   - Triggers: Push to `main`, Git tags, Manual dispatch
   - Steps:
     - Build application
     - Run tests
     - Build and push Docker image to Docker Hub
     - Tag with version, branch name, and SHA

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

- [x] Step 1: Build Spring Boot application
- [x] Step 2: Git + GitHub
- [x] Step 3: Maven
- [x] Step 4: Docker
- [x] Step 5: GitHub Actions CI
- [x] Step 6: SonarQube
- [ ] Step 7: AWS ECR
- [ ] Step 8: Kubernetes locally
- [ ] Step 9: AWS EKS
- [ ] Step 10: Terraform
- [ ] Step 11: Prometheus + Grafana
- [ ] Step 12: Full CI/CD pipeline
- [ ] Step 13: Optional: Argo CD / GitOps

## Next Steps

Push Docker images to AWS Elastic Container Registry (ECR).

## License

MIT License
