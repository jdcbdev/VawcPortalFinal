from django import forms
from PIL import Image
from django.contrib.auth.forms import PasswordChangeForm

    
class CustomPasswordChangeForm(PasswordChangeForm):
    def __init__(self, user, *args, **kwargs):
        super(CustomPasswordChangeForm, self).__init__(user, *args, **kwargs)
        del self.fields['old_password']
