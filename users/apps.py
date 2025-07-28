from django.apps import AppConfig


class UsersConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'users'

    def ready(self):
        """Insert default user data when the app is ready."""
        import sys
        from django.db import connection
        
        # Only run this if we're not in a management command
        if 'runserver' in sys.argv:
            try:
                from .models import User
                # Check if we already have users in the database
                if not User.objects.exists():
                    # Create default users
                    default_users = [
                        {
                            'name': 'John Doe',
                            'age': 30,
                            'phone_number': '1234567890',
                            'home_address': '123 Main St'
                        },
                        {
                            'name': 'Jane Smith',
                            'age': 25,
                            'phone_number': '9876543210',
                            'home_address': '456 Oak Ave'
                        }
                    ]
                    
                    for user_data in default_users:
                        User.objects.create(**user_data)
            except Exception:
                # Ignore errors during app initialization
                pass 