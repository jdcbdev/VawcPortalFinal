from django.shortcuts import render, redirect, get_object_or_404
from django.http import JsonResponse, HttpResponseNotFound, QueryDict, HttpResponse, HttpResponseRedirect, HttpResponseBadRequest
from django.contrib.auth import authenticate, login, logout, update_session_auth_hash, get_user_model
from django.contrib import messages
from django.views.decorators.http import require_POST
from django.db.models import Max, Q, Count
from django.db.models.functions import ExtractYear
from django.core.files.storage import FileSystemStorage
import os
from django.contrib import auth
from django.conf import settings
import uuid
from django.core.mail import send_mail, EmailMultiAlternatives 
from django.template.loader import render_to_string
import random
import string
from django.utils import timezone
from django.core.serializers.json import DjangoJSONEncoder
from django.contrib.auth.decorators import login_required, permission_required
from django.template.loader import render_to_string
import json
from django.core.exceptions import ObjectDoesNotExist
from django.urls import reverse
from datetime import timedelta
from django.contrib.auth.tokens import default_token_generator
from django.utils.crypto import get_random_string
from django.contrib.auth.models import User
from weasyprint import HTML
from django.template import loader
from collections import defaultdict
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.utils.encoding import force_bytes, force_str
from django.contrib.auth.hashers import make_password
from account.utils import *
import requests
from twilio.rest import Client
# Create your views here.

from .utils import encrypt_data, decrypt_data
import base64
import random
import string
import json
import datetime

#models
from case.models import *
from account.models import *
from .forms import *
from ph_geography.models import Region, Province, Municipality, Barangay

def home_view (request):
    if request.user.is_authenticated:
        if hasattr(request.user, 'account') and request.user.account.type == 'admin':
            return redirect('admin dashboard')
        elif hasattr(request.user, 'account') and request.user.account.type == 'staff':
            return redirect('barangay dashboard')
        
    return render(request, 'landing/home.html')

def address_view (request):
    return render(request, 'address.html')

def error_view (request):
    return render(request, 'landing/error_404.html')

def login_view (request):
    if request.user.is_authenticated:
        if hasattr(request.user, 'account') and request.user.account.type == 'admin':
            return redirect('admin dashboard')
        elif hasattr(request.user, 'account') and request.user.account.type == 'staff':
            return redirect('barangay dashboard')
    
    return render(request, 'login/login.html')

def forgot_pass_view (request):
    return render(request, 'login/forgot-pass.html')

def forgot_pass_confirm_sent_view(request):
    # Retrieve the email from the query parameters
    email = request.GET.get('email')
    print('email: ', email)
    try:
        # Check if the email exists in the CustomUser model
        custom_user = CustomUser.objects.get(email=email)
        
        token = default_token_generator.make_token(custom_user)
        
        # Build the password reset URL
        reset_url = request.build_absolute_uri(reverse('change_password', kwargs={'uidb64': urlsafe_base64_encode(force_bytes(custom_user.pk)), 'token': token}))

        # Send email
        subject = 'Reset Your Password'
        message = f'Click the following link to reset your password: {reset_url}'
        to_email = [custom_user.email]
        send_email(to_email, subject, message)

        # If the email exists, return success response
        return JsonResponse({'success': True, 'message': 'Link has been sent'})
    except ObjectDoesNotExist:
        # If the email does not exist, return error response
        print('not found')
        return JsonResponse({'success': False, 'message': 'Email does not exist'})

def change_password_view(request, uidb64, token):
    try:
        user_id = force_str(urlsafe_base64_decode(uidb64))
        user = CustomUser.objects.get(pk=user_id)
    except (TypeError, ValueError, OverflowError, CustomUser.DoesNotExist):
        return HttpResponseBadRequest('Invalid user ID')

    if not default_token_generator.check_token(user, token):
        return HttpResponseBadRequest('Invalid token')

    return render(request, 'login/forgot-pass-change.html', {'uidb64': uidb64, 'token': token})

def process_change_password(request, uidb64, token):
    try:
        user_id = force_str(urlsafe_base64_decode(uidb64))
        user = CustomUser.objects.get(pk=user_id)
    except (TypeError, ValueError, OverflowError, CustomUser.DoesNotExist):
        return HttpResponseBadRequest('Invalid user ID')

    if not default_token_generator.check_token(user, token):
        return HttpResponseBadRequest('Invalid token')

    if request.method == 'POST':
        new_password1 = request.POST.get('new_password1')
        new_password2 = request.POST.get('new_password2')

        if new_password1 and new_password1 == new_password2:
            # Update user's password
            user.password = make_password(new_password1)
            user.save()

            # Update session authentication hash
            update_session_auth_hash(request, user)

            # Return success response as JsonResponse
            messages.success(request, 'Your password was successfully updated!')
            return redirect('success_reset_password')
        else:
            # Return error response as JsonResponse
            messages.error(request, 'Passwords do not match.')

    return render(request, 'login/forgot-pass-change.html', {'uidb64': uidb64, 'token': token})

def success_reset_view (request):
    return render(request, 'login/forgot-pass-success.html')

def track_case_view (request):
    recaptcha = load_recaptcha_settings()
    twl_settings = load_twilio_settings()
    
    # Safely retrieve 'twilio.type' from the dictionary, providing a default value if not found
    twilio_type = twl_settings.get('twilio_type', 'local')  # Set a fallback value

    # Render the template
    return render(request, 'landing/track_case.html', {
        'site_key': recaptcha.get('site_key', ''),  # Default empty string if not found
        'twilio_type': twilio_type
    })

def check_email_case(request):
    if request.method == 'POST':
        email = request.POST.get('contact', None)  # Get the email from the POST data
        if email:
            # Check if there is any case associated with the given email
            if Case.objects.filter(email=email).exists():
                return JsonResponse({'success': True, 'message': 'There is an Email associated with at least one case.'})
            else:
                return JsonResponse({'success': False, 'message': 'There is no Email associated with any case.'})
        else:
            return JsonResponse({'success': False, 'message': 'No email provided.'})
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request method.'})

def check_phone_case(request):
    if request.method == 'POST':
        phone = request.POST.get('contact', None)  # Get the phone from the POST data
        # checks if phone number is still in invalid format
        if not phone.isdigit() or not len(phone) == 10:
            return JsonResponse({'success': False, 'message': 'Invalid phone number'})
        if phone:
            # Check if there is any case associated with the given email
            if Case.objects.filter(phone=phone).exists():
                return JsonResponse({'success': True, 'message': 'There is a Phone number associated with at least one case.'})
            else:
                return JsonResponse({'success': False, 'message': 'No Account Associated with any Case.'})
        else:
            return JsonResponse({'success': False, 'message': 'No phone provided.'})
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request method.'})

# Set expiration time for tokens (30 minutes)
TOKEN_EXPIRATION_TIMEDELTA = timedelta(minutes=1)

def verify_otp_email_track_case(request):
    if request.method == 'POST':
        otp_entered = ''
        for i in range(1, 7):  # Iterate through OTP fields from 1 to 6
            otp_entered += request.POST.get(f'otp_{i}', '')

        otp_saved = request.session.get('otp')
        otp_expiry_str = request.session.get('otp_expiry')
        user_email = request.session.get('user_email')  # Retrieving user email from session
        print(user_email)

        if otp_saved and otp_expiry_str and user_email:  # Check if user_email exists
            otp_expiry = timezone.datetime.fromisoformat(otp_expiry_str)
            if timezone.now() < otp_expiry and otp_entered == otp_saved:
                # Clear session data after successful OTP verification
                request.session.pop('otp')
                request.session.pop('otp_expiry')
                request.session.pop('user_email')
                print('OTP Verified Succesfully, Used Email:', user_email)

                # Generate a unique token for password reset using Django's default_token_generator
                token = generate_token(user_email)

                return JsonResponse({'success': True, 'message': 'OTP verified successfully.', 'user_email': user_email, 'token': token})
            elif timezone.now() >= otp_expiry:
                return JsonResponse({'success': False, 'message': 'OTP has expired.'})
        return JsonResponse({'success': False, 'message': 'Incorrect OTP.', 'user_email': user_email})

def verify_otp_phone_track_case(request):
    if request.method == 'POST':
        otp_entered = ''
        for i in range(1, 7):  # Iterate through OTP fields from 1 to 6
            otp_entered += request.POST.get(f'otp_{i}', '')

        otp_saved = request.session.get('otp')
        otp_expiry_str = request.session.get('otp_expiry')
        user_phone = request.session.get('user_phone')  # Retrieving user phone from session
        print(user_phone)

        if otp_saved and otp_expiry_str and user_phone:  # Check if user_phone exists
            otp_expiry = timezone.datetime.fromisoformat(otp_expiry_str)
            if timezone.now() < otp_expiry and otp_entered == otp_saved:
                # Clear session data after successful OTP verification
                request.session.pop('otp')
                request.session.pop('otp_expiry')
                request.session.pop('user_phone')
                print('OTP Verified Succesfully, Used Phone:', user_phone)

                # Generate a unique token for password reset using Django's default_token_generator
                token = generate_token(user_phone)

                return JsonResponse({'success': True, 'message': 'OTP verified successfully.', 'user_phone': user_phone, 'token': token})
            elif timezone.now() >= otp_expiry:
                return JsonResponse({'success': False, 'message': 'OTP has expired.'})
        return JsonResponse({'success': False, 'message': 'Incorrect OTP.', 'user_phone': user_phone})

def generate_token(user_email):
    # Create a temporary user object with the email address
    temp_user = User(email=user_email)
    # Generate a unique token for password reset using Django's default_token_generator
    token = default_token_generator.make_token(temp_user)
    # Get current timestamp
    timestamp = timezone.now()
    return token

def track_case_info_view(request, contact_type, user_contact, token):
    try:
        # Create a temporary user object with the email address
        temp_user = None
        if contact_type == 'email':
            temp_user = User(email=user_contact)
        elif contact_type == 'phone':
            temp_user = User(email=user_contact)

    except User.DoesNotExist:
        return redirect('error_view')

    # Check if the token is valid for the temporary user
    if not default_token_generator.check_token(temp_user, token):
        return redirect('error_view')

    # Fetch cases related to the user_contact and prefetch related status history
    cases = None
    if contact_type == 'email':
        cases = Case.objects.filter(email=user_contact).prefetch_related('status_history')
    elif contact_type == 'phone':
        print('contact type: phone')
        cases = Case.objects.filter(phone=user_contact).prefetch_related('status_history')

    print(cases)
    # Token is valid, render the template
    return render(request, 'landing/track_case_info.html', {'contact_type': contact_type, 'user_contact': user_contact, 'token': token, 'cases': cases})

@login_required
def logout_view(request):
    logout(request)
    return redirect(reverse('login'))

@login_required
def admin_dashboard_view (request):
    if request.user.account.type != 'admin':
        return redirect('login')
    
    year_list = Case.objects.annotate(year=ExtractYear('date_added')).values_list('year', flat=True).distinct()

    return render (request, 'super-admin/dashboard.html', {"year_list": year_list})

@login_required
def admin_case_view(request):
    if request.user.account.type != 'admin':
        return redirect('login')
    
    logged_in_user = request.user  # Retrieve the logged-in user
    # Retrieve the Account object associated with the logged-in user
    try:
        account = logged_in_user.account
        barangay = 'All'
    except Account.DoesNotExist:
        barangay = None
    cases = Case.objects.all()  # Retrieve all cases from the database
    
    filtered_cases = []
    
    for case in cases:
        filtered_cases.append(case)   
    
    return render(request, 'super-admin/case/case.html', {
        'cases': filtered_cases,
        'global': request.session,
        'logged_in_user': logged_in_user,
        'barangay': barangay,
    })

def admin_dashboard_data (request, get_year):
    if request.method != 'GET':
        return JsonResponse({'success': False, 'message': 'Invalid request method'})
    
    if get_year == 0:
        cases = Case.objects.prefetch_related('victim_set', 'perpetrator')
    else:
        cases = Case.objects.prefetch_related('victim_set', 'perpetrator').filter(date_added__year = get_year)

    total_cases = cases.count() or 0
    ongoing_cases = cases.filter(status='Active').count() or 0
    resolved_cases = cases.filter(status='Close').count() or 0
    cases_per_geography = []
    services_provided = 0
    bpo_count = 0
    tpo_count = 0
    ppo_count = 0
    ra_9262 = 0
    ra_8353 = 0
    ra_7877 = 0
    ra_7610 = 0
    ra_9775 = 0
    annual_cases = defaultdict(lambda:defaultdict(int))
    cases_w_criminal_cases = 0
    cases_list = []
    all_months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    for month_temp in all_months:
        annual_cases[month_temp] = 0     
    
    # Iterate through filtered cases
    for case in cases:

        # count all the services of resolved case
        if (case.status == 'Close'):
            services_provided += (case.psychosocial_services + case.emergency_shelter + case.economic_assistance + case.provision_of_appropriate_medical_treatment + case.issuance_of_medical_certificate + case.medico_legal_exam + case.rescue_operations_of_vaw_cases + case.forensic_interview_and_investigation + case.enforcement_of_protection_order + case.refers_to_other_service_provider)

        # count bpo, tpo, ppo
        if case.service_information == 'issuance':
            bpo_count += 1
            if case.enforcement_of_protection_order:
                ppo_count += 1
            else:
                tpo_count += 1
                
        # if case.enforcement_of_protection_order == 1 and case.service_information == 'issuance':
        #     ppo_count += 1
        # elif(case.service_information == 'issuance'):
        #     tpo_count += 1

        # count RAs
        ra_9262 += case.checkbox_ra_9262
        ra_8353 += case.checkbox_ra_8353
        ra_7877 += case.checkbox_ra_7877
        ra_7610 += case.checkbox_a_7610
        ra_9775 += case.checkbox_ra_9775
        
        # no of cases with criminal case
        if case.checkbox_ra_9262 or case.checkbox_ra_8353 or case.checkbox_ra_7877 or case.checkbox_a_7610 or case.checkbox_ra_9775:
            cases_w_criminal_cases += 1
        
        # increment case count per month    
        month = case.date_added.strftime('%b')
        annual_cases[month] += 1
        
        # if get_year:
        #     case_dict_data = Case.objects.filter(date_added__year=get_year, id=case.id).values().first()
        # else:
        #     case_dict_data = Case.objects.filter(id=case.id).values().first()
        case_dict_data = {
            'case_number': case.case_number,
            'date_added': case.date_added,
            'barangay': case.barangay,
            'city': case.city,
            'province': case.province,
            'checkbox_ra_8353': case.checkbox_ra_8353,
            'checkbox_ra_9262': case.checkbox_ra_9262,
            'checkbox_ra_7877': case.checkbox_ra_7877,
            'checkbox_ra_9775': case.checkbox_ra_9775,
            'checkbox_a_7610': case.checkbox_a_7610,
        }
        case_dict = {
            'data': case_dict_data,
            'victims': list(case.victim_set.values()),
            'perpetrators': list(case.perpetrator.values())
        }
        cases_list.append(case_dict)


        # Count the number of impacted and behalf cases
        # impacted_count = len(list(filter(lambda case: case.type_of_case == Case.TYPE_IMPACTED_VICTIM, cases)))
        # behalf_count = len(list(filter(lambda case: case.type_of_case == Case.TYPE_REPORTING_BEHALF, cases)))
        #bpo_count = len(list(filter(lambda case: case.service_information == Case.ISSUANCE_ENFORCEMENT, cases)))
    
    # Get all provinces within the region
    provinces = Province.objects.filter(region_id=10) # 10 is region 9
    for province in provinces:
        if get_year:
            province_case_count = Case.objects.filter(date_added__year=get_year, province=province.name).count() 
        else:
            province_case_count = Case.objects.filter(province=province.name).count()
            
        if province_case_count == 0:
            continue

        province_data = {
            'name': province.name,
            'count': province_case_count,
            'cities': []
        }

        # Get all cities within the province
        cities = Municipality.objects.filter(province=province)
        for city in cities:
            if get_year:
                city_case_count = Case.objects.filter(date_added__year=get_year, city=city.name).count()
            else:
                city_case_count = Case.objects.filter(city=city.name).count()
                
            if city_case_count == 0:
                continue

            city_data = {
                'name': city.name,
                'count': city_case_count,
                'barangays': []
            }

            # Get all barangays within the city
            barangays = Barangay.objects.filter(municipality=city)
            for barangay in barangays:
                if get_year:
                    barangay_case_count = Case.objects.filter(date_added__year=get_year, barangay=barangay.name, city=city.name).count()
                else:
                    barangay_case_count = Case.objects.filter(barangay=barangay.name, city=city.name).count()

                if barangay_case_count == 0:
                    continue

                barangay_data = {
                    'name': barangay.name,
                    'count': barangay_case_count
                }
                city_data['barangays'].append(barangay_data)

            province_data['cities'].append(city_data) # Add list of cities in province_data

        cases_per_geography.append(province_data) # Add province_data to list of provinces


    republic_acts = {
        'RA 9262': ra_9262,
        'RA 8353': ra_8353,
        'RA 7877': ra_7877,
        'RA 7610': ra_7610,
        'RA 9775': ra_9775
    }


    return JsonResponse({
        # 'cases': cases,
        'total_cases': total_cases,
        'ongoing_cases': ongoing_cases,
        'resolved_cases': resolved_cases,
        'services_provided': services_provided,
        'ppo_count': ppo_count,
        'tpo_count': tpo_count,
        'bpo_count': bpo_count,
        'cases_w_criminal_cases': cases_w_criminal_cases,
        'cases_per_geography': cases_per_geography,
        'republic_acts': republic_acts,
        'annual_cases': annual_cases,
        'cases_list': cases_list,
    })

