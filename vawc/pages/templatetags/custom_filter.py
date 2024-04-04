from django import template
from datetime import datetime

register = template.Library()

@register.filter
def get_latest_status(history):
    return history.latest('status_date_added') if history.exists() else None

@register.filter
def calculate_age(date_of_birth_str):
    try:
        date_of_birth = datetime.strptime(date_of_birth_str, '%Y-%m-%d')
        today = datetime.now()
        age = today.year - date_of_birth.year - ((today.month, today.day) < (date_of_birth.month, date_of_birth.day))
        return age
    except ValueError:
        return None