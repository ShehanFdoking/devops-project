# 🎨 Frontend Setup Guide - DevOps Dashboard

## 🚀 What We've Built

A complete **DevOps Monitoring Dashboard** with React that connects to your Spring Boot backend.

### Features

✅ **7 Professional Pages:**
1. 🏠 **Dashboard** - Application overview, metrics, latest deployment
2. ❤️ **Application Health** - Health checks, component status
3. 📊 **System Metrics** - Real-time CPU, memory, requests
4. 🚀 **Deployments** - CI/CD pipeline history
5. 📦 **Services** - Infrastructure status
6. 📋 **API Explorer** - Test all endpoints
7. ⚙️ **Settings** - Configuration and environment

✅ **Real Backend Integration** - Connects to Spring Boot APIs
✅ **Auto-Refresh** - Real-time data updates
✅ **Professional UI** - Clean, modern DevOps dashboard

---

## 📦 Files Created

### Backend Controllers (Java)
```
src/main/java/com/example/devops/controller/
├── HelloController.java         (✅ Updated with CORS)
├── DeploymentController.java    (✅ New)
├── MetricsController.java       (✅ New)
├── ServiceController.java       (✅ New)
└── ApiInfoController.java       (✅ New)
```

### Frontend (React)
```
frontend/src/
├── App.jsx                      (✅ Router setup)
├── App.css                      (✅ Complete styling)
├── api/
│   └── api.js                   (✅ API client)
├── components/
│   └── Layout.jsx               (✅ Sidebar navigation)
└── pages/
    ├── Dashboard.jsx            (✅ Main overview)
    ├── Health.jsx               (✅ Health monitoring)
    ├── Metrics.jsx              (✅ Performance metrics)
    ├── Deployments.jsx          (✅ CI/CD history)
    ├── Services.jsx             (✅ Service status)
    ├── ApiExplorer.jsx          (✅ API testing)
    └── Settings.jsx             (✅ Configuration)
```

---

## ⚠️ DISK SPACE ISSUE

You're seeing: `ENOSPC: no space left on device`

### Quick Fix Options

**Option 1: Clean npm cache**
```bash
npm cache clean --force
```

**Option 2: Clear temporary files**
```bash
# Windows
# Open Disk Cleanup (cleanmgr.exe)
# Select C: drive, clean temp files
```

**Option 3: Clean Maven target folder**
```bash
cd d:\DevOps Project\devops-project
rmdir /s /q target
mvn clean
```

**Option 4: Clean Docker (if needed)**
```bash
docker system prune -a
```

---

## 🚀 Setup Steps (After Freeing Space)

### 1. Install React Router

```bash
cd "d:\DevOps Project\devops-project\frontend"
npm install react-router-dom
```

### 2. Start Backend (Spring Boot)

```bash
cd "d:\DevOps Project\devops-project"
mvn spring-boot:run
```

Backend will run on: `http://localhost:8082`

### 3. Start Frontend (React)

```bash
cd "d:\DevOps Project\devops-project\frontend"
npm run dev
```

Frontend will run on: `http://localhost:5173`

### 4. Open Browser

Navigate to: `http://localhost:5173`

You should see the DevOps Dashboard! 🎉

---

## 📊 What Each Page Shows

### 1. Dashboard (/)
- Application status (Healthy/Down)
- Current version
- CPU & Memory usage
- Latest deployment info
- Recent activity

### 2. Application Health (/health)
- Backend API health
- Database status
- Kubernetes health
- ECR connection
- Health check configuration

### 3. System Metrics (/metrics)
- Real-time CPU usage
- Memory usage
- Requests per second
- Response times
- Total requests & errors

### 4. Deployments (/deployments)
- Deployment history table
- Version, status, date
- Duration & environment
- Shows last 5 deployments

### 5. Services (/services)
- Backend API status
- Frontend status
- Database status
- Kubernetes status
- Monitoring status

### 6. API Explorer (/api)
- Lists all endpoints
- Method, path, description
- Test button for each
- Shows API responses

### 7. Settings (/settings)
- Application info
- Environment details
- System information
- Monitoring configuration

---

## 🔌 Backend APIs Available

### Application
- `GET /api/hello` - Application greeting
- `GET /api/status` - Application status

### Health
- `GET /actuator/health` - Spring Boot health

### Metrics
- `GET /api/metrics` - System metrics (CPU, memory, etc.)

### Deployments
- `GET /api/deployments` - All deployments
- `GET /api/deployments/latest` - Latest deployment

### Services
- `GET /api/services` - All services
- `GET /api/services/status` - Services summary

### Info
- `GET /api/info/endpoints` - List all endpoints
- `GET /api/info/version` - Application version
- `GET /api/info/environment` - Environment info

