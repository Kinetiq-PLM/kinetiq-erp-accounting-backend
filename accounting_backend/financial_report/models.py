from django.db import models

from django.db import models

class FinancialReport(models.Model):
    report_id = models.CharField(max_length=255, primary_key=True)
    report_type = models.CharField(max_length=255) 
    total_cost = models.DecimalField(max_digits=15, decimal_places=2) 
    start_date = models.DateField()  
    end_date = models.DateField(null=True, blank=True)  
    generated_by = models.CharField(max_length=255) 

    def __str__(self):
        return f"{self.report_id} - {self.report_type}"
    
    class Meta:
        db_table = "financial_report"  # Correct indentation
        managed = False  # Correct indentation
