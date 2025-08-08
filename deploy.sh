#!/bin/bash

# Kubernetes Deployment Script for Employee Details Django Application
# This script deploys the Django application to Kubernetes

set -e  # Exit on any error

echo "🚀 Starting Kubernetes deployment for Employee Details Django Application..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed or not in PATH"
    exit 1
fi

# Check if we can connect to Kubernetes cluster
if ! kubectl cluster-info &> /dev/null; then
    print_error "Cannot connect to Kubernetes cluster"
    exit 1
fi

print_status "Connected to Kubernetes cluster: $(kubectl config current-context)"

# Apply the Kubernetes manifests
print_status "Applying Kubernetes manifests..."
kubectl apply -f k8s-deployment.yaml

print_success "Kubernetes manifests applied successfully!"

# Wait for namespace to be created
print_status "Waiting for namespace to be ready..."
kubectl wait --for=condition=Active namespace/employee-details --timeout=30s

# Wait for deployment to be ready
print_status "Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/employee-details-django -n employee-details

print_success "Deployment is ready!"

# Get deployment status
print_status "Deployment Status:"
kubectl get deployment employee-details-django -n employee-details

# Get pod status
print_status "Pod Status:"
kubectl get pods -n employee-details -l app=employee-details-django

# Get service status
print_status "Service Status:"
kubectl get services -n employee-details

# Get ingress status
print_status "Ingress Status:"
kubectl get ingress -n employee-details

# Display access information
echo ""
print_success "🎉 Deployment completed successfully!"
echo ""
print_status "Access Information:"
echo "  • ClusterIP Service: employee-details-service.employee-details.svc.cluster.local:80"
echo "  • NodePort Service: <node-ip>:30080"
echo "  • Ingress: http://employee-details.local (if ingress controller is configured)"
echo ""
print_status "To check logs:"
echo "  kubectl logs -f deployment/employee-details-django -n employee-details"
echo ""
print_status "To access the application:"
echo "  kubectl port-forward service/employee-details-service 8080:80 -n employee-details"
echo "  Then visit: http://localhost:8080"
echo ""
print_status "To delete the deployment:"
echo "  kubectl delete -f k8s-deployment.yaml"
