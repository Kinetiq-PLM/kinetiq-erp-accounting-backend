from rest_framework import serializers
from .models import PayrollRemittance

class PayrollRemittanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = PayrollRemittance
        fields = '__all__'
