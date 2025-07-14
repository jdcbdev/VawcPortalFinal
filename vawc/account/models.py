from django.db import models
from django.contrib.auth.models import AbstractUser
from django.contrib.auth.models import UserManager
from django.utils import timezone

# Custom User model with email-based authentication
class CustomUser(AbstractUser):
    email = models.EmailField(unique=True)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ('username',)

    objects = UserManager()
    def __str__(self):
        return self.username

class Account(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, primary_key=True)
    first_name = models.CharField(max_length=100)
    middle_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=100)
    YES, NO = 'Yes', 'No'
    VERIFIED_CHOICES = [(YES, 'Yes'), (NO, 'No')]
    verified = models.CharField(
        max_length=3,
        choices=VERIFIED_CHOICES,
        null=True,
        blank=True,
        default=NO
    )
    status = models.CharField(max_length=100, null=True, blank=True, default='Active')
    region = models.CharField(max_length=100, null=True, blank=True)
    province = models.CharField(max_length=100, null=True, blank=True)
    city = models.CharField(max_length=100, null=True, blank=True)
    barangay = models.CharField(max_length=100, null=True, blank=True)
    ADMIN, STAFF = 'admin', 'staff'
    TYPE_CHOICES = [(ADMIN, 'Admin'), (STAFF, 'Staff')]
    type = models.CharField(
        max_length=5,
        choices=TYPE_CHOICES,
        default=STAFF
    )
    passkey = models.CharField(max_length=100, null=True, blank=True)
    
    def __str__(self):
        return self.user.username
    
class LawEnforcementAccount(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, primary_key=True)
    first_name = models.CharField(max_length=100)
    middle_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=100)
    YES, NO = 'Yes', 'No'
    VERIFIED_CHOICES = [(YES, 'Yes'), (NO, 'No')]
    verified = models.CharField(
        max_length=3,
        choices=VERIFIED_CHOICES,
        null=True,
        blank=True,
        default=NO
    )
    status = models.CharField(max_length=100, null=True, blank=True, default='Active')
    region = models.CharField(max_length=100, null=True, blank=True)
    province = models.CharField(max_length=100, null=True, blank=True)
    station = models.CharField(max_length=100, null=True, blank=True)
    type = models.CharField(max_length=20, default='law_enforcement')
    passkey = models.CharField(max_length=100, null=True, blank=True)
    
    def __str__(self):
        return self.user.username
    
class SWDOaccount(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, primary_key=True)
    name = models.CharField(max_length=100)
    status = models.CharField(max_length=100, null=True, blank=True, default='Active')
    type = models.CharField(max_length=20, default='SWDO')
    
    def __str__(self):
        return self.user.username
    
class PoliceStations(models.Model):
    name = models.CharField(max_length=255)
    province = models.CharField(max_length=100)
    region = models.CharField(max_length=50)

    def __str__(self):
        return self.name

class Passkey_Reset(models.Model):
    email = models.CharField(max_length=250, null=True, blank=True)
    status = models.CharField(max_length=250, null=True, blank=True)
    date = models.DateTimeField(default=timezone.now)

class Email(models.Model):
    email = models.EmailField()
    host = models.CharField(max_length=250)
    port = models.PositiveBigIntegerField()
    password = models.CharField(max_length=250)

    def __str__(self):
        return f"Email: {self.email} - Host: {self.host} - Port: {self.port}"
    
class Recaptcha(models.Model):
    site_key = models.CharField(max_length=150)
    secret_key = models.CharField(max_length=150)

    def __str__(self):
        return f"Site key: {self.site_key} - Secret key: {self.secret_key}"

class Twilio(models.Model):
    account_sid = models.CharField(max_length=50)
    auth_token = models.CharField(max_length=50)
    phone_number = models.CharField(max_length=20, null=True, blank=True)
    type = models.CharField(max_length=20, null=True, blank=True)
    TYPE_CHOICES = [
        ('local', 'Local'),
        ('deployed', 'Deployed'),
    ]
    account_type = models.CharField(
        max_length=20,
        choices=TYPE_CHOICES,
        default='local',
        null=False,
        blank=False
    )

    def __str__(self):
        return f"Account SID: {self.account_sid} - From contact: {self.phone_number}"