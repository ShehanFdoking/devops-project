# 🏗️ Full-Stack DevOps Platform - Architecture

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                         End Users / Developers                      │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                    Browser (Chrome, Firefox, etc.)
                             │
┌────────────────────────────▼────────────────────────────────────────┐
│                   FRONTEND LAYER (React 19)                         │
│                                                                     │
│  ┌─────────────┐  ┌──────────┐  ┌─────────┐  ┌──────────────┐   │
│  │  Dashboard  │  │  Health  │  │ Metrics │  │ Deployments  │   │
│  │    (/)      │  │ (/health)│  │(/metrics)│  │(/deployments)│   │
│  └─────────────┘  └──────────┘  └─────────┘  └──────────────┘   │
│                                                                     │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────┐              │
│  │  Services   │  │ API Explorer │  │  Settings  │              │
│  │ (/services) │  │   (/api)     │  │ (/settings)│              │
│  └─────────────┘  └──────────────┘  └────────────┘              │
│                                                                     │
│  Port: 5173  |  Vite Dev Server  |  Auto-refresh enabled         │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                    REST API (HTTP/JSON)
                             │
┌────────────────────────────▼────────────────────────────────────────┐
│                  BACKEND LAYER (Spring Boot 3.2)                    │
│                                                                     │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │              REST API Controllers                          │   │
│  ├────────────────────────────────────────────────────────────┤   │
│  │  HelloController     │ /api/hello, /api/status           │   │
│  │  MetricsController   │ /api/metrics                      │   │
│  │  DeploymentController│ /api/deployments/*                │   │
│  │  ServiceController   │ /api/services/*                   │   │
│  │  ApiInfoController   │ /api/info/*                       │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │           Spring Boot Actuator                             │   │
│  ├────────────────────────────────────────────────────────────┤   │
│  │  /actuator/health      │ Health checks                    │   │
│  │  /actuator/prometheus  │ Metrics export                   │   │
│  │  /actuator/info        │ Application info                 │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  Port: 8082  |  Embedded Tomcat  |  CORS Enabled                  │
└────────────────────────────┬────────────────────────────────────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
         ▼                   ▼                   ▼
┌─────────────────┐  ┌──────────────┐  ┌──────────────────┐
│  Docker         │  │  Kubernetes  │  │  Prometheus      │
│  Containers     │  │  Pods        │  │  Monitoring      │
└─────────────────┘  └──────────────┘  └──────────────────┘
```

---

## Component Breakdown

### 1. Frontend Layer

**Technology:** React 19 + Vite + React Router DOM

**Pages:**
```
Dashboard (/)
  ├─ Application Status
  ├─ System Metrics Preview
  ├─ Latest Deployment
  └─ Recent Activity

Health (/health)
  ├─ Component Health Status
  ├─ Response Times
  ├─ Health Check Config
  └─ Raw Health Data

Metrics (/metrics)
  ├─ CPU Usage
  ├─ Memory Usage
  ├─ Request Stats
  └─ Performance Metrics

Deployments (/deployments)
  ├─ Deployment History Table
  ├─ Status Indicators
  └─ Environment Info

Services (/services)
  ├─ Backend API Status
  ├─ Kubernetes Status
  ├─ Database Status
  └─ Infrastructure Components

API Explorer (/api)
  ├─ Endpoint List
  ├─ Test Interface
  └─ Response Viewer

Settings (/settings)
  ├─ Application Config
  ├─ Environment Info
  └─ System Details
```

**Key Features:**
- Auto-refresh (5s - 30s depending on page)
- CORS-enabled API calls
- Error handling
- Loading states
- Responsive design

---

### 2. Backend Layer

**Technology:** Spring Boot 3.2.0 + Java 17 + Maven

**Controllers:**

#### HelloController
```
GET /api/hello         → Application greeting & info
GET /api/status        → Application status
```

#### MetricsController
```
GET /api/metrics       → Real-time system metrics
  - CPU usage
  - Memory usage  
  - Request stats
  - Uptime
```

#### DeploymentController
```
GET /api/deployments         → All deployments
GET /api/deployments/latest  → Latest deployment
```

#### ServiceController
```
GET /api/services        → All services status
GET /api/services/status → Services summary
```

#### ApiInfoController
```
GET /api/info/endpoints    → API endpoint list
GET /api/info/version      → Application version
GET /api/info/environment  → Environment details
```

**Spring Actuator:**
```
GET /actuator/health      → Health check (Kubernetes probes)
GET /actuator/prometheus  → Prometheus metrics
GET /actuator/info        → Application info
```

---

## Data Flow

### 1. User Request Flow

```
User clicks "Dashboard"
  │
  ▼
React Router (client-side)
  │
  ▼
Dashboard.jsx loads
  │
  ├─► api.getStatus()       → GET /api/status
  ├─► api.getVersion()      → GET /api/info/version
  ├─► api.getMetrics()      → GET /api/metrics
  ├─► api.getLatestDeployment() → GET /api/deployments/latest
  └─► api.getHealth()       → GET /actuator/health
  │
  ▼
Backend processes requests
  │
  ▼
Responses returned (JSON)
  │
  ▼
React state updated
  │
  ▼
UI re-renders with new data
```

### 2. Auto-Refresh Flow

```
Component mounts
  │
  ▼
Load initial data
  │
  ▼
Set interval (useEffect)
  │
  ├─► Every 5s  → Metrics page
  ├─► Every 10s → Health, Services pages
  └─► Every 30s → Dashboard page
  │
  ▼
Fetch new data from backend
  │
  ▼
Update state → UI updates
```

---

## Deployment Architecture

### Development

```
┌─────────────────┐         ┌─────────────────┐
│  React Dev      │         │  Spring Boot    │
│  localhost:5173 │────────▶│  localhost:8082 │
│  (npm run dev)  │  REST   │  (mvn run)      │
└─────────────────┘         └─────────────────┘
```

### Docker

```
┌─────────────────────┐       ┌──────────────────────┐
│  Frontend Container │       │  Backend Container   │
│  nginx:alpine       │       │  eclipse-temurin:17  │
│  Port: 80           │──────▶│  Port: 8082          │
│  (Static files)     │ HTTP  │  (Spring Boot)       │
└─────────────────────┘       └──────────────────────┘
```

### Kubernetes

```
┌─────────────────────────────────────────────────┐
│              Kubernetes Cluster                 │
│                                                 │
│  ┌──────────────────┐    ┌──────────────────┐ │
│  │ Frontend Pods    │    │ Backend Pods     │ │
│  │ (2 replicas)     │    │ (3 replicas)     │ │
│  └────────┬─────────┘    └────────┬─────────┘ │
│           │                       │           │
│  ┌────────▼─────────┐    ┌────────▼─────────┐ │
│  │ Frontend Service │    │ Backend Service  │ │
│  │ (LoadBalancer)   │    │ (ClusterIP)      │ │
│  └────────┬─────────┘    └────────┬─────────┘ │
│           │                       │           │
│  ┌────────▼───────────────────────▼─────────┐ │
│  │            Ingress Controller            │ │
│  │  devops-app.example.com                  │ │
│  └──────────────────────────────────────────┘ │
└───────────────────┬─────────────────────────────┘
                    │
        ┌───────────▼───────────┐
        │  Load Balancer (AWS)  │
        │  External IP          │
        └───────────────────────┘
```

---

## CI/CD Pipeline

```
GitHub Push
  │
  ▼
┌─────────────────────────────────────┐
│      GitHub Actions Workflow        │
├─────────────────────────────────────┤
│  1. Build & Test                    │
│     ├─ Backend (Maven)              │
│     └─ Frontend (npm)               │
│                                     │
│  2. Code Quality                    │
│     └─ SonarCloud                   │
│                                     │
│  3. Security Scan                   │
│     └─ Trivy                        │
│                                     │
│  4. Docker Build                    │
│     ├─ Backend image                │
│     └─ Frontend image               │
│                                     │
│  5. Push to ECR                     │
│     ├─ Tag: version                 │
│     └─ Tag: latest                  │
│                                     │
│  6. Deploy to K8s                   │
│     └─ kubectl apply                │
│                                     │
│  7. Health Check                    │
│     └─ Verify deployment            │
└─────────────────────────────────────┘
```

---

## Monitoring Architecture

```
┌─────────────────────────────────────────┐
│         Spring Boot Application         │
│                                         │
│  /actuator/prometheus                   │
│  (Metrics endpoint)                     │
└────────────────┬────────────────────────┘
                 │
                 │ Scrape (every 15s)
                 │
         ┌───────▼────────┐
         │  Prometheus    │
         │  Server        │
         │  (Port 9090)   │
         └───────┬────────┘
                 │
                 │ Query
                 │
         ┌───────▼────────┐
         │   Grafana      │
         │   (Port 3000)  │
         │                │
         │  Dashboards:   │
         │  - Spring Boot │
         │  - JVM Metrics │
         │  - Kubernetes  │
         └────────────────┘
```

---

## Security Architecture

### 1. CORS Configuration

```java
@CrossOrigin(origins = "*")  // Development
// Production: Specific origins only
@CrossOrigin(origins = "https://devops-app.example.com")
```

### 2. API Security (Future)

```
User Request
  │
  ▼
API Gateway
  │
  ├─► JWT Validation
  ├─► Rate Limiting
  └─► Authentication
  │
  ▼
Backend Services
```

### 3. Kubernetes Security

```
- Network Policies
- Pod Security Standards
- RBAC
- Secrets Management
- Image Scanning (Trivy)
```

---

## Scalability

### Horizontal Pod Autoscaler (HPA)

```yaml
Target CPU: 70%
Min Replicas: 2
Max Replicas: 10

Scale Up:
  70% CPU → Add pod
  
Scale Down:
  <50% CPU → Remove pod
```

### Database Scaling (Future)

```
Primary DB
  │
  ├─► Read Replica 1
  ├─► Read Replica 2
  └─► Read Replica 3
```

---

## High Availability

```
Region: us-east-1
  │
  ├─► AZ-1a (Subnet 1)
  │   ├─ Backend Pod 1
  │   └─ Frontend Pod 1
  │
  ├─► AZ-1b (Subnet 2)
  │   ├─ Backend Pod 2
  │   └─ Frontend Pod 2
  │
  └─► AZ-1c (Subnet 3)
      ├─ Backend Pod 3
      └─ Frontend Pod 3
```

**RTO:** < 5 minutes  
**RPO:** < 1 minute  
**Availability:** 99.9%

---

## Technology Decisions

### Why React?
- ✅ Modern, popular framework
- ✅ Component-based architecture
- ✅ Large ecosystem
- ✅ Easy to learn

### Why Spring Boot?
- ✅ Industry standard for Java
- ✅ Built-in features (Actuator, Metrics)
- ✅ Easy Kubernetes integration
- ✅ Excellent for microservices

### Why Kubernetes?
- ✅ Industry standard orchestration
- ✅ Self-healing
- ✅ Auto-scaling
- ✅ Cloud-agnostic

### Why AWS?
- ✅ Most popular cloud provider
- ✅ EKS for managed Kubernetes
- ✅ ECR for container registry
- ✅ Rich ecosystem

---

## Future Architecture

### Microservices Evolution

```
Current: Monolithic
  Frontend ─► Backend (Single app)

Future: Microservices
  Frontend
    │
    ├─► User Service
    ├─► Metrics Service
    ├─► Deployment Service
    └─► Gateway/BFF
```

### Event-Driven

```
Service A ─► Message Queue ─► Service B
           (Kafka/RabbitMQ)
```

---

**Status:** ✅ Architecture complete and documented!

**Next:** Deploy full stack to see it in action!
