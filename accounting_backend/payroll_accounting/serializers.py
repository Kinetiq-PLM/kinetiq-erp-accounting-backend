from rest_framework import serializers
from .models import PayrollAccounting

class PayrollAccountingSerializer(serializers.ModelSerializer):
    class Meta:
        model = PayrollAccounting
        fields = '__all__'
