# PowerShell Script to Push Docker Image to AWS ECR
# Usage: .\scripts\push-to-ecr.ps1 -Version "1.0" -Region "us-east-1"

param(
    [Parameter(Mandatory=$false)]
    [string]$Version = "latest",
    
    [Parameter(Mandatory=$false)]
    [string]$Region = "us-east-1",
    
    [Parameter(Mandatory=$false)]
    [string]$Repository = "devops-springboot-app"
)

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  AWS ECR Push Script" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check if AWS CLI is installed
Write-Host "Checking AWS CLI installation..." -ForegroundColor Yellow
$awsVersion = aws --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: AWS CLI is not installed!" -ForegroundColor Red
    Write-Host "Install from: https://aws.amazon.com/cli/" -ForegroundColor Yellow
    exit 1
}
Write-Host "✓ AWS CLI found: $awsVersion" -ForegroundColor Green
Write-Host ""

# Check if Docker is running
Write-Host "Checking Docker..." -ForegroundColor Yellow
$dockerVersion = docker version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop" -ForegroundColor Yellow
    exit 1
}
Write-Host "✓ Docker is running" -ForegroundColor Green
Write-Host ""

# Get AWS Account ID
Write-Host "Getting AWS Account ID..." -ForegroundColor Yellow
$accountId = aws sts get-caller-identity --query Account --output text 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Cannot get AWS Account ID!" -ForegroundColor Red
    Write-Host "Make sure you've run: aws configure" -ForegroundColor Yellow
    exit 1
}
Write-Host "✓ AWS Account ID: $accountId" -ForegroundColor Green
Write-Host ""

# Construct ECR URI
$ecrUri = "$accountId.dkr.ecr.$Region.amazonaws.com"
$fullImageName = "$ecrUri/$Repository"

Write-Host "ECR Configuration:" -ForegroundColor Cyan
Write-Host "  Region: $Region" -ForegroundColor White
Write-Host "  Repository: $Repository" -ForegroundColor White
Write-Host "  Full URI: $fullImageName" -ForegroundColor White
Write-Host ""

# Check if repository exists
Write-Host "Checking if ECR repository exists..." -ForegroundColor Yellow
$repoExists = aws ecr describe-repositories --repository-names $Repository --region $Region 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠ Repository does not exist. Creating..." -ForegroundColor Yellow
    aws ecr create-repository `
        --repository-name $Repository `
        --region $Region `
        --image-scanning-configuration scanOnPush=true `
        --encryption-configuration encryptionType=AES256
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Repository created successfully" -ForegroundColor Green
    } else {
        Write-Host "ERROR: Failed to create repository" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✓ Repository exists" -ForegroundColor Green
}
Write-Host ""

# Login to ECR
Write-Host "Logging in to Amazon ECR..." -ForegroundColor Yellow
aws ecr get-login-password --region $Region | docker login --username AWS --password-stdin $ecrUri
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to login to ECR!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Successfully logged in to ECR" -ForegroundColor Green
Write-Host ""

# Build Docker image
Write-Host "Building Docker image..." -ForegroundColor Yellow
docker build -t devops-springboot-app:$Version .
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to build Docker image!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Docker image built successfully" -ForegroundColor Green
Write-Host ""

# Tag image for ECR
Write-Host "Tagging image for ECR..." -ForegroundColor Yellow
docker tag devops-springboot-app:$Version "$fullImageName:$Version"
docker tag devops-springboot-app:$Version "$fullImageName:latest"
Write-Host "✓ Image tagged: $fullImageName:$Version" -ForegroundColor Green
Write-Host "✓ Image tagged: $fullImageName:latest" -ForegroundColor Green
Write-Host ""

# Push to ECR
Write-Host "Pushing image to ECR..." -ForegroundColor Yellow
Write-Host "This may take a few minutes..." -ForegroundColor Gray
docker push "$fullImageName:$Version"
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to push image!" -ForegroundColor Red
    exit 1
}
docker push "$fullImageName:latest"
Write-Host "✓ Image pushed successfully!" -ForegroundColor Green
Write-Host ""

# Initiate vulnerability scan
Write-Host "Initiating vulnerability scan..." -ForegroundColor Yellow
aws ecr start-image-scan `
    --repository-name $Repository `
    --image-id imageTag=$Version `
    --region $Region 2>&1 | Out-Null
Write-Host "✓ Vulnerability scan initiated" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Success! Image pushed to ECR" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Image URI:" -ForegroundColor Cyan
Write-Host "  $fullImageName:$Version" -ForegroundColor White
Write-Host "  $fullImageName:latest" -ForegroundColor White
Write-Host ""
Write-Host "View in AWS Console:" -ForegroundColor Cyan
Write-Host "  https://console.aws.amazon.com/ecr/repositories/$Repository" -ForegroundColor Blue
Write-Host ""
Write-Host "Pull image:" -ForegroundColor Cyan
Write-Host "  docker pull $fullImageName:$Version" -ForegroundColor Gray
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "  1. View scan results in AWS ECR Console" -ForegroundColor White
Write-Host "  2. Deploy to Kubernetes using this image" -ForegroundColor White
Write-Host "  3. Set up lifecycle policies to manage old images" -ForegroundColor White
Write-Host ""
