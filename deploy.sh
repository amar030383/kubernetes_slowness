#!/bin/bash

# Employee Details Kubernetes Deployment Script
# This script builds the Docker image and deploys to Kubernetes

set -e

echo "🚀 Starting Employee Details Kubernetes Deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
IMAGE_NAME="employee-details"
IMAGE_TAG="latest"
NAMESPACE="employee-details"

echo -e "${BLUE}📦 Building Docker image...${NC}"
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Docker image built successfully${NC}"
else
    echo -e "${RED}❌ Docker build failed${NC}"
    exit 1
fi

echo -e "${BLUE}🔧 Creating namespace...${NC}"
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

echo -e "${BLUE}📋 Applying Kubernetes manifests...${NC}"
kubectl apply -f k8s-deployment-simple.yaml

echo -e "${BLUE}⏳ Waiting for deployment to be ready...${NC}"
kubectl rollout status deployment/employee-details -n ${NAMESPACE}

echo -e "${BLUE}🔍 Checking deployment status...${NC}"
kubectl get pods -n ${NAMESPACE}
kubectl get services -n ${NAMESPACE}

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
echo -e "${YELLOW}📋 Access Information:${NC}"
echo -e "   Dashboard: http://localhost:30080/dashboard/"
echo -e "   API: http://localhost:30080/api/users/"
echo -e "   Welcome: http://localhost:30080/"

echo -e "${BLUE}🔧 To check logs:${NC}"
echo -e "   kubectl logs -f deployment/employee-details -n ${NAMESPACE}"

echo -e "${BLUE}🔧 To delete deployment:${NC}"
echo -e "   kubectl delete -f k8s-deployment-simple.yaml" 