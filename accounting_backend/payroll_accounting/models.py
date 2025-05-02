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

class PayrollJournalView(models.Model):
    payroll_accounting_id = models.CharField(max_length=255, primary_key=True)
    payroll_hr_id = models.CharField(max_length=255)
    employee_id = models.CharField(max_length=255)
    pay_period_start = models.DateField()
    pay_period_end = models.DateField()
    employment_type = models.CharField(max_length=20)
    base_salary = models.DecimalField(max_digits=12, decimal_places=2)
    overtime_hours = models.DecimalField(max_digits=5, decimal_places=2)
    overtime_pay = models.DecimalField(max_digits=12, decimal_places=2)
    holiday_pay = models.DecimalField(max_digits=12, decimal_places=2)
    bonus_pay = models.DecimalField(max_digits=12, decimal_places=2)
    thirteenth_month_pay = models.DecimalField(max_digits=12, decimal_places=2)
    total_bonuses = models.DecimalField(max_digits=12, decimal_places=2)
    gross_pay = models.DecimalField(max_digits=12, decimal_places=2)
    sss_contribution = models.DecimalField(max_digits=12, decimal_places=2)
    philhealth_contribution = models.DecimalField(max_digits=12, decimal_places=2)
    pagibig_contribution = models.DecimalField(max_digits=12, decimal_places=2)
    tax = models.DecimalField(max_digits=12, decimal_places=2)
    late_deduction = models.DecimalField(max_digits=12, decimal_places=2)
    absent_deduction = models.DecimalField(max_digits=12, decimal_places=2)
    undertime_deduction = models.DecimalField(max_digits=12, decimal_places=2)
    total_deductions = models.DecimalField(max_digits=12, decimal_places=2)
    net_pay = models.DecimalField(max_digits=12, decimal_places=2)
    status = models.CharField(max_length=50)
    date_approved = models.DateTimeField()
    reference_number = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'payroll_journal_view'

    def __str__(self):
        return f"Payroll Journal {self.payroll_accounting_id} - {self.employee_id}"