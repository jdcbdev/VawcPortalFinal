from django.test import TestCase, Client
from django.urls import reverse
from case.models import Case, Victim, Perpetrator, Contact_Person

from django.contrib.auth import get_user_model

class AddNewCaseViewTest(TestCase):
    def setUp(self):
        self.client = Client()
        self.url = reverse('add_new_case')
        User = get_user_model()
        self.user = User.objects.create_user(username='testuser', email='testuser@example.com', password='password123')
        self.client.login(email='testuser@example.com', password='password123')
    
    # test the POST request
    def test_add_standard_case(self):
        post_data = {
            'email': 'test@example.com',
            'case_type': 'Impacted',
            'service_type': 'Counseling',
            'barangay': 'San Jose'
        }
        
        # simulate the POST request
        response = self.client.post(self.url, post_data)
        
        # check for the http response
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json()['success'])
        self.assertEqual(response.json()['type_of_case'], 'Impacted')
        
        # check database for the objects if they are created
        self.assertEqual(Case.objects.count(), 1)
        self.assertEqual(Victim.objects.count(), 1)
        self.assertEqual(Perpetrator.objects.count(), 1)
        
        # ensure contact person object is not created for self case
        self.assertEqual(Contact_Person.objects.count(), 0)
        
    def test_add_case_behalf(self):
        post_data = {
            'email': 'test@gmail.com',
            'case_type': 'Behalf'
        }
        
        # check for http response
        response = self.client.post(self.url, post_data)
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json()['success'])
        self.assertEqual(response.json()['type_of_case'], 'Behalf')
        
        # test behalf case creation
        self.assertEqual(Case.objects.count(), 1)
        self.assertEqual(Contact_Person.objects.count(), 1)
    
    def test_law_enforcement_case(self):
        post_data = {
            'email': 'test@example.com',
            'station': 'Ayala Police Station',
            'case_type': 'Impacted',
            'service_type': 'Crisis'
        }
        # check for http response
        response = self.client.post(self.url, post_data)
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json()['success'])
        self.assertEqual(response.json()['type_of_case'], 'Impacted')
        
        self.assertEqual(Case.objects.count(), 1)
        self.assertEqual(Victim.objects.count(), 1)
        self.assertEqual(Perpetrator.objects.count(), 1)
    
    def test_law_enforcement_case_behalf(self):
        post_data = {
            'email': 'test@example.com',
            'station': 'Ayala Police Station',
            'case_type': 'Behalf',
            'service_type': 'Crisis'
        }
        
        # check for http response
        response = self.client.post(self.url, post_data)
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json()['success'])
        self.assertEqual(response.json()['type_of_case'], 'Behalf')
        # check if objects are created 
        self.assertEqual(Case.objects.count(), 1)
        self.assertEqual(Victim.objects.count(), 1)
        self.assertEqual(Perpetrator.objects.count(), 1)
        
    def test_healthcare_case(self):
        post_data = {
            'email': 'test@example.com',
            'hospital_name': 'Zamboanga City Medical Center',
            'case_type': 'Impacted',
            'service_type': 'Crisis'
        }
        
        # check for http response
        response = self.client.post(self.url, post_data)
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json()['success'])
        self.assertEqual(response.json()['type_of_case'], 'Impacted')
        
        # check if objects are created
        self.assertEqual(Case.objects.count(), 1)
        self.assertEqual(Victim.objects.count(), 1)
        self.assertEqual(Perpetrator.objects.count(), 1)

    def test_healthcare_case_behalf(self):
        post_data = {
            'email': 'test@example.com',
            'hospital_name': 'Zamboanga City Medical Center',
            'case_type': 'Behalf',
            'service_type': 'Crisis'
        }
        
        # check for http response
        response = self.client.post(self.url, post_data)
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json()['success'])
        self.assertEqual(response.json()['type_of_case'], 'Behalf')
        
        # check if objects are created
        self.assertEqual(Case.objects.count(), 1)
        self.assertEqual(Victim.objects.count(), 1)
        self.assertEqual(Perpetrator.objects.count(), 1)
    
    def test_swdo_case(self):
        post_data = {
            'email': 'test@example.com',
            'swdo': 'swdo',
            'case_type': 'Impacted',
            'service_type': 'Crisis'
        }
        
        # check http response
        response = self.client.post(self.url, post_data)
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json()['success'])
        self.assertEqual(response.json()['type_of_case'], 'Impacted')
        
        # checl if objects are created
        self.assertEqual(Case.objects.count(), 1)
        self.assertEqual(Victim.objects.count(), 1)
        self.assertEqual(Perpetrator.objects.count(), 1)
    
    def test_healthcare_case_behalf(self):
        post_data = {
            'email': 'test@example.com',
            'swdo': 'swdo',
            'case_type': 'Behalf',
            'service_type': 'Crisis'
        }
        
        # checks http respones
        response = self.client.post(self.url, post_data)
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json()['success'])
        self.assertEqual(response.json()['type_of_case'], 'Behalf')
        
        # check if ibjectsa are created
        self.assertEqual(Case.objects.count(), 1)
        self.assertEqual(Victim.objects.count(), 1)
        self.assertEqual(Perpetrator.objects.count(), 1)


