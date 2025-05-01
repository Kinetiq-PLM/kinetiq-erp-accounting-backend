from rest_framework import generics
from .models import PayrollAccounting
from .serializers import PayrollAccountingSerializer

class PayrollAccountingListCreateView(generics.ListCreateAPIView):
    queryset = PayrollAccounting.objects.all()
    serializer_class = PayrollAccountingSerializer

class PayrollAccountingRetrieveUpdateView(generics.RetrieveUpdateAPIView):
    queryset = PayrollAccounting.objects.all()
    serializer_class = PayrollAccountingSerializer
