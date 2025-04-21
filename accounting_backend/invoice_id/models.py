from django.db import models

class Invoice(models.Model):
    invoice_id = models.CharField(max_length=255, primary_key=True)
    delivery_note_id = models.CharField(max_length=255)
    is_returned = models.BooleanField(default=False)
    invoice_date = models.DateTimeField()
    total_amount = models.DecimalField(max_digits=10, decimal_places=2)
    total_amount_paid = models.DecimalField(max_digits=10, decimal_places=2)
    remaining_balance = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        db_table = '"sales"."sales_invoices"'
        managed = False