@login_required
def admin_manage_passkey_view (request):
    pending_passkeys = Passkey_Reset.objects.filter(status="pending")
    return render(request, 'super-admin/passkey.html', {'request': pending_passkeys})

@login_required
def admin_manage_account_view(request):
    # Emails to exclude
    excluded_emails = ['admin@gmail.com', 'vawcdilg@gmail.com']

     # default/initial data to use when page loads
    region_id = 10 # region 9
    province_id = 50 # zamboanga del sur
    municipality_id = 1133 # zamboanga city
    
    # Exclude the specified emails from the queryset
    users = CustomUser.objects.exclude(email__in=excluded_emails)
    accounts = Account.objects.filter(user__in=users)
    
    return render(request, 'super-admin/account.html', {
        'users': users,
        'accounts': accounts,
        'default_regions': Region.objects.filter(id=region_id),
        'default_provinces': Province.objects.filter(region_id=region_id),
        'default_cities': Municipality.objects.filter(province_id=province_id),
        'default_barangays': Barangay.objects.filter(municipality_id=municipality_id),

    })


def edit_account_view(request, account_id):
    if request.method == 'GET':
        try: 
            
            

            print(account_id)
            account = get_object_or_404(Account, user__id=account_id)
            regions = list(Region.objects.filter(name=account.region).values())
            provinces = list(Province.objects.filter(region_id = Province.objects.filter(name=account.province).values('region_id').first()['region_id']).values())
            cities = list(Municipality.objects.filter(province_id = Municipality.objects.filter(name=account.city).values('province_id').first()['province_id']).values())
            barangays = list(Barangay.objects.filter(municipality_id = Barangay.objects.filter(name=account.barangay).values('municipality_id').first()['municipality_id']).values())
            

            return JsonResponse({
                'success': True,
                'account_id': account_id,               
                'first_name': account.first_name,
                'middle_name': account.middle_name,
                'last_name': account.last_name,
                'status': account.status,
                'region': account.region,
                'province': account.province,
                'city': account.city,
                'barangay': account.barangay,
                'default_regions': regions,
                'default_provinces': provinces,
                'default_cities': cities,
                'default_barangays': barangays,
            })
        except Account.DoesNotExist:
            return JsonResponse({'success': False, 'message': 'Account not found'})
        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)})
    elif request.method == 'POST':
        try:
            account = get_object_or_404(Account, user__id=account_id)
            account.first_name = request.POST.get('edit_account_fname')
            account.middle_name = request.POST.get('edit_account_mname') 
            account.last_name = request.POST.get('edit_account_lname')
            account.status = request.POST.get('edit_status')
            account.region = request.POST.get('edit_account_region')
            account.province = request.POST.get('edit_account_province')
            account.city = request.POST.get('edit_account_city')
            account.barangay = request.POST.get('edit_account_barangay')
            account.save()
            return JsonResponse({'success': True, 'message': 'Account updated successfully'})
        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)})

@login_required
def delete_account(request):
    if request.method == 'POST':
        account_id = request.POST.get('account_id')
        try:
            # Retrieve the CustomUser object
            account = CustomUser.objects.get(id=account_id)
            # Delete the account
            account.delete()
            return JsonResponse({'success': True, 'message': 'Account deleted successfully'})
        except CustomUser.DoesNotExist:
            return JsonResponse({'success': False, 'message': 'Account not found'}, status=404)
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request'}, status=400)

def generate_random_password(length=8):
    """Generate a random password with specified length."""
    characters = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(characters) for _ in range(length))

@login_required
def create_account(request):
    if request.method == 'POST':
        try:
            username = request.POST.get('account_username')
            email = request.POST.get('account_email')
            first_name = request.POST.get('account_fname')
            middle_name = request.POST.get('account_mname')
            last_name = request.POST.get('account_lname')
            region = request.POST.get('account_region')
            province = request.POST.get('account_province')
            city = request.POST.get('account_city')
            barangay = request.POST.get('account_barangay')
            
            print(username, email, first_name, middle_name, last_name, region, province, city, barangay)
            
            try:
                password = generate_random_password()
                passkey = generate_random_password()
                subject = 'Account Creation from VAWC'
                message = (
                    f'--------------------------\n'
                    f'Account Details\n'
                    f'--------------------------\n\n'
                    f'Here is your New Account From VAWC:\n\n'
                    f'Email:  {email}\n'
                    f'Username:  {username}\n'
                    f'Password:  {password}\n\n'
                    f'First Name:  {first_name}\n'
                    f'Middle Name:  {middle_name}\n'
                    f'Last Name:  {last_name}\n\n'
                    f'Region:  {region}\n'
                    f'Province:  {province}\n'
                    f'City/Municipality:  {city}\n'
                    f'Barangay:  {barangay}\n\n'
                    f'--------------------------\n'
                    f'This email was sent automatically. Please do not reply.'
                )
                send_email(email, subject, message)
                # Create the user with provided data using the CustomUser manager
                user = CustomUser.objects.create_user(username=username, email=email, password=password)
                # Create the Account instance and link it to the user
                account = Account.objects.create(
                    user=user,
                    first_name=first_name,
                    middle_name=middle_name,
                    last_name=last_name,
                    region=region, 
                    province=province, 
                    city=city,
                    barangay=barangay
                )
            except:
                pass
            # Return success response
            return JsonResponse({'success': True, 'message': 'Account created successfully'})

        except Exception as e:
            # Return error response if something goes wrong
            return JsonResponse({'success': False, 'error': str(e)}, status=400)

    else:
        # Return error response for unsupported methods
        return JsonResponse({'success': False, 'error': 'Method not allowed'}, status=405)

def check_username_email(request):
    if request.method == 'GET':
        username = request.GET.get('username')
        email = request.GET.get('email')

        # Check if username is taken
        username_taken = CustomUser.objects.filter(username=username).exists()
        # Check if email is taken
        email_taken = CustomUser.objects.filter(email=email).exists()

        response_data = {
            'username_taken': username_taken,
            'email_taken': email_taken
        }

        return JsonResponse(response_data)

@login_required
def admin_graph_view(request):
    user = request.user
    account = user.account
    cases = Case.objects.all()
    victims = Victim.objects.all()
    perpetrators = Perpetrator.objects.all()
    
    total_cases = cases.count()
    total_active = cases.filter(status=Case.STATUS_ACTIVE).count()  # Count active cases
    total_closed = cases.filter(status=Case.STATUS_CLOSE).count()  # Count closed cases
    total_victim = victims.count()
    total_perpetrator = perpetrators.count()

    return render(request, 'super-admin/graph-report.html', {
        'cases': cases,
        'account': account,
        'total_cases': total_cases,
        'total_active': total_active,
        'total_closed': total_closed,
        'total_victim': total_victim,
        'total_perpetrator': total_perpetrator
    })

@login_required
def send_email_report(request):
    email = request.POST.get('email')

    receiver = email

    total_cases = request.POST.get('total_cases') # Replace with actual total cases count
    total_active_cases = request.POST.get('total_active_cases')  # Replace with actual total active cases count
    total_closed_cases = request.POST.get('total_closed_cases')  # Replace with actual total closed cases count
    total_victims = request.POST.get('total_victims')  # Replace with actual total victims count
    total_perpetrators = request.POST.get('total_perpetrators')  # Replace with actual total perpetrators count
    
    print(email, total_cases, total_active_cases, total_closed_cases, total_victims, total_perpetrators)

    subject = 'VAWC Summary Report'
    message = (
        f'--------------------------\n'
        f'VAWC Case Statistics\n'
        f'--------------------------\n\n'
        f'Total Cases Filed: {total_cases}\n'
        f'Total Active Cases: {total_active_cases}\n'
        f'Total Closed Cases: {total_closed_cases}\n'
        f'Total Victims: {total_victims}\n'
        f'Total Perpetrators: {total_perpetrators}\n\n'
        f'--------------------------\n'
        f'This report is generated automatically. Please do not reply.'
    )
    send_email(receiver, subject, message)

    return JsonResponse({'success': True, 'message': 'Sent Succcessfully'})

def update_graph_table_report(request):
    if request.method == 'GET':
        try:
            min_date_str = request.GET.get('min_date')
            max_date_str = request.GET.get('max_date')

            # Convert string dates to datetime objects
            min_date = datetime.strptime(min_date_str, '%m/%d/%Y').strftime('%Y-%m-%d') if min_date_str else None

            # Convert max_date_str to datetime object if it's not empty
            max_date = datetime.strptime(max_date_str, '%m/%d/%Y').strftime('%Y-%m-%d') if max_date_str else None

            temp_case =Case.objects.all()
            total_active = temp_case.filter(status=Case.STATUS_ACTIVE).count()
            print("active:",total_active)
            # Filter cases based on the date range
            if max_date:
                cases = Case.objects.filter(date_added__range=[min_date, max_date])
            else:
                cases = Case.objects.filter(date_added__gte=min_date)

            # Total number of cases
            total_cases = cases.count()

            # Total number of active cases
            active_cases = cases.filter(status=Case.STATUS_ACTIVE).count()

            # Total number of closed cases
            closed_cases = cases.filter(status=Case.STATUS_CLOSE).count()

            # Total number of victims
            total_victims = Victim.objects.filter(case_victim__in=cases).count()

            # Total number of perpetrators
            total_perpetrators = Perpetrator.objects.filter(case_perpetrator__in=cases).count()

            # Construct the JSON response
            response_data = {
                'success': True,
                'total_cases': total_cases,
                'active_cases': active_cases,
                'closed_cases': closed_cases,
                'total_victims': total_victims,
                'total_perpetrators': total_perpetrators
            }
            
            return JsonResponse(response_data)
        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)})
    else:
        pass

def update_graph_report(request):
    if request.method == 'GET':
        try:
            min_date_str = request.GET.get('min_date')
            max_date_str = request.GET.get('max_date')

            # Convert string dates to datetime objects
            min_date = datetime.strptime(min_date_str, '%m/%d/%Y').strftime('%Y-%m-%d') if min_date_str else None

            # Convert max_date_str to datetime object if it's not empty
            max_date = datetime.strptime(max_date_str, '%m/%d/%Y').strftime('%Y-%m-%d') if max_date_str else None

            print("Start Date test:", min_date)
            print("End Date test:", max_date)
            
            # Filter cases based on the date range
            if min_date and max_date:
                cases = Case.objects.filter(date_added__range=[min_date, max_date])
            elif min_date:
                cases = Case.objects.filter(date_added__gte=min_date)
            elif max_date:
                cases = Case.objects.filter(date_added__lte=max_date)
            else:
                cases = Case.objects.all()

            # Aggregate data by date
            date_data = defaultdict(lambda: {'total_cases': 0, 'total_victims': 0, 'total_perpetrators': 0})
            for case in cases:
                date_str = case.date_added.strftime('%m/%d/%Y')
                date_data[date_str]['total_cases'] += 1
                date_data[date_str]['total_victims'] += Victim.objects.filter(case_victim=case).count()
                date_data[date_str]['total_perpetrators'] += Perpetrator.objects.filter(case_perpetrator=case).count()

            # Convert the defaultdict to a list of dictionaries
            date_list = [{'date': date_str, **data} for date_str, data in date_data.items()]

            return JsonResponse({'success': True, 'data': date_list})
        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)})
    else:
        pass
    
# NOTIF
@login_required
def admin_notification_view (request):
    user_account = request.user.account
    notifications = Notification.objects.filter(receiver_account = request.user.email).order_by('-date')

    return render(request, 'barangay-admin/notification.html', {'notifications': notifications})

@login_required
def super_admin_notification_view (request):
    user_account = request.user.account
    notifications = Notification.objects.filter(receiver_account = request.user.email).order_by('-date')

    return render(request, 'super-admin/notification.html', {'notifications': notifications})


# message ="message"
# receiver = get_id_based_barangay(barangay_post)
# send_notification(message, receiver)
# send_notification("Your profile image has been updated", 0)

def send_notification (message, link, receiver):
    # Create a Notification instance
    notification = Notification(
        receiver_account = receiver,
        message = message,
        link = link,
        date = timezone.now()  # Assuming you're using timezone.now() for the date
    )

    # Save the instance to the database
    notification.save()

def read_notification(request):
    if request.method == 'POST':
        notification_id = request.POST.get('id')

    notification = Notification.objects.get(id=notification_id)
    notification.read = True
    notification.save()
    
    # Return JSON response
    return JsonResponse({'success': True, 'message': 'Updated Succesfully.'})

def get_all_notification_barangay(request):
    # Get the current user
    CustomUser = get_user_model()
    current_user = request.user

    # Filter notifications for the current user
    user_notifications = Notification.objects.filter(receiver_account=current_user.email)

    # Check if there are any unread notifications for the current user
    unread_notifications_exist = user_notifications.filter(read=False).exists()

    # Serialize the queryset to JSON
    notifications_list = list(user_notifications.values())

    # Return JSON response with list of dictionaries and flag indicating unread notifications
    return JsonResponse({'notifications': notifications_list, 'unread_notifications_exist': unread_notifications_exist})

def get_all_notification_admin(request):
    # Get the current user
    CustomUser = get_user_model()
    current_user = request.user
    print('admin:',current_user)

    # Filter notifications for the current user
    user_notifications = Notification.objects.filter(receiver_account=current_user.email)

    # Check if there are any unread notifications for the current user
    unread_notifications_exist = user_notifications.filter(read=False).exists()

    # Serialize the queryset to JSON
    notifications_list = list(user_notifications.values())

    # Return JSON response with list of dictionaries and flag indicating unread notifications
    return JsonResponse({'notifications': notifications_list, 'unread_notifications_exist': unread_notifications_exist})

@login_required
def barangay_dashboard_view (request):
    if request.user.account.type != 'staff':
        return redirect('login')
    
    logged_in_user = request.user  # Retrieve the logged-in user
    # Retrieve the Account object associated with the logged-in user
    try:
        account = logged_in_user.account
        barangay = account.barangay
    except Account.DoesNotExist:
        barangay = None

    print(barangay)

    year_list = Case.objects.filter(barangay=barangay).annotate(year=ExtractYear('date_added')).values_list('year', flat=True).distinct()

    return render(request, 'barangay-admin/dashboard.html', {"year_list": year_list, "barangay": barangay})

