from django.shortcuts import render
from django.http import HttpResponse
import json
from my_elevator.models import ElevatorList, Elevator

# Create your views here.

def get_all(request):
   if request.method == 'GET':
      to_json={}
      for ob in ElevatorList.objects.all():
         to_json[ob.sn] =  {
         "status": ob.status,
         "address": ob.address,
         "contact person": ob.contact_person,
         "contact number": ob.contact_number,}
      return HttpResponse(json.dumps(to_json), content_type='application/json')
