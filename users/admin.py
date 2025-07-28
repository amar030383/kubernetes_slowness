from django.contrib import admin
from .models import User


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    """Admin configuration for the User model."""
    list_display = ['name', 'age', 'phone_number', 'home_address', 'created_at']
    list_filter = ['age', 'created_at']
    search_fields = ['name', 'phone_number', 'home_address']
    readonly_fields = ['created_at', 'updated_at'] 