def barangay_dashboard_data(request, get_year):
    if request.method != 'GET':
        return JsonResponse({'success': False, 'message': 'Invalid request method'})

    logged_in_user = request.user  # Retrieve the logged-in user
    # Retrieve the Account object associated with the logged-in user
    try:
        account = logged_in_user.account
        barangay = account.barangay
    except Account.DoesNotExist:
        barangay = None
    
    if get_year == 0:
        cases = Case.objects.prefetch_related('victim_set', 'perpetrator').filter(barangay=barangay)
    else:
        cases = Case.objects.prefetch_related('victim_set', 'perpetrator').filter( barangay=barangay, date_added__year = get_year)

    
    total_cases = cases.count() or 0
    ongoing_cases = cases.filter(status='Active').count() or 0
    resolved_cases = cases.filter(status='Close').count() or 0
    services_provided = 0
    bpo_count = 0
    tpo_count = 0
    ppo_count = 0
    ra_9262 = 0
    ra_8353 = 0
    ra_7877 = 0
    ra_7610 = 0
    ra_9775 = 0
    annual_cases = defaultdict(lambda:defaultdict(int))
    cases_w_criminal_cases = 0
    barangay_case_list = []
    all_months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    for month_temp in all_months:   
        annual_cases[month_temp] = 0

    # Iterate through filtered cases
    for case in cases:

        # count all the services of resolved case
        if (case.status == 'Close'):
            services_provided += (case.psychosocial_services + case.emergency_shelter + case.economic_assistance + case.provision_of_appropriate_medical_treatment + case.issuance_of_medical_certificate + case.medico_legal_exam + case.rescue_operations_of_vaw_cases + case.forensic_interview_and_investigation + case.enforcement_of_protection_order + case.refers_to_other_service_provider)

        # count bpo, tpo, ppo
        if case.service_information == 'issuance':
            bpo_count += 1
            if case.enforcement_of_protection_order:
                ppo_count += 1
            else:
                tpo_count += 1

         # count RAs
        ra_9262 += case.checkbox_ra_9262
        ra_8353 += case.checkbox_ra_8353
        ra_7877 += case.checkbox_ra_7877
        ra_7610 += case.checkbox_a_7610
        ra_9775 += case.checkbox_ra_9775

        # no of cases with criminal case
        if case.checkbox_ra_9262 or case.checkbox_ra_8353 or case.checkbox_ra_7877 or case.checkbox_a_7610 or case.checkbox_ra_9775:
            cases_w_criminal_cases += 1

        # increment case count per month    
        month = case.date_added.strftime('%b') 
        annual_cases[month] += 1

        case_dict_data = {
            'case_number': case.case_number,
            'date_added': case.date_added,
            'barangay': case.barangay,
            'city': case.city,
            'province': case.province,
            'checkbox_ra_8353': case.checkbox_ra_8353,
            'checkbox_ra_9262': case.checkbox_ra_9262,
            'checkbox_ra_7877': case.checkbox_ra_7877,
            'checkbox_ra_9775': case.checkbox_ra_9775,
            'checkbox_a_7610': case.checkbox_a_7610,
        }
        case_dict = {
            'data': case_dict_data,
            'victims': list(case.victim_set.values()),
            'perpetrators': list(case.perpetrator.values())
        }
        barangay_case_list.append(case_dict)



    republic_acts = {
        'RA 9262': ra_9262,
        'RA 8353': ra_8353,
        'RA 7877': ra_7877,
        'RA 7610': ra_7610,
        'RA 9775': ra_9775
    }

    return JsonResponse({
        #'cases': filtered_cases,
        'total_cases': total_cases,
        'ongoing_cases': ongoing_cases,
        'resolved_cases': resolved_cases,
        'services_provided': services_provided,
        'bpo_count': bpo_count,
        'ppo_count': ppo_count,
        'tpo_count': tpo_count,
        'cases_w_criminal_cases': cases_w_criminal_cases,
        'republic_acts': republic_acts,
        'annual_cases': annual_cases,
        'barangay_case_list': barangay_case_list,
        # 'logged_in_user': logged_in_user,
        # 'email' : logged_in_user.email,
        'barangay': barangay,
        # 'global': request.session,
    })

def calculate_age(date_of_birth_str):
    try:
        date_of_birth = datetime.strptime(date_of_birth_str, '%Y-%m-%d')
        today = datetime.now()
        age = today.year - date_of_birth.year - ((today.month, today.day) < (date_of_birth.month, date_of_birth.day))
        return age
    except ValueError:
        return None

@login_required
def barangay_settings_view (request):
    if request.user.account.type != 'staff':
        return redirect('login')
    
    logged_in_user = request.user
    
    return render(request, 'barangay-admin/settings.html', {'global': request.session, 'logged_in_user': logged_in_user})

@login_required
def admin_settings_view (request):
    if request.user.account.type != 'admin':
        return redirect('login')
    
    logged_in_user = request.user
    
    return render(request, 'super-admin/settings.html', {'global': request.session, 'logged_in_user': logged_in_user})

@login_required
def custom_password_change_view(request):
    if request.method == 'POST':
        form = CustomPasswordChangeForm(request.user, request.POST)
        if form.is_valid():
            user = form.save()
            update_session_auth_hash(request, user)
            messages.success(request, 'Your password was successfully updated!')
            return JsonResponse({'success': True})
        else:
            messages.error(request, 'Please correct the error below.')
            errors = dict(form.errors)
            return JsonResponse({'success': False, 'errors': errors})

@login_required
def barangay_case_view(request):
    if request.user.account.type != 'staff':
        return redirect('login')
    
    logged_in_user = request.user  # Retrieve the logged-in user
    # Retrieve the Account object associated with the logged-in user
    try:
        account = logged_in_user.account
        barangay = account.barangay
    except Account.DoesNotExist:
        barangay = None
    cases = Case.objects.all()  # Retrieve all cases from the database
    
    filtered_cases = []
    
    for case in cases:
        if case.barangay == barangay:
            filtered_cases.append(case)
    
    return render(request, 'barangay-admin/case/case.html', {
        'cases': filtered_cases,
        'global': request.session,
        'logged_in_user': logged_in_user,
        'barangay': barangay,
    })

def send_otp_email(email, otp):
    subject = 'One-Time Password Verification'
    message = (
        f'--------------------------\n'
        f'One-Time Password Verification\n'
        f'--------------------------\n\n'
        f'Your One-Time Password (OTP) is: {otp}\n\n'
        f'Please use this OTP to verify your account.\n\n'
        f'This OTP will expire in 5 minutes.\n\n'
        f'--------------------------\n'
        f'This email was sent automatically. Please do not reply.'
    )
    load_settings()
    send_mail(subject, message, settings.DEFAULT_FROM_EMAIL, [email])

def send_otp_phone(phone, otp):
    message = (
        # f'One-Time Password Verification\n\n'
        # f'Your One-Time Password (OTP) is: {otp}\n'
        # f'Please use this OTP to verify your account.\n'
        # f'This OTP will expire in 5 minutes.\n'
        f'Your VAWC One-Time Password (OTP) code is: {otp}\n'
        # f'Please use this OTP to verify your account.\n'
    )
    send_phone(phone, message)
    
def send_email(receiver, subject, message):
    load_settings()
    send_mail(subject, message, settings.DEFAULT_FROM_EMAIL, [receiver])

def send_phone(receiver, message_body):
    load_twilio_settings()
    account_sid = settings.TWILIO_ACCOUNT_SID
    auth_token = settings.TWILIO_AUTH_TOKEN
    client = Client(account_sid, auth_token)

    message = client.messages.create(
    from_= settings.TWILIO_PHONE_NUMBER,
    body= message_body,
    to=f'+63{receiver}'
    )
    print(message.sid)

def generate_otp():
    return ''.join(random.choices(string.digits, k=6))

def login_with_otp(request):
    if request.method == 'POST':
        email = request.POST.get('barangay-email')
        passkey = request.POST.get('barangay-passkey')
        # Check if the user exists
        user = CustomUser.objects.filter(email=email).first()
        if user:
            if user.account.status == 'Not Active':
                return JsonResponse({'success': False, 'message': 'Account is Not Active Anymore'})
            # Validate passkey
            user_authenticated = authenticate(request, username=email, password=passkey)
            if user_authenticated:
                otp = generate_otp()
                request.session['otp'] = otp
                request.session['user_email'] = email  # Store user email in session for later retrieval
                otp_expiry = timezone.now() + timezone.timedelta(minutes=1)
                request.session['otp_expiry'] = otp_expiry.isoformat()  # Convert datetime to string
                send_otp_email(email, otp)
                return JsonResponse({'success': True, 'message': 'OTP has been sent to your email.'})
            else:
                print('Invalid passkey. Please try again.')
                return JsonResponse({'success': False, 'message': 'Invalid password. Please try again.'})
        else:
            print('Account not found.')
            return JsonResponse({'success': False, 'message': 'Account not found.'})
    return render(request, 'login/login.html')

def verify_otp(request):
    if request.method == 'POST':
        otp_entered = ''
        for i in range(1, 7):  # Iterate through OTP fields from 1 to 6
            otp_entered += request.POST.get(f'otp_{i}', '')

        otp_saved = None
        otp_expiry_str = None

        # Check all possible OTP fields
        for i in range(1, 4):  # Adjust the range based on your maximum OTP fields
            otp_saved = request.session.get('otp')
            otp_expiry_str = request.session.get('otp_expiry')
            user_email = request.session.get('user_email')
            print(user_email)
            if otp_saved and otp_expiry_str:
                otp_expiry = timezone.datetime.fromisoformat(otp_expiry_str)
                if timezone.now() < otp_expiry and otp_entered == otp_saved:
                    user = CustomUser.objects.filter(email=user_email).first()
                    if user:
                        login(request, user)  # Logging in the user
                        request.session.pop('otp')
                        request.session.pop('otp_expiry')
                        request.session.pop('user_email')

                        # Fetch the account type of the user
                        account_type = Account.objects.filter(user=user).first().type

                        # Print a success message
                        print("User logged in successfully")
                        print(account_type)

                        request.session['security_status'] = "decrypted"
                        print(request.session['security_status'])

                        # Return success along with account type
                        return JsonResponse({'success': True, 'message': 'Login successful.', 'account_type': account_type, 'otp_expiry': otp_expiry_str})
                    else:
                        return JsonResponse({'success': False, 'message': 'User not found.'})
                elif timezone.now() >= otp_expiry:
                    return JsonResponse({'success': False, 'message': 'Code is already expired.', 'otp_expiry': otp_expiry_str})
                else:
                    break
        # If OTP is incorrect
        return JsonResponse({'success': False, 'message': 'OTP Inputted is not Correct.', 'otp_expiry': otp_expiry_str})

    return JsonResponse({'success': False, 'message': 'Invalid request.'}, encoder=DjangoJSONEncoder)

def resend_otp(request):
    if request.method == 'GET':
        user_email = request.session.get('user_email')  # Corrected key
        if user_email:
            try:
                user = CustomUser.objects.get(email=user_email)
                otp = generate_otp()  # Assuming you have a function to generate OTP
                request.session['otp'] = otp
                otp_expiry = timezone.now() + timezone.timedelta(minutes=1)
                request.session['otp_expiry'] = otp_expiry.isoformat()
                send_otp_email(user_email, otp)  # Assuming you have a function to send OTP email
                return JsonResponse({'success': True, 'message': 'OTP resent successfully.'})
            except ObjectDoesNotExist:
                return JsonResponse({'success': False, 'message': 'User not found.'})
        else:
            return JsonResponse({'success': False, 'message': 'User email not found in session.'})
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request method.'})

def email_confirm(request):
    if request.method == 'POST':

        # reCAPTCHA server side validation
        recaptcha_response = request.POST.get('g-recaptcha-response')
        data = {
            'secret': settings.RECAPTCHA_SECRET_KEY,
            'response': recaptcha_response
        }
        r = requests.post('https://www.google.com/recaptcha/api/siteverify', data=data)
        result = r.json()
        # return JsonResponse({'result': result})
        if not result['success']:
            return JsonResponse({'success': False, 'message': 'reCAPTCHA validation failed, please try again'})
        
        email = request.POST.get('contactConfirm')
        print('Email Inputted:',email)

        otp = generate_otp()
        request.session['otp'] = otp
        request.session['user_email'] = email  # Store user email in session for later retrieval
        otp_expiry = timezone.now() + timezone.timedelta(minutes=1)
        request.session['otp_expiry'] = otp_expiry.isoformat()  # Convert datetime to string
        send_otp_email(email, otp)
        return JsonResponse({'success': True, 'message': 'OTP has been sent to your email.'})

def phone_confirm(request):
    if request.method == 'POST':

        # reCAPTCHA server side validation
        recaptcha_response = request.POST.get('g-recaptcha-response')
        data = {
            'secret': settings.RECAPTCHA_SECRET_KEY,
            'response': recaptcha_response
        }
        r = requests.post('https://www.google.com/recaptcha/api/siteverify', data=data)
        result = r.json()
        if not result['success']:
            return JsonResponse({'success': False, 'message': 'reCAPTCHA validation failed, please try again'})
        
        phone = request.POST.get('contactConfirm')
        print('Phone Inputted:',phone)

        # checks if phone number is still in invalid format
        if not phone.isdigit() or not len(phone) == 10:
            return JsonResponse({'success': False, 'message': 'Invalid phone number'})

        otp = generate_otp()
        request.session['otp'] = otp
        request.session['user_phone'] = phone  # Store user email in session for later retrieval
        otp_expiry = timezone.now() + timezone.timedelta(minutes=1)
        request.session['otp_expiry'] = otp_expiry.isoformat()  # Convert datetime to string
        print('OTP: ' + otp)

        send_otp_phone(phone, otp)
        return JsonResponse({'success': True, 'message': 'OTP has been sent to your phone number.'})

def verify_otp_email(request):
    if request.method == 'POST':
        otp_entered = ''
        for i in range(1, 7):  # Iterate through OTP fields from 1 to 6
            otp_entered += request.POST.get(f'otp_{i}', '')

        otp_saved = request.session.get('otp')
        otp_expiry_str = request.session.get('otp_expiry')
        user_email = request.session.get('user_email')  # Retrieving user email from session
        print(user_email)

        if otp_saved and otp_expiry_str and user_email:  # Check if user_email exists
            otp_expiry = timezone.datetime.fromisoformat(otp_expiry_str)
            if timezone.now() < otp_expiry and otp_entered == otp_saved:
                # Clear session data after successful OTP verification
                request.session.pop('otp')
                request.session.pop('otp_expiry')
                request.session.pop('user_email')
                return JsonResponse({'success': True, 'message': 'OTP verified successfully.', 'user_email': user_email})
            elif timezone.now() >= otp_expiry:
                return JsonResponse({'success': False, 'message': 'OTP has expired.'})
        return JsonResponse({'success': False, 'message': 'Incorrect OTP.', 'user_email': user_email})

def verify_otp_phone(request):
    if request.method == 'POST':
        otp_entered = ''
        for i in range(1, 7):  # Iterate through OTP fields from 1 to 6
            otp_entered += request.POST.get(f'otp_{i}', '')

        otp_saved = request.session.get('otp')
        otp_expiry_str = request.session.get('otp_expiry')
        user_phone = request.session.get('user_phone')  # Retrieving user email from session
        print(user_phone)

        if otp_saved and otp_expiry_str and user_phone:  # Check if user_email exists
            otp_expiry = timezone.datetime.fromisoformat(otp_expiry_str)
            if timezone.now() < otp_expiry and otp_entered == otp_saved:
                # Clear session data after successful OTP verification
                request.session.pop('otp')
                request.session.pop('otp_expiry')
                request.session.pop('user_phone')
                return JsonResponse({'success': True, 'message': 'OTP verified successfully.', 'user_phone': user_phone})
            elif timezone.now() >= otp_expiry:
                return JsonResponse({'success': False, 'message': 'OTP has expired.'})
        return JsonResponse({'success': False, 'message': 'Incorrect OTP.', 'user_phone': user_phone})

def resend_otp_email(request):
    if request.method == 'GET':
        user_email = request.session.get('user_email')  # Corrected key
        otp = generate_otp()  # Assuming you have a function to generate OTP
        request.session['otp'] = otp
        otp_expiry = timezone.now() + timezone.timedelta(minutes=1)
        request.session['otp_expiry'] = otp_expiry.isoformat()
        send_otp_email(user_email, otp)  # Assuming you have a function to send OTP email
        return JsonResponse({'success': True, 'message': 'OTP resent successfully.'})
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request method.'})
    
def resend_otp_phone(request):
    if request.method == 'GET':
        user_phone = request.session.get('user_phone')  # Corrected key
        otp = generate_otp()  # Assuming you have a function to generate OTP
        request.session['otp'] = otp
        otp_expiry = timezone.now() + timezone.timedelta(minutes=1)
        request.session['otp_expiry'] = otp_expiry.isoformat()
        send_otp_phone(user_phone, otp)  # Assuming you have a function to send OTP phone
        return JsonResponse({'success': True, 'message': 'OTP resent successfully.'})
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request method.'})

def report_violence_view (request):
    return render(request, 'landing/report_violence.html')

def impact_victim_view (request):
    recaptcha = load_recaptcha_settings()
    twl_settings = load_twilio_settings()
    
    # Safely retrieve 'twilio.type' from the dictionary, providing a default value if not found
    twilio_type = twl_settings.get('twilio_type', 'local')  # Set a fallback value

    # default/initial data to use when page loads
    region_id = 10 # region 9
    province_id = 50 # zamboanga del sur
    municipality_id = 1133 # zamboanga city
    
    return render(request, 'landing/case_type/impacted-victim.html', {
        'site_key': recaptcha['site_key'],
        'twilio_type': twilio_type,
        'default_regions': Region.objects.filter(id=region_id),
        'default_provinces': Province.objects.filter(region_id=region_id),
        'default_cities': Municipality.objects.filter(province_id=province_id),
        'default_barangays': Barangay.objects.filter(municipality_id=municipality_id),
        })

def behalf_victim_view (request):
    recaptcha = load_recaptcha_settings()
    twl_settings = load_twilio_settings()
    
    # Safely retrieve 'twilio.type' from the dictionary, providing a default value if not found
    twilio_type = twl_settings.get('twilio_type', 'local')  # Set a fallback value

    # default/initial data to use when page loads
    region_id = 10 # region 9
    province_id = 50 # zamboanga del sur
    municipality_id = 1133 # zamboanga city

    return render(request, 'landing/case_type/behalf-victim.html', {
        'site_key': recaptcha['site_key'],
        'twilio_type': twilio_type,
        'default_regions': Region.objects.filter(id=region_id),
        'default_provinces': Province.objects.filter(region_id=region_id),
        'default_cities': Municipality.objects.filter(province_id=province_id),
        'default_barangays': Barangay.objects.filter(municipality_id=municipality_id),
        })

