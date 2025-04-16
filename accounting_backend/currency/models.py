from django.db import models

class Currency(models.Model):
    currency_id = models.CharField(max_length=255, primary_key=True, default='currency_id')
    currency_name = models.CharField(max_length=255, default='currency_name')
    exchange_rate = models.DecimalField(max_digits=15, decimal_places=6)
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = '"admin"."currency"'
        managed = False