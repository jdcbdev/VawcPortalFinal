================================================================================
VAWC PROJECT DOCUMENTATION
================================================================================

This documentation provides comprehensive guidance on how to understand the core 
modules of the VAWC Project (VawcPortalFinal). The project is built using Python, 
Django (MVT architecture), and MySQL, with various third-party integrations 
(Twilio, Recaptcha, Weasyprint).

NOTE: For setup and troubleshooting instructions, please see `start.txt`.


--------------------------------------------------------------------------------
PROJECT MODULES OVERVIEW
--------------------------------------------------------------------------------
The VAWC project follows Django's Model-View-Template (MVT) architecture and is 
split into distinct functional apps (modules).


A. ACCOUNT MODULE (vawc/account)
--------------------------------
This module handles custom user authentication, role-based access control, and 
dynamic application settings.

Models:
- CustomUser: Extends Django's AbstractUser to enforce email-based login.
- Account: Stores extended profile fields (Status, Type [Admin/Staff], Address, 
           Verification) and is linked 1-to-1 with CustomUser.
- PoliceStation: Stores geographic mapping of police stations.
- Passkey_Reset: Tracks passkey recovery requests.
- Email, Recaptcha, Twilio: Dynamic configuration models to let administrators 
  configure 3rd-party credentials via the UI instead of hardcoding them.

Views: 
Dedicated to passkey requests, dispatching emails, and notifying users.


B. CASE MODULE (vawc/case)
--------------------------------
This is the core data module defining the structure of VAWC incidents.

Models:
- Case: The primary entity tracking incident details, case numbers, service 
        referrals, and general status.
- Victim: Detailed profiles of victims including demographics / familial status.
- Perpetrator: Demographics and relationship matrices of the accused.
- Parent / Parent_Perpetrator: Guardianship tracking for minors involved.
- Witness & Contact_Person: Supplemental personnel involved in the case.
- Evidence: Handles file uploads tied to specific cases.
- Status_History: Audit trails for tracking the lifecycle of a case.
- Notification: In-system alerts routed to specific receivers.


C. PAGES MODULE (vawc/pages)
--------------------------------
This is the primary presentation and business logic layer (Views & Templates), 
driving the UI dashboards and workflows.

Features & Views:
- Public/Landing Pages: Home page, login, forgot password, and case tracking.
- Dashboards: Separate dashboards and analytics views populating year-over-year 
              or geographic case statistics.
- Account Management: Role-specific logic to CRUD (Create, Read, Update, Delete) 
                      law enforcement, healthcare providers, SWDO, and admins.
- Case Management: Render logic for displaying cases, exporting data (via 
                   weasyprint for PDF reports), and handling form submissions.
- Geographic Utilities: Leverages `django-ph-geography` for regional filters.


D. DATA MODULE (vawc/data)
--------------------------------
A supplementary asset directory housing static data fixtures (like address.json) 
useful for geographic UI population without hitting the database repeatedly.


E. VAWC ROOT APP (vawc/)
--------------------------------
The core configuration folder integrating all independent apps.

Key settings.py Considerations:
1. File Uploads (Evidence): All uploaded media (like case evidence) is routed 
   to /img/ and physically stored in the static/uploads directory.

2. Session Lifetimes: The system natively uses django-auto-logout with an idle 
   timeout of 30 minutes to enforce security for admin portals.

3. Case Tracking OTPs: Although case tracking natively supports email and Twilio 
   OTPs, this feature is disabled by default for local development 
   (ENABLE_OTP = False at the bottom of settings.py). 
   Set this to True when testing notifications.
