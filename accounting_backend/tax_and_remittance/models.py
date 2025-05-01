from django.db import models

class PayrollRemittance(models.Model):
    REMITTANCE_STATUS_CHOICES = [
        ('Processing', 'Processing'),
        ('Completed', 'Completed'),
    ]

    PAYMENT_METHOD_CHOICES = [
        ('Credit Card', 'Credit Card'),
        ('Bank Transfer', 'Bank Transfer'),
        ('Cash', 'Cash'),
    ]

    remittance_id = models.CharField(max_length=255, primary_key=True)
    employee_id = models.CharField(max_length=255)
    deduction_type = models.CharField(max_length=50)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    payment_date = models.DateField()
    payment_method = models.CharField(max_length=50, choices=PAYMENT_METHOD_CHOICES)
    reference_number = models.CharField(max_length=100)
    status = models.CharField(max_length=50, choices=REMITTANCE_STATUS_CHOICES)

    class Meta:
        db_table = 'tax_and_remittances'
        managed = False

    def __str__(self):
        return f"Remittance {self.remittance_id} - {self.status}"