def add_case(request):
    
    temp_barangay = request.POST.get('incident-barangay')
    temp_type_case = request.POST.get('type_of_case')
    temp_service_info = request.POST.get('service')
    
    print('service:',temp_service_info)
    if request.method == 'POST':
        email = request.POST.get('email-confirmed') or None
        phone = request.POST.get('phone-confirmed') or None
        print('Entered Email:', email)

        # Create a new QueryDict object
        modified_post_data = QueryDict('', mutable=True)

        # Attributes to ignore for encryption
        ignore_key = [
            'type_of_case',
            'victim_count',
            'perpetrator_count',
            'incomplete-date',
            'service',
            'csrfmiddlewaretoken',
            'status_date',
            'date_added'
        ]

        # for key, values in request.POST.lists():
        #     modified_values = []

        #     if key in ignore_key:
        #         for value in values:
        #             modified_values.append(value)
        #     else:
        #         for value in values:
        #             modified_values.append(encrypt_data(value).decode('utf-8'))
        #     modified_post_data.setlist(key, modified_values)

        # request.POST = modified_post_data

        case_data = {
            'case_number': get_next_case_number(),
            'email':email,
            'phone':phone,
            'date_latest_incident': request.POST.get('date-latest-incident'),
            'incomplete_date': request.POST.get('incomplete-date'),
            'place_of_incident': request.POST.get('place-incident'),
            'street': request.POST.get('incident-street'),
            'barangay': request.POST.get('incident-barangay'),
            'province': request.POST.get('incident-province'),
            'city': request.POST.get('incident-city'),
            'region': request.POST.get('incident-region'),
            'description_of_incident': request.POST.get('incident-desc'),
            'service_information': request.POST.get('service'),
            'type_of_case': request.POST.get('type_of_case'),  # Collecting type of case from the form
            'date_added': timezone.now(),
        }
        case_instance = Case.objects.create(**case_data)

        if 'evidence_file' in request.FILES:
            handle_evidence_files(request.FILES.getlist('evidence_file'), case_instance)

        # Get dynamic victim data
        victim_instances = []
        victim_form_prefix = 'victim-'  # Adjust this prefix according to your form field names
        victim_count = int(request.POST.get('victim_count'))  # Assuming you have a hidden input for victim count
        for i in range(victim_count):
            victim_data = get_victim_data(request.POST, prefix=victim_form_prefix, index=i)
            victim_instance = Victim.objects.create(case_victim=case_instance, **victim_data)
            victim_instances.append(victim_instance)

        # Perpetrator data handling
        perpetrator_count = int(request.POST.get('perpetrator_count'))  # Assuming you have a hidden input for perpetrator count
        for i in range(perpetrator_count):
            perpetrator_data = get_perpetrator_data(request.POST, index=i)
            perpetrator_instance = Perpetrator.objects.create(case_perpetrator=case_instance, **perpetrator_data)

        contact_person_data = get_contact_person_data(request.POST)
        contact_person_instance = Contact_Person.objects.create(case_contact=case_instance, **contact_person_data)

        matching_users_emails = []

        # Filter CustomUser objects based on the barangay attribute of associated Account objects
        all_users = CustomUser.objects.all()

        print('case number:',case_instance.case_number)
        # Now you can iterate over all_users and access each user's attributes
        for user in all_users:
            try:
                # Access the associated Account object
                account = user.account

                # Check if the account's barangay matches temp_barangay
                if account.barangay == temp_barangay:
                    # Add the email of the user to the list of matching users
                    matching_users_emails.append(user.email)

            except ObjectDoesNotExist:
                # Handle the case where no associated Account object exists for the user
                print("No associated Account object found for this user.")

        # Now, matching_users_emails contains the email addresses of all users whose associated accounts match temp_barangay
        print("Matching users emails:", matching_users_emails)

        # Iterate over the collected emails and send the notification to each email
        for receiver in matching_users_emails:
            message = "You have a new case (#" + str(case_instance.case_number) + ") awaiting for your attention. The priority is "
            if temp_service_info == "crisis":
                message += "HIGH"
            else:
                message += "LOW"

            try:
                path = f"/admin-barangay-vawc/view-case/{temp_type_case.lower()}/{case_instance.id}/"
                link = request.build_absolute_uri(path)
                print('link:', link)
            except:
                link = request.build_absolute_uri("/admin-barangay-vawc/view-case/")

            send_notification(message, link, receiver)
        
        case_id = str(case_instance.case_number)
        
        receiver = email
        subject = "Submitted Succesfully"
        
        # Generate the track case URL
        track_case_url = f"{request.scheme}://{request.get_host()}{reverse('track_case')}"

        # Message with the dynamic URL
        message = (
            f'--------------------------\n'
            f'Your case #{case_id} has been submitted successfully\n'
            f'--------------------------\n\n'
            f'You can check your case status here:\n'
            f'{track_case_url}\n\n'
            f'--------------------------\n'
            f'This email was sent automatically. Please do not reply.'
        )
        
        send_email(receiver, subject, message)
        
        return JsonResponse({'success': True})
    else:
        return JsonResponse({'success': False, 'error': 'Invalid request method'})

def get_next_case_number():
    latest_case_number = Case.objects.aggregate(Max('case_number'))['case_number__max']
    return 1 if latest_case_number is None else latest_case_number + 1

def handle_evidence_files(files, case_instance):
    for file in files:
        fs = FileSystemStorage(location=settings.MEDIA_ROOT)
        unique_filename = str(uuid.uuid4()) + os.path.splitext(file.name)[-1]
        filename = fs.save(unique_filename, file)
        evidence_instance = Evidence.objects.create(case=case_instance, file=filename)

def get_victim_data(post_data, prefix, index):
    # all "gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==" are replaced with dummy_text
    # dummy_text = '[data-placeholder]'
    dummy_text = ''
    victim_data = {
        'first_name': post_data.get(f'{prefix}firstname_{index}'),
        'middle_name': post_data.get(f'{prefix}middlename_{index}'),
        'last_name': post_data.get(f'{prefix}lastname_{index}'),
        'suffix': post_data.get(f'{prefix}Suffix_{index}'),
        'sex': post_data.get(f'{prefix}sex_{index}'),
        'date_of_birth': post_data.get(f'{prefix}date-of-birth_{index}'),
        'civil_status': post_data.get(f'{prefix}civilstatus_{index}'),
        'nationality': post_data.get(f'{prefix}nationality_{index}'),
        'contact_number': post_data.get(f'{prefix}cellphone_number_{index}'),
        'telephone_number': dummy_text,
        'house_information': post_data.get(f'{prefix}house-info_{index}'),
        'street': post_data.get(f'{prefix}street_{index}'),
        'barangay': post_data.get(f'{prefix}barangay_{index}'),
        'province': post_data.get(f'{prefix}province_{index}'),
        'city': post_data.get(f'{prefix}city_{index}'),
        'educational_attainment': dummy_text,
        'occupation': dummy_text,
        'religion': dummy_text,
        'type_of_disability': dummy_text,
        'region': post_data.get(f'{prefix}region_{index}'),
        'number_of_children': dummy_text,
        'ages_of_children': dummy_text,
    }
    return victim_data

def get_perpetrator_data(post_data, index):
    # all "gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g==" are replaced with dummy_text
    # dummy_text = '[data-placeholder]'
    dummy_text = ''
    perpetrator_data = {
        'first_name': post_data.get(f'perp-firstname_{index}'),
        'middle_name': post_data.get(f'perp-middlename_{index}'),
        'last_name': post_data.get(f'perp-lastname_{index}'),
        'suffix': post_data.get(f'perp-Suffix_{index}'),
        'alias': post_data.get(f'perp-alias_{index}'),
        'sex': post_data.get(f'perp-sex_{index}'),
        'date_of_birth': post_data.get(f'perp-date-of-birth_{index}'),
        'nationality': post_data.get(f'perp-nationality_{index}'),
        'identifying_marks': post_data.get(f'perp-identifying-marks_{index}'),
        'house_information': post_data.get(f'perp-address-info_{index}'),
        'street': post_data.get(f'perp-street_{index}'),
        'barangay': post_data.get(f'perp-barangay_{index}'),
        'province': post_data.get(f'perp-province_{index}'),
        'city': post_data.get(f'perp-city_{index}'),
        'region': post_data.get(f'perp-region_{index}'),
        'educational_attainment': dummy_text,
        'occupation': dummy_text,
        'type_of_disability': dummy_text,
        'civil_status': dummy_text,
        'contact_number': dummy_text,
        'telephone_number': dummy_text,
        'religion': dummy_text,
        'relationship_to_victim': post_data.get(f'perp-relationsip-victim_{index}'),
    }
    return perpetrator_data

def get_contact_person_data(post_data):
    contact_person_data = {
        'first_name': post_data.get('contact-firstname'),
        'middle_name': post_data.get('contact-midname'),
        'last_name': post_data.get('contact-lastname'),
        'suffix': post_data.get('contact-Suffix'),
        'relationship': post_data.get('relationship'),
        'street': post_data.get('contact-street'),
        'barangay': post_data.get('contact-barangay'),
        'city': post_data.get('contact-city'),
        'province': post_data.get('contact-province'),
        'contact_number': post_data.get('contact-number'),
        'telephone_number': post_data.get('contact-tel'),
        'region': post_data.get('contact-region'),
        'bldg_number': post_data.get('contact-bldg-no'),
    }
    return contact_person_data

def add_new_case(request):
    dummy_encrypted = "gAAAAABl-UOp4RWQLPLraFI_q80Ogmfk-Epd8K-CA9zHzYoc1FMwc7tnLv8hTBWTvjlmwjr866FtvBwRZjPXWKBEo3SPvHOU6g=="

    # all dummy_encrypted are replaced with dummy_text
    # dummy_text = '[data-placeholder]'
    dummy_text = ''
    
    if request.method == 'POST':
        email = request.POST.get('email')
        type_of_case = request.POST.get('case_type')
        service_information = request.POST.get('service_type')
        barangay = request.POST.get('barangay')

        print('barangay encrypted:', encrypt_data(barangay))
        print('barangay decrypted:', barangay)
        case_data = {
            'case_number': get_next_case_number(),
            'email': email,
            'date_latest_incident': dummy_text,
            'place_of_incident': dummy_text,
            'street': dummy_text,
            'barangay': barangay,
            'province': dummy_text,
            'city': dummy_text,
            'region': dummy_text,
            'description_of_incident': dummy_text,
            'service_information': service_information,
            'type_of_case': type_of_case,  # Collecting type of case from the form
            'date_added': timezone.now()
        }
        case_instance = Case.objects.create(**case_data)
        
        victim_data = {
            'first_name': dummy_text,
            'middle_name': dummy_text,
            'last_name': dummy_text,
            'suffix': dummy_text,
            'sex': dummy_text,
            'date_of_birth': dummy_text,
            'civil_status': dummy_text,
            'nationality': dummy_text,
            'contact_number': dummy_text,
            'telephone_number': dummy_text,
            'house_information': dummy_text,
            'street': dummy_text,
            'barangay': dummy_text,
            'province': dummy_text,
            'city': dummy_text,
            'educational_attainment': dummy_text,
            'occupation': dummy_text,
            'religion': dummy_text,
            'type_of_disability': dummy_text,
            'region': dummy_text,
            'number_of_children': dummy_text,
            'ages_of_children': dummy_text,
        }
        
        victim_instance = Victim.objects.create(case_victim=case_instance, **victim_data)

        perpetrator_data = {
            'first_name': dummy_text,
            'middle_name': dummy_text,
            'last_name': dummy_text,
            'suffix': dummy_text,
            'alias': dummy_text,
            'sex': dummy_text,
            'date_of_birth': dummy_text,
            'nationality': dummy_text,
            'identifying_marks': dummy_text,
            'house_information': dummy_text,
            'street': dummy_text,
            'barangay': dummy_text,
            'province': dummy_text,
            'city': dummy_text,
            'region': dummy_text,
            'educational_attainment': dummy_text,
            'occupation': dummy_text,
            'type_of_disability': dummy_text,
            'civil_status': dummy_text,
            'contact_number': dummy_text,
            'telephone_number': dummy_text,
            'religion': dummy_text,
            'relationship_to_victim': dummy_text,
        }
     
        perpetrator_instance = Perpetrator.objects.create(case_perpetrator=case_instance, **perpetrator_data)
        
        if type_of_case == 'Behalf':
            contact_person_data = {
                'first_name': dummy_text,
                'middle_name': dummy_text,
                'last_name': dummy_text,
                'suffix': dummy_text,
                'relationship': dummy_text,
                'street': dummy_text,
                'barangay': dummy_text,
                'city': dummy_text,
                'province': dummy_text,
                'contact_number': dummy_text,
                'telephone_number': dummy_text,
                'region': dummy_text,
                'bldg_number': dummy_text,
            }

            contact_person_instance = Contact_Person.objects.create(case_contact=case_instance, **contact_person_data)
        else:
            pass

            # Return the case_id upon successful creation
        return JsonResponse({'success': True, 'case_id': case_instance.id, 'type_of_case': type_of_case})
    #         #return redirect('barangay case') 
    #     except Exception as e:
    #         # Return error response if creation fails
    #         return JsonResponse({'success': False, 'error': str(e)})
    # else:
    #     return HttpResponse("Method not allowed", status=405)

@login_required
def view_admin_case_behalf(request, case_id):
    if request.user.account.type != 'admin':
        return redirect('login')
    
    try:
        # Retrieve the case object from the database based on the case_id
        case = Case.objects.get(id=case_id)
        # Retrieve related objects such as contact persons, evidence, victims, perpetrators, and parents
        contact_persons = Contact_Person.objects.filter(case_contact=case)
        evidences = Evidence.objects.filter(case=case)
        victims = Victim.objects.filter(case_victim=case)
        perpetrators = Perpetrator.objects.filter(case_perpetrator=case)
        status_history = Status_History.objects.filter(case_status_history=case)
        witnesses = Witness.objects.filter(case_witness=case)

        # Retrieve only the latest status history entry
        latest_status_history = status_history.order_by('-status_date_added').first()

        print(request.session['security_status'])

        if request.session['security_status'] == "encrypted":
            case.street = encrypt_data(case.street)
            case.barangay = encrypt_data(case.barangay)
            case.date_latest_incident = encrypt_data(case.date_latest_incident)
            case.place_of_incident = encrypt_data(case.place_of_incident)
            case.province = encrypt_data(case.province)
            case.region = encrypt_data(case.region)
            case.description_of_incident = encrypt_data(case.description_of_incident)
            case.city = encrypt_data(case.city)

            # for victim in victims:
            #     victim.description
            for victim in victims:
                victim.first_name = encrypt_data(victim.first_name)
                victim.middle_name = encrypt_data(victim.middle_name)
                victim.last_name = encrypt_data(victim.last_name)
                victim.suffix = encrypt_data(victim.suffix)
                victim.date_of_birth = encrypt_data(victim.date_of_birth)
                victim.sex = encrypt_data(victim.sex)
                victim.civil_status = encrypt_data(victim.civil_status)
                victim.nationality = encrypt_data(victim.nationality)
                victim.contact_number = encrypt_data(victim.contact_number)
                victim.telephone_number = encrypt_data(victim.telephone_number)
                victim.house_information = encrypt_data(victim.house_information)
                victim.street = encrypt_data(victim.street)
                victim.barangay = encrypt_data(victim.barangay)
                victim.province = encrypt_data(victim.province)
                victim.city = encrypt_data(victim.city)
                victim.region = encrypt_data(victim.region)
                victim.occupation = encrypt_data(victim.occupation)
                victim.number_of_children = encrypt_data(victim.number_of_children)
                victim.ages_of_children = encrypt_data(victim.ages_of_children)
                
                print("Here")
                print(victim.occupation)

            for perpetrator in perpetrators:
                perpetrator.relationship_to_victim = encrypt_data(perpetrator.relationship_to_victim)
                perpetrator.first_name = encrypt_data(perpetrator.first_name)
                perpetrator.middle_name = encrypt_data(perpetrator.middle_name)
                perpetrator.last_name = encrypt_data(perpetrator.last_name)
                perpetrator.suffix = encrypt_data(perpetrator.suffix)
                perpetrator.identifying_marks = encrypt_data(perpetrator.identifying_marks)
                perpetrator.alias = encrypt_data(perpetrator.alias)
                perpetrator.sex = encrypt_data(perpetrator.sex)
                perpetrator.contact_number = encrypt_data(perpetrator.contact_number)
                perpetrator.telephone_number = encrypt_data(perpetrator.telephone_number)
                print(perpetrator.contact_number)
                perpetrator.occupation = encrypt_data(perpetrator.occupation)
                perpetrator.date_of_birth = encrypt_data(perpetrator.date_of_birth)
                perpetrator.nationality = encrypt_data(perpetrator.nationality)
                perpetrator.house_information = encrypt_data(perpetrator.house_information)
                perpetrator.street = encrypt_data(perpetrator.street)
                perpetrator.barangay = encrypt_data(perpetrator.barangay)
                perpetrator.province = encrypt_data(perpetrator.province)
                perpetrator.city= encrypt_data(perpetrator.city)
                perpetrator.region = encrypt_data(perpetrator.region)
            
            for contact_person in contact_persons:
                
                contact_person.first_name = encrypt_data(contact_person.first_name)
                contact_person.middle_name = encrypt_data(contact_person.middle_name)
                contact_person.last_name = encrypt_data(contact_person.last_name)
                contact_person.barangay = encrypt_data(contact_person.barangay)
                contact_person.city = encrypt_data(contact_person.city)
                contact_person.province = encrypt_data(contact_person.province)
                contact_person.telephone_number = encrypt_data(contact_person.telephone_number)
                contact_person.contact_number = encrypt_data(contact_person.contact_number)
                contact_person.street = encrypt_data(contact_person.street)
                contact_person.bldg_number = encrypt_data(contact_person.bldg_number)
                contact_person.relationship = encrypt_data(contact_person.relationship)

                # contact num
                # region
                # street
                # relationship
                # suffix

            # for contact_person in contact_persons:
            #     contact_person.first_name = decrypt_data(contact_person.first_name)
            #     contact_person.middle_name = decrypt_data(contact_person.middle_name)
            #     contact_person.last_name = decrypt_data(contact_person.last_name)
            #     contact_person.suffix = decrypt_data(contact_person.suffix)
            #     contact_person.relationship= decrypt_data(contact_person.relationship)
            #     contact_person.contact_number = decrypt_data(contact_person.contact_number)
            #     contact_person.telephone_number = decrypt_data(contact_person.telephone_number)
            #     contact_person.street = decrypt_data(contact_person.street)
            #     contact_person.city = decrypt_data(contact_person.city)
            #     contact_person.barangay = decrypt_data(contact_person.barangay)
            #     contact_person.province = decrypt_data(contact_person.province)
            #     contact_person.region = decrypt_data(contact_person.region)

        #print(decrypt_data(case.street))
        # if isinstance(encrypted_data_from_db, bytes):
        #     print("Decrypted: ", decrypt_data(encrypted_data_from_db))
        # else:
        #     print("Decrypted: ", decrypt_data())
        
        # for victim in victims:
        #     encryted_value = encrypt_data(victim.first_name)
        #     print("Encrypted: ", encryted_value)
        #     print("Decrypted: ", decrypt_data(encryted_value))

        # Render the view-case.html template with the case and related objects as context
        
        region_id = 10 # region 9
        province_id = 50 # zamboanga del sur
        municipality_id = 1133 # zamboanga city
        
        return render(request, 'super-admin/case/view-case-behalf.html', {
            'case': case,
            'contact_persons': contact_persons,
            'evidence': evidences,
            'victims': victims,
            'perpetrators': perpetrators,
            'status_histories': status_history,
            'witnesses': witnesses,
            'latest_status_history': latest_status_history,
            'global': request.session,
            'default_regions': Region.objects.filter(id=region_id),
            'default_provinces': Province.objects.filter(region_id=region_id),
            'default_cities': Municipality.objects.filter(province_id=province_id),
            'default_barangays': Barangay.objects.filter(municipality_id=municipality_id),
        })
    except Case.DoesNotExist:
        # Handle case not found appropriately, for example, return a 404 page
        return HttpResponseNotFound("Case not found")

