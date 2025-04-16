from rest_framework import serializers
from .models import Payroll

class PayrollSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payroll
        fields = [
            'payroll_id', 'employee_id', 'pay_period_start', 'pay_period_end',
            'employment_type', 'base_salary', 'overtime_hours', 'overtime_pay',
            'holiday_pay', 'bonus_pay', 'thirteenth_month_pay', 'gross_pay',
            'sss_contribution', 'philhealth_contribution', 'pagibig_contribution',
            'tax', 'late_deduction', 'absent_deduction', 'undertime_deduction',
            'total_deductions', 'net_pay', 'status', 'created_at', 'updated_at'
        ]
        read_only_fields = ['gross_pay', 'total_deductions', 'net_pay']