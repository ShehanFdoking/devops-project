# 🚀 Full-Stack DevOps Platform - Complete Guide

## 🎯 Project Overview

A **production-ready full-stack DevOps monitoring platform** that demonstrates:
- Complete CI/CD pipeline
- Containerization with Docker
- Kubernetes orchestration
- Cloud deployment (AWS ECR/EKS)
- Real-time monitoring
- Infrastructure as Code (Terraform)
- GitOps with Argo CD

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     User Browser                            │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│           React Frontend (Port 5173)                        │
│  Dashboard | Health | Metrics | Deployments | Services     │
└────────────────────┬────────────────────────────────────────┘
                     │ HTTP/REST API
                     ▼
┌─────────────────────────────────────────────────────────────┐
│         Spring Boot Backend (Port 8082)                     │
│  Controllers: Hello | Metrics | Deployments | Services     │
│  Actuator: Health, Prometheus, Info                        │
└────────────────────┬────────────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
   ┌────────┐  ┌─────────┐  ┌──────────┐
   │ Docker │  │ K8s/EKS │  │Prometheus│
   └────────┘  └─────────┘  └──────────┘
```

---

## 📦 Technology Stack

### Backend
- **Language:** Java 17
- **Framework:** Spring Boot 3.2.0
- **Build Tool:** Maven 3.9+
- **Features:** REST API, Actuator, Prometheus metrics

### Frontend
- **Framework:** React 19
- **Router:** React Router DOM 7
- **Build Tool:** Vite 8
- **Styling:** Modern CSS with custom variables

### DevOps Tools
- **Containerization:** Docker
- **Orchestration:** Kubernetes (Docker Desktop / AWS EKS)
- **CI/CD:** GitHub Actions
- **Code Quality:** SonarCloud
- **Container Registry:** AWS ECR
- **Infrastructure:** Terraform
- **Monitoring:** Prometheus + Grafana
- **GitOps:** Argo CD

---

## 🎨 Frontend Pages

### 1. 🏠 Dashboard (`/`)
**Purpose:** Main overview of the entire platform

**Shows:**
- Application status (Healthy/Down)
- Current version & environment
- CPU & Memory usage with visual bars
- Latest deployment info with pipeline stages
- Request metrics (requests/sec, response time, errors)
- Uptime
- Recent activity feed

**Data Source:** 
- `/api/status`
- `/api/metrics`
- `/api/deployments/latest`
- `/actuator/health`

**Auto-refresh:** Every 30 seconds

---

### 2. ❤️ Application Health (`/health`)
**Purpose:** Monitor health status of all components

**Shows:**
- Backend API health (UP/DOWN)
- Application health
- Kubernetes health
- ECR connection status
- Response times per component
- Uptime tracking
- Health check configuration (Liveness/Readiness probes)
- Last health check timestamp & raw JSON

**Data Source:**
- `/actuator/health`
- `/api/metrics`

**Auto-refresh:** Every 10 seconds

---

### 3. 📊 System Metrics (`/metrics`)
**Purpose:** Real-time performance monitoring

**Shows:**
- CPU usage percentage with visual bar
- Memory usage (used/total MB)
- Requests per second
- Average response time
- Total requests count
- Error count
- System uptime
- Available processors

**Data Source:**
- `/api/metrics` (real JVM metrics)

**Auto-refresh:** Every 5 seconds

---

### 4. 🚀 Deployments (`/deployments`)
**Purpose:** CI/CD pipeline history

**Shows:**
- Deployment history table
- Version number
- Status (Success/Failed)
- Deployment date & time
- Duration
- Environment (production/staging)

**Data Source:**
- `/api/deployments`

**Future Enhancement:**
- Connect to GitHub Actions API
- Show detailed pipeline stages
- Deployment logs
- Rollback functionality

---

### 5. 📦 Services (`/services`)
**Purpose:** Infrastructure component status

**Shows:**
- Backend API (Spring Boot 3.2.0)
- Frontend (React 18)
- Database (PostgreSQL 15)
- Kubernetes (v1.34.1)
- Monitoring (Prometheus + Grafana)
- Each service shows: Status, Version, Uptime

**Data Source:**
- `/api/services`

**Auto-refresh:** Every 10 seconds

---

### 6. 📋 API Explorer (`/api`)
**Purpose:** Interactive API testing

**Shows:**
- All available endpoints
- HTTP method (GET/POST/etc.)
- Endpoint path
- Description
- Test button for each
- Response viewer with JSON formatting

**Available Endpoints:**
- `/api/hello` - Application info
- `/api/metrics` - Performance metrics
- `/api/deployments` - Deployment history
- `/api/services` - Service status
- `/api/info/endpoints` - Endpoint list
- `/actuator/health` - Health check
- `/actuator/prometheus` - Prometheus metrics

**Use Case:**
- Demo the backend during presentations
- Quick API testing
- Documentation reference

---

### 7. ⚙️ Settings (`/settings`)
**Purpose:** Configuration and environment info

**Shows:**
- Application name
- Environment (development/production)
- Version
- Backend API URL
- Java version
- Spring Boot version
- Active profile
- Monitoring configuration

**Data Source:**
- `/api/info/environment`

---

## 🔌 Backend API Endpoints

### Application Endpoints

#### `GET /api/hello`
Returns application information
```json
{
  "message": "Hello from DevOps CI/CD Pipeline!",
  "version": "2.0",
  "pipeline": "Full CI/CD with GitHub Actions",
  "status": "All 13 steps completed!"
}
```

#### `GET /api/status`
Application status
```json
{
  "status": "online",
  "healthy": true,
  "timestamp": 1696742400000
}
```

---

### Metrics Endpoints

#### `GET /api/metrics`
Real-time system metrics
```json
{
  "memoryUsed": 245,
  "memoryTotal": 512,
  "memoryUsagePercent": 47.85,
  "cpuUsagePercent": 42.0,
  "availableProcessors": 8,
  "uptimeHours": 12,
  "uptimeMinutes": 32,
  "uptimeFormatted": "12h 32m",
  "requestsPerSecond": 25,
  "avgResponseTime": 38,
  "totalRequests": 1245,
  "errorCount": 2
}
```

---

### Deployment Endpoints

#### `GET /api/deployments`
Deployment history
```json
[
  {
    "version": "2.0",
    "status": "success",
    "date": "2026-10-08 13:04",
    "description": "Full CI/CD pipeline test",
    "environment": "production",
    "duration": "180s"
  }
]
```

#### `GET /api/deployments/latest`
Latest deployment info

---

### Service Endpoints

#### `GET /api/services`
All services status
```json
[
  {
    "name": "Backend API",
    "status": "running",
    "version": "Spring Boot 3.2.0",
    "uptime": "12h"
  }
]
```

#### `GET /api/services/status`
Services summary
```json
{
  "total": 5,
  "running": 5,
  "stopped": 0,
  "healthy": true
}
```

---

### Info Endpoints

#### `GET /api/info/endpoints`
List all API endpoints
```json
[
  {
    "method": "GET",
    "path": "/api/hello",
    "description": "Returns application information",
    "authentication": "Public"
  }
]
```

#### `GET /api/info/version`
Application version
```json
{
  "version": "2.0",
  "buildDate": "2026-10-08",
  "commitHash": "47fcef8",
  "environment": "development"
}
```

#### `GET /api/info/environment`
Environment info
```json
{
  "environment": "development",
  "javaVersion": "17.0.11",
  "springBootVersion": "3.2.0",
  "profile": "default"
}
```

---

### Spring Boot Actuator

#### `GET /actuator/health`
Application health check
```json
{
  "status": "UP"
}
```

#### `GET /actuator/prometheus`
Prometheus metrics (text format)

---

## 🚀 Quick Start

### Prerequisites
- Java 17+
- Node.js 18+
- Maven 3.9+
- Docker (optional)
- 5GB+ free disk space

### 1. Start Backend

```bash
cd "d:\DevOps Project\devops-project"
mvn spring-boot:run
```

Backend runs on: **http://localhost:8082**

Test:
```bash
curl http://localhost:8082/api/hello
```

### 2. Setup Frontend

**First time only:**
```bash
cd frontend
npm install
```

**Start dev server:**
```bash
npm run dev
```

Frontend runs on: **http://localhost:5173**

### 3. Open Browser

Navigate to: **http://localhost:5173**

You should see the DevOps Dashboard! 🎉

---

## 🐳 Docker Deployment

### Backend Docker

```bash
# Build image
docker build -t devops-backend:2.0 .

