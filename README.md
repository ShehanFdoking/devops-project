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

## Current Status: Step 1 - Spring Boot Application ✅

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

## Running Locally

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
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
   curl http://localhost:8080/api/hello
   ```

   Expected response:
   ```json
   {
     "message": "Hello from DevOps!",
     "version": "1.0"
   }
   ```

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
- [ ] Step 2: Git + GitHub
- [ ] Step 3: Maven
- [ ] Step 4: Docker
- [ ] Step 5: GitHub Actions CI
- [ ] Step 6: SonarQube
- [ ] Step 7: AWS ECR
- [ ] Step 8: Kubernetes locally
- [ ] Step 9: AWS EKS
- [ ] Step 10: Terraform
- [ ] Step 11: Prometheus + Grafana
- [ ] Step 12: Full CI/CD pipeline
- [ ] Step 13: Optional: Argo CD / GitOps

## Next Steps

Configure Git and push to GitHub repository.

## License

MIT License
