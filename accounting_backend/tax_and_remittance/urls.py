from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import PayrollRemittanceViewSet

router = DefaultRouter()
router.register(r'payroll_remittances', PayrollRemittanceViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
