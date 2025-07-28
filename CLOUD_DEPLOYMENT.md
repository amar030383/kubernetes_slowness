# Cloud Kubernetes Deployment Guide

## Overview

This guide explains how to deploy the Employee Details API to various cloud Kubernetes platforms.

## Prerequisites

1. **Cloud Account** (AWS, GCP, Azure, DigitalOcean, etc.)
2. **kubectl** configured for your cluster
3. **Docker** installed locally
4. **Container Registry** access (Docker Hub, ECR, GCR, etc.)

## Quick Deployment Options

### Option 1: Docker Compose (Local Testing)

```bash
# Build and run locally
docker-compose up --build

# Access the application
curl http://localhost:8000/api/users/
curl http://localhost:8000/dashboard/
```

### Option 2: Cloud Kubernetes Cluster

#### Step 1: Build and Push Docker Image

```bash
# Build the image
docker build -t your-registry/employee-details:latest .

# Push to registry
docker push your-registry/employee-details:latest
```

#### Step 2: Update Image in Kubernetes Config

Edit `k8s-deployment.yaml`:
```yaml
image: your-registry/employee-details:latest
```

#### Step 3: Deploy to Cluster

```bash
# Apply the deployment
kubectl apply -f k8s-deployment.yaml

# Check status
kubectl get pods -n employee-details
kubectl get services -n employee-details
```

## Cloud-Specific Instructions

### AWS EKS

1. **Create EKS Cluster**:
   ```bash
   eksctl create cluster --name employee-details --region us-west-2
   ```

2. **Update kubeconfig**:
   ```bash
   aws eks update-kubeconfig --name employee-details --region us-west-2
   ```

3. **Deploy**:
   ```bash
   kubectl apply -f k8s-deployment.yaml
   ```

### Google GKE

1. **Create GKE Cluster**:
   ```bash
   gcloud container clusters create employee-details --zone us-central1-a
   ```

2. **Get credentials**:
   ```bash
   gcloud container clusters get-credentials employee-details --zone us-central1-a
   ```

3. **Deploy**:
   ```bash
   kubectl apply -f k8s-deployment.yaml
   ```

### Azure AKS

1. **Create AKS Cluster**:
   ```bash
   az aks create --resource-group myResourceGroup --name employee-details --node-count 3
   ```

2. **Get credentials**:
   ```bash
   az aks get-credentials --resource-group myResourceGroup --name employee-details
   ```

3. **Deploy**:
   ```bash
   kubectl apply -f k8s-deployment.yaml
   ```

### DigitalOcean Kubernetes

1. **Create cluster via DO Console**
2. **Download kubeconfig**
3. **Deploy**:
   ```bash
   kubectl apply -f k8s-deployment.yaml
   ```

## Production Considerations

### 1. Container Registry

Use a proper container registry:
- **Docker Hub**: `docker.io/yourusername/employee-details`
- **AWS ECR**: `123456789012.dkr.ecr.us-west-2.amazonaws.com/employee-details`
- **Google GCR**: `gcr.io/your-project/employee-details`

### 2. Secrets Management

Replace the hardcoded secret with proper secret management:

```bash
# Create secret
kubectl create secret generic employee-details-secret \
  --from-literal=secret-key="your-production-secret-key" \
  -n employee-details
```

### 3. Database

For production, use a managed database:

```yaml
# Update environment variables
env:
- name: DATABASE_URL
  value: "postgresql://user:pass@host:5432/dbname"
```

### 4. Ingress and SSL

Configure proper ingress with SSL:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
  - hosts:
    - your-domain.com
    secretName: employee-details-tls
```

### 5. Monitoring

Add monitoring and logging:

```yaml
# Add to deployment
env:
- name: PROMETHEUS_MULTIPROC_DIR
  value: "/tmp"
```

## Access Your Application

After deployment, access your application:

```bash
# Get external IP
kubectl get service employee-details-service -n employee-details

# Access endpoints
curl http://<EXTERNAL-IP>:30080/api/users/
curl http://<EXTERNAL-IP>:30080/dashboard/
```

## Troubleshooting

### Common Issues

1. **Image Pull Errors**:
   ```bash
   kubectl describe pod <pod-name> -n employee-details
   ```

2. **Service Not Accessible**:
   ```bash
   kubectl get endpoints -n employee-details
   kubectl describe service employee-details-service -n employee-details
   ```

3. **Database Issues**:
   ```bash
   kubectl logs deployment/employee-details -n employee-details
   ```

### Scaling

```bash
# Scale up
kubectl scale deployment employee-details --replicas=5 -n employee-details

# Check scaling
kubectl get pods -n employee-details
```

## Cost Optimization

1. **Use spot instances** for non-critical workloads
2. **Set resource limits** to prevent over-provisioning
3. **Use autoscaling** based on demand
4. **Monitor usage** with cloud provider tools

## Security Best Practices

1. **Network Policies**: Restrict pod-to-pod communication
2. **RBAC**: Use least privilege access
3. **Pod Security**: Enable pod security policies
4. **Secrets**: Use external secret management
5. **TLS**: Enable HTTPS everywhere 