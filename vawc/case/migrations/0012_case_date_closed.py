# Generated by Django 5.0.1 on 2024-03-29 02:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('case', '0011_case_refer_healthcare_date_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='case',
            name='date_closed',
            field=models.DateField(blank=True, null=True),
        ),
    ]