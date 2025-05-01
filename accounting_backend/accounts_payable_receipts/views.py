from rest_framework import viewsets
from .models import AccountsPayableReceipt
from .serializers import AccountsPayableReceiptSerializer

class AccountsPayableReceiptViewSet(viewsets.ModelViewSet):
    queryset = AccountsPayableReceipt.objects.all()
    serializer_class = AccountsPayableReceiptSerializer
