@echo off
setlocal enabledelayedexpansion

echo 🔍 Validating Kubernetes configuration...

REM Check if kubectl is available
kubectl version --client >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ kubectl is not installed or not in PATH
    exit /b 1
)

echo ✅ kubectl is available

REM Check if Docker is available
docker version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ Docker is not installed or not in PATH
    exit /b 1
)

echo ✅ Docker is available

REM Validate the YAML file
echo 📋 Validating k8s-deployment.yaml...
kubectl apply -f k8s-deployment.yaml --dry-run=client

if %ERRORLEVEL% neq 0 (
    echo ❌ Kubernetes configuration has errors
    exit /b 1
)

echo ✅ Kubernetes configuration is valid

REM Check cluster connectivity
echo 🌐 Checking cluster connectivity...
kubectl cluster-info >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ Cannot connect to Kubernetes cluster
    echo    Please ensure your cluster is running and kubectl is configured
    exit /b 1
)

echo ✅ Connected to Kubernetes cluster
kubectl cluster-info | findstr "Kubernetes control plane"

echo 🎉 All validations passed! Ready to deploy.
pause 