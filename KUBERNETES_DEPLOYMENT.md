# Kubernetes Deployment Guide

## Overview

This document describes the Kubernetes deployment configuration for the Employee Details API application.

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Ingress       │    │   Service       │    │   Pods          │
│   (Optional)    │───▶│   NodePort      │───▶│   (3 replicas)  │
│                 │    │   Port: 30080   │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                              ┌─────────────────┐
                                              │   PVC           │
                                              │   (1GB Storage) │
                                              └─────────────────┘
```

## Components

### 1. Namespace
- **Name**: `employee-details`
- **Purpose**: Isolates the application resources

### 2. Deployment
- **Replicas**: 3 (high availability)
- **Strategy**: RollingUpdate (zero-downtime)
- **Image**: `employee-details:latest`
- **Resources**:
  - Requests: 256Mi memory, 200m CPU
  - Limits: 512Mi memory, 500m CPU

### 3. Service
- **Type**: NodePort
- **Port**: 8000 (internal)
- **NodePort**: 30080 (external access)
- **Session Affinity**: None

### 4. Persistent Volume Claim
- **Storage**: 1GB
- **Access Mode**: ReadWriteOnce
- **Purpose**: Database persistence

### 5. Secret
- **Name**: `employee-details-secret`
- **Type**: Opaque
- **Contains**: Django secret key

### 6. Ingress (Optional)
- **Host**: `employee-details.local`
- **Annotations**: nginx ingress controller
- **SSL**: Disabled (for development)

## Health Checks

### Liveness Probe
- **Path**: `/api/users/`
- **Initial Delay**: 60s
- **Period**: 30s
- **Timeout**: 10s
- **Failure Threshold**: 3

### Readiness Probe
- **Path**: `/api/users/`
- **Initial Delay**: 30s
- **Period**: 10s
- **Timeout**: 5s
- **Failure Threshold**: 3

## Environment Variables

| Variable | Source | Description |
|----------|--------|-------------|
| SECRET_KEY | Secret | Django secret key |
| DEBUG | ConfigMap | Debug mode (False) |
| ALLOWED_HOSTS | ConfigMap | Allowed hosts (*) |
| DATABASE_URL | ConfigMap | Database connection |

## Deployment Steps

### Prerequisites
1. Kubernetes cluster running
2. kubectl configured
3. Docker installed
4. Application code ready

### Quick Deployment
```bash
# Option 1: Using script
./deploy.sh          # Linux/Mac
deploy.bat           # Windows

# Option 2: Manual
docker build -t employee-details:latest .
kubectl apply -f k8s-deployment.yaml
```

### Validation
```bash
# Validate configuration
./validate-k8s.sh    # Linux/Mac
validate-k8s.bat     # Windows
```

## Access Points

| Service | URL | Description |
|---------|-----|-------------|
| Dashboard | http://localhost:30080/dashboard/ | Web interface |
| API | http://localhost:30080/api/users/ | REST API |
| Welcome | http://localhost:30080/ | Landing page |

## Management Commands

### Monitoring
```bash
# Check pods
kubectl get pods -n employee-details

# Check services
kubectl get services -n employee-details

# View logs
kubectl logs -f deployment/employee-details -n employee-details

# Check events
kubectl get events -n employee-details
```

### Scaling
```bash
# Scale up
kubectl scale deployment employee-details --replicas=5 -n employee-details

# Scale down
kubectl scale deployment employee-details --replicas=1 -n employee-details
```

### Updates
```bash
# Rolling update
kubectl set image deployment/employee-details employee-details=employee-details:v2.0.0 -n employee-details

# Check rollout status
kubectl rollout status deployment/employee-details -n employee-details
```

### Cleanup
```bash
# Delete deployment
kubectl delete -f k8s-deployment.yaml

# Delete namespace
kubectl delete namespace employee-details
```

## Troubleshooting

### Common Issues

1. **Pod not starting**
   ```bash
   kubectl describe pod <pod-name> -n employee-details
   kubectl logs <pod-name> -n employee-details
   ```

2. **Service not accessible**
   ```bash
   kubectl get endpoints -n employee-details
   kubectl describe service employee-details-service -n employee-details
   ```

3. **Storage issues**
   ```bash
   kubectl get pvc -n employee-details
   kubectl describe pvc employee-details-pvc -n employee-details
   ```

### Performance Tuning

1. **Resource limits**: Adjust CPU/memory based on usage
2. **Replicas**: Scale based on load
3. **Storage**: Increase PVC size if needed
4. **Health checks**: Adjust probe timing if needed

## Security Considerations

1. **Secrets**: Use proper secret management in production
2. **Network**: Configure network policies
3. **RBAC**: Set up proper role-based access control
4. **TLS**: Enable HTTPS in production
5. **Image**: Use specific image tags, not `latest`

## Production Recommendations

1. **Use external database** (PostgreSQL/MySQL)
2. **Enable TLS/HTTPS**
3. **Set up monitoring** (Prometheus/Grafana)
4. **Configure backups**
5. **Use image registry** (Docker Hub, ECR, etc.)
6. **Set up CI/CD pipeline**
7. **Configure resource quotas**
8. **Enable pod security policies** 