@login_required
def view_admin_case_impact(request, case_id):
    if request.user.account.type != 'admin':
        return redirect('login')
    
    try:
        # Retrieve the case object from the database based on the case_id
        case = Case.objects.get(id=case_id)
        # Retrieve related objects such as evidence, victims, perpetrators, and parents
        evidences = Evidence.objects.filter(case=case)
        victims = Victim.objects.filter(case_victim=case)
        perpetrators = Perpetrator.objects.filter(case_perpetrator=case)
        status_history = Status_History.objects.filter(case_status_history=case)
        witnesses = Witness.objects.filter(case_witness=case)

        # Retrieve only the latest status history entry
        latest_status_history = status_history.order_by('-status_date_added').first()

        print(request.session['security_status'])

        if request.session['security_status'] == "encrypted":
            case.street = encrypt_data(case.street)
            case.barangay = encrypt_data(case.barangay)
            case.date_latest_incident = encrypt_data(case.date_latest_incident)
            case.place_of_incident = encrypt_data(case.place_of_incident)
            case.province = encrypt_data(case.province)
            case.region = encrypt_data(case.region)
            case.description_of_incident = encrypt_data(case.description_of_incident)
            case.city = encrypt_data(case.city)

            # for victim in victims:
            #     victim.description
            for victim in victims:
                victim.first_name = encrypt_data(victim.first_name)
                victim.middle_name = encrypt_data(victim.middle_name)
                victim.last_name = encrypt_data(victim.last_name)
                victim.suffix = encrypt_data(victim.suffix)
                victim.date_of_birth = encrypt_data(victim.date_of_birth)
                victim.sex = encrypt_data(victim.sex)
                victim.civil_status = encrypt_data(victim.civil_status)
                victim.nationality = encrypt_data(victim.nationality)
                victim.contact_number = encrypt_data(victim.contact_number)
                victim.telephone_number = encrypt_data(victim.telephone_number)
                victim.house_information = encrypt_data(victim.house_information)
                victim.street = encrypt_data(victim.street)
                victim.barangay = encrypt_data(victim.barangay)
                victim.province = encrypt_data(victim.province)
                victim.city = encrypt_data(victim.city)
                victim.region = encrypt_data(victim.region)
                victim.occupation = encrypt_data(victim.occupation)
                
                # new
                victim.type_of_disability = encrypt_data(victim.type_of_disability)
                victim.educational_attainment = encrypt_data(victim.educational_attainment)
                victim.religion = encrypt_data(victim.religion)
                victim.number_of_children = encrypt_data(victim.number_of_children)
                victim.ages_of_children = encrypt_data(victim.ages_of_children)
                
            for perpetrator in perpetrators:
                perpetrator.relationship_to_victim = encrypt_data(perpetrator.relationship_to_victim)
                perpetrator.first_name = encrypt_data(perpetrator.first_name)
                perpetrator.middle_name = encrypt_data(perpetrator.middle_name)
                perpetrator.last_name = encrypt_data(perpetrator.last_name)
                perpetrator.suffix = encrypt_data(perpetrator.suffix)
                perpetrator.identifying_marks = encrypt_data(perpetrator.identifying_marks)
                perpetrator.alias = encrypt_data(perpetrator.alias)
                perpetrator.sex = encrypt_data(perpetrator.sex)
                perpetrator.contact_number = encrypt_data(perpetrator.contact_number)
                perpetrator.telephone_number = encrypt_data(perpetrator.telephone_number)
                perpetrator.date_of_birth = encrypt_data(perpetrator.date_of_birth)
                perpetrator.nationality = encrypt_data(perpetrator.nationality)
                perpetrator.house_information = encrypt_data(perpetrator.house_information)
                perpetrator.street = encrypt_data(perpetrator.street)
                perpetrator.barangay = encrypt_data(perpetrator.barangay)
                perpetrator.province = encrypt_data(perpetrator.province)
                perpetrator.region = encrypt_data(perpetrator.region)
                
                # new
                perpetrator.type_of_disability = encrypt_data(perpetrator.type_of_disability)
                perpetrator.civil_status = encrypt_data(perpetrator.civil_status)
                perpetrator.religion = encrypt_data(perpetrator.religion)
                perpetrator.educational_attainment = encrypt_data(perpetrator.educational_attainment)
                perpetrator.occupation = encrypt_data(perpetrator.occupation)
                perpetrator.city = encrypt_data(perpetrator.city)
                

        # Render the view-case.html template with the case and related objects as context
        
        region_id = 10 # region 9
        province_id = 50 # zamboanga del sur
        municipality_id = 1133 # zamboanga city
                
        return render(request, 'super-admin/case/view-case-impacted.html', {
            'case': case,
            'evidence': evidences,
            'victims': victims,
            'perpetrators': perpetrators,
            'status_histories': status_history,
            'witnesses': witnesses,
            'latest_status_history': latest_status_history,
            'global': request.session,
            'default_regions': Region.objects.filter(id=region_id),
            'default_provinces': Province.objects.filter(region_id=region_id),
            'default_cities': Municipality.objects.filter(province_id=province_id),
            'default_barangays': Barangay.objects.filter(municipality_id=municipality_id),
        })
    except Case.DoesNotExist:
        # Handle case not found appropriately, for example, return a 404 page
        return HttpResponseNotFound("Case not found")

@login_required
def view_case_behalf(request, case_id):
    if request.user.account.type != 'staff':
        return redirect('login')
    
    try:
        # Retrieve the case object from the database based on the case_id
        case = Case.objects.get(id=case_id)
        # Retrieve related objects such as contact persons, evidence, victims, perpetrators, and parents
        contact_persons = Contact_Person.objects.filter(case_contact=case)
        evidences = Evidence.objects.filter(case=case)
        victims = Victim.objects.filter(case_victim=case)
        perpetrators = Perpetrator.objects.filter(case_perpetrator=case)
        status_history = Status_History.objects.filter(case_status_history=case)
        witnesses = Witness.objects.filter(case_witness=case)

        # Retrieve only the latest status history entry
        latest_status_history = status_history.order_by('-status_date_added').first()

        print(request.session['security_status'])

        if request.session['security_status'] == "encrypted":
            case.street = encrypt_data(case.street)
            case.barangay = encrypt_data(case.barangay)
            case.date_latest_incident = encrypt_data(case.date_latest_incident)
            case.place_of_incident = encrypt_data(case.place_of_incident)
            case.province = encrypt_data(case.province)
            case.region = encrypt_data(case.region)
            case.description_of_incident = encrypt_data(case.description_of_incident)
            case.city = encrypt_data(case.city)

            # for victim in victims:
            #     victim.description
            for victim in victims:
                victim.first_name = encrypt_data(victim.first_name)
                victim.middle_name = encrypt_data(victim.middle_name)
                victim.last_name = encrypt_data(victim.last_name)
                victim.suffix = encrypt_data(victim.suffix)
                victim.date_of_birth = encrypt_data(victim.date_of_birth)
                victim.sex = encrypt_data(victim.sex)
                victim.civil_status = encrypt_data(victim.civil_status)
                victim.nationality = encrypt_data(victim.nationality)
                victim.contact_number = encrypt_data(victim.contact_number)
                victim.telephone_number = encrypt_data(victim.telephone_number)
                victim.house_information = encrypt_data(victim.house_information)
                victim.street = encrypt_data(victim.street)
                victim.barangay = encrypt_data(victim.barangay)
                victim.province = encrypt_data(victim.province)
                victim.city = encrypt_data(victim.city)
                victim.region = encrypt_data(victim.region)
                victim.occupation = encrypt_data(victim.occupation)
                victim.number_of_children = encrypt_data(victim.number_of_children)
                victim.ages_of_children = encrypt_data(victim.ages_of_children)
                
                print("Here")
                print(victim.occupation)

            for perpetrator in perpetrators:
                perpetrator.relationship_to_victim = encrypt_data(perpetrator.relationship_to_victim)
                perpetrator.first_name = encrypt_data(perpetrator.first_name)
                perpetrator.middle_name = encrypt_data(perpetrator.middle_name)
                perpetrator.last_name = encrypt_data(perpetrator.last_name)
                perpetrator.suffix = encrypt_data(perpetrator.suffix)
                perpetrator.identifying_marks = encrypt_data(perpetrator.identifying_marks)
                perpetrator.alias = encrypt_data(perpetrator.alias)
                perpetrator.sex = encrypt_data(perpetrator.sex)
                perpetrator.contact_number = encrypt_data(perpetrator.contact_number)
                perpetrator.telephone_number = encrypt_data(perpetrator.telephone_number)
                print(perpetrator.contact_number)
                perpetrator.occupation = encrypt_data(perpetrator.occupation)
                perpetrator.date_of_birth = encrypt_data(perpetrator.date_of_birth)
                perpetrator.nationality = encrypt_data(perpetrator.nationality)
                perpetrator.house_information = encrypt_data(perpetrator.house_information)
                perpetrator.street = encrypt_data(perpetrator.street)
                perpetrator.barangay = encrypt_data(perpetrator.barangay)
                perpetrator.province = encrypt_data(perpetrator.province)
                perpetrator.city= encrypt_data(perpetrator.city)
                perpetrator.region = encrypt_data(perpetrator.region)
            
            for contact_person in contact_persons:
                
                contact_person.first_name = encrypt_data(contact_person.first_name)
                contact_person.middle_name = encrypt_data(contact_person.middle_name)
                contact_person.last_name = encrypt_data(contact_person.last_name)
                contact_person.barangay = encrypt_data(contact_person.barangay)
                contact_person.city = encrypt_data(contact_person.city)
                contact_person.province = encrypt_data(contact_person.province)
                contact_person.telephone_number = encrypt_data(contact_person.telephone_number)
                contact_person.contact_number = encrypt_data(contact_person.contact_number)
                contact_person.street = encrypt_data(contact_person.street)
                contact_person.bldg_number = encrypt_data(contact_person.bldg_number)
                contact_person.relationship = encrypt_data(contact_person.relationship)

                # contact num
                # region
                # street
                # relationship
                # suffix

            # for contact_person in contact_persons:
            #     contact_person.first_name = decrypt_data(contact_person.first_name)
            #     contact_person.middle_name = decrypt_data(contact_person.middle_name)
            #     contact_person.last_name = decrypt_data(contact_person.last_name)
            #     contact_person.suffix = decrypt_data(contact_person.suffix)
            #     contact_person.relationship= decrypt_data(contact_person.relationship)
            #     contact_person.contact_number = decrypt_data(contact_person.contact_number)
            #     contact_person.telephone_number = decrypt_data(contact_person.telephone_number)
            #     contact_person.street = decrypt_data(contact_person.street)
            #     contact_person.city = decrypt_data(contact_person.city)
            #     contact_person.barangay = decrypt_data(contact_person.barangay)
            #     contact_person.province = decrypt_data(contact_person.province)
            #     contact_person.region = decrypt_data(contact_person.region)

        #print(decrypt_data(case.street))
        # if isinstance(encrypted_data_from_db, bytes):
        #     print("Decrypted: ", decrypt_data(encrypted_data_from_db))
        # else:
        #     print("Decrypted: ", decrypt_data())
        
        # for victim in victims:
        #     encryted_value = encrypt_data(victim.first_name)
        #     print("Encrypted: ", encryted_value)
        #     print("Decrypted: ", decrypt_data(encryted_value))

        # Render the view-case.html template with the case and related objects as context
        
        region_id = 10 # region 9
        province_id = 50 # zamboanga del sur
        municipality_id = 1133 # zamboanga city

        return render(request, 'barangay-admin/case/view-case-behalf.html', {
            'case': case,
            'contact_persons': contact_persons,
            'evidence': evidences,
            'victims': victims,
            'perpetrators': perpetrators,
            'status_histories': status_history,
            'witnesses': witnesses,
            'latest_status_history': latest_status_history,
            'global': request.session,
            'default_regions': Region.objects.filter(id=region_id),
            'default_provinces': Province.objects.filter(region_id=region_id),
            'default_cities': Municipality.objects.filter(province_id=province_id),
            'default_barangays': Barangay.objects.filter(municipality_id=municipality_id),
        })
    except Case.DoesNotExist:
        # Handle case not found appropriately, for example, return a 404 page
        return HttpResponseNotFound("Case not found")