# Run container
docker run -d -p 8082:8082 --name devops-backend devops-backend:2.0
```

### Frontend Docker

```dockerfile
# frontend/Dockerfile
FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

```bash
# Build frontend
cd frontend
docker build -t devops-frontend:2.0 .

# Run frontend
docker run -d -p 80:80 --name devops-frontend devops-frontend:2.0
```

---

## ☸️ Kubernetes Deployment

### Backend Deployment

Already exists in `k8s/deployment.yaml`

### Frontend Deployment

```yaml
# k8s/frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devops-frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: devops-frontend
  template:
    metadata:
      labels:
        app: devops-frontend
    spec:
      containers:
      - name: frontend
        image: devops-frontend:2.0
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: devops-frontend-service
spec:
  type: LoadBalancer
  selector:
    app: devops-frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

Deploy:
```bash
kubectl apply -f k8s/frontend-deployment.yaml
```

---

## 🔄 CI/CD Pipeline

The full pipeline (`.github/workflows/full-pipeline.yaml`) now includes:

1. **Build & Test** - Both backend and frontend
2. **Code Quality** - SonarCloud analysis
3. **Security Scan** - Trivy scanning
4. **Docker Build** - Multi-container builds
5. **Deploy** - Both services to Kubernetes

Update to build both:
```yaml
- name: Build Frontend
  run: |
    cd frontend
    npm install
    npm run build
    
