from rest_framework import serializers
from .models import User


class UserSerializer(serializers.ModelSerializer):
    """Serializer for the User model."""
    
    class Meta:
        model = User
        fields = ['id', 'name', 'age', 'phone_number', 'home_address', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at'] 