@login_required
def view_case_impact(request, case_id):
    if request.user.account.type != 'staff':
        return redirect('login')
    
    try:
        # Retrieve the case object from the database based on the case_id
        case = Case.objects.get(id=case_id)
        # Retrieve related objects such as evidence, victims, perpetrators, and parents
        evidences = Evidence.objects.filter(case=case)
        victims = Victim.objects.filter(case_victim=case)
        perpetrators = Perpetrator.objects.filter(case_perpetrator=case)
        status_history = Status_History.objects.filter(case_status_history=case)
        witnesses = Witness.objects.filter(case_witness=case)

        # Retrieve only the latest status history entry
        latest_status_history = status_history.order_by('-status_date_added').first()

        print(request.session['security_status'])

        if request.session['security_status'] == "encrypted":
            case.street = encrypt_data(case.street)
            case.barangay = encrypt_data(case.barangay)
            case.date_latest_incident = encrypt_data(case.date_latest_incident)
            case.place_of_incident = encrypt_data(case.place_of_incident)
            case.province = encrypt_data(case.province)
            case.region = encrypt_data(case.region)
            case.description_of_incident = encrypt_data(case.description_of_incident)
            case.city = encrypt_data(case.city)

            # for victim in victims:
            #     victim.description
            for victim in victims:
                victim.first_name = encrypt_data(victim.first_name)
                victim.middle_name = encrypt_data(victim.middle_name)
                victim.last_name = encrypt_data(victim.last_name)
                victim.suffix = encrypt_data(victim.suffix)
                victim.date_of_birth = encrypt_data(victim.date_of_birth)
                victim.sex = encrypt_data(victim.sex)
                victim.civil_status = encrypt_data(victim.civil_status)
                victim.nationality = encrypt_data(victim.nationality)
                victim.contact_number = encrypt_data(victim.contact_number)
                victim.telephone_number = encrypt_data(victim.telephone_number)
                victim.house_information = encrypt_data(victim.house_information)
                victim.street = encrypt_data(victim.street)
                victim.barangay = encrypt_data(victim.barangay)
                victim.province = encrypt_data(victim.province)
                victim.city = encrypt_data(victim.city)
                victim.region = encrypt_data(victim.region)
                victim.occupation = encrypt_data(victim.occupation)
                
                # new
                victim.type_of_disability = encrypt_data(victim.type_of_disability)
                victim.educational_attainment = encrypt_data(victim.educational_attainment)
                victim.religion = encrypt_data(victim.religion)
                victim.number_of_children = encrypt_data(victim.number_of_children)
                victim.ages_of_children = encrypt_data(victim.ages_of_children)
                
            for perpetrator in perpetrators:
                perpetrator.relationship_to_victim = encrypt_data(perpetrator.relationship_to_victim)
                perpetrator.first_name = encrypt_data(perpetrator.first_name)
                perpetrator.middle_name = encrypt_data(perpetrator.middle_name)
                perpetrator.last_name = encrypt_data(perpetrator.last_name)
                perpetrator.suffix = encrypt_data(perpetrator.suffix)
                perpetrator.identifying_marks = encrypt_data(perpetrator.identifying_marks)
                perpetrator.alias = encrypt_data(perpetrator.alias)
                perpetrator.sex = encrypt_data(perpetrator.sex)
                perpetrator.contact_number = encrypt_data(perpetrator.contact_number)
                perpetrator.telephone_number = encrypt_data(perpetrator.telephone_number)
                perpetrator.date_of_birth = encrypt_data(perpetrator.date_of_birth)
                perpetrator.nationality = encrypt_data(perpetrator.nationality)
                perpetrator.house_information = encrypt_data(perpetrator.house_information)
                perpetrator.street = encrypt_data(perpetrator.street)
                perpetrator.barangay = encrypt_data(perpetrator.barangay)
                perpetrator.province = encrypt_data(perpetrator.province)
                perpetrator.region = encrypt_data(perpetrator.region)
                
                # new
                perpetrator.type_of_disability = encrypt_data(perpetrator.type_of_disability)
                perpetrator.civil_status = encrypt_data(perpetrator.civil_status)
                perpetrator.religion = encrypt_data(perpetrator.religion)
                perpetrator.educational_attainment = encrypt_data(perpetrator.educational_attainment)
                perpetrator.occupation = encrypt_data(perpetrator.occupation)
                perpetrator.city = encrypt_data(perpetrator.city)
                

        # Render the view-case.html template with the case and related objects as context
        
        region_id = 10 # region 9
        province_id = 50 # zamboanga del sur
        municipality_id = 1133 # zamboanga city
        
        return render(request, 'barangay-admin/case/view-case-impacted.html', {
            'case': case,
            'evidence': evidences,
            'victims': victims,
            'perpetrators': perpetrators,
            'status_histories': status_history,
            'witnesses': witnesses,
            'latest_status_history': latest_status_history,
            'global': request.session,
            'default_regions': Region.objects.filter(id=region_id),
            'default_provinces': Province.objects.filter(region_id=region_id),
            'default_cities': Municipality.objects.filter(province_id=province_id),
            'default_barangays': Barangay.objects.filter(municipality_id=municipality_id),
        })
    except Case.DoesNotExist:
        # Handle case not found appropriately, for example, return a 404 page
        return HttpResponseNotFound("Case not found")

@login_required
def pdf_template_view (request, case_id):
    logged_in_user = request.user
    account = logged_in_user.account
    # Retrieve the case object from the database based on the case_id
    case = Case.objects.get(id=case_id)
    # Retrieve related objects such as evidence, victims, perpetrators, and parents
    evidences = Evidence.objects.filter(case=case)
    victims = Victim.objects.filter(case_victim=case)
    perpetrators = Perpetrator.objects.filter(case_perpetrator=case)
    witnesses = Witness.objects.filter(case_witness=case)
    
    # CASE ----------------------
    case_attributes = vars(case)
    case_decrypted = {}
    
    for attribute, value in case_attributes.items():
        if isinstance(value, str) and value.startswith('b\'gAAAAA'):
            case_decrypted[attribute] = decrypt_data(value)
        else:
            case_decrypted[attribute] = value


    # VICTIM ----------------------
    list_victim_decrypted = []

    for victim in victims:
        case_attributes = vars(victim)
        victim_decrypted = {}

        for attribute, value in case_attributes.items():
            if isinstance(value, str) and value.startswith('b\'gAAAAA'):
                victim_decrypted[attribute] = decrypt_data(value)
            else:
                victim_decrypted[attribute] = value
        
        #insert print of date_of_birth of victims here
        
        # Fetch parent object related to this victim
        parent = Parent.objects.filter(victim_parent=victim).first()

        if parent:
            parent_attributes = vars(parent)
            parent_decrypted = {}
            for parent_attribute, parent_value in parent_attributes.items():
                if isinstance(parent_value, str) and parent_value.startswith('b\'gAAAAA'):
                    parent_decrypted[parent_attribute] = decrypt_data(parent_value)
                else:
                    parent_decrypted[parent_attribute] = parent_value
            list_victim_decrypted.append((victim_decrypted, parent_decrypted))
        else:
            # If no parent is found for the victim, append None
            list_victim_decrypted.append((victim_decrypted, None))
        
        # Calculate age for each victim
        for victim, parent in list_victim_decrypted:
            if 'date_of_birth' in victim:
                victim['age'] = calculate_age(victim['date_of_birth'])
                print(f"victim Age: {victim['age']}")


    # PERPETRATORS ----------------------
    list_perpetrator_decrypted = []

    for perpetrator in perpetrators:
        case_attributes = vars(perpetrator)
        perpetrator_decrypted = {}

        for attribute, value in case_attributes.items():
            if isinstance(value, str) and value.startswith('b\'gAAAAA'):
                perpetrator_decrypted[attribute] = decrypt_data(value)
            else:
                perpetrator_decrypted[attribute] = value
        
        # Fetch parent perpetrator object related to this perpetrator
        parent_perpetrator = Parent_Perpetrator.objects.filter(perpetrator_parent=perpetrator).first()

        if parent_perpetrator:
            parent_attributes = vars(parent_perpetrator)
            parent_decrypted = {}
            for parent_attribute, parent_value in parent_attributes.items():
                if isinstance(parent_value, str) and parent_value.startswith('b\'gAAAAA'):
                    parent_decrypted[parent_attribute] = decrypt_data(parent_value)
                else:
                    parent_decrypted[parent_attribute] = parent_value
            list_perpetrator_decrypted.append((perpetrator_decrypted, parent_decrypted))
        else:
            # If no parent perpetrator is found for the perpetrator, append None
            list_perpetrator_decrypted.append((perpetrator_decrypted, None))

        # Calculate age for each perpetrator
        for perpetrator, parent_perpetrator in list_perpetrator_decrypted:
            if 'date_of_birth' in perpetrator:
                perpetrator['age'] = calculate_age(perpetrator['date_of_birth'])
                print(f"Perpetrator Age: {perpetrator['age']}")

        # Print the encrypted attributes
        # for attribute, value in perpetrator_decrypted.items():
        #     print(f"{attribute}: {value}")

    template = loader.get_template('barangay-admin/case/pdf-template.html') # Load HTML template
    html_string = template.render({
        'case': case,
        'case_decrypted': case_decrypted,
        'account': account,
        'list_victim_decrypted': list_victim_decrypted,
        'list_perpetrator_decrypted': list_perpetrator_decrypted,
        'witnesses': witnesses,
    }) # Render the template
    # print(html_string)

    # Generate the PDF using WeasyPrint
    pdf = HTML(string=html_string, base_url=request.build_absolute_uri()).write_pdf()
    
    # Create an HttpResponse with the PDF content
    response = HttpResponse(pdf, content_type='application/pdf')
    response['Content-Disposition'] = 'inline; filename="Print Case No. {}.pdf"'.format(case.case_number)
    # Display in the browser

    return response
    
@require_POST
def save_victim_data(request, victim_id):
    try:
        victim = get_object_or_404(Victim, id=victim_id)

        # Update victim data
        victim.first_name = request.POST.get('victim_first_name_' + str(victim_id))
        victim.middle_name = request.POST.get('victim_middle_name_' + str(victim_id))
        victim.last_name = request.POST.get('victim_last_name_' + str(victim_id))
        victim.suffix = request.POST.get('victim_suffix_name_' + str(victim_id))
        victim.sex = request.POST.get('victim_sex_' + str(victim_id))
        victim.type_of_disability = request.POST.get('victim_type_of_disability_' + str(victim_id))
        victim.date_of_birth = request.POST.get('victim_date_of_birth_' + str(victim_id))
        victim.civil_status = request.POST.get('victim_civil_status_' + str(victim_id))
        victim.contact_number = request.POST.get('victim_contact_number_' + str(victim_id))
        victim.telephone_number = request.POST.get('victim_telephone_number_' + str(victim_id))
        victim.educational_attainment = request.POST.get('victim_educational_attainment_' + str(victim_id))
        victim.occupation = request.POST.get('victim_occupation_' + str(victim_id))
        victim.nationality = request.POST.get('victim_nationality_' + str(victim_id))
        victim.religion = request.POST.get('victim_religion_' + str(victim_id))
        victim.house_information = request.POST.get('victim_house_information_' + str(victim_id))
        victim.street = request.POST.get('victim_street_' + str(victim_id))
        victim.barangay = request.POST.get('victim_barangay_' + str(victim_id))
        victim.province = request.POST.get('victim_province_' + str(victim_id))
        victim.city = request.POST.get('victim_city_' + str(victim_id))
        victim.region = request.POST.get('victim_region_' + str(victim_id))
        victim.number_of_children = request.POST.get('victim_number_children_' + str(victim_id))
        victim.ages_of_children = request.POST.get('victim_ages_children_' + str(victim_id))

        # Save victim data
        victim.save()

        return JsonResponse({'success': True, 'message': 'Victim data saved successfully'})
    except Exception as e:
        return JsonResponse({'success': False, 'message': str(e)})

@require_POST
def add_new_victim(request):
    try:
        case_id = request.POST.get('case_id')
        
        case_instance = get_object_or_404(Case, id=case_id)
        # Extract form data
        first_name = request.POST.get('victim_first_name')
        middle_name = request.POST.get('victim_middle_name')
        last_name = request.POST.get('victim_last_name')
        suffix = request.POST.get('victim_suffix_name')
        date_of_birth = request.POST.get('victim_date_of_birth')
        sex = request.POST.get('victim_sex')
        civil_status = request.POST.get('victim_civil_status')
        educational_attainment = request.POST.get('victim_educational_attainment')
        occupation = request.POST.get('victim_occupation')
        type_of_disability = request.POST.get('victim_type_of_disability')
        nationality = request.POST.get('victim_nationality')
        religion = request.POST.get('victim_religion')
        contact_number = request.POST.get('victim_contact_number')
        telephone_number = request.POST.get('victim_telephone_number')
        house_information = request.POST.get('victim_house_information')
        street = request.POST.get('victim_street')
        barangay = request.POST.get('victim_barangay')
        province = request.POST.get('victim_province')
        city = request.POST.get('victim_city')
        region = request.POST.get('victim_region')
        number_of_children = request.POST.get('victim_number_children')
        ages_of_children = request.POST.get('victim_ages_children')
        
        print(case_id)
        print(first_name)
        print(last_name)
        # Create and save the new victim instance
        victim = Victim.objects.create(
            case_victim=case_instance,
            first_name=first_name,
            middle_name=middle_name,
            last_name=last_name,
            suffix=suffix,
            date_of_birth=date_of_birth,
            sex=sex,
            civil_status=civil_status,
            educational_attainment=educational_attainment,
            occupation=occupation,
            type_of_disability=type_of_disability,
            nationality=nationality,
            religion=religion,
            contact_number=contact_number,
            telephone_number=telephone_number,
            house_information=house_information,
            street=street,
            barangay=barangay,
            province=province,
            city=city,
            region=region,
            number_of_children = number_of_children,
            ages_of_children=ages_of_children
        )

        # Return success response
        return JsonResponse({'success': True, 'message': 'Victim added successfully'})
    except Exception as e:
        # Return error response
        return JsonResponse({'success': False, 'message': str(e)})

@require_POST
def add_new_perpetrator(request):
    try:
        case_id = request.POST.get('case_id')
        
        case_instance = get_object_or_404(Case, id=case_id)
        # Extract form data
        first_name = request.POST.get('perpetrator_first_name')
        middle_name = request.POST.get('perpetrator_middle_name')
        last_name = request.POST.get('perpetrator_last_name')
        suffix = request.POST.get('perpetrator_suffix_name')
        perpetrator_identifying_marks = request.POST.get('perpetrator_identifying_marks')
        perpetrator_alias = request.POST.get('perpetrator_alias')
        perp_relationship_victim = request.POST.get('perp-relationship-victim')
        date_of_birth = request.POST.get('perpetrator_date_of_birth')
        sex = request.POST.get('perpetrator_sex')
        civil_status = request.POST.get('perpetrator_civil_status')
        educational_attainment = request.POST.get('perpetrator_educational_attainment')
        occupation = request.POST.get('perpetrator_occupation')
        type_of_disability = request.POST.get('perpetrator_type_of_disability')
        nationality = request.POST.get('perpetrator_nationality')
        religion = request.POST.get('perpetrator_religion')
        contact_number = request.POST.get('perpetrator_contact_number')
        telephone_number = request.POST.get('perpetrator_telephone_number')
        house_information = request.POST.get('perpetrator_house_information')
        street = request.POST.get('perpetrator_street')
        barangay = request.POST.get('perpetrator_barangay')
        province = request.POST.get('perpetrator_province')
        city = request.POST.get('perpetrator_city')
        region = request.POST.get('perpetrator_region')

        print(case_id)
        print(first_name)
        print(last_name)
        # Create and save the new perpetrator instance
        perpetrator = Perpetrator.objects.create(
            case_perpetrator=case_instance,
            first_name=first_name,
            middle_name=middle_name,
            last_name=last_name,
            suffix=suffix,
            identifying_marks=perpetrator_identifying_marks,
            alias=perpetrator_alias,
            relationship_to_victim=perp_relationship_victim,
            date_of_birth=date_of_birth,
            sex=sex,
            civil_status=civil_status,
            educational_attainment=educational_attainment,
            occupation=occupation,
            type_of_disability=type_of_disability,
            nationality=nationality,
            religion=religion,
            contact_number=contact_number,
            telephone_number=telephone_number,
            house_information=house_information,
            street=street,
            barangay=barangay,
            province=province,
            city=city,
            region=region
        )

        # Return success response
        return JsonResponse({'success': True, 'message': 'Perpetrator added successfully'})
    except Exception as e:
        # Return error response
        return JsonResponse({'success': False, 'message': str(e)})

@require_POST
def save_perpetrator_data(request, perpetrator_id):
    try:
        print("HERE")
        print(request.POST.get('perpetrator_contact_number_' + str(perpetrator_id)))
        perpetrator = get_object_or_404(Perpetrator, id=perpetrator_id)

        # Update perpetrator data
        perpetrator.first_name = request.POST.get('perpetrator_first_name_' + str(perpetrator_id))
        perpetrator.middle_name = request.POST.get('perpetrator_middle_name_' + str(perpetrator_id))
        perpetrator.last_name = request.POST.get('perpetrator_last_name_' + str(perpetrator_id))
        perpetrator.suffix = request.POST.get('perpetrator_suffix_name_' + str(perpetrator_id))
        perpetrator.identifying_marks = request.POST.get('perpetrator_identifying_marks_' + str(perpetrator_id))
        perpetrator.alias = request.POST.get('perpetrator_alias_' + str(perpetrator_id))
        perpetrator.relationship_to_victim = request.POST.get('perp-relationship-victim_' + str(perpetrator_id))
        perpetrator.sex = request.POST.get('perpetrator_sex_' + str(perpetrator_id))
        perpetrator.type_of_disability = request.POST.get('perpetrator_type_of_disability_' + str(perpetrator_id))
        perpetrator.date_of_birth = request.POST.get('perpetrator_date_of_birth_' + str(perpetrator_id))
        perpetrator.civil_status = request.POST.get('perpetrator_civil_status_' + str(perpetrator_id))
        perpetrator.contact_number = request.POST.get('perpetrator_contact_number_' + str(perpetrator_id))
        perpetrator.telephone_number = request.POST.get('perpetrator_telephone_number_' + str(perpetrator_id))
        perpetrator.educational_attainment = request.POST.get('perpetrator_educational_attainment_' + str(perpetrator_id))
        perpetrator.occupation = request.POST.get('perpetrator_occupation_' + str(perpetrator_id))
        perpetrator.nationality = request.POST.get('perpetrator_nationality_' + str(perpetrator_id))
        perpetrator.religion = request.POST.get('perpetrator_religion_' + str(perpetrator_id))
        perpetrator.house_information = request.POST.get('perpetrator_house_information_' + str(perpetrator_id))
        perpetrator.street = request.POST.get('perpetrator_street_' + str(perpetrator_id))
        perpetrator.barangay = request.POST.get('perpetrator_barangay_' + str(perpetrator_id))
        perpetrator.province = request.POST.get('perpetrator_province_' + str(perpetrator_id))
        perpetrator.city = request.POST.get('perpetrator_city_' + str(perpetrator_id))
        perpetrator.region = request.POST.get('perpetrator_region_' + str(perpetrator_id))

        # Save perpetrator data
        perpetrator.save()

        return JsonResponse({'success': True, 'message': 'Perpetrator data saved successfully'})
    except Exception as e:
        return JsonResponse({'success': False, 'message': str(e)})

