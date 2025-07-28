"""
URL configuration for employee_details project.
"""
from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from users.views import UserViewSet, dashboard, index

# Create a router and register our viewsets with it
router = DefaultRouter()
router.register(r'users', UserViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', index, name='index'),
    path('api/', include(router.urls)),
    path('dashboard/', dashboard, name='dashboard'),
] 