# Dockerfile for Employee Information Django Application
# This file defines how to build a Docker image for our Django application

# Use Python 3.11 slim image as the base
# Slim images are smaller and contain only essential packages
FROM python:3.11-slim

# Set environment variables for Python
# These help with Python performance and security
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app

# Set the working directory inside the container
# All subsequent commands will run from this directory
WORKDIR /app

# Install system dependencies required for Python packages
# These are needed for building some Python packages with C extensions
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        # curl for health checks
        curl \
        # gcc and build tools for compiling Python packages
        gcc \
        # libpq-dev for PostgreSQL support (if needed later)
        libpq-dev \
        # pkg-config for package configuration
        pkg-config \
    # Clean up package cache to reduce image size
    && apt-get clean \
    # Remove package lists to reduce image size
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file first
# This is a Docker best practice for better layer caching
# If requirements.txt doesn't change, this layer will be cached
COPY requirements.txt .

# Install Python dependencies
# This creates a separate layer for dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy the entire Django project into the container
# This includes all Python files, templates, and static files
COPY . .

# Create a non-root user for security
# Running as root in containers is a security risk
RUN groupadd -r django \
    && useradd -r -g django django

# Change ownership of the application directory to the django user
# This ensures the application runs with proper permissions
RUN chown -R django:django /app

# Switch to the django user
# This improves security by not running as root
USER django

# Expose port 8000
# This tells Docker that the container will listen on port 8000
EXPOSE 8000

# Health check to ensure the application is running
# This helps Docker determine if the container is healthy
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8000/ || exit 1

# Default command to run when the container starts
# This runs the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# Alternative commands for different environments:
# 
# For production with Gunicorn:
# CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "employee_details.wsgi:application"]
# 
# For running migrations first:
# CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
# 
# For collecting static files first:
# CMD ["sh", "-c", "python manage.py collectstatic --noinput && python manage.py runserver 0.0.0.0:8000"]
