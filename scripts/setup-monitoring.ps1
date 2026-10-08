# PowerShell Script to Setup Prometheus & Grafana Monitoring
# Usage: .\scripts\setup-monitoring.ps1

$ErrorActionPreference = "Stop"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Monitoring Stack Setup" -ForegroundColor Cyan
Write-Host "  Prometheus + Grafana" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check kubectl
Write-Host "Checking kubectl..." -ForegroundColor Yellow
try {
    kubectl version --client --short 2>&1 | Out-Null
    Write-Host "✓ kubectl found" -ForegroundColor Green
} catch {
    Write-Host "ERROR: kubectl not found!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Check helm
Write-Host "Checking Helm..." -ForegroundColor Yellow
try {
    $helmVersion = helm version --short 2>&1
    Write-Host "✓ Helm found: $helmVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Helm not found!" -ForegroundColor Red
    Write-Host "Install with: choco install kubernetes-helm -y" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Check cluster connection
Write-Host "Checking Kubernetes cluster..." -ForegroundColor Yellow
try {
    $nodes = kubectl get nodes --no-headers 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Cannot connect to cluster"
    }
    Write-Host "✓ Connected to Kubernetes cluster" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Cannot connect to Kubernetes cluster" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Add Prometheus Helm repo
Write-Host "Adding Prometheus Helm repository..." -ForegroundColor Yellow
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>&1 | Out-Null
helm repo update 2>&1 | Out-Null
Write-Host "✓ Helm repository added" -ForegroundColor Green
Write-Host ""

# Create monitoring namespace
Write-Host "Creating monitoring namespace..." -ForegroundColor Yellow
kubectl create namespace monitoring 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "  Namespace already exists (OK)" -ForegroundColor Gray
} else {
    Write-Host "✓ Namespace created" -ForegroundColor Green
}
Write-Host ""

# Install Prometheus stack
Write-Host "Installing Prometheus + Grafana..." -ForegroundColor Yellow
Write-Host "This may take 2-3 minutes..." -ForegroundColor Gray
Write-Host ""

helm upgrade --install prometheus prometheus-community/kube-prometheus-stack `
    --namespace monitoring `
    --values monitoring/prometheus/values.yaml `
    --wait `
    --timeout 10m

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to install monitoring stack" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Monitoring stack installed" -ForegroundColor Green
Write-Host ""

# Wait for pods
Write-Host "Waiting for pods to be ready..." -ForegroundColor Yellow
$timeout = 300
$elapsed = 0
$interval = 10

while ($elapsed -lt $timeout) {
    $pods = kubectl get pods -n monitoring --no-headers 2>&1
    $total = ($pods | Measure-Object).Count
    $ready = ($pods | Where-Object { $_ -match "Running" } | Measure-Object).Count
    
    Write-Host "  Ready: $ready/$total pods" -ForegroundColor Gray
    
    if ($ready -eq $total -and $total -gt 0) {
        Write-Host "✓ All pods are ready!" -ForegroundColor Green
        break
    }
    
    Start-Sleep -Seconds $interval
    $elapsed += $interval
}

if ($elapsed -ge $timeout) {
    Write-Host "WARNING: Not all pods ready within timeout" -ForegroundColor Yellow
    Write-Host "Check status: kubectl get pods -n monitoring" -ForegroundColor Yellow
}
Write-Host ""

# Apply ServiceMonitor
Write-Host "Applying ServiceMonitor..." -ForegroundColor Yellow
kubectl apply -f monitoring/servicemonitor.yaml 2>&1 | Out-Null
Write-Host "✓ ServiceMonitor applied" -ForegroundColor Green
Write-Host ""

# Apply PrometheusRule (alerts)
Write-Host "Applying alert rules..." -ForegroundColor Yellow
kubectl apply -f monitoring/alerts.yaml 2>&1 | Out-Null
Write-Host "✓ Alert rules applied" -ForegroundColor Green
Write-Host ""

# Get Grafana info
Write-Host "Getting Grafana access information..." -ForegroundColor Yellow
$grafanaService = kubectl get svc -n monitoring prometheus-grafana -o jsonpath='{.spec.type}' 2>&1

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Monitoring Stack Ready!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Grafana Access:" -ForegroundColor Cyan
Write-Host "  URL: http://localhost:3000" -ForegroundColor White
Write-Host "  Username: admin" -ForegroundColor White
Write-Host "  Password: admin123" -ForegroundColor White
Write-Host ""

Write-Host "Port Forward Commands:" -ForegroundColor Cyan
Write-Host "  Grafana:" -ForegroundColor Yellow
Write-Host "    kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80" -ForegroundColor Gray
Write-Host ""
Write-Host "  Prometheus:" -ForegroundColor Yellow
Write-Host "    kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090" -ForegroundColor Gray
Write-Host ""
Write-Host "  Alertmanager:" -ForegroundColor Yellow
Write-Host "    kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-alertmanager 9093:9093" -ForegroundColor Gray
Write-Host ""

Write-Host "Useful Commands:" -ForegroundColor Cyan
Write-Host "  View pods:        kubectl get pods -n monitoring" -ForegroundColor Gray
Write-Host "  View services:    kubectl get svc -n monitoring" -ForegroundColor Gray
Write-Host "  View alerts:      kubectl get prometheusrule -n monitoring" -ForegroundColor Gray
Write-Host "  View monitors:    kubectl get servicemonitor -A" -ForegroundColor Gray
Write-Host ""

Write-Host "Pre-configured Dashboards:" -ForegroundColor Cyan
Write-Host "  - Spring Boot 2.x (ID: 12900)" -ForegroundColor White
Write-Host "  - JVM Micrometer (ID: 4701)" -ForegroundColor White
Write-Host "  - Kubernetes Cluster (ID: 7249)" -ForegroundColor White
Write-Host "  - Node Exporter (ID: 1860)" -ForegroundColor White
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Port forward Grafana (command above)" -ForegroundColor White
Write-Host "  2. Open http://localhost:3000 in browser" -ForegroundColor White
Write-Host "  3. Login with credentials above" -ForegroundColor White
Write-Host "  4. Go to Dashboards → Browse" -ForegroundColor White
Write-Host "  5. Open 'Spring Boot 2.x' dashboard" -ForegroundColor White
Write-Host "  6. Generate traffic to see metrics!" -ForegroundColor White
Write-Host ""

Write-Host "Documentation: MONITORING_GUIDE.md" -ForegroundColor Cyan
Write-Host ""