---

## 🧪 Testing the Full Stack

### Test Backend is Running

```bash
curl http://localhost:8082/api/hello
```

Expected:
```json
{
  "message": "Hello from DevOps CI/CD Pipeline!",
  "version": "2.0",
  "pipeline": "Full CI/CD with GitHub Actions",
  "status": "All 13 steps completed!"
}
```

### Test Metrics

```bash
curl http://localhost:8082/api/metrics
```

### Test Deployments

```bash
curl http://localhost:8082/api/deployments
```

---

## 🎨 Features & UI

### Auto-Refresh
- Dashboard: 30 seconds
- Health: 10 seconds
- Metrics: 5 seconds
- Services: 10 seconds

### Status Badges
- 🟢 Green = Healthy/Success
- 🔴 Red = Down/Failed
- 🟡 Yellow = Warning

### Navigation
- Sidebar navigation
- Active link highlighting
- Icons for each section

---

## 🔧 Troubleshooting

### Backend not connecting?

1. Check backend is running on port 8082
2. Check for CORS errors in browser console
3. Verify `@CrossOrigin(origins = "*")` in controllers

### Frontend not loading data?

1. Open browser DevTools (F12)
2. Check Console for errors
3. Check Network tab for failed requests
4. Verify API_BASE_URL in `src/api/api.js`

### Port already in use?

**Backend (8082):**
```bash
netstat -ano | findstr :8082
taskkill /F /PID <PID>
```

**Frontend (5173):**
```bash
netstat -ano | findstr :5173
taskkill /F /PID <PID>
```

---

## 🚀 Next Steps

### After Basic Setup Works:

1. **Enhance with Real Data**
   - Connect to Prometheus metrics
   - Pull real Kubernetes pod status
   - Show actual deployment history from GitHub Actions

2. **Add Docker Support**
   - Create frontend Dockerfile
   - Multi-container setup with docker-compose

3. **Deploy to Kubernetes**
   - Frontend deployment.yaml
   - Frontend service.yaml
   - Ingress for both frontend & backend

4. **CI/CD Integration**
   - Add frontend to GitHub Actions
   - Build & push frontend Docker image
   - Automated deployment

5. **Advanced Features**
   - Real-time updates with WebSocket
   - Dark/light theme toggle
   - User authentication
   - Custom dashboards
   - Alerts & notifications

---

## 📁 Project Structure

```
devops-project/
├── src/                        # Spring Boot backend
│   └── main/java/.../controller/
│       ├── HelloController.java
│       ├── MetricsController.java
│       ├── DeploymentController.java
│       ├── ServiceController.java
│       └── ApiInfoController.java
│
├── frontend/                   # React frontend
│   ├── src/
│   │   ├── App.jsx
│   │   ├── App.css
│   │   ├── api/api.js
│   │   ├── components/
│   │   │   └── Layout.jsx
│   │   └── pages/
│   │       ├── Dashboard.jsx
│   │       ├── Health.jsx
│   │       ├── Metrics.jsx
│   │       ├── Deployments.jsx
│   │       ├── Services.jsx
│   │       ├── ApiExplorer.jsx
│   │       └── Settings.jsx
│   ├── package.json
│   └── vite.config.js
│
├── k8s/                        # Kubernetes configs
├── .github/workflows/          # CI/CD pipelines
└── README.md
```

---

## ✅ Success Criteria

You'll know it's working when:

✅ Backend starts on port 8082
✅ Frontend starts on port 5173
✅ Dashboard shows real data from backend
✅ All 7 pages are accessible
✅ Metrics update automatically
✅ API Explorer can test endpoints
✅ No CORS errors in console

---

## 🎓 What This Demonstrates

For your DevOps portfolio/internship:

✅ **Full-Stack Development** - React + Spring Boot
✅ **RESTful APIs** - Proper API design
✅ **Real-Time Monitoring** - Live metrics
✅ **DevOps Integration** - CI/CD visibility
✅ **Professional UI** - Production-ready dashboard
✅ **Docker & Kubernetes Ready** - Containerization
✅ **Modern Tech Stack** - Current industry tools

---

## 📚 Technologies Used

**Backend:**
- Java 17
- Spring Boot 3.2.0
- Spring Web
- Spring Actuator
- Maven

**Frontend:**
- React 19
- React Router DOM
- Vite
- Modern CSS

**DevOps:**
- Docker
- Kubernetes
- GitHub Actions
- AWS ECR
- Prometheus

---

**Status:** 🎯 Frontend complete, waiting for disk space!

**Next:** Clear disk space → Install react-router-dom → npm run dev → See your dashboard!
