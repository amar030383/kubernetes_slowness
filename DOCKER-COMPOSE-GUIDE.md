# Docker Compose Guide for Employee Information Django Application

## What is Docker Compose?

Docker Compose is a tool that allows you to define and run multi-container Docker applications. Instead of running multiple `docker run` commands, you can use a single `docker-compose.yml` file to configure all your application's services, networks, and volumes.

## Why Use Docker Compose?

### 🚀 **Benefits:**

1. **Simplified Development**: Run your entire application stack with one command
2. **Environment Consistency**: Same environment across development, testing, and production
3. **Service Orchestration**: Manage multiple services (web app, database, cache) together
4. **Easy Configuration**: All configuration in one YAML file
5. **Isolation**: Each service runs in its own container
6. **Scalability**: Easy to scale individual services
7. **Networking**: Automatic service discovery between containers

### 🔧 **Key Concepts:**

- **Services**: Individual containers (web app, database, cache)
- **Networks**: How containers communicate with each other
- **Volumes**: Persistent data storage
- **Environment Variables**: Configuration for each service

## Our Docker Compose Setup

### 📁 **File Structure:**
```
kubernetes_slowness/
├── docker-compose.yml          # Main compose configuration
├── Dockerfile                  # Web service image definition
├── .dockerignore              # Files to exclude from build
├── requirements.txt           # Python dependencies
└── DOCKER-COMPOSE-GUIDE.md    # This guide
```

### 🏗️ **Services Overview:**

1. **Web Service** (`web`): Django application
2. **Database Service** (`db`): PostgreSQL database (optional)
3. **Cache Service** (`redis`): Redis for caching (optional)

## Detailed Service Breakdown

### 🌐 **Web Service (Django Application)**

```yaml
web:
  build: .                    # Build from current directory
  container_name: employee-information-web
  ports:
    - "8000:8000"            # Host:Container port mapping
  environment:
    - SECRET_KEY=your-secret-key
    - DEBUG=True
    - ALLOWED_HOSTS=localhost,127.0.0.1,0.0.0.0
  volumes:
    - .:/app                 # Code changes without rebuild
    - django_data:/app/db.sqlite3  # Persistent database
  depends_on:
    - db                     # Start database first
  restart: unless-stopped    # Auto-restart policy
  healthcheck:               # Health monitoring
    test: ["CMD", "curl", "-f", "http://localhost:8000/"]
    interval: 30s
    timeout: 10s
    retries: 3
```

**Purpose of each section:**
- `build: .`: Build Docker image from current directory
- `ports`: Map container port 8000 to host port 8000
- `environment`: Set Django configuration variables
- `volumes`: Mount directories for development and data persistence
- `depends_on`: Ensure database starts before web service
- `restart`: Automatically restart if container crashes
- `healthcheck`: Monitor if service is responding

### 🗄️ **Database Service (PostgreSQL)**

```yaml
db:
  image: postgres:15-alpine   # Use official PostgreSQL image
  container_name: employee-information-db
  environment:
    - POSTGRES_DB=employee_db
    - POSTGRES_USER=employee_user
    - POSTGRES_PASSWORD=employee_password
  volumes:
    - postgres_data:/var/lib/postgresql/data
  ports:
    - "5432:5432"            # Expose PostgreSQL port
  restart: unless-stopped
  healthcheck:
    test: ["CMD-SHELL", "pg_isready -U employee_user -d employee_db"]
    interval: 10s
    timeout: 5s
    retries: 5
```

**Purpose:**
- Provides a robust database for production use
- Data persists across container restarts
- Health checks ensure database is ready before web service starts

### 🚀 **Cache Service (Redis) - Optional**

```yaml
redis:
  image: redis:7-alpine
  container_name: employee-information-redis
  ports:
    - "6379:6379"
  volumes:
    - redis_data:/data
  restart: unless-stopped
  healthcheck:
    test: ["CMD", "redis-cli", "ping"]
    interval: 10s
    timeout: 5s
    retries: 3
```

**Purpose:**
- Improves performance through caching
- Stores session data
- Reduces database load

## Volume Management

### 📦 **Named Volumes:**

```yaml
volumes:
  django_data:               # SQLite database persistence
    driver: local
  postgres_data:             # PostgreSQL data persistence
    driver: local
  redis_data:                # Redis data persistence
    driver: local
```

**Benefits:**
- Data persists when containers are removed
- Easy backup and restore
- Shared between container restarts

## Network Configuration

### 🌐 **Custom Network:**

```yaml
networks:
  default:
    name: employee-information-network
    driver: bridge
```

**Benefits:**
- Isolated network for services
- Automatic service discovery
- Better security

## How to Use Docker Compose

### 🚀 **Basic Commands:**