from django.core.files.uploadedfile import SimpleUploadedFile
from pages.views import validate_file_upload
from django.contrib.admin.models import LogEntry, DELETION, CHANGE
from django.conf import settings
from account.models import Account
from unittest.mock import patch

class FileValidationTests(TestCase):
    def test_valid_image_upload(self):
        valid_image = SimpleUploadedFile("test.jpg", b"valid_content_here", content_type="image/jpeg")
        try:
            validate_file_upload(valid_image, 'image')
        except ValueError as e:
            self.fail(f"validate_file_upload raised ValueError for valid image: {e}")

    def test_invalid_extension_upload(self):
        invalid_file = SimpleUploadedFile("shell.php", b"<?php echo 'hack'; ?>", content_type="text/plain")
        with self.assertRaises(ValueError) as context:
            validate_file_upload(invalid_file, 'image')
        self.assertIn("is not allowed", str(context.exception))

    def test_invalid_mime_type_upload(self):
        invalid_file = SimpleUploadedFile("test.jpg", b"some content", content_type="text/html")
        with self.assertRaises(ValueError) as context:
            validate_file_upload(invalid_file, 'image')
        self.assertIn("MIME type", str(context.exception))

    def test_too_large_file_upload(self):
        large_content = b"0" * (6 * 1024 * 1024)
        large_file = SimpleUploadedFile("test.jpg", large_content, content_type="image/jpeg")
        with self.assertRaises(ValueError) as context:
            validate_file_upload(large_file, 'image')
        self.assertIn("exceeds the limit", str(context.exception))


class AuditLoggingTests(TestCase):
    def setUp(self):
        self.client = Client()
        self.User = get_user_model()
        self.admin_user = self.User.objects.create_superuser(
            username='adminuser', email='adminuser@example.com', password='password123'
        )
        # Create corresponding admin account so can_edit_case returns True
        Account.objects.get_or_create(user=self.admin_user, type='admin')
        self.client.login(email='adminuser@example.com', password='password123')

    def test_delete_account_audit_log(self):
        user_to_delete = self.User.objects.create_user(
            username='deleteme', email='deleteme@example.com', password='password123'
        )
        Account.objects.create(user=user_to_delete, type='staff')
        url = reverse('delete_account')
        response = self.client.post(url, {'account_id': user_to_delete.id})
        self.assertEqual(response.status_code, 200)

        log = LogEntry.objects.filter(action_flag=DELETION, object_id=user_to_delete.id).first()
        self.assertIsNotNone(log)
        self.assertIn("Deleted user account", log.change_message)

    def test_delete_case_audit_log(self):
        case = Case.objects.create(
            case_number=9999,
            email="victim@example.com",
            type_of_case="Impacted",
            service_information="Crisis",
            is_deleted=False
        )
        url = reverse('delete_case')
        response = self.client.post(url, {'case_id': case.id, 'reason': 'Duplicate entry'})
        self.assertEqual(response.status_code, 200)

        log = LogEntry.objects.filter(action_flag=CHANGE, object_id=case.id).first()
        self.assertIsNotNone(log)
        self.assertIn("Soft-deleted case", log.change_message)
        self.assertIn("Duplicate entry", log.change_message)

    def test_restore_case_audit_log(self):
        case = Case.objects.create(
            case_number=8888,
            email="victim2@example.com",
            type_of_case="Impacted",
            service_information="Crisis",
            is_deleted=True
        )
        url = reverse('restore_case')
        response = self.client.post(url, {'case_id': case.id})
        self.assertEqual(response.status_code, 200)

        log = LogEntry.objects.filter(action_flag=CHANGE, object_id=case.id).first()
        self.assertIsNotNone(log)
        self.assertIn("Restored case", log.change_message)

    @patch('account.views.send_email')
    def test_update_passkey_approve_audit_log(self, mock_send_email):
        user = self.User.objects.create_user(
            username='user_for_passkey', email='passkey@example.com', password='password123'
        )
        account = Account.objects.create(user=user, type='staff')
        
        url = reverse('update_passkey')
        response = self.client.post(url, {'email': 'passkey@example.com', 'action': 'approve'})
        self.assertEqual(response.status_code, 200)

        log = LogEntry.objects.filter(action_flag=CHANGE, object_id=account.pk).first()
        self.assertIsNotNone(log)
        self.assertIn("Approved passkey reset request", log.change_message)


class SettingsSecurityTests(TestCase):
    def test_timezone_aware_setting(self):
        self.assertTrue(settings.USE_TZ)

    def test_session_idle_duration_is_safe(self):
        self.assertLessEqual(settings.AUTO_LOGOUT['SESSION_TIME'].total_seconds(), 3600)
