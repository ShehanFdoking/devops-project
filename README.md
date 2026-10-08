# DevOps Spring Boot Application

[![Basic CI](https://github.com/ShehanFdoking/devops-project/actions/workflows/basic-ci.yml/badge.svg)](https://github.com/ShehanFdoking/devops-project/actions/workflows/basic-ci.yml)

A production-ready DevOps demonstration project featuring Spring Boot backend with React frontend, showcasing modern CI/CD practices, containerization, and cloud deployment.

## 🚀 Features

- **Spring Boot Backend**: RESTful API with health checks and metrics
- **React Frontend**: Professional full-screen dashboard UI
- **Docker**: Containerized application with multi-stage builds
- **Kubernetes**: Production-ready K8s manifests for deployment
- **Monitoring**: Prometheus & Grafana integration
- **CI/CD**: Automated GitHub Actions workflows
- **AWS Ready**: EKS and ECR configurations included

## 🏗️ Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   React     │────▶│  Spring     │────▶│  Database   │
│  Frontend   │     │  Boot API   │     │  (Future)   │
│ (Port 5173) │     │ (Port 8082) │     └─────────────┘
└─────────────┘     └─────────────┘
       │                   │
       │                   │
       ▼                   ▼
┌─────────────────────────────┐
│     Docker Container        │
│   (Production Ready)        │
└─────────────────────────────┘
```

## 🛠️ Tech Stack

### Backend
- Java 17
- Spring Boot 3.2.0
- Spring Actuator (Health checks & metrics)
- Micrometer Prometheus
- Maven

### Frontend
- React 19
- Vite 8
- React Router DOM
- Modern CSS

### DevOps
- Docker & Docker Compose
- Kubernetes (K8s)
- GitHub Actions
- Prometheus & Grafana
- AWS EKS & ECR

## 🚀 Quick Start

### Prerequisites
- Java 17+
- Node.js 18+
- Maven 3.8+
- Docker (optional)

### Running Locally

#### Backend (Spring Boot)
```bash
mvn spring-boot:run
```
Backend will be available at: http://localhost:8082

#### Frontend (React)
```bash
cd frontend
npm install
npm run dev
```
Frontend will be available at: http://localhost:5173

### Running with Docker
```bash
# Build the image
docker build -t devops-springboot-app .

# Run the container
docker run -p 8082:8082 devops-springboot-app
```

## 📊 API Endpoints

### Application Endpoints
- `GET /api/hello` - Hello endpoint
- `GET /api/info` - API information
- `GET /api/services` - List of services
- `GET /api/deployments` - Deployment status
- `GET /api/metrics/system` - System metrics

### Actuator Endpoints
- `GET /actuator/health` - Health check
- `GET /actuator/info` - Application info
- `GET /actuator/metrics` - Metrics
- `GET /actuator/prometheus` - Prometheus metrics

## 🔧 Configuration

### Backend Configuration
Configuration is in `src/main/resources/application.properties`:
```properties
server.port=8082
management.endpoints.web.exposure.include=health,info,metrics,prometheus
```

### Frontend Configuration
Frontend API endpoint is configured in `frontend/src/api/api.js`

## 📦 Build & Deploy

### Build JAR
```bash
mvn clean package
```

### Build Docker Image
```bash
docker build -t devops-springboot-app:latest .
```

### Deploy to Kubernetes
```bash
kubectl apply -f k8s/
```

### Deploy to AWS EKS
See [AWS_EKS_SETUP.md](AWS_EKS_SETUP.md) for detailed instructions.

## 📈 Monitoring

### Prometheus Metrics
Available at: http://localhost:8082/actuator/prometheus

### Health Check
```bash
curl http://localhost:8082/actuator/health
```

## 🧪 Testing

### Run Unit Tests
```bash
mvn test
```

### Run with Coverage
```bash
mvn test jacoco:report
```

## 📚 Documentation

- [Architecture Guide](ARCHITECTURE.md)
- [CI/CD Pipeline Guide](CICD_PIPELINE_GUIDE.md)
- [Kubernetes Setup](KUBERNETES_SETUP.md)
- [AWS EKS Setup](AWS_EKS_SETUP.md)
- [Monitoring Guide](MONITORING_GUIDE.md)
- [Frontend Setup](FRONTEND_SETUP.md)
- [ArgoCD Guide](ARGOCD_GUIDE.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 👤 Author

**Shehan Fernando**
- GitHub: [@ShehanFdoking](https://github.com/ShehanFdoking)

## 🌟 Show your support

Give a ⭐️ if this project helped you!

---
Made with ❤️ for DevOps enthusiasts