@require_POST
def delete_perpetrator(request):
    perpetrator_id = request.POST.get('perpetrator_id')
    perpetrator = get_object_or_404(Perpetrator, id=perpetrator_id)
    perpetrator.delete()
    return JsonResponse({'success': True, 'message': 'Perpetrator and related Parents deleted successfully'})

@require_POST
def delete_case(request):
    case_id = request.POST.get('case_id')
    print('Case ID:', case_id)
    case = get_object_or_404(Case, id=case_id)
    case.delete()
    return JsonResponse({'success': True, 'message': 'Case Deleted successfully'})

def add_new_contact_person(request):
    try:
        case_id = request.POST.get('case_id')
        case_instance = get_object_or_404(Case, id=case_id)

        # Update contact_person data
        first_name = request.POST.get('contact_person_first_name')
        middle_name = request.POST.get('contact_person_middle_name')
        last_name = request.POST.get('contact_person_last_name')
        suffix = request.POST.get('contact_person_suffix_name')
        relationship = request.POST.get('contact_person-relationship')
        contact_number = request.POST.get('contact_person_contact-number')
        telephone_number = request.POST.get('contact_person_contact-tel')
        street = request.POST.get('contact_person_street')
        barangay = request.POST.get('contact_person_barangay')
        province = request.POST.get('contact_person_province')
        city = request.POST.get('contact_person_city')
        region = request.POST.get('contact_person_region')
        bldg_no = request.POST.get('contact_person_bldg_no')

        # Create and save the new victim instance
        contact_person = Contact_Person.objects.create(
            case_contact=case_instance,
            first_name=first_name,
            middle_name=middle_name,
            last_name=last_name,
            suffix=suffix,
            relationship=relationship,
            contact_number=contact_number,
            telephone_number=telephone_number,
            street=street,
            barangay=barangay,
            province=province,
            city=city,
            region=region,
            bldg_number=bldg_no,
        )


        return JsonResponse({'success': True, 'message': 'Contact Person added successfully'})
    except Exception as e:
        return JsonResponse({'success': False, 'message': str(e)})

@require_POST
def save_contact_person_data(request, contact_person_id):
    try:
        contact_person = get_object_or_404(Contact_Person, id=contact_person_id)

        # Update contact_person data
        contact_person.first_name = request.POST.get('contact_person_first_name_' + str(contact_person_id))
        contact_person.middle_name = request.POST.get('contact_person_middle_name_' + str(contact_person_id))
        contact_person.last_name = request.POST.get('contact_person_last_name_' + str(contact_person_id))
        # contact_person.suffix = request.POST.get('contact_person_suffix_name_' + str(contact_person_id))
        # contact_person.relationship = request.POST.get('contact_person-relationship_' + str(contact_person_id))
        # contact_person.contact_number = request.POST.get('contact_person_contact-number_' + str(contact_person_id))
        contact_person.telephone_number = request.POST.get('contact_person_contact-tel_' + str(contact_person_id))
        # contact_person.street = request.POST.get('contact_person_street_' + str(contact_person_id))
        contact_person.barangay = request.POST.get('contact_person_barangay_' + str(contact_person_id))
        contact_person.province = request.POST.get('contact_person_province_' + str(contact_person_id))
        contact_person.city = request.POST.get('contact_person_city_' + str(contact_person_id))
        # contact_person.region = request.POST.get('contact_person_region_' + str(contact_person_id))
        contact_person.bldg_number = request.POST.get('contact_person_bldg_no_' + str(contact_person_id))
        # Save contact_person data
        contact_person.save()

        return JsonResponse({'success': True, 'message': 'Contact Person data saved successfully'})
    except Exception as e:
        return JsonResponse({'success': False, 'message': str(e)})

#parent victim data crud ----------------------------------------------------------------

@login_required
def add_parent_view(request, case_id, victim_id):
    # Get the Case and Victim objects
    case = Case.objects.get(id=case_id)
    victim = Victim.objects.get(id=victim_id)

    # Query Parent objects related to the Victim
    parents = Parent.objects.filter(victim_parent=victim)
    
    if request.session['security_status'] == "encrypted":
        for parent in parents:
            parent.first_name = encrypt_data(parent.first_name)
            parent.middle_name = encrypt_data(parent.middle_name)
            parent.last_name = encrypt_data(parent.last_name)
            parent.suffix = encrypt_data(parent.suffix)
            parent.date_of_birth = encrypt_data(parent.date_of_birth)
            parent.civil_status = encrypt_data(parent.civil_status)
            parent.educational_attainment = encrypt_data(parent.educational_attainment)
            parent.occupation = encrypt_data(parent.occupation)
            parent.type_of_disability = encrypt_data(parent.type_of_disability)
            parent.nationality = encrypt_data(parent.nationality)
            parent.religion = encrypt_data(parent.religion)
            parent.contact_number = encrypt_data(parent.contact_number)
            parent.telephone_number = encrypt_data(parent.telephone_number)
            parent.house_information = encrypt_data(parent.house_information)
            parent.street = encrypt_data(parent.street)
            parent.barangay = encrypt_data(parent.barangay)
            parent.province = encrypt_data(parent.province)
            parent.city = encrypt_data(parent.city)
            parent.region = encrypt_data(parent.region)
            parent.relationship_to_victim = encrypt_data(parent.relationship_to_victim)

    return render(request, 'barangay-admin/case/add-parent.html', {
        'victim': victim,
        'case': case,
        'parents': parents,
    })

@require_POST
def save_parent_data(request, parent_id):
    try:
        parent = get_object_or_404(Parent, id=parent_id)

        # Update parent data
        parent.first_name = request.POST.get('parent_first_name_' + str(parent_id))
        parent.middle_name = request.POST.get('parent_middle_name_' + str(parent_id))
        parent.last_name = request.POST.get('parent_last_name_' + str(parent_id))
        parent.suffix = request.POST.get('parent_suffix_name_' + str(parent_id))
        parent.sex = request.POST.get('parent_sex_' + str(parent_id))
        parent.type_of_disability = request.POST.get('parent_type_of_disability_' + str(parent_id))
        parent.date_of_birth = request.POST.get('parent_date_of_birth_' + str(parent_id))
        parent.civil_status = request.POST.get('parent_civil_status_' + str(parent_id))
        parent.contact_number = request.POST.get('parent_contact_number_' + str(parent_id))
        parent.telephone_number = request.POST.get('parent_telephone_number_' + str(parent_id))
        parent.educational_attainment = request.POST.get('parent_educational_attainment_' + str(parent_id))
        parent.occupation = request.POST.get('parent_occupation_' + str(parent_id))
        parent.nationality = request.POST.get('parent_nationality_' + str(parent_id))
        parent.religion = request.POST.get('parent_religion_' + str(parent_id))
        parent.house_information = request.POST.get('parent_house_information_' + str(parent_id))
        parent.street = request.POST.get('parent_street_' + str(parent_id))
        parent.barangay = request.POST.get('parent_barangay_' + str(parent_id))
        parent.province = request.POST.get('parent_province_' + str(parent_id))
        parent.city = request.POST.get('parent_city_' + str(parent_id))
        parent.region = request.POST.get('parent_region_' + str(parent_id))
        parent.relationship_to_victim = request.POST.get('parent_relationship_' + str(parent_id))
        
        # Save parent data
        parent.save()

        return JsonResponse({'success': True, 'message': 'Parent data saved successfully'})
    except Exception as e:
        return JsonResponse({'success': False, 'message': str(e)})

@require_POST
def add_new_parent_form(request):
    try:
        victim_id = request.POST.get('victim_id')

        # Extract form data
        first_name = request.POST.get('parent_first_name')
        middle_name = request.POST.get('parent_middle_name')
        last_name = request.POST.get('parent_last_name')
        suffix = request.POST.get('parent_suffix_name')
        date_of_birth = request.POST.get('parent_date_of_birth')
        sex = request.POST.get('parent_sex')
        civil_status = request.POST.get('parent_civil_status')
        educational_attainment = request.POST.get('parent_educational_attainment')
        occupation = request.POST.get('parent_occupation')
        type_of_disability = request.POST.get('parent_type_of_disability')
        nationality = request.POST.get('parent_nationality')
        religion = request.POST.get('parent_religion')
        contact_number = request.POST.get('parent_contact_number')
        telephone_number = request.POST.get('parent_telephone_number')
        house_information = request.POST.get('parent_house_information')
        street = request.POST.get('parent_street')
        barangay = request.POST.get('parent_barangay')
        province = request.POST.get('parent_province')
        city = request.POST.get('parent_city')
        region = request.POST.get('parent_region')
        relationship = request.POST.get('parent_relationship')

        # Create and save the new parent instance
        parent = Parent.objects.create(
            victim_parent_id=victim_id,
            first_name=first_name,
            middle_name=middle_name,
            last_name=last_name,
            suffix=suffix,
            date_of_birth=date_of_birth,
            sex=sex,
            civil_status=civil_status,
            educational_attainment=educational_attainment,
            occupation=occupation,
            type_of_disability=type_of_disability,
            nationality=nationality,
            religion=religion,
            contact_number=contact_number,
            telephone_number=telephone_number,
            house_information=house_information,
            street=street,
            barangay=barangay,
            province=province,
            city=city,
            region=region,
            relationship_to_victim = relationship
        )

        # Return success response
        return JsonResponse({'success': True, 'message': 'Parent added successfully'})
    except Exception as e:
        # Return error response
        return JsonResponse({'success': False, 'message': str(e)})

@require_POST
def delete_parent(request):
    try:
        parent_id = request.POST.get('parent_id')
        parent = Parent.objects.get(id=parent_id)
        parent.delete()
        return JsonResponse({'success': True, 'message': 'Parent deleted successfully'})
    except Parent.DoesNotExist:
        return JsonResponse({'success': False, 'message': 'Parent does not exist'})
    except Exception as e:
        return JsonResponse({'success': False, 'message': str(e)})


#parent victim data crud ----------------------------------------------------------------

#parent perp data crud ----------------------------------------------------------------
@login_required
def add_parent_perp_view(request, case_id, perp_id):
    # Get the Case and Victim objects
    case = Case.objects.get(id=case_id)
    perpetrator = Perpetrator.objects.get(id=perp_id)

    # Query Parent objects related to the Victim
    parents = Parent_Perpetrator.objects.filter(perpetrator_parent=perpetrator)
    
    print("test")
    
   
    if request.session['security_status'] == "encrypted":
        for parent in parents:
            parent.first_name = encrypt_data(parent.first_name)
            parent.middle_name = encrypt_data(parent.middle_name)
            parent.last_name = encrypt_data(parent.last_name)
            parent.suffix = encrypt_data(parent.suffix)
            parent.date_of_birth = encrypt_data(parent.date_of_birth)
            parent.civil_status = encrypt_data(parent.civil_status)
            parent.educational_attainment = encrypt_data(parent.educational_attainment)
            parent.occupation = encrypt_data(parent.occupation)
            parent.type_of_disability = encrypt_data(parent.type_of_disability)
            parent.nationality = encrypt_data(parent.nationality)
            parent.religion = encrypt_data(parent.religion)
            parent.contact_number = encrypt_data(parent.contact_number)
            parent.telephone_number = encrypt_data(parent.telephone_number)
            parent.house_information = encrypt_data(parent.house_information)
            parent.street = encrypt_data(parent.street)
            parent.barangay = encrypt_data(parent.barangay)
            parent.province = encrypt_data(parent.province)
            parent.city = encrypt_data(parent.city)
            parent.region = encrypt_data(parent.region)
            parent.relationship_of_guardian = encrypt_data(parent.relationship_of_guardian)

    return render(request, 'barangay-admin/case/add-parent-perp.html', {
        'perpetrator': perpetrator,
        'case': case,
        'parents': parents,
    })

@require_POST
def add_new_parent_perp_form(request):
    try:
        perp_id = request.POST.get('perp_id')
        perpetrator = Perpetrator.objects.get(id=perp_id)

        # Extract form data
        first_name = request.POST.get('parent_first_name')
        middle_name = request.POST.get('parent_middle_name')
        last_name = request.POST.get('parent_last_name')
        suffix = request.POST.get('parent_suffix_name')
        date_of_birth = request.POST.get('parent_date_of_birth')
        sex = request.POST.get('parent_sex')
        civil_status = request.POST.get('parent_civil_status')
        educational_attainment = request.POST.get('parent_educational_attainment')
        occupation = request.POST.get('parent_occupation')
        type_of_disability = request.POST.get('parent_type_of_disability')
        nationality = request.POST.get('parent_nationality')
        religion = request.POST.get('parent_religion')
        contact_number = request.POST.get('parent_contact_number')
        telephone_number = request.POST.get('parent_telephone_number')
        house_information = request.POST.get('parent_house_information')
        street = request.POST.get('parent_street')
        barangay = request.POST.get('parent_barangay')
        province = request.POST.get('parent_province')
        city = request.POST.get('parent_city')
        region = request.POST.get('parent_region')
        relationship = request.POST.get('parent_relationship_of_guardian')
        # Create and save the new parent instance
        parent = Parent_Perpetrator.objects.create(
            perpetrator_parent=perpetrator,
            first_name=first_name,
            middle_name=middle_name,
            last_name=last_name,
            suffix=suffix,
            date_of_birth=date_of_birth,
            sex=sex,
            civil_status=civil_status,
            educational_attainment=educational_attainment,
            occupation=occupation,
            type_of_disability=type_of_disability,
            nationality=nationality,
            religion=religion,
            contact_number=contact_number,
            telephone_number=telephone_number,
            house_information=house_information,
            street=street,
            barangay=barangay,
            province=province,
            city=city,
            region=region,
            relationship_of_guardian=relationship,
        )

        # Return success response
        return JsonResponse({'success': True, 'message': 'Parent added successfully'})
    except Exception as e:
        # Return error response
        return JsonResponse({'success': False, 'message': str(e)})

@require_POST
def save_parent_perp_data(request, parent_id):
    try:
        parent = get_object_or_404(Parent_Perpetrator, id=parent_id)
        
        # Update parent data
        parent.first_name = request.POST.get('parent_first_name_' + str(parent_id))
        parent.middle_name = request.POST.get('parent_middle_name_' + str(parent_id))
        parent.last_name = request.POST.get('parent_last_name_' + str(parent_id))
        parent.suffix = request.POST.get('parent_suffix_name_' + str(parent_id))
        parent.sex = request.POST.get('parent_sex_' + str(parent_id))
        parent.type_of_disability = request.POST.get('parent_type_of_disability_' + str(parent_id))
        parent.date_of_birth = request.POST.get('parent_date_of_birth_' + str(parent_id))
        parent.civil_status = request.POST.get('parent_civil_status_' + str(parent_id))
        parent.contact_number = request.POST.get('parent_contact_number_' + str(parent_id))
        parent.telephone_number = request.POST.get('parent_telephone_number_' + str(parent_id))
        parent.educational_attainment = request.POST.get('parent_educational_attainment_' + str(parent_id))
        parent.occupation = request.POST.get('parent_occupation_' + str(parent_id))
        parent.nationality = request.POST.get('parent_nationality_' + str(parent_id))
        parent.religion = request.POST.get('parent_religion_' + str(parent_id))
        parent.house_information = request.POST.get('parent_house_information_' + str(parent_id))
        parent.street = request.POST.get('parent_street_' + str(parent_id))
        parent.barangay = request.POST.get('parent_barangay_' + str(parent_id))
        parent.province = request.POST.get('parent_province_' + str(parent_id))
        parent.city = request.POST.get('parent_city_' + str(parent_id))
        parent.region = request.POST.get('parent_region_' + str(parent_id))
        parent.relationship_of_guardian = request.POST.get('parent_relationship_of_guardian_' + str(parent_id))

        # Save parent data
        parent.save()

        return JsonResponse({'success': True, 'message': 'Parent data saved successfully'})
    except Exception as e:
        return JsonResponse({'success': False, 'message': str(e)})

