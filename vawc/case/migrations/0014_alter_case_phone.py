# Generated by Django 5.0.1 on 2024-07-09 17:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('case', '0013_case_phone'),
    ]

    operations = [
        migrations.AlterField(
            model_name='case',
            name='phone',
            field=models.CharField(blank=True, default=None, max_length=30, null=True),
        ),
    ]
