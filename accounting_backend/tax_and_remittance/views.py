from rest_framework import viewsets
from .models import PayrollRemittance
from .serializers import PayrollRemittanceSerializer

class PayrollRemittanceViewSet(viewsets.ModelViewSet):
    queryset = PayrollRemittance.objects.all()
    serializer_class = PayrollRemittanceSerializer