@require_POST
def delete_parent_perp(request):
    try:
        parent_id = request.POST.get('parent_id')
        parent = Parent_Perpetrator.objects.get(id=parent_id)
        parent.delete()
        return JsonResponse({'success': True, 'message': 'Parent deleted successfully'})
    except Parent_Perpetrator.DoesNotExist:
        return JsonResponse({'success': False, 'message': 'Parent does not exist'})
    except Exception as e:
        return JsonResponse({'success': False, 'message': str(e)})

#parent perp data crud ----------------------------------------------------------------


@require_POST
def delete_victim(request):
    if request.method == 'POST':
        victim_id = request.POST.get('victim_id')
        print(victim_id)
        if victim_id:
            try:
                victim = Victim.objects.get(id=victim_id)
                # Delete related Parent instances
                Parent.objects.filter(victim_parent=victim).delete()
                # Delete the victim instance
                victim.delete()
                return JsonResponse({'success': True, 'message': 'Victim and related Parents deleted successfully'})
            except Victim.DoesNotExist:
                return JsonResponse({'success': False, 'message': 'Victim does not exist'})
            except Exception as e:
                return JsonResponse({'success': False, 'message': str(e)})
        else:
            return JsonResponse({'success': False, 'message': 'Invalid victim ID'})
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request method'})

def check_parent_count(request):
    # Count the number of parents
    parent_count = Parent.objects.count()
    print (parent_count)

    # Return a success response if the limit is not exceeded
    return JsonResponse({'success': parent_count})

@require_POST
def delete_parent(request):
    try:
        parent_id = request.POST.get('parent_id')
        parent = Parent.objects.get(id=parent_id)
        parent.delete()
        return JsonResponse({'success': True, 'message': 'Parent deleted successfully'})
    except Parent.DoesNotExist:
        return JsonResponse({'success': False, 'message': 'Parent does not exist'})
    except Exception as e:
        return JsonResponse({'success': False, 'message': str(e)})


def process_incident_form(request):
    if request.method == 'POST':
        # Process removal of evidence
        evidence_to_delete = request.POST.getlist('evidenceToDelete')
        for evidence_id in evidence_to_delete:
            Evidence.objects.filter(id=evidence_id).delete()

        # Process upload of new evidence
        if 'evidence_file' in request.FILES:
            case_id = request.POST.get('case_id')
            case_instance = Case.objects.get(id=case_id)
            handle_evidence_files(request.FILES.getlist('evidence_file'), case_instance)

        # Process addition of new witnesses
        if 'witness_name' in request.POST:
            case_id = request.POST.get('case_id')
            case_instance = Case.objects.get(id=case_id)

            # Get data for all new witnesses
            witness_data = zip(
                request.POST.getlist('witness_name'),
                request.POST.getlist('witness_address'),
                request.POST.getlist('witness_number'),
                request.POST.getlist('witness_email')
            )
            witness_data_list = list(witness_data)
            print(witness_data_list)

            #Create a new Witness object for each set of witness data
            for name, address, number, email in witness_data_list:
                try:
                    Witness.objects.create(
                        case_witness=case_instance,
                        name=name,
                        address=address,
                        contact_number=number,
                        email=email,
                    )
                    print('saved data:',name, address, number, email)
                except Exception as e:
                    print("Error creating Witness:", e)
        # Process removal of witnesses
        witnesses_to_delete = request.POST.getlist('witnesstoDelete')
        for witness_id in witnesses_to_delete:
            Witness.objects.filter(id=witness_id).delete()

        # Process other fields in the form and save them to Case model
        case_id = request.POST.get('case_id')
        case = Case.objects.get(id=case_id)
        print(case_id)
        
        # Retrieve existing witnesses associated with the case
        existing_witnesses = Witness.objects.filter(case_witness=case)

        # Iterate over existing witnesses and check for changes
        for witness_instance in existing_witnesses:
            witness_id = witness_instance.id
            name = request.POST.get(f'witness_name_{witness_id}')
            address = request.POST.get(f'witness_address_{witness_id}')
            number = request.POST.get(f'witness_number_{witness_id}')
            email = request.POST.get(f'witness_email_{witness_id}')
            
            # Check if witness data has been modified
            if (name != witness_instance.name or
                address != witness_instance.address or
                number != witness_instance.contact_number or
                email != witness_instance.email):
                
                # Update the witness instance with new data and save
                witness_instance.name = name
                witness_instance.address = address
                witness_instance.contact_number = number
                witness_instance.email = email
                witness_instance.save()

        date_latest_incident = request.POST.get('date_latest_incident')
        print(date_latest_incident)

        case.date_latest_incident = request.POST.get('date_latest_incident')
        case.incomplete_date = True if request.POST.get('incomplete_date') == 'true' else False
        case.place_of_incident =  request.POST.get('place_of_incident')
        case.street = request.POST.get('street') 
        case.barangay = request.POST.get('barangay') 
        case.province = request.POST.get('province') 
        case.city = request.POST.get('city')
        case.region = request.POST.get('region')
        case.description_of_incident = request.POST.get('description_of_incident')


        # Additional fields
        case.checkbox_ra_9262 = True if request.POST.get('checkbox_ra_9262') == 'true' else False
        case.checkbox_sexual_abuse = True if request.POST.get('checkbox_sexual_abuse') == 'true' else False
        case.checkbox_psychological_abuse = True if request.POST.get('checkbox_psychological_abuse') == 'true' else False
        case.checkbox_physical_abuse = True if request.POST.get('checkbox_physical_abuse') == 'true' else False
        case.checkbox_economic_abuse = True if request.POST.get('checkbox_economic_abuse') == 'true' else False
        case.checkbox_others = True if request.POST.get('checkbox_others') == 'true' else False
        case.others_input = request.POST.get('others_input')
        case.checkbox_ra_8353 = True if request.POST.get('checkbox_ra_8353') == 'true' else False
        case.checkbox_rape_by_sexual_intercourse = True if request.POST.get('checkbox_rape_by_sexual_intercourse') == 'true' else False
        case.checkbox_rape_by_sexual_assault = True if request.POST.get('checkbox_rape_by_sexual_assault') == 'true' else False
        case.checkbox_art_336 = True if request.POST.get('checkbox_art_336') == 'true' else False
        case.checkbox_acts_of_lasciviousness = True if request.POST.get('checkbox_acts_of_lasciviousness') == 'true' else False
        case.checkbox_ra_7877 = True if request.POST.get('checkbox_ra_7877') == 'true' else False
        case.checkbox_verbal = True if request.POST.get('checkbox_verbal') == 'true' else False
        case.checkbox_physical = True if request.POST.get('checkbox_physical') == 'true' else False
        case.checkbox_use_of_objects = True if request.POST.get('checkbox_use_of_objects') == 'true' else False
        case.checkbox_a_7610 = True if request.POST.get('checkbox_a_7610') == 'true' else False
        case.checkbox_engage_prostitution = True if request.POST.get('checkbox_engage_prostitution') == 'true' else False
        case.checkbox_sexual_lascivious_conduct = True if request.POST.get('checkbox_sexual_lascivious_conduct') == 'true' else False
        case.checkbox_ra_9775 = True if request.POST.get('checkbox_ra_9775') == 'true' else False

        # Save the case instance with updated fields
        case.save()

        # Return JSON response
        response_data = {
            'status': 'success',
            'message': 'Form submitted successfully.'
        }
        return JsonResponse(response_data)
    else:
        response_data = {
            'status': 'error',
            'message': 'Invalid request method.'
        }
        return JsonResponse(response_data)

from datetime import datetime

def process_service_info(request):
    if request.method == 'POST':
        case_id = request.POST.get('case_id')
        try:
            case = Case.objects.get(id=case_id)
        except Case.DoesNotExist:
            return JsonResponse({'error': 'Case not found.'}, status=404)

        # Helper function to parse and validate date
        def parse_date(date_string):
            try:
                if date_string:
                    return datetime.strptime(date_string, '%Y-%m-%d').date()
                return None  # Return None if the date is empty
            except ValueError:
                return None  # Return None if the date format is invalid

        # Extracting and updating data for each field
        case.refers_to_social_welfare = True if request.POST.get('refer_social_welware') == 'true' else False
        case.refer_social_date = parse_date(request.POST.get('refer_social_date', ''))
        case.psychosocial_services = True if request.POST.get('psych_service') == 'true' else False
        case.emergency_shelter = True if request.POST.get('emergency_shelter') == 'true' else False
        case.economic_assistance = True if request.POST.get('economic_assist') == 'true' else False

        case.refers_to_healthcare_provider = True if request.POST.get('refer_health') == 'true' else False
        case.refer_healthcare_date = parse_date(request.POST.get('refer_healthcare_date', ''))
        case.healthcare_provider_name = request.POST.get('name_health', '')
        case.provision_of_appropriate_medical_treatment = True if request.POST.get('provision') == 'true' else False
        case.issuance_of_medical_certificate = True if request.POST.get('issuance_medical_cert') == 'true' else False
        case.medico_legal_exam = True if request.POST.get('medico_legal') == 'true' else False

        case.refers_to_law_enforcement = True if request.POST.get('refer_law_enforce') == 'true' else False
        case.refer_law_enforcement_date = parse_date(request.POST.get('refer_law_enforcement_date', ''))
        case.law_enforcement_agency_name = request.POST.get('name_of_agency', '')
        case.receipt_and_recording_of_complaints = True if request.POST.get('receipt_comp') == 'true' else False
        case.rescue_operations_of_vaw_cases = True if request.POST.get('resuce_operation') == 'true' else False
        case.forensic_interview_and_investigation = True if request.POST.get('forensic_interview') == 'true' else False
        case.enforcement_of_protection_order = True if request.POST.get('enforce_protect_order') == 'true' else False

        case.refers_to_other_service_provider = True if request.POST.get('refer_other_service') == 'true' else False
        case.refer_other_service_date = parse_date(request.POST.get('refer_other_service_date', ''))
        case.other_service_provider_name = request.POST.get('name_of_service_provider', '')
        case.type_of_service = request.POST.get('type_of_service_provider', '')

        # Saving the updated Case object
        case.save()

        # Return a JSON response indicating success
        return JsonResponse({'message': 'Service information saved successfully.'})
    else:
        # Return a JSON response indicating failure
        return JsonResponse({'error': 'Invalid request method.'})


def add_status(request, case_id):
    if request.method == 'POST':
        try:
            # Retrieve the case object based on the case_id
            case = Case.objects.get(id=case_id)
            
            # Extract status description from the POST data
            status_title = request.POST.get('status_title')
            status_description = request.POST.get('status_text')
            status_event_date = request.POST.get('status_event_date')

            # Create a new Status_History object
            status_history = Status_History.objects.create(
                case_status_history=case,
                status_title=status_title,
                status_description=status_description,
                status_event_date=status_event_date,
                status_date_added=timezone.now()
            )
            case_numbuh = str(case.case_number)
            receiver = case.email
            subject = "VAWC DESK PORTAL: The status of your case " + case_numbuh + " has been updated"
            link = request.build_absolute_uri('/track_case/')
            message = (
                f'--------------------------\n'
                f'You case has been updated on {timezone.now()}\n'
                f'--------------------------\n\n'
                f'Please check your status in {link}.\n\n'
                f'--------------------------\n'
                f'This email was sent automatically. Please do not reply hehe.'
            )
            
            send_email(receiver, subject, message)

            # Return success response
            return JsonResponse({'success': True, 'message': 'Status added successfully'})

        except Case.DoesNotExist:
            return JsonResponse({'success': False, 'message': 'Case not found'})
        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)})
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request method'})

def edit_status(request, status_id):
    if request.method == 'GET':
        try:
            status = Status_History.objects.get(id=status_id)
            return JsonResponse({'success': True, 'status_title': status.status_title, 'status_description': status.status_description, 'status_event_date': status.status_event_date})
        except Status_History.DoesNotExist:
            return JsonResponse({'success': False, 'message': 'Status not found'})
        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)})
    elif request.method == 'POST':
        try:
            status = Status_History.objects.get(id=status_id)
            new_title = request.POST.get('new_title')
            new_description = request.POST.get('new_description')
            new_event_date = request.POST.get('new_event_date')
            status.status_title = new_title
            status.status_description = new_description
            status.status_event_date = new_event_date
            status.save()
            return JsonResponse({'success': True, 'message': 'Status updated successfully'})
        except Status_History.DoesNotExist:
            return JsonResponse({'success': False, 'message': 'Status not found'})
        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)})

def delete_status(request, status_id):
    if request.method == 'POST':
        try:
            status = Status_History.objects.get(id=status_id)
            status.delete()
            return JsonResponse({'success': True, 'message': 'Status deleted successfully'})
        except Status_History.DoesNotExist:
            return JsonResponse({'success': False, 'message': 'Status not found'})
        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)})
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request method'})

def update_case_status(request, case_id):
    if request.method == 'POST':
        new_status = request.POST.get('status_case')  # Get the new status from the form data
        case = get_object_or_404(Case, pk=case_id)  # Get the case object
        case.status = new_status  # Update the status
        case.save()  # Save the changes
        return JsonResponse({'success': True})  # Return a JSON response indicating success
    else:
        return JsonResponse({'success': False, 'error': 'Invalid request method'})  # Return an error response if the request method is not POST
    
def update_case_date_closed(request, case_id):
    if request.method == 'POST':
        new_status_date = request.POST.get('date_closed')  # Get the new status from the form data
        case = get_object_or_404(Case, pk=case_id)  # Get the case object
        case.date_closed = new_status_date  # Update the status
        case.save()  # Save the changes
        return JsonResponse({'success': True})  # Return a JSON response indicating success
    else:
        return JsonResponse({'success': False, 'error': 'Invalid request method'})

# def encrypt_decrypt(request):

#     form_data = request.POST.get('formData')
#     parsed_data = QueryDict(form_data)
    
    
#     # check if what the button want to do. 
#     action = parsed_data.get('security_status')
#     requested_user = request.POST.get('logged_in_user')
#     user = CustomUser.objects.filter(username=requested_user).first()
#     account = user.account
#     print("account:",user)
#     if action == "decrypted":
#         request.session['security_status'] = "encrypted"
#         return JsonResponse({'success': True, 'message': 'encryted successfully.'})
   
#     # real_passkey = GET PASSKEY OF WHO LOGGED IN
#     real_passkey = account.passkey
#     user_passkey = parsed_data.get('user_passkey')
#     # decrypt_real_pk = decrypt_data(real_passkey)
    
#     if real_passkey == user_passkey:
#         request.session['security_status'] = "decrypted"
#         return JsonResponse({'success': True, 'message': 'Valid passkey.'})
#     else:
#         return JsonResponse({'success': False, 'message': 'Invalid passkey.'})

def encrypt_decrypt(request):
    form_data = request.POST.get('formData')
    parsed_data = QueryDict(form_data)
    security_stat = request.POST.get('security_status')
    print(security_stat)
    # Check if what action the button wants to perform
    action = parsed_data.get('security_status')
    requested_user = request.POST.get('logged_in_user')
    
    # Retrieve the user from the database
    user = CustomUser.objects.filter(username=requested_user).first()
    print("user:", user)
    if user:
        account = user.account
        print("account:", account)
        print(account.passkey)

        if security_stat == "decrypted":
            request.session['security_status'] = "encrypted"
            return JsonResponse({'success': True, 'message': 'Encrypted successfully.'})

        # Get the real passkey of the logged-in user
        real_passkey = account.passkey
        user_passkey = parsed_data.get('user_passkey')

        if real_passkey == user_passkey:
            request.session['security_status'] = "decrypted"
            return JsonResponse({'success': True, 'message': 'Valid passkey.'})
        else:
            return JsonResponse({'success': False, 'message': 'Invalid passkey.'})
    else:
        return JsonResponse({'success': False, 'message': 'User not found.'})


def ph_address(request):
    if request.method == 'POST':

        data = json.loads(request.body)

        if data.get('action') == 'province':
            filter_value = data.get('filter')
            region = Region.objects.get(code=filter_value)
            provinces = Province.objects.filter(region=region).order_by('name').values('code', 'name')
            return JsonResponse(list(provinces), safe=False)
        elif data.get('action') == 'city':
            filter_value = data.get('filter')
            province = Province.objects.get(code=filter_value)
            cities = Municipality.objects.filter(province=province).order_by('name').values('code', 'name')
            return JsonResponse(list(cities), safe=False)
        elif data.get('action') == 'barangay':
            filter_value = data.get('filter')
            city = Municipality.objects.get(code=filter_value)
            brgy = Barangay.objects.filter(municipality=city).order_by('name').values('code', 'name')
            return JsonResponse(list(brgy), safe=False)
        else:
            region = Region.objects.values('code', 'name').order_by('name')
            return JsonResponse(list(region), safe=False)
    else:
        return 