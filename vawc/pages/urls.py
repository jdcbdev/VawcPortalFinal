from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from django.contrib.auth import views as auth_views
from . import views

urlpatterns = [
    path('login/', views.login_view, name='login'),
    #password forgot
    path('forgot-password/', views.forgot_pass_view, name='forgot pass'),
    path('forgot-password/sent', views.forgot_pass_confirm_sent_view, name='forgot_pass_sent'),
    path('change_password/<uidb64>/<token>/', views.change_password_view, name='change_password'),
    path('process_change_password/<uidb64>/<token>/', views.process_change_password, name='process_change_password'),
    path('forgot_password/success/', views.success_reset_view, name='success_reset_password'),
    
    
    path('login-with-otp/', views.login_with_otp, name='login_with_otp'),
    path('verify-otp/', views.verify_otp, name='verify_otp'),
    path('resend-otp/', views.resend_otp, name='resend_otp'),
    path('logout/', views.logout_view, name='logout'),
    path('track_case/', views.track_case_view, name='track_case'),
    path('check_email_case/', views.check_email_case, name='check_email_case'),
    path('check_phone_case/', views.check_phone_case, name='check_phone_case'),
    path('verify-otp-email-case/', views.verify_otp_email_track_case, name='verify_otp_email_track_case'),
    path('verify-otp-phone-case/', views.verify_otp_phone_track_case, name='verify_otp_phone_track_case'),
    path('track_case_info/<str:contact_type>/<str:user_contact>/<str:token>/', views.track_case_info_view, name='track_case_info'),
    path('error_404/', views.error_view, name='error_view'),
    
    #anonymouse side
    path('report_violence/', views.report_violence_view, name='report violence'),
    path('impact-victim-survivor/', views.impact_victim_view, name='impact victim'),
    path('behalf-victim-survivor/', views.behalf_victim_view, name='behalf impact victim'),
    path('add-case/', views.add_case, name='add_case'),
    path('email-confrim/', views.email_confirm, name='email_confirm'),
    path('phone-confirm/', views.phone_confirm, name='phone_confirm'),
    path('verify-otp-email/', views.verify_otp_email, name='verify_otp_email'),
    path('verify-otp-phone/', views.verify_otp_phone, name='verify_otp_phone'),
    path('resend-otp-email/', views.resend_otp_email, name='resend_otp_email'),
    path('resend-otp-phone/', views.resend_otp_phone, name='resend_otp_phone'),

    #super admin side
    path('admin-vawc/dashboard/', views.admin_dashboard_view, name='admin dashboard'),
    path('admin-vawc/admin-dashboard-data/<int:get_year>/', views.admin_dashboard_data, name='admin dashboard data'),
    path('admin-vawc/graph-report/', views.admin_graph_view, name='admin graph'),
    path('admin-vawc/manage/account/', views.admin_manage_account_view, name='admin account'),
    path('admin-vawc/manage/law-enforcement-account/', views.law_enforcement_manage_account_view, name='law enforcement account'),
    path('admin-vawc/manage/passkey/', views.admin_manage_passkey_view, name='admin passkey'),
    path('admin-vawc/create_account/', views.create_account, name='create account'),
    path('admin-vawc/create_law-enforcement-account/', views.create_law_enforcement_account, name='create law enforcement account'),
    path('admin-vawc/edit_account/<int:account_id>/', views.edit_account_view, name='edit_account'),
    path('admin-vawc/edit_law-enforcement_account/<int:account_id>/', views.edit_law_enforcement_account_view, name='edit_law-enforcement_account'),
    path('delete_account/', views.delete_account, name='delete_account'),
    path('check_username_email/', views.check_username_email, name='check_username_email'),
    path('admin-vawc/settings/', views.admin_settings_view, name='admin settings'),
    path('admin-vawc/notification', views.super_admin_notification_view, name="notif admin"),

    path('admin-vawc/case/', views.admin_case_view, name='admin case'),
    path('add-new-case/', views.add_new_case, name='add_new_case'),
    path('admin-vawc/view-case/behalf/<int:case_id>/', views.view_admin_case_behalf, name='admin case behalf view'),
    path('admin-vawc/view-case/impacted/<int:case_id>/', views.view_admin_case_impact, name='admin case impacted view'),
    path('admin-vawc/case/pdf/<int:case_id>/', views.pdf_template_view, name='pdf case'),
    # path('process_service_info/', views.process_service_info, name='process_service_info'),
    
    #barangay admin side
    path('admin-barangay-vawc/dashboard/', views.barangay_dashboard_view, name='barangay dashboard'),
    path('admin-barangay-vawc/barangay-dashboard-data/<int:get_year>/', views.barangay_dashboard_data, name='barangay dashboard data'),
    path('admin-barangay-vawc/settings/', views.barangay_settings_view, name='barangay settings'),

    path('add_status/<int:case_id>/', views.add_status, name='add_status'),
    path('edit_status/<int:status_id>/', views.edit_status, name='edit_status'),
    path('delete_status/<int:status_id>/', views.delete_status, name='delete_status'),

    path('admin-barangay-vawc/case/', views.barangay_case_view, name='barangay case'),
    path('add-new-case/', views.add_new_case, name='add_new_case'),
    path('admin-barangay-vawc/view-case/behalf/<int:case_id>/', views.view_case_behalf, name='barangay case behalf view'),
    path('admin-barangay-vawc/view-case/impacted/<int:case_id>/', views.view_case_impact, name='barangay case impacted view'),
    path('admin-barangay-vawc/case/pdf/<int:case_id>/', views.pdf_template_view, name='pdf case'),
    path('process_service_info/', views.process_service_info, name='process_service_info'),

    #law enforcement admin side
    # path('admin-law-enforcement-vawc/dashboard/', views.law_enforcement_dashboard_view, name='law enforcement dashboard'),
    # path('admin-law-enforcement-vawc/law-enforcement-dashboard-data/<int:get_year>/', views.law_enforcement_dashboard_data, name='law enforcement dashboard data'),
    path('admin-law-enforcement-vawc/settings/', views.law_enforcement_settings_view, name='law enforcement settings'),

    path('add_status/<int:case_id>/', views.add_status, name='add_status'),
    path('edit_status/<int:status_id>/', views.edit_status, name='edit_status'),
    path('delete_status/<int:status_id>/', views.delete_status, name='delete_status'),

    path('admin-law-enforcement-vawc/case/', views.law_enforcement_case_view, name='law enforcement case'),
    path('admin-law-enforcement-vawc/view-law-enforcement-case/behalf/<int:case_id>/', views.view_enforcement_case_behalf, name='law enforcement case behalf view'),
    path('admin-law-enforcement-vawc/view-law-enforcement-case/impacted/<int:case_id>/', views.view_enforcement_case_impact, name='law enforcement case impacted view'),
    path('admin-law-enforcement-vawc/case/pdf/<int:case_id>/', views.pdf_template_view, name='pdf case'),
    path('process_service_info/', views.process_service_info, name='process_service_info'),
    # path('pages/select-police-station/', views.select_police_station, name='select-police-station'),

    # NOTIF
    path('admin-barangay-vawc/notification', views.admin_notification_view, name="Notification"),
    path('read_notification/', views.read_notification, name='read_notification'),
    path('get_all_notification_barangay/', views.get_all_notification_barangay, name='get_all_notification_barangay'),
    path('get_all_notification_admin/', views.get_all_notification_admin, name='get_all_notification_admin'),
    

    # GRAPH
    path('update_graph_table_report/', views.update_graph_table_report, name='update_graph_table_report'),
    path('update_graph_report/', views.update_graph_report, name='update_graph_report'),
    path('send_email_report/', views.send_email_report, name='send_email_report'),

    path('add_new_contact_person/', views.add_new_contact_person, name='add_new_contact_person'),
    path('save_victim_data/<int:victim_id>/', views.save_victim_data, name='save_victim_data'),
    path('add_new_victim_data/', views.add_new_victim, name='add_new_victim'),
    path('delete_victim_data/', views.delete_victim, name='delete_victim'),
    path('add_new_perpetrator_data/', views.add_new_perpetrator, name='add_new_perpetrator'),
    path('save_perpetrator_data/<int:perpetrator_id>/', views.save_perpetrator_data, name='save_perpetrator_data'),
    path('delete_perpetrator_data/', views.delete_perpetrator, name='delete_perpetrator'),
    path('process_incident_form/', views.process_incident_form, name='process_incident_form'),
    path('save_contact_person_data/<int:contact_person_id>/', views.save_contact_person_data, name='save_contact_person_data'),
    path('delete_case/', views.delete_case, name='delete_case'),
    path('update_case_status/<int:case_id>/', views.update_case_status, name='update_case_status'),
    path('update_case_date_closed/<int:case_id>/', views.update_case_date_closed, name='update_case_date_closed'),

    path('admin-barangay-vawc/parent_victim/<int:case_id>/<int:victim_id>/', views.add_parent_view, name='add_parent'),
    path('save_parent_data/<int:parent_id>/', views.save_parent_data, name='save_parent_data'),
    path('add_new_parent_data/', views.add_new_parent_form, name='add_new_parent_form'),
    path('check_parent_count/', views.check_parent_count, name='check_parent_count'),
    path('delete_parent_data/', views.delete_parent, name='delete_parent'),

    path('admin-barangay-vawc/parent_perpetrator/<int:case_id>/<int:perp_id>/', views.add_parent_perp_view, name='add_parent_perp'),
    path('add_new_parent_perp_data/', views.add_new_parent_perp_form, name='add_new_parent_perp_form'),
    path('save_parent_perp_data/<int:parent_id>/', views.save_parent_perp_data, name='save_parent_perp_data'),
    path('delete_parent_perp_data/', views.delete_parent_perp, name='delete_parent_perp'),
    
    #user
    path('custom_password_change/', views.custom_password_change_view, name='custom_password_change'),

    path('encrypt_decrypt/', views.encrypt_decrypt, name='encrypt_decrypt'),


    #misc
    path('pages/select-address/', views.ph_address, name='ph_address'),
    path('pages/get-police-station/', views.get_police_station, name='get police station'),
]

# Serve media files during development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)