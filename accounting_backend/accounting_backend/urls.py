"""
URL configuration for accounting_backend project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/", include("chart_of_accounts.urls")),  # Include your app's URLs
    path("api/", include("journal_entry.urls")),  # Add this line
    path("api/", include("general_ledger.urls")),  # Add this line
    path("api/", include("journal_entry_lines.urls")),  # Add this line
    path("api/", include("official_receipts.urls")),  # Add this line
    path("api/", include("currency.urls")),  # Add this line
]

