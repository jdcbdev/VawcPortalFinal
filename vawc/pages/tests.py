from django.test import TestCase, Client
from django.urls import reverse
from case.models import Case, Victim, Perpetrator, Contact_Person

class AddNewCaseViewTest(TestCase):
    def setUp(self):
        self.client = Client()
        self.url = reverse('add_new_case')
    
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
