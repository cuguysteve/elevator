from django.shortcuts import render
from django.http import HttpResponse
import json
from my_elevator.models import ElevatorList, Elevator
from django_sse.redisqueue import RedisQueueView
from django_sse.redisqueue import send_event


#class SSE(RedisQueueView):
#    to_json={}
#    for ob in ElevatorList.objects.all():
#       to_json[ob.sn] =  {
#       "status": ob.status,
#       "address": ob.address,
#       "contact person": ob.contact_person,
#       "contact number": ob.contact_number,}
#    send_event('getall',json.dumps(to_json))
#    pass

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

def get_alert(request):
   if request.method == 'GET':
      to_json={}
      for ob in ElevatorList.objects.filter(status=0):
         to_json[ob.sn] =  {
         "status": ob.status,
         "address": ob.address,
         "contact person": ob.contact_person,
         "contact number": ob.contact_number,
         "date" : ob.pub_date.strftime("%Y-%m-%d-%H-%M-%S"),}

      return HttpResponse(json.dumps(to_json), content_type='application/json')

def get_warning(request):
   if request.method == 'GET':
      to_json={}
      for ob in ElevatorList.objects.filter(status=1):
         to_json[ob.sn] =  {
         "status": ob.status,
         "address": ob.address,
         "contact person": ob.contact_person,
         "contact number": ob.contact_number,
         "date" : ob.pub_date.strftime("%Y-%m-%d-%H-%M-%S"),}
      return HttpResponse(json.dumps(to_json), content_type='application/json')

def get_normal(request):
   if request.method == 'GET':
      to_json={}
      for ob in ElevatorList.objects.filter(status=2):
         to_json[ob.sn] =  {
         "status": ob.status,
         "address": ob.address,
         "contact person": ob.contact_person,
         "contact number": ob.contact_number,
         "date" : ob.pub_date.strftime("%Y-%m-%d-%H-%M-%S"),}
      return HttpResponse(json.dumps(to_json), content_type='application/json')
