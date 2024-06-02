from django.conf import settings
from account.models import Email

# Set email settings config
def load_settings():

    email = Email.objects.all().first()
    if email:
        settings.DEFAULT_FROM_EMAIL = email.email
        settings.EMAIL_HOST = email.host
        settings.EMAIL_PORT = email.port
        settings.EMAIL_HOST_USER = email.email
        settings.EMAIL_HOST_PASSWORD = email.password