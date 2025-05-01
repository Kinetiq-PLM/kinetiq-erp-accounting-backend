from rest_framework import serializers
from .models import AccountsPayableReceipt

class AccountsPayableReceiptSerializer(serializers.ModelSerializer):
    class Meta:
        model = AccountsPayableReceipt
        fields = '__all__'