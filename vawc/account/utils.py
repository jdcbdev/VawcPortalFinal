from django.conf import settings
from account.models import Email, Recaptcha

# Set email settings config
def load_settings():

    email = Email.objects.all().first()
    if email:
        settings.DEFAULT_FROM_EMAIL = email.email
        settings.EMAIL_HOST = email.host
        settings.EMAIL_PORT = email.port
        settings.EMAIL_HOST_USER = email.email
        settings.EMAIL_HOST_PASSWORD = email.password
    else:
        raise ValueError("No email settings found in the database.")

def load_recaptcha_settings():
    recaptcha = Recaptcha.objects.all().first()
    if recaptcha:
        settings.RECAPTCHA_SECRET_KEY = recaptcha.secret_key
        return {'site_key': recaptcha.site_key, 'secret_key': recaptcha.secret_key}
    else:
        raise ValueError("No reCAPTCHA settings found in the database.")