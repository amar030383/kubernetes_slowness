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

echo -e "${BLUE}📤 Loading image into minikube...${NC}"
minikube image load ${IMAGE_NAME}:${IMAGE_TAG}

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Image loaded into minikube successfully${NC}"
else
    echo -e "${RED}❌ Failed to load image into minikube${NC}"
    exit 1
fi

echo -e "${BLUE}🔧 Creating namespace...${NC}"
minikube kubectl -- create namespace ${NAMESPACE} --dry-run=client -o yaml | minikube kubectl -- apply -f -

echo -e "${BLUE}📋 Applying Kubernetes manifests...${NC}"
minikube kubectl -- apply -f k8s-deployment-simple.yaml

echo -e "${BLUE}⏳ Waiting for deployment to be ready...${NC}"
minikube kubectl -- rollout status deployment/employee-details -n ${NAMESPACE}

echo -e "${BLUE}🔍 Checking deployment status...${NC}"
minikube kubectl -- get pods -n ${NAMESPACE}
minikube kubectl -- get services -n ${NAMESPACE}

# Get minikube IP
MINIKUBE_IP=$(minikube ip)
echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
echo -e "${YELLOW}📋 Access Information:${NC}"
echo -e "   Dashboard: http://${MINIKUBE_IP}:30080/dashboard/"
echo -e "   API: http://${MINIKUBE_IP}:30080/api/users/"
echo -e "   Welcome: http://${MINIKUBE_IP}:30080/"

echo -e "${BLUE}🔧 To check logs:${NC}"
echo -e "   minikube kubectl -- logs -f deployment/employee-details -n ${NAMESPACE}"

echo -e "${BLUE}🔧 To delete deployment:${NC}"
echo -e "   minikube kubectl -- delete -f k8s-deployment-simple.yaml" 