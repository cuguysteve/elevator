from django.contrib import admin

# Register your models here.
from .models import ElevatorList
from .models import Elevator

admin.site.register(ElevatorList )
admin.site.register(Elevator )
