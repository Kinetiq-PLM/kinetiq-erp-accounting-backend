from rest_framework import generics
from .models import Invoice
from .serializers import InvoiceSerializer
from django.db.models import Exists, OuterRef
from official_receipts.models import OfficialReceipt
from django.db.models import Q
from decimal import Decimal

class InvoiceListView(generics.ListAPIView):
    serializer_class = InvoiceSerializer

    def get_queryset(self):
        """
        Returns a queryset of invoices with remaining_balance > 0 and is_returned = False.
        If 'for_journal' is True and 'require_receipt' is True, only invoices with associated OfficialReceipts are included.
        Uses Decimal for precise comparison to handle floating-point edge cases.
        """
        # Use Decimal for precise comparison, with a small threshold to avoid tiny balances
        queryset = Invoice.objects.filter(
            Q(remaining_balance__gt=Decimal('0.01')),  # Threshold to avoid tiny balances
            is_returned=False
        )
        
        # Apply additional filter if for_journal is True
        if self.request.query_params.get('for_journal', 'false').lower() == 'true':
            # REVISED: Only apply receipt filter if require_receipt is explicitly true
            if self.request.query_params.get('require_receipt', 'true').lower() == 'true':
                queryset = queryset.filter(
                    Exists(OfficialReceipt.objects.filter(invoice_id=OuterRef('invoice_id')))
                )
        
        return queryset

class InvoiceDetailView(generics.RetrieveAPIView):
    """
    Retrieves a single invoice by invoice_id.
    """
    queryset = Invoice.objects.all()
    serializer_class = InvoiceSerializer
    lookup_field = 'invoice_id'