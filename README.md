# Employee Details API

A simple Django REST Framework-based application that returns a list of users with basic information.

## Features

- REST API endpoint at `/users/` that returns a list of users
- SQLite database for data storage
- Default user data inserted on startup
- CORS enabled to allow all origins
- Environment variable configuration
- Docker containerization
- Kubernetes deployment support

## Quick Start

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd automation
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Set up environment variables**
   ```bash
   cp env.example .env
   # Edit .env file with your configuration
   ```

5. **Run migrations**
   ```bash
   python manage.py makemigrations
   python manage.py migrate
   ```

6. **Start the development server**
   ```bash
   python manage.py runserver
   ```

7. **Access the application**
   - **Web Interface**: http://localhost:8000/ (Welcome page)
   - **Dashboard**: http://localhost:8000/dashboard/ (Employee data with request info)
   - **API Endpoint**: http://localhost:8000/api/users/ (REST API)
   - **Admin Interface**: http://localhost:8000/admin/ (Django admin)

### Docker

1. **Build the Docker image**
   ```bash
   docker build -t employee-details .
   ```

2. **Run the container**
   ```bash
   docker run -p 8000:8000 employee-details
   ```

3. **Test the API**
   ```bash
   curl http://localhost:8000/users/
   ```

### Kubernetes

#### Prerequisites
- Kubernetes cluster (local or cloud)
- kubectl configured
- Docker installed

#### Quick Deployment

**Option 1: Using deployment script (Recommended)**
```bash
# Linux/Mac
./deploy.sh

# Windows
deploy.bat
```

**Option 2: Manual deployment**
```bash
# Build Docker image
docker build -t employee-details:latest .

# Deploy to Kubernetes
kubectl apply -f k8s-deployment.yaml
```

#### Deployment Features
- **Namespace**: `employee-details` (isolated environment)
- **Replicas**: 3 (high availability)
- **Service Type**: NodePort (port 30080)
- **Persistent Storage**: 1GB for database
- **Health Checks**: Liveness and readiness probes
- **Resource Limits**: CPU and memory constraints
- **Rolling Updates**: Zero-downtime deployments

#### Access the Application
```bash
# Check deployment status
kubectl get pods -n employee-details
kubectl get services -n employee-details

# Access via NodePort
curl http://localhost:30080/api/users/
curl http://localhost:30080/dashboard/
```

#### Management Commands
```bash
# View logs
kubectl logs -f deployment/employee-details -n employee-details

# Scale deployment
kubectl scale deployment employee-details --replicas=5 -n employee-details

# Delete deployment
kubectl delete -f k8s-deployment.yaml
```

## Web Interface

### Dashboard (/dashboard/)
A beautiful web interface that displays:
- **Employee List**: All users with their details in card format
- **Request Information**: 
  - Source IP Address of the request
  - Response time of the API call
  - Request timestamp
  - User agent information
- **Real-time Updates**: Auto-refreshes every 30 seconds
- **Manual Refresh**: Button to manually refresh data

### Welcome Page (/)
A landing page with links to all available endpoints.

## API Endpoints

### GET /api/users/
Returns a list of all users.

**Response:**
```json
[
  {
    "id": 1,
    "name": "John Doe",
    "age": 30,
    "phone_number": "1234567890",
    "home_address": "123 Main St",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  },
  {
    "id": 2,
    "name": "Jane Smith",
    "age": 25,
    "phone_number": "9876543210",
    "home_address": "456 Oak Ave",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  }
]
```

## Project Structure

```
automation/
├── employee_details/          # Django project settings
│   ├── __init__.py
│   ├── settings.py           # Django settings with CORS and REST framework
│   ├── urls.py               # Main URL configuration
│   └── wsgi.py               # WSGI configuration
├── users/                    # Users app
│   ├── __init__.py
│   ├── admin.py              # Django admin configuration
│   ├── apps.py               # App configuration with default data
│   ├── models.py             # User model
│   ├── serializers.py        # REST API serializers
│   ├── views.py              # API views
│   └── migrations/
│       └── __init__.py
├── templates/                # HTML templates
│   ├── base.html             # Base template with styling
│   ├── index.html            # Welcome page
│   └── users/
│       └── dashboard.html    # Dashboard with request info
├── manage.py                 # Django management script
├── requirements.txt          # Python dependencies
├── env.example               # Environment variables template
├── Dockerfile                # Docker configuration
├── k8s-deployment.yaml       # Kubernetes deployment
└── README.md                 # This file
```

## Configuration

### Environment Variables

- `SECRET_KEY`: Django secret key (required)
- `DEBUG`: Enable/disable debug mode (default: True)
- `ALLOWED_HOSTS`: Comma-separated list of allowed hosts (default: *)

### Database

The application uses SQLite by default. The database file will be created automatically at `db.sqlite3`.

## Default Data

The application automatically creates two default users on startup:
- John Doe (age 30, phone: 1234567890, address: 123 Main St)
- Jane Smith (age 25, phone: 9876543210, address: 456 Oak Ave)

## Production Considerations

1. **Security**: Change the default SECRET_KEY in production
2. **Database**: Consider using PostgreSQL or MySQL for production
3. **Static Files**: Configure a proper static file server
4. **HTTPS**: Enable HTTPS in production environments
5. **Monitoring**: Add proper logging and monitoring

## License

This project is open source and available under the MIT License. "# kubernetes_slowness" 
