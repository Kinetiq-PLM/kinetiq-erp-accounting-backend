from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import FinancialReportViewSet

# Create a router and register the viewset
router = DefaultRouter()
router.register(r'financial-reports', FinancialReportViewSet)

urlpatterns = [
    path('', include(router.urls)),
]