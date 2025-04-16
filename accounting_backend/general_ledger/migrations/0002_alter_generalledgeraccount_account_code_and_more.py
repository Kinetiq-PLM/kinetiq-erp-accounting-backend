# Generated by Django 5.1.6 on 2025-04-16 02:59

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('general_ledger', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='generalledgeraccount',
            name='account_code',
            field=models.CharField(max_length=255, unique=True),
        ),
        migrations.AlterField(
            model_name='generalledgeraccount',
            name='gl_account_id',
            field=models.CharField(max_length=255, primary_key=True, serialize=False, unique=True),
        ),
    ]
