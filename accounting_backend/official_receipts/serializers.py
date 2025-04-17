from rest_framework import serializers
from .models import OfficialReceipt
import re

class OfficialReceiptSerializer(serializers.ModelSerializer):
    class Meta:
        model = OfficialReceipt
        fields = '__all__'

    def validate_reference_number(self, value):
        if value is None or value == '':
            return value  # Allow blank/null as per model
        if not re.match(r'^REF-[a-z0-9]{6}$', value):
            raise serializers.ValidationError("Reference number must be in the format 'REF-<6-character alphanumeric>' (e.g., REF-4e8663).")
        return value