# Employee Details Full-Stack Kubernetes Application

A complete full-stack application deployed on Kubernetes with:
- **Frontend**: React.js with Nginx reverse proxy
- **Backend**: Django REST API
- **Database**: External PostgreSQL (192.168.67.149:5432)
- **Orchestration**: Kubernetes with Ansible automation

## Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   React Frontend│    │  Django Backend │    │  PostgreSQL DB  │
│   (Nginx)       │◄──►│   (Django API)  │◄──►│   (External)    │
│   Port: 30080   │    │   Port: 8000    │    │   Port: 5432    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Kubernetes    │
                    │   Cluster       │
                    └─────────────────┘
```

## Prerequisites

### Environment Setup
- Kubernetes cluster (Minikube for local development)
- Docker installed and running
- kubectl configured
- PostgreSQL database accessible at 192.168.67.149:5432

### Database Setup
Create the PostgreSQL database:
```sql
CREATE DATABASE employee_db;
CREATE USER postgres WITH PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE employee_db TO postgres;
```

## Quick Start

### Option 1: Automated Deployment Script
```bash
# Make the script executable
chmod +x deploy-full-stack.sh

# Run the deployment
./deploy-full-stack.sh
```

### Option 2: Manual Deployment
```bash
# 1. Build Docker images
docker build -t employee-details-backend:latest .
cd frontend && docker build -t employee-details-frontend:latest .

# 2. Load images into minikube
minikube image load employee-details-backend:latest
minikube image load employee-details-frontend:latest

# 3. Deploy to Kubernetes
kubectl apply -f manifests/namespace.yaml
kubectl apply -f manifests/configmap.yaml
kubectl apply -f manifests/secret.yaml
kubectl apply -f manifests/backend-deployment.yaml
kubectl apply -f manifests/backend-service.yaml
kubectl apply -f manifests/frontend-deployment.yaml
kubectl apply -f manifests/frontend-service.yaml
```

### Option 3: Ansible Automation
```bash
# Install Ansible collections
ansible-galaxy collection install -r ansible/requirements.yml

# Run the playbook
ansible-playbook -i ansible/inventory.ini ansible/deploy.yml
```

## Accessing the Application

### Get Minikube IP
```bash
minikube ip
```

### Application URLs
- **Frontend Dashboard**: http://<minikube-ip>:30080
- **Backend API**: http://<minikube-ip>:30080/api/users/
- **Health Check**: http://<minikube-ip>:30080/health

## Project Structure

```
kubernetes_slowness/
├── backend/                          # Django backend application
│   ├── employee_details/             # Django project settings
│   ├── users/                        # Django app with models
│   ├── Dockerfile                    # Backend containerization
│   ├── requirements.txt              # Python dependencies
│   └── start.sh                      # Startup script
├── frontend/                         # React frontend application
│   ├── public/                       # Static files
│   ├── src/                          # React source code
│   ├── Dockerfile                    # Frontend containerization
│   ├── nginx.conf                    # Nginx configuration
│   └── package.json                  # Node.js dependencies
├── manifests/                        # Kubernetes manifests
│   ├── namespace.yaml                # Namespace definition
│   ├── configmap.yaml                # Environment variables
│   ├── secret.yaml                   # Sensitive data
│   ├── backend-deployment.yaml       # Backend deployment
│   ├── backend-service.yaml          # Backend service
│   ├── frontend-deployment.yaml      # Frontend deployment
│   └── frontend-service.yaml         # Frontend service
├── ansible/                          # Ansible automation
│   ├── inventory.ini                 # Host inventory
│   ├── deploy.yml                    # Deployment playbook
│   └── requirements.yml              # Ansible collections
├── deploy-full-stack.sh              # Automated deployment script
└── README-FULLSTACK.md               # This file
```

## Configuration

### Environment Variables

#### ConfigMap (manifests/configmap.yaml)
- `DEBUG`: Django debug mode
- `ALLOWED_HOSTS`: Allowed hosts for Django
- `DB_ENGINE`: Database engine (postgresql)
- `DB_NAME`: Database name
- `DB_HOST`: Database host
- `DB_PORT`: Database port

#### Secret (manifests/secret.yaml)
- `SECRET_KEY`: Django secret key
- `DB_USER`: Database username
- `DB_PASSWORD`: Database password

### Database Configuration
The application connects to PostgreSQL at `192.168.67.149:5432`. Update the following files if your database configuration differs:

1. `manifests/configmap.yaml` - Database host and port
2. `manifests/secret.yaml` - Database credentials
3. `env.example` - Local development environment

## Monitoring and Debugging

### Check Pod Status
```bash
kubectl get pods -n employee-details
```

### View Logs
```bash
# Backend logs
kubectl logs -f deployment/employee-details-backend -n employee-details

# Frontend logs
kubectl logs -f deployment/employee-details-frontend -n employee-details
```

### Check Services
```bash
kubectl get services -n employee-details
```

### Test Database Connection
```bash
# Test from within a backend pod
kubectl exec -it deployment/employee-details-backend -n employee-details -- python manage.py dbshell
```

## Scaling

### Scale Backend
```bash
kubectl scale deployment employee-details-backend --replicas=3 -n employee-details
```

### Scale Frontend
```bash
kubectl scale deployment employee-details-frontend --replicas=3 -n employee-details
```

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Verify PostgreSQL is running at 192.168.67.149:5432
   - Check database credentials in `manifests/secret.yaml`
   - Ensure network connectivity from Kubernetes cluster

2. **Frontend Can't Reach Backend**
   - Verify backend service is running
   - Check Nginx configuration in `frontend/nginx.conf`
   - Ensure CORS settings are correct

3. **Images Not Found**
   - Build images locally: `docker build -t image-name:latest .`
   - Load into minikube: `minikube image load image-name:latest`

4. **Pods Not Starting**
   - Check resource limits in deployment manifests
   - Verify image names match in manifests
   - Check pod events: `kubectl describe pod <pod-name> -n employee-details`

### Health Checks
- Frontend health: `curl http://<minikube-ip>:30080/health`
- Backend health: `curl http://<minikube-ip>:30080/api/users/`

## Cleanup

### Remove Deployment
```bash
kubectl delete namespace employee-details
```

### Remove Images
```bash
docker rmi employee-details-backend:latest
docker rmi employee-details-frontend:latest
```

## Production Considerations

1. **Security**
   - Use proper secrets management (HashiCorp Vault, AWS Secrets Manager)
   - Enable TLS/SSL termination
   - Implement proper RBAC

2. **Monitoring**
   - Add Prometheus metrics
   - Configure Grafana dashboards
   - Set up alerting

3. **High Availability**
   - Use multiple replicas
   - Implement proper health checks
   - Use persistent volumes for data

4. **CI/CD**
   - Integrate with GitLab CI or GitHub Actions
   - Implement automated testing
   - Use image registries (Docker Hub, AWS ECR)

## Support

For issues and questions:
1. Check the troubleshooting section above
2. Review Kubernetes and Docker logs
3. Verify network connectivity and database access
4. Ensure all prerequisites are met 