```bash
# Start all services
docker-compose up

# Start services in background
docker-compose up -d

# Stop all services
docker-compose down

# View running services
docker-compose ps

# View service logs
docker-compose logs

# View specific service logs
docker-compose logs web

# Rebuild and start services
docker-compose up --build

# Stop and remove containers, networks, and volumes
docker-compose down -v
```

### 🔧 **Development Workflow:**

1. **First Time Setup:**
   ```bash
   # Build and start all services
   docker-compose up --build
   ```

2. **Daily Development:**
   ```bash
   # Start services
   docker-compose up -d
   
   # View logs
   docker-compose logs -f web
   
   # Stop services
   docker-compose down
   ```

3. **Code Changes:**
   ```bash
   # Code changes are automatically reflected due to volume mounting
   # No need to rebuild unless requirements.txt changes
   ```

### 🛠️ **Advanced Commands:**

```bash
# Scale a service
docker-compose up --scale web=3

# Execute commands in running containers
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser

# View resource usage
docker-compose top

# Pause services
docker-compose pause

# Resume services
docker-compose unpause
```

## Environment Configuration

### 🔐 **Environment Variables:**

Create a `.env` file for sensitive data:

```env
# Django Configuration
SECRET_KEY=your-super-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1,0.0.0.0

# Database Configuration
DB_ENGINE=django.db.backends.postgresql
DB_NAME=employee_db
DB_USER=employee_user
DB_PASSWORD=employee_password
DB_HOST=db
DB_PORT=5432
```

### 📝 **Update docker-compose.yml to use .env:**

```yaml
environment:
  - SECRET_KEY=${SECRET_KEY}
  - DEBUG=${DEBUG}
  - ALLOWED_HOSTS=${ALLOWED_HOSTS}
  - DB_ENGINE=${DB_ENGINE}
  - DB_NAME=${DB_NAME}
  - DB_USER=${DB_USER}
  - DB_PASSWORD=${DB_PASSWORD}
  - DB_HOST=${DB_HOST}
  - DB_PORT=${DB_PORT}
```

## Production Considerations

### 🔒 **Security:**

1. **Change Default Passwords**: Update all default passwords
2. **Use Environment Variables**: Don't hardcode secrets
3. **Limit Port Exposure**: Only expose necessary ports
4. **Use Non-Root Users**: Run containers as non-root users
5. **Regular Updates**: Keep base images updated

### 📊 **Performance:**

1. **Use Production WSGI Server**: Replace Django dev server with Gunicorn
2. **Enable Caching**: Use Redis for session and query caching
3. **Database Optimization**: Use PostgreSQL for production
4. **Load Balancing**: Scale web services across multiple containers

### 🔄 **Monitoring:**

1. **Health Checks**: Monitor service health
2. **Logging**: Centralized logging with ELK stack
3. **Metrics**: Monitor resource usage
4. **Backups**: Regular database backups

## Troubleshooting

### 🐛 **Common Issues:**

1. **Port Already in Use:**
   ```bash
   # Check what's using the port
   netstat -tulpn | grep :8000
   
   # Change port in docker-compose.yml
   ports:
     - "8001:8000"
   ```

2. **Database Connection Issues:**
   ```bash
   # Check database logs
   docker-compose logs db
   
   # Test database connection
   docker-compose exec web python manage.py dbshell
   ```

3. **Permission Issues:**
   ```bash
   # Fix file permissions
   sudo chown -R $USER:$USER .
   ```

4. **Container Won't Start:**
   ```bash
   # Check container logs
   docker-compose logs web
   
   # Rebuild container
   docker-compose up --build
   ```

### 🔍 **Debugging Commands:**

```bash
# Inspect running containers
docker-compose ps

# View detailed container info
docker-compose exec web env

# Check container resource usage
docker stats

# Access container shell
docker-compose exec web bash

# View network configuration
docker network ls
docker network inspect employee-information-network
```

## Best Practices

### ✅ **Do's:**

1. **Use Named Volumes**: For data persistence
2. **Set Resource Limits**: Prevent resource exhaustion
3. **Use Health Checks**: Monitor service health
4. **Version Your Images**: Use specific image tags
5. **Document Dependencies**: Clear service dependencies
6. **Use Environment Files**: Separate configuration from code

### ❌ **Don'ts:**

1. **Don't Run as Root**: Security risk
2. **Don't Expose Unnecessary Ports**: Security risk
3. **Don't Store Secrets in Images**: Use environment variables
4. **Don't Use Latest Tags**: Can cause unexpected changes
5. **Don't Ignore Logs**: Monitor application health

## Next Steps

1. **Add Production WSGI Server**: Replace Django dev server with Gunicorn
2. **Implement Caching**: Add Redis for performance
3. **Add Monitoring**: Implement logging and metrics
4. **Set Up CI/CD**: Automated testing and deployment
5. **Add Load Balancing**: Scale across multiple containers

This Docker Compose setup provides a solid foundation for developing, testing, and deploying your Django application with proper service isolation, data persistence, and health monitoring.
