from django.urls import path
from .views import PayrollAccountingListCreateView, PayrollAccountingRetrieveUpdateView

urlpatterns = [
    path('payroll_accounting/', PayrollAccountingListCreateView.as_view(), name='payroll_accounting_list_create'),
    path('payroll_accounting/<str:pk>/', PayrollAccountingRetrieveUpdateView.as_view(), name='payroll_accounting_detail'),
]
