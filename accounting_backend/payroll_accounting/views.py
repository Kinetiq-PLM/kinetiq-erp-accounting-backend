from rest_framework import generics
from .models import PayrollAccounting
from .serializers import PayrollAccountingSerializer, PayrollJournalViewSerializer, PayrollJournalView

class PayrollAccountingListCreateView(generics.ListCreateAPIView):
    queryset = PayrollAccounting.objects.all()
    serializer_class = PayrollAccountingSerializer

class PayrollAccountingRetrieveUpdateView(generics.RetrieveUpdateAPIView):
    queryset = PayrollAccounting.objects.all()
    serializer_class = PayrollAccountingSerializer

class PayrollJournalViewListView(generics.ListAPIView):
    queryset = PayrollJournalView.objects.all()
    serializer_class = PayrollJournalViewSerializer

class PayrollJournalViewRetrieveView(generics.RetrieveAPIView):
    queryset = PayrollJournalView.objects.all()
    serializer_class = PayrollJournalViewSerializer
