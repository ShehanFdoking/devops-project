# Kubernetes Setup Guide

## 🎯 What is Kubernetes?

Kubernetes (K8s) is an open-source container orchestration platform that:
- ✅ Automates deployment, scaling, and management of containerized applications
- ✅ Provides self-healing (restarts failed containers)
- ✅ Load balances traffic across multiple containers
- ✅ Enables zero-downtime deployments
- ✅ Manages secrets and configuration
- ✅ Auto-scales based on CPU/memory usage

---

## 🚀 Option 1: Local Kubernetes with Docker Desktop (Recommended for Windows)

### Prerequisites
- Docker Desktop installed
- At least 4 GB RAM allocated to Docker

### Step 1: Enable Kubernetes in Docker Desktop

1. Open **Docker Desktop**
2. Click **Settings** (gear icon)
3. Go to **Kubernetes** tab
4. Check **"Enable Kubernetes"** ✅
5. Click **"Apply & Restart"**
6. Wait 2-5 minutes for Kubernetes to start

### Step 2: Verify Kubernetes is Running

```powershell
# Check kubectl is installed
kubectl version --client

# Check cluster info
kubectl cluster-info

# Check nodes
kubectl get nodes
```

Expected output:
```
NAME             STATUS   ROLES           AGE   VERSION
docker-desktop   Ready    control-plane   5d    v1.28.2
```

### Step 3: Deploy Your Application

```powershell
# Navigate to project directory
cd "D:\DevOps Project\devops-project"

# Apply Kubernetes manifests
kubectl apply -f k8s/deployment.yaml

# Check deployment status
kubectl get deployments
kubectl get pods
kubectl get services
```

### Step 4: Access Your Application

```powershell
# Get service URL (LoadBalancer)
kubectl get service devops-springboot-app-service

# If using Docker Desktop, access via:
# http://localhost:80 (or the port shown in EXTERNAL-IP)

# Or use port-forward
kubectl port-forward service/devops-springboot-app-service 8080:80

# Then access: http://localhost:8080/api/hello
```

---

## 🚀 Option 2: Minikube (Alternative Local Kubernetes)

### Step 1: Install Minikube

**Windows (PowerShell as Admin):**
```powershell
# Via Chocolatey
choco install minikube -y

# Or download installer from:
# https://minikube.sigs.k8s.io/docs/start/
```

### Step 2: Start Minikube

```powershell
# Start with Docker driver
minikube start --driver=docker

# Verify
minikube status
kubectl get nodes
```

### Step 3: Load Docker Image into Minikube

```powershell
# Point Docker to Minikube's Docker daemon
minikube docker-env | Invoke-Expression

# Rebuild image in Minikube's Docker
docker build -t devops-springboot-app:1.0 .

# Or load existing image
minikube image load devops-springboot-app:1.0
```

### Step 4: Deploy Application

```powershell
# Apply manifests
kubectl apply -f k8s/deployment.yaml

# Expose service
minikube service devops-springboot-app-service

# This will open browser automatically with your app
```

---

## 🚀 Option 3: Kind (Kubernetes in Docker)

### Step 1: Install Kind

```powershell
# Via Chocolatey
choco install kind -y

# Or download from:
# https://kind.sigs.k8s.io/docs/user/quick-start/#installation
```

### Step 2: Create Cluster

```powershell
# Create cluster
kind create cluster --name devops-cluster

# Verify
kubectl cluster-info --context kind-devops-cluster
kubectl get nodes
```

### Step 3: Load Image

```powershell
# Load local Docker image into Kind
kind load docker-image devops-springboot-app:1.0 --name devops-cluster
```

### Step 4: Deploy

```powershell
kubectl apply -f k8s/deployment.yaml

# Port forward to access
kubectl port-forward service/devops-springboot-app-service 8080:80
```

---

## 📋 Understanding the Kubernetes Manifests

### 1. Deployment (`k8s/deployment.yaml`)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devops-springboot-app
spec:
  replicas: 3  # Run 3 instances
  selector:
    matchLabels:
      app: devops-springboot-app
  template:
    spec:
      containers:
      - name: devops-springboot-app
        image: devops-springboot-app:1.0
        ports:
        - containerPort: 8082
```

**What it does:**
- Creates 3 replicas (pods) of your application
- Manages rolling updates
- Ensures desired state (self-healing)
- Defines resource limits (CPU, memory)
- Configures health checks (liveness, readiness probes)

### 2. Service (`k8s/deployment.yaml`)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: devops-springboot-app-service
spec:
  type: LoadBalancer
  selector:
    app: devops-springboot-app
  ports:
  - port: 80
    targetPort: 8082
```

**What it does:**
- Exposes your application to the network
- Load balances traffic across 3 pods
- Provides stable endpoint (DNS name)
- Type: LoadBalancer = external access

