from django.db import models

class PayrollAccounting(models.Model):
    payroll_accounting_id = models.CharField(max_length=50, primary_key=True)
    payroll_hr_id = models.ForeignKey(
        'payroll.Payroll',
        on_delete=models.CASCADE,
        to_field='payroll_id',  # Referencing payroll_id
        db_column='payroll_hr_id'
    )
    date_approved = models.DateTimeField()
    approved_by = models.CharField(max_length=100)
    payment_method = models.CharField(max_length=50)
    reference_number = models.CharField(max_length=100)
    status = models.CharField(max_length=50)

    class Meta:
        db_table = 'payroll_accounting'