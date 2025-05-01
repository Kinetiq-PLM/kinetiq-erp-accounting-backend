from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import AccountsPayableReceiptViewSet

router = DefaultRouter()
router.register(r'accounts-payable-receipts', AccountsPayableReceiptViewSet, basename='accounts_payable_receipts')

urlpatterns = [
    path('', include(router.urls)),
]