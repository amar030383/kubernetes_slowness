# Employee Information Django Application

A simple Django REST API application for managing employee information with a web dashboard.

## Features

- REST API for employee management
- Web dashboard with real-time request information
- SQLite database (configurable for production)
- CORS enabled for API access

## Installation

### Option 1: Docker Compose (Recommended)

1. **Prerequisites:**
   - Docker Desktop installed and running
   - Docker Compose installed

2. **Manual Setup Steps:**
   ```bash
   # Step 1: Build and start all services
   docker-compose up --build -d
   
   # Step 2: Check if services are running
   docker-compose ps
   
   # Step 3: View logs to ensure everything started correctly
   docker-compose logs
   ```

3. **Access the application:**
   - **Home Page**: http://localhost:8000/
   - **Dashboard**: http://localhost:8000/dashboard/
   - **Admin**: http://localhost:8000/admin/
   - **API**: http://localhost:8000/api/users/

### Option 2: Local Development

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Run migrations:
```bash
python manage.py makemigrations
python manage.py migrate
```

3. Create a superuser (optional):
```bash
python manage.py createsuperuser
```

4. Run the development server:
```bash
python manage.py runserver
```

## Usage

- **Home Page**: `http://localhost:8000/` - Welcome page with API links
- **Dashboard**: `http://localhost:8000/dashboard/` - Employee dashboard with request info
- **Admin**: `http://localhost:8000/admin/` - Django admin interface
- **API**: `http://localhost:8000/api/users/` - REST API endpoint

## API Endpoints

- `GET /api/users/` - List all employees
- `POST /api/users/` - Create a new employee
- `GET /api/users/{id}/` - Get specific employee
- `PUT /api/users/{id}/` - Update employee
- `DELETE /api/users/{id}/` - Delete employee

## Environment Variables

Create a `.env` file with the following variables:
```
SECRET_KEY=your-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
DB_ENGINE=django.db.backends.sqlite3
DB_NAME=db.sqlite3
```

## Docker Compose Management

### Manual Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs

# View logs for specific service
docker-compose logs web
docker-compose logs db

# Follow logs in real-time
docker-compose logs -f

# Run migrations
docker-compose exec web python manage.py migrate

# Create superuser
docker-compose exec web python manage.py createsuperuser

# Open shell in web container
docker-compose exec web bash

# Check service status
docker-compose ps

# Rebuild and restart services
docker-compose up --build -d

# Stop and remove everything (containers, networks, volumes)
docker-compose down -v

# View resource usage
docker-compose top
```

### Step-by-Step Manual Setup

#### **Step 1: Prerequisites**
```bash
# Verify Docker is installed and running
docker --version
docker-compose --version
```

#### **Step 2: Build and Start Services**
```bash
# Build images and start all services in background
docker-compose up --build -d

# Check if services are running
docker-compose ps
```

#### **Step 3: Verify Services**
```bash
# View logs to ensure everything started correctly
docker-compose logs

# Check specific service logs if needed
docker-compose logs web
docker-compose logs db
```

#### **Step 4: Run Database Migrations**
```bash
# Run Django migrations
docker-compose exec web python manage.py migrate
```

#### **Step 5: Create Admin User (Optional)**
```bash
# Create a Django superuser for admin access
docker-compose exec web python manage.py createsuperuser
```

#### **Step 6: Test the Application**
Open your browser and visit:
- **Home Page**: http://localhost:8000/
- **Dashboard**: http://localhost:8000/dashboard/
- **Admin**: http://localhost:8000/admin/
- **API**: http://localhost:8000/api/users/

#### **Step 7: Test API Endpoints**
```bash
# Test the API endpoint
curl http://localhost:8000/api/users/

# Test the home page
curl http://localhost:8000/
```

### Troubleshooting

#### **If services won't start:**
```bash
# Check detailed logs
docker-compose logs

# Rebuild containers
docker-compose up --build -d

# Check if ports are in use
netstat -ano | findstr :8000
```

#### **If database connection fails:**
```bash
# Check database logs
docker-compose logs db

# Test database connection
docker-compose exec web python manage.py dbshell
```

#### **If you need to restart everything:**
```bash
# Stop all services
docker-compose down

# Remove all data (volumes)
docker-compose down -v

# Start fresh
docker-compose up --build -d
```

#### **If you need to access container shell:**
```bash
# Access web container shell
docker-compose exec web bash

# Access database container shell
docker-compose exec db bash
```

### Docker Compose Services

- **Web Service**: Django application (port 8000)
- **Database Service**: PostgreSQL database (port 5432)
- **Cache Service**: Redis cache (port 6379) - optional

### Volume Management

- **django_data**: SQLite database persistence
- **postgres_data**: PostgreSQL data persistence
- **redis_data**: Redis data persistence

## Project Structure

```
├── docker-compose.yml          # Docker Compose configuration
├── Dockerfile                  # Web service image definition
├── .dockerignore              # Files to exclude from build
├── DOCKER-COMPOSE-GUIDE.md    # Detailed Docker Compose guide
├── DOCKER-SUMMARY.md          # Quick Docker Compose reference
├── employee_details/           # Django project settings
├── users/                     # Employee management app
├── templates/                 # HTML templates
├── manage.py                  # Django management script
├── requirements.txt           # Python dependencies
└── README.md                  # This file
``` 
