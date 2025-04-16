from rest_framework import generics
from .models import Payroll
from .serializers import PayrollSerializer

class PayrollListView(generics.ListAPIView):
    queryset = Payroll.objects.all()
    serializer_class = PayrollSerializer