- name: Build Frontend Docker
  run: |
    docker build -t $ECR_REGISTRY/devops-frontend:$IMAGE_TAG frontend/
    docker push $ECR_REGISTRY/devops-frontend:$IMAGE_TAG
```

---

## 📊 Monitoring Integration

### Prometheus Metrics

Backend exposes Prometheus metrics at `/actuator/prometheus`

### Grafana Dashboards

Import these dashboards:
- **Spring Boot 2.x Statistics** (ID: 12900)
- **JVM Micrometer** (ID: 4701)
- **Kubernetes Cluster** (ID: 7249)

### Custom Metrics

Add custom metrics in `MetricsController.java`:
```java
@Timed(value = "api.hello", description = "Time taken to return hello")
public Map<String, String> hello() {
    // ...
}
```

---

## 🎓 What This Project Demonstrates

### For DevOps Roles
✅ CI/CD pipeline design and implementation
✅ Container orchestration with Kubernetes
✅ Cloud platform knowledge (AWS)
✅ Infrastructure as Code (Terraform)
✅ Monitoring and observability
✅ GitOps practices

### For Full-Stack Roles
✅ Modern React application
✅ RESTful API design
✅ Real-time data updates
✅ Responsive UI design
✅ API integration

### For Backend Roles
✅ Spring Boot best practices
✅ RESTful API development
✅ Metrics and monitoring
✅ Health checks
✅ CORS configuration

---

## 🚧 Future Enhancements

### Phase 1: Enhanced Monitoring
- [ ] Real-time WebSocket updates
- [ ] Custom alerting system
- [ ] Log aggregation viewer
- [ ] Performance profiling

### Phase 2: Advanced Features
- [ ] User authentication (OAuth2/JWT)
- [ ] Role-based access control
- [ ] Multi-environment management
- [ ] Deployment approvals

### Phase 3: AI/ML Integration
- [ ] Anomaly detection
- [ ] Predictive scaling
- [ ] Intelligent alerting
- [ ] Performance optimization suggestions

---

## 📚 Documentation Links

- [Frontend Setup](FRONTEND_SETUP.md)
- [CI/CD Pipeline Guide](CICD_PIPELINE_GUIDE.md)
- [Kubernetes Setup](KUBERNETES_SETUP.md)
- [AWS EKS Setup](AWS_EKS_SETUP.md)
- [Monitoring Guide](MONITORING_GUIDE.md)
- [Terraform Guide](TERRAFORM_GUIDE.md)
- [Argo CD Guide](ARGOCD_GUIDE.md)

---

## ✅ Project Checklist

### Backend
- [x] Spring Boot application
- [x] REST API controllers
- [x] Health checks
- [x] Prometheus metrics
- [x] CORS configuration
- [x] Unit tests

### Frontend
- [x] React application
- [x] 7 professional pages
- [x] API integration
- [x] Auto-refresh
- [x] Responsive design
- [ ] Unit tests (TODO)

### DevOps
- [x] Docker containerization
- [x] Kubernetes manifests
- [x] CI/CD pipeline
- [x] AWS ECR integration
- [x] Monitoring setup
- [x] Terraform IaC
- [x] GitOps with Argo CD

---

**Status:** 🎉 Full-stack DevOps platform complete!

**Next Steps:** Clear disk space → Install frontend dependencies → Launch dashboard!
