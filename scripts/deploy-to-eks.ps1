# PowerShell Script to Deploy Application to AWS EKS
# Usage: .\scripts\deploy-to-eks.ps1 -ClusterName "devops-cluster" -Region "eu-north-1"

param(
    [Parameter(Mandatory=$false)]
    [string]$ClusterName = "devops-cluster",
    
    [Parameter(Mandatory=$false)]
    [string]$Region = "eu-north-1",
    
    [Parameter(Mandatory=$false)]
    [string]$Namespace = "default"
)

$ErrorActionPreference = "Stop"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  AWS EKS Deployment Script" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check kubectl
Write-Host "Checking kubectl..." -ForegroundColor Yellow
try {
    $kubectlVersion = kubectl version --client --short 2>&1
    Write-Host "✓ kubectl found: $kubectlVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: kubectl not found!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Check AWS CLI
Write-Host "Checking AWS CLI..." -ForegroundColor Yellow
try {
    $awsVersion = aws --version 2>&1
    Write-Host "✓ AWS CLI found" -ForegroundColor Green
} catch {
    Write-Host "ERROR: AWS CLI not found!" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Check cluster exists
Write-Host "Checking if cluster exists..." -ForegroundColor Yellow
try {
    $clusterInfo = aws eks describe-cluster --name $ClusterName --region $Region --query 'cluster.status' --output text 2>&1
    if ($clusterInfo -eq "ACTIVE") {
        Write-Host "✓ Cluster $ClusterName is ACTIVE" -ForegroundColor Green
    } else {
        Write-Host "ERROR: Cluster $ClusterName is not active (Status: $clusterInfo)" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERROR: Cluster $ClusterName not found in region $Region" -ForegroundColor Red
    Write-Host "Create cluster first: eksctl create cluster -f k8s/eks/cluster-config.yaml" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Update kubeconfig
Write-Host "Updating kubeconfig..." -ForegroundColor Yellow
aws eks update-kubeconfig --name $ClusterName --region $Region
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to update kubeconfig" -ForegroundColor Red
    exit 1
}
Write-Host "✓ kubeconfig updated" -ForegroundColor Green
Write-Host ""

# Verify connection
Write-Host "Verifying cluster connection..." -ForegroundColor Yellow
$nodes = kubectl get nodes --no-headers 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Cannot connect to cluster" -ForegroundColor Red
    exit 1
}
$nodeCount = ($nodes | Measure-Object).Count
Write-Host "✓ Connected to cluster with $nodeCount nodes" -ForegroundColor Green
Write-Host ""

# Check if namespace exists
Write-Host "Checking namespace..." -ForegroundColor Yellow
kubectl get namespace $Namespace 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Creating namespace $Namespace..." -ForegroundColor Yellow
    kubectl create namespace $Namespace
}
Write-Host "✓ Namespace $Namespace ready" -ForegroundColor Green
Write-Host ""

# Deploy application
Write-Host "Deploying application to EKS..." -ForegroundColor Yellow
kubectl apply -f k8s/eks/deployment.yaml -n $Namespace
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Deployment failed" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Application deployed" -ForegroundColor Green
Write-Host ""

# Wait for pods to be ready
Write-Host "Waiting for pods to be ready..." -ForegroundColor Yellow
$timeout = 300  # 5 minutes
$elapsed = 0
$interval = 10

while ($elapsed -lt $timeout) {
    $readyPods = kubectl get pods -n $Namespace -l app=devops-springboot-app -o jsonpath='{.items[*].status.conditions[?(@.type=="Ready")].status}' 2>&1
    $totalReady = ($readyPods -split ' ' | Where-Object { $_ -eq 'True' }).Count
    $totalPods = kubectl get pods -n $Namespace -l app=devops-springboot-app --no-headers 2>&1 | Measure-Object | Select-Object -ExpandProperty Count
    
    Write-Host "  Ready: $totalReady/$totalPods pods" -ForegroundColor Gray
    
    if ($totalReady -eq $totalPods -and $totalPods -gt 0) {
        Write-Host "✓ All pods are ready!" -ForegroundColor Green
        break
    }
    
    Start-Sleep -Seconds $interval
    $elapsed += $interval
}

if ($elapsed -ge $timeout) {
    Write-Host "WARNING: Pods did not become ready within timeout" -ForegroundColor Yellow
    Write-Host "Check pod status: kubectl get pods -n $Namespace" -ForegroundColor Yellow
}
Write-Host ""

# Get LoadBalancer URL
Write-Host "Getting LoadBalancer URL..." -ForegroundColor Yellow
$maxWait = 180  # 3 minutes
$waited = 0

while ($waited -lt $maxWait) {
    $lbHostname = kubectl get service devops-springboot-app-service -n $Namespace -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>&1
    
    if ($lbHostname -and $lbHostname -ne "") {
        Write-Host "✓ LoadBalancer provisioned" -ForegroundColor Green
        break
    }
    
    Write-Host "  Waiting for LoadBalancer..." -ForegroundColor Gray
    Start-Sleep -Seconds 10
    $waited += 10
}

if (-not $lbHostname -or $lbHostname -eq "") {
    Write-Host "WARNING: LoadBalancer URL not available yet" -ForegroundColor Yellow
    Write-Host "Check later: kubectl get service devops-springboot-app-service -n $Namespace" -ForegroundColor Yellow
    $lbHostname = "<pending>"
}
Write-Host ""

# Summary
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Deployment Complete!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Cluster: $ClusterName" -ForegroundColor White
Write-Host "Region: $Region" -ForegroundColor White
Write-Host "Namespace: $Namespace" -ForegroundColor White
Write-Host ""
Write-Host "Application URL:" -ForegroundColor Cyan
Write-Host "  http://$lbHostname/api/hello" -ForegroundColor White
Write-Host "  http://$lbHostname/actuator/health" -ForegroundColor White
Write-Host ""
Write-Host "Useful Commands:" -ForegroundColor Cyan
Write-Host "  View pods:    kubectl get pods -n $Namespace" -ForegroundColor Gray
Write-Host "  View logs:    kubectl logs -l app=devops-springboot-app -n $Namespace --tail=50" -ForegroundColor Gray
Write-Host "  View service: kubectl get service devops-springboot-app-service -n $Namespace" -ForegroundColor Gray
Write-Host "  Scale:        kubectl scale deployment devops-springboot-app --replicas=5 -n $Namespace" -ForegroundColor Gray
Write-Host ""
Write-Host "AWS Console:" -ForegroundColor Cyan
Write-Host "  https://console.aws.amazon.com/eks/home?region=$Region#/clusters/$ClusterName" -ForegroundColor Blue
Write-Host ""
