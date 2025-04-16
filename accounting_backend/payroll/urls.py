from django.urls import path
from .views import PayrollListView

urlpatterns = [
    path('payrolls/', PayrollListView.as_view(), name='payroll-list'),
]