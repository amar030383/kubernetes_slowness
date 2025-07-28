import time
from django.shortcuts import render
from django.http import JsonResponse
from rest_framework import viewsets
from .models import User
from .serializers import UserSerializer


class UserViewSet(viewsets.ModelViewSet):
    """ViewSet for the User model."""
    queryset = User.objects.all()
    serializer_class = UserSerializer


import socket

def dashboard(request):
    """Dashboard view that displays users with request information."""
    start_time = time.time()
    
    # Get client IP address with improved detection
    def get_client_ip(request):
        # Check for forwarded headers first
        x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
        if x_forwarded_for:
            return x_forwarded_for.split(',')[0].strip()
        
        # Check for real IP header
        x_real_ip = request.META.get('HTTP_X_REAL_IP')
        if x_real_ip:
            return x_real_ip
        
        # Check for client IP header
        x_client_ip = request.META.get('HTTP_CLIENT_IP')
        if x_client_ip:
            return x_client_ip
        
        # Get remote address
        remote_addr = request.META.get('REMOTE_ADDR')
        
        # If it's localhost (127.0.0.1), try to get the actual network IP
        if remote_addr in ['127.0.0.1', 'localhost', '::1']:
            try:
                # Get the hostname and then the IP
                hostname = socket.gethostname()
                local_ip = socket.gethostbyname(hostname)
                return local_ip
            except:
                return remote_addr
        
        return remote_addr or 'Unknown'
    
    source_ip = get_client_ip(request)
    
    # Get users data
    users = User.objects.all()
    
    # Calculate response time
    response_time = round((time.time() - start_time) * 1000, 2)
    
    # Prepare request information
    request_info = {
        'source_ip': source_ip,
        'response_time': response_time,
        'timestamp': time.strftime('%Y-%m-%d %H:%M:%S'),
        'user_agent': request.META.get('HTTP_USER_AGENT', 'Unknown'),
    }
    
    context = {
        'users': users,
        'request_info': request_info,
    }
    
    return render(request, 'users/dashboard.html', context)


def index(request):
    """Index page view."""
    return render(request, 'index.html') 