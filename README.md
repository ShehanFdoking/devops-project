# DevOps Demo Application

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

## Current Status: Step 5 - GitHub Actions CI/CD ✅

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

1. **ci.yml** - Continuous Integration
   - Triggers: Push to `main`/`develop` branches, Pull Requests to `main`
   - Steps:
     - Build with Maven
     - Run tests
     - Build Docker image
     - Test Docker image (health checks)
   
2. **docker-publish.yml** - Docker Image Publishing
   - Triggers: Push to `main`, Git tags, Manual dispatch
   - Steps:
     - Build application
     - Run tests
     - Build and push Docker image to Docker Hub
     - Tag with version, branch name, and SHA

### Setting Up Docker Hub Integration

To enable automatic Docker image publishing:

1. **Create Docker Hub account** at https://hub.docker.com

2. **Generate Access Token**
   - Go to Account Settings → Security → New Access Token
   - Copy the token

3. **Add GitHub Secrets**
   - Go to your GitHub repository → Settings → Secrets and variables → Actions
   - Add two secrets:
     - `DOCKERHUB_USERNAME`: Your Docker Hub username
     - `DOCKERHUB_TOKEN`: Your Docker Hub access token

4. **Push to main branch** - The workflow will automatically:
   - Build your application
   - Run tests
   - Build Docker image
   - Push to Docker Hub with multiple tags

### Viewing CI/CD Results

- Go to your GitHub repository
- Click on "Actions" tab
- View workflow runs and logs

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
- [ ] Step 6: SonarQube
- [ ] Step 7: AWS ECR
- [ ] Step 8: Kubernetes locally
- [ ] Step 9: AWS EKS
- [ ] Step 10: Terraform
- [ ] Step 11: Prometheus + Grafana
- [ ] Step 12: Full CI/CD pipeline
- [ ] Step 13: Optional: Argo CD / GitOps

## Next Steps

Integrate SonarQube for code quality analysis.

## License

MIT License
