from django.db import models

class Payroll(models.Model):
    payroll_id = models.CharField(max_length=255, primary_key=True, unique=True)
    employee_id = models.CharField(max_length=255, unique=True)
    pay_period_start = models.DateField()
    pay_period_end = models.DateField()
    employment_type = models.CharField(max_length=20)
    base_salary = models.DecimalField(max_digits=12, decimal_places=2)
    overtime_hours = models.DecimalField(max_digits=5, decimal_places=2)
    overtime_pay = models.DecimalField(max_digits=12, decimal_places=2)
    holiday_pay = models.DecimalField(max_digits=12, decimal_places=2)
    bonus_pay = models.DecimalField(max_digits=12, decimal_places=2)
    thirteenth_month_pay = models.DecimalField(max_digits=12, decimal_places=2)
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
    status = models.CharField(max_length=20)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        db_table = '"human_resources"."payroll"' 
        managed = False