from django.contrib import admin

# Register your models here.
from .models import EleList, EleAlarm

admin.site.register(EleList)
admin.site.register(EleAlarm)

