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

echo 📤 Loading image into minikube...
minikube image load %IMAGE_NAME%:%IMAGE_TAG%

if %ERRORLEVEL% neq 0 (
    echo ❌ Failed to load image into minikube
    exit /b 1
)

echo ✅ Image loaded into minikube successfully

echo 🔧 Creating namespace...
minikube kubectl -- create namespace %NAMESPACE% --dry-run=client -o yaml | minikube kubectl -- apply -f -

echo 📋 Applying Kubernetes manifests...
minikube kubectl -- apply -f k8s-deployment-simple.yaml

echo ⏳ Waiting for deployment to be ready...
minikube kubectl -- rollout status deployment/employee-details -n %NAMESPACE%

echo 🔍 Checking deployment status...
minikube kubectl -- get pods -n %NAMESPACE%
minikube kubectl -- get services -n %NAMESPACE%

echo ✅ Deployment completed successfully!
echo 📋 Access Information:
for /f "tokens=*" %%i in ('minikube ip') do set MINIKUBE_IP=%%i
echo    Dashboard: http://%MINIKUBE_IP%:30080/dashboard/
echo    API: http://%MINIKUBE_IP%:30080/api/users/
echo    Welcome: http://%MINIKUBE_IP%:30080/

echo 🔧 To check logs:
echo    minikube kubectl -- logs -f deployment/employee-details -n %NAMESPACE%

echo 🔧 To delete deployment:
echo    minikube kubectl -- delete -f k8s-deployment-simple.yaml

pause 