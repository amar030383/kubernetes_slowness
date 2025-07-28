@echo off
setlocal enabledelayedexpansion

echo 🚀 Starting Employee Details Kubernetes Deployment...

REM Configuration
set IMAGE_NAME=employee-details
set IMAGE_TAG=latest
set NAMESPACE=employee-details

echo 📦 Building Docker image...
docker build -t %IMAGE_NAME%:%IMAGE_TAG% .

if %ERRORLEVEL% neq 0 (
    echo ❌ Docker build failed
    exit /b 1
)

echo ✅ Docker image built successfully

echo 🔧 Creating namespace...
kubectl create namespace %NAMESPACE% --dry-run=client -o yaml | kubectl apply -f -

echo 📋 Applying Kubernetes manifests...
kubectl apply -f k8s-deployment-simple.yaml

echo ⏳ Waiting for deployment to be ready...
kubectl rollout status deployment/employee-details -n %NAMESPACE%

echo 🔍 Checking deployment status...
kubectl get pods -n %NAMESPACE%
kubectl get services -n %NAMESPACE%

echo ✅ Deployment completed successfully!
echo 📋 Access Information:
echo    Dashboard: http://localhost:30080/dashboard/
echo    API: http://localhost:30080/api/users/
echo    Welcome: http://localhost:30080/

echo 🔧 To check logs:
echo    kubectl logs -f deployment/employee-details -n %NAMESPACE%

echo 🔧 To delete deployment:
echo    kubectl delete -f k8s-deployment-simple.yaml

pause 