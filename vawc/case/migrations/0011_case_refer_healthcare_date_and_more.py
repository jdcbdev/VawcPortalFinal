# Generated by Django 5.0.1 on 2024-03-29 02:36

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('case', '0010_alter_witness_email'),
    ]

    operations = [
        migrations.AddField(
            model_name='case',
            name='refer_healthcare_date',
            field=models.DateField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='case',
            name='refer_law_enforcement_date',
            field=models.DateField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='case',
            name='refer_other_service_date',
            field=models.DateField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='case',
            name='refer_social_date',
            field=models.DateField(blank=True, null=True),
        ),
    ]
