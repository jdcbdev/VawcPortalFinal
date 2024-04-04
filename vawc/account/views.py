from django.shortcuts import render
from django.utils import timezone
from django.http import JsonResponse
from django.core.mail import send_mail 
from django.conf import settings

from account.models import *
from case.models import *
from pages.views import *

import secrets
import string

# Create your views here.
def request_passkey (request):
  email = request.POST.get('requester')
  
  existing_passkey_reset = Passkey_Reset.objects.filter(email=email, status="pending").exists()

  message = ''
  
  if existing_passkey_reset:
    message =  "Passkey reset request already exists for the email with status 'Pending'"
  else:
    message = 'Passkey request created successfully.'
    passkey_reset_instance = Passkey_Reset(
              email=email,
              status='pending',
              date=timezone.now()
    )
    passkey_reset_instance.save()
    
    # Retrieve all admin accounts
    admin_accounts = Account.objects.filter(type='admin')
    
    # Loop through each admin account and send notification
    for admin_account in admin_accounts:
        receiver = admin_account.user.email
        message = f"Passkey reset request from email: {email}."
        link = request.build_absolute_uri('/admin-vawc/manage/passkey/')
        print('link:', link)

        # Send notification
        send_notification(message, link, receiver)
    

  return JsonResponse({'success': True, 'message': message})

def update_passkey(request):
  email = request.POST.get('email')
  action = request.POST.get('action')
  
  if action == "approve":
    status = "approved"
    passkey = generate_passkey()
    message = "Your new passkey is " + passkey
    
    receiver = email
    message_notif = f"New Passkey is sent to your Email."
    link = request.build_absolute_uri('/admin-barangay-vawc/settings/')
    print('link:', link)

    # Send notification
    send_notification(message_notif, link, receiver)
    
    user = CustomUser.objects.filter(email=email).first()  # Or use .get() if you expect only one object to match the filter
    account = user.account

    account.passkey = passkey
    account.save()
  else:
    status = "declined"
    message = "Unfortunately, your request for new passkey is " + status
    receiver = email
    link = request.build_absolute_uri('/admin-barangay-vawc/settings/')
    print('link:', link)

    # Send notification
    send_notification(message, link, receiver)

  subject = "Request for new passkey is " + status
  send_email(email, subject, message)
  Passkey_Reset.objects.filter(email=email).update(status=status)

  return JsonResponse({'success': True})

def send_email(receiver, subject, message):
    send_mail(subject, message, settings.DEFAULT_FROM_EMAIL, [receiver])
  
def generate_passkey(length=12):
    """Generate a random passkey containing only letters."""
    # Define the character set for generating passkey (only letters)
    characters = string.ascii_letters
    
    # Generate a random passkey using secrets.choice()
    passkey = ''.join(secrets.choice(characters) for _ in range(length))
    
    return passkey