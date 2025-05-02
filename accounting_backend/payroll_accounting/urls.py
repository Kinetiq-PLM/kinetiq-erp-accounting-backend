from django.urls import path
from .views import PayrollAccountingListCreateView, PayrollAccountingRetrieveUpdateView, PayrollJournalViewListView, PayrollJournalViewRetrieveView


urlpatterns = [
    path('payroll-accounting/', PayrollAccountingListCreateView.as_view(), name='payroll_accounting_list_create'),
    path('payroll-accounting/<str:pk>/', PayrollAccountingRetrieveUpdateView.as_view(), name='payroll_accounting_detail'),

    path('payroll-journal/', PayrollJournalViewListView.as_view(), name='payroll_journal_list'),
    path('payroll-journal/<str:pk>/', PayrollJournalViewRetrieveView.as_view(), name='payroll_journal_detail'),
]
