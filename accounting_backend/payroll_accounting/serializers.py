from rest_framework import serializers
from .models import PayrollAccounting, PayrollJournalView

class PayrollAccountingSerializer(serializers.ModelSerializer):
    class Meta:
        model = PayrollAccounting
        fields = '__all__'
        
class PayrollJournalViewSerializer(serializers.ModelSerializer):
    class Meta:
        model = PayrollJournalView
        fields = '__all__'