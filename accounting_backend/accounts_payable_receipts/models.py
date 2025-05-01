from django.db import models

class AccountsPayableReceipt(models.Model):
    ap_id = models.CharField(max_length=255, primary_key=True)
    invoice_id = models.CharField(max_length=255)
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    payment_date = models.DateField()
    payment_method = models.CharField(max_length=50)  # Enum-like choices can be added here
    paid_by = models.CharField(max_length=100)
    reference_number = models.CharField(max_length=100)
    status = models.CharField(max_length=50)  # Enum-like choices can be added here

    class Meta:
        db_table = 'accounts_payable_receipts'
        managed = False

    def __str__(self):
        return f"AP Receipt {self.ap_id} - {self.status}"