### 3. ConfigMap (`k8s/configmap.yaml`)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: devops-springboot-app-config
data:
  application.properties: |
    server.port=8082
```

**What it does:**
- Stores configuration separately from code
- Can be updated without rebuilding image
- Mounted as files or environment variables

### 4. HorizontalPodAutoscaler (`k8s/hpa.yaml`)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        averageUtilization: 70
```

**What it does:**
- Automatically scales pods based on CPU/memory
- Scales from 2 to 10 pods
- Triggers when CPU > 70%

### 5. Ingress (`k8s/ingress.yaml`)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: devops-springboot-app-ingress
spec:
  rules:
  - host: devops-app.local
```

**What it does:**
- HTTP(S) routing to services
- SSL/TLS termination
- Virtual hosting (multiple domains)

---

## 🧪 Common Kubernetes Commands

### View Resources

```bash
# List all pods
kubectl get pods

# List all services
kubectl get services

# List all deployments
kubectl get deployments

# View all resources
kubectl get all

# Describe a pod (detailed info)
kubectl describe pod <pod-name>
```

### Logs and Debugging

```bash
# View pod logs
kubectl logs <pod-name>

# Follow logs (like tail -f)
kubectl logs -f <pod-name>

# View logs from all pods with label
kubectl logs -l app=devops-springboot-app

# Execute command in pod
kubectl exec -it <pod-name> -- /bin/sh
```

### Scaling

```bash
# Scale deployment manually
kubectl scale deployment devops-springboot-app --replicas=5

# Autoscale
kubectl autoscale deployment devops-springboot-app --min=2 --max=10 --cpu-percent=70
```

### Updates and Rollbacks

```bash
# Update image
kubectl set image deployment/devops-springboot-app devops-springboot-app=devops-springboot-app:2.0

# Check rollout status
kubectl rollout status deployment/devops-springboot-app

# View rollout history
kubectl rollout history deployment/devops-springboot-app

# Rollback to previous version
kubectl rollout undo deployment/devops-springboot-app

# Rollback to specific revision
kubectl rollout undo deployment/devops-springboot-app --to-revision=2
```

### Cleanup

```bash
# Delete resources
kubectl delete -f k8s/deployment.yaml

# Delete by resource name
kubectl delete deployment devops-springboot-app
kubectl delete service devops-springboot-app-service

# Delete all resources with label
kubectl delete all -l app=devops-springboot-app
```

---

## 🔍 Troubleshooting

### Pod not starting

```bash
# Check pod status
kubectl get pods

# View pod events
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>
```

**Common issues:**
- Image pull errors: Check image name and registry
- CrashLoopBackOff: Application is crashing, check logs
- Pending: Insufficient resources, check resource requests

### Service not accessible

```bash
# Check service
kubectl get service devops-springboot-app-service

# Check endpoints
kubectl get endpoints devops-springboot-app-service

# Port forward to test
kubectl port-forward service/devops-springboot-app-service 8080:80
```

### Image pull errors

```bash
# For local images, set imagePullPolicy
imagePullPolicy: IfNotPresent  # or Never
```

---

## 📊 Monitoring Your Application

### Resource Usage

```bash
# View resource usage (requires metrics-server)
kubectl top nodes
kubectl top pods
```

### Health Checks

Your deployment includes:

**Liveness Probe**: Restarts pod if application is unhealthy
```yaml
livenessProbe:
  httpGet:
    path: /actuator/health
    port: 8082
  initialDelaySeconds: 30
  periodSeconds: 10
```

**Readiness Probe**: Removes pod from service if not ready
```yaml
readinessProbe:
  httpGet:
    path: /actuator/health
    port: 8082
  initialDelaySeconds: 20
  periodSeconds: 5
```

---

## 🎨 Advanced Features

### Rolling Updates

```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
```

### Resource Limits

```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

### Environment Variables

```yaml
env:
- name: SPRING_PROFILES_ACTIVE
  value: "production"
- name: DATABASE_URL
  valueFrom:
    secretKeyRef:
      name: db-secret
      key: url
```

---

## 🔗 Useful Links

- **Kubernetes Documentation**: https://kubernetes.io/docs/
- **kubectl Cheat Sheet**: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- **Docker Desktop Kubernetes**: https://docs.docker.com/desktop/kubernetes/
- **Minikube**: https://minikube.sigs.k8s.io/docs/
- **Kind**: https://kind.sigs.k8s.io/

---

## ✅ Verification Checklist

Before moving to AWS EKS:

- [ ] Kubernetes cluster running locally
- [ ] Application deployed successfully
- [ ] Pods are in Running state
- [ ] Service is accessible
- [ ] Health checks are passing
- [ ] Can view logs
- [ ] Can scale deployment
- [ ] Understand K8s concepts (Pods, Deployments, Services)

---

**Status:** Ready for local Kubernetes deployment!

**Next Step:** Deploy to AWS EKS (managed Kubernetes in production)
