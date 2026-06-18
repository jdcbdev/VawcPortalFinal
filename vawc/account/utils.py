import base64
import hashlib
from django.conf import settings
from cryptography.fernet import Fernet, InvalidToken
from account.models import Email, Recaptcha, Twilio


def _get_fernet():
    """
    Derive a stable Fernet key from Django's SECRET_KEY.
    Uses SHA-256 of the secret key, then base64-urlsafe-encodes it
    to produce a valid 32-byte Fernet key.
    """
    raw = settings.SECRET_KEY.encode('utf-8')
    key_bytes = hashlib.sha256(raw).digest()  # 32 bytes
    fernet_key = base64.urlsafe_b64encode(key_bytes)
    return Fernet(fernet_key)


def encrypt_password(plaintext: str) -> str:
    """Encrypt a plaintext password for storage in the database."""
    f = _get_fernet()
    return f.encrypt(plaintext.encode('utf-8')).decode('utf-8')


def decrypt_password(ciphertext: str) -> str:
    """
    Decrypt a stored password. Falls back to returning the ciphertext
    as-is if it was stored in plaintext (legacy), so admins can
    re-save via the admin panel to migrate to encrypted storage.
    """
    f = _get_fernet()
    try:
        return f.decrypt(ciphertext.encode('utf-8')).decode('utf-8')
    except (InvalidToken, Exception):
        # Plaintext fallback for pre-existing records — re-save to encrypt
        return ciphertext


# ── Settings Loaders ──────────────────────────────────────────────────────────

def load_settings():
    """Load SMTP settings from the database, decrypting the password."""
    email = Email.objects.all().first()
    if email:
        settings.DEFAULT_FROM_EMAIL = email.email
        settings.EMAIL_HOST = email.host
        settings.EMAIL_PORT = email.port
        settings.EMAIL_HOST_USER = email.email
        # Decrypt password on the fly — never stored in settings as plaintext
        settings.EMAIL_HOST_PASSWORD = decrypt_password(email.password)
    else:
        raise ValueError("No email settings found in the database.")


def save_email_settings(email_address, host, port, password):
    """
    Helper to create/update an Email record with an encrypted password.
    Use this instead of directly creating Email objects.
    """
    email_obj, _ = Email.objects.get_or_create(pk=1)
    email_obj.email = email_address
    email_obj.host = host
    email_obj.port = port
    email_obj.password = encrypt_password(password)
    email_obj.save()


def load_recaptcha_settings():
    recaptcha = Recaptcha.objects.all().first()
    if recaptcha:
        settings.RECAPTCHA_SECRET_KEY = recaptcha.secret_key
        return {'site_key': recaptcha.site_key, 'secret_key': recaptcha.secret_key}
    else:
        raise ValueError("No reCAPTCHA settings found in the database.")


def load_twilio_settings():
    twilio = Twilio.objects.all().first()
    if twilio:
        settings.TWILIO_ACCOUNT_SID = twilio.account_sid
        settings.TWILIO_AUTH_TOKEN = twilio.auth_token
        settings.TWILIO_PHONE_NUMBER = twilio.phone_number
        settings.TWILIO_TYPE = twilio.type
        return {'twilio_type': twilio.type}
    else:
        raise ValueError("No Twilio settings found in the database.")