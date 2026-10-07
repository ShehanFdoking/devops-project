#!/bin/bash
# Bash Script to Push Docker Image to AWS ECR
# Usage: ./scripts/push-to-ecr.sh [version] [region] [repository]

set -e

# Default values
VERSION="${1:-latest}"
REGION="${2:-us-east-1}"
REPOSITORY="${3:-devops-springboot-app}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}======================================${NC}"
echo -e "${CYAN}  AWS ECR Push Script${NC}"
echo -e "${CYAN}======================================${NC}"
echo ""

# Check AWS CLI
echo -e "${YELLOW}Checking AWS CLI installation...${NC}"
if ! command -v aws &> /dev/null; then
    echo -e "${RED}ERROR: AWS CLI is not installed!${NC}"
    echo -e "${YELLOW}Install from: https://aws.amazon.com/cli/${NC}"
    exit 1
fi
AWS_VERSION=$(aws --version)
echo -e "${GREEN}✓ AWS CLI found: $AWS_VERSION${NC}"
echo ""

# Check Docker
echo -e "${YELLOW}Checking Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}ERROR: Docker is not installed!${NC}"
    exit 1
fi
if ! docker info &> /dev/null; then
    echo -e "${RED}ERROR: Docker is not running!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker is running${NC}"
echo ""

# Get AWS Account ID
echo -e "${YELLOW}Getting AWS Account ID...${NC}"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Cannot get AWS Account ID!${NC}"
    echo -e "${YELLOW}Make sure you've run: aws configure${NC}"
    exit 1
fi
echo -e "${GREEN}✓ AWS Account ID: $ACCOUNT_ID${NC}"
echo ""

# Construct ECR URI
ECR_URI="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"
FULL_IMAGE_NAME="$ECR_URI/$REPOSITORY"

echo -e "${CYAN}ECR Configuration:${NC}"
echo "  Region: $REGION"
echo "  Repository: $REPOSITORY"
echo "  Full URI: $FULL_IMAGE_NAME"
echo ""

# Check if repository exists
echo -e "${YELLOW}Checking if ECR repository exists...${NC}"
if ! aws ecr describe-repositories --repository-names $REPOSITORY --region $REGION &> /dev/null; then
    echo -e "${YELLOW}⚠ Repository does not exist. Creating...${NC}"
    aws ecr create-repository \
        --repository-name $REPOSITORY \
        --region $REGION \
        --image-scanning-configuration scanOnPush=true \
        --encryption-configuration encryptionType=AES256
    echo -e "${GREEN}✓ Repository created successfully${NC}"
else
    echo -e "${GREEN}✓ Repository exists${NC}"
fi
echo ""

# Login to ECR
echo -e "${YELLOW}Logging in to Amazon ECR...${NC}"
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URI
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to login to ECR!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Successfully logged in to ECR${NC}"
echo ""

# Build Docker image
echo -e "${YELLOW}Building Docker image...${NC}"
docker build -t devops-springboot-app:$VERSION .
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to build Docker image!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker image built successfully${NC}"
echo ""

# Tag image for ECR
echo -e "${YELLOW}Tagging image for ECR...${NC}"
docker tag devops-springboot-app:$VERSION $FULL_IMAGE_NAME:$VERSION
docker tag devops-springboot-app:$VERSION $FULL_IMAGE_NAME:latest
echo -e "${GREEN}✓ Image tagged: $FULL_IMAGE_NAME:$VERSION${NC}"
echo -e "${GREEN}✓ Image tagged: $FULL_IMAGE_NAME:latest${NC}"
echo ""

# Push to ECR
echo -e "${YELLOW}Pushing image to ECR...${NC}"
echo "This may take a few minutes..."
docker push $FULL_IMAGE_NAME:$VERSION
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to push image!${NC}"
    exit 1
fi
docker push $FULL_IMAGE_NAME:latest
echo -e "${GREEN}✓ Image pushed successfully!${NC}"
echo ""

# Initiate vulnerability scan
echo -e "${YELLOW}Initiating vulnerability scan...${NC}"
aws ecr start-image-scan \
    --repository-name $REPOSITORY \
    --image-id imageTag=$VERSION \
    --region $REGION &> /dev/null || true
echo -e "${GREEN}✓ Vulnerability scan initiated${NC}"
echo ""

# Summary
echo -e "${CYAN}======================================${NC}"
echo -e "${GREEN}  Success! Image pushed to ECR${NC}"
echo -e "${CYAN}======================================${NC}"
echo ""
echo -e "${CYAN}Image URI:${NC}"
echo "  $FULL_IMAGE_NAME:$VERSION"
echo "  $FULL_IMAGE_NAME:latest"
echo ""
echo -e "${CYAN}View in AWS Console:${NC}"
echo -e "  ${CYAN}https://console.aws.amazon.com/ecr/repositories/$REPOSITORY${NC}"
echo ""
echo -e "${CYAN}Pull image:${NC}"
echo "  docker pull $FULL_IMAGE_NAME:$VERSION"
echo ""
echo -e "${CYAN}Next Steps:${NC}"
echo "  1. View scan results in AWS ECR Console"
echo "  2. Deploy to Kubernetes using this image"
echo "  3. Set up lifecycle policies to manage old images"
echo ""
