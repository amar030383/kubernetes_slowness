#!/bin/bash

# Kubernetes Configuration Validation Script

echo "🔍 Validating Kubernetes configuration..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed or not in PATH"
    exit 1
fi

echo "✅ kubectl is available"

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed or not in PATH"
    exit 1
fi

echo "✅ Docker is available"

# Validate the YAML file
echo "📋 Validating k8s-deployment.yaml..."
kubectl apply -f k8s-deployment.yaml --dry-run=client

if [ $? -eq 0 ]; then
    echo "✅ Kubernetes configuration is valid"
else
    echo "❌ Kubernetes configuration has errors"
    exit 1
fi

# Check cluster connectivity
echo "🌐 Checking cluster connectivity..."
if kubectl cluster-info &> /dev/null; then
    echo "✅ Connected to Kubernetes cluster"
    kubectl cluster-info | head -1
else
    echo "❌ Cannot connect to Kubernetes cluster"
    echo "   Please ensure your cluster is running and kubectl is configured"
    exit 1
fi

echo "🎉 All validations passed! Ready to deploy." 