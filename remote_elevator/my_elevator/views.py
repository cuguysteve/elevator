import json
import multiprocessing
import os
import socket
import select
import time

from django.http import HttpResponse
from django.shortcuts import render
from django.shortcuts import render_to_response
from models import EleList, EleAlarm

# Create your views here.

def _contrl(ipaddr, action):
    ''' Action is STOP. '''
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((ipaddr, 4567))
        s.sendall(action)
        # socket timeout is 120s.
        timeout = 60 * 2
        s.setblocking(0)
        ready = select.select([s], [], [], timeout)
        if ready[0]:
            data = s.recv(1024).strip('\x00')
            if s.recv(256) == 'Done':
                print('Have already receive the response from client...')
    except Exception as ex:
        print 'Error creating socket: {}'.format(ex)
        raise
    finally:
        s.close()
    

def do_get(request):
    ''' Get method. '''
    if request.GET.get('Period'):
        period = request.GET.get('Period')
        per_data = json.loads(period)
        sn = EleList.objects.get(SerilNo = per_data['SN'])
        if sn.status == 'Active':
            sn.ConTime = time.localtime(time.time())
        else:
            return HttpResponse(status = 400)

    elif request.GET.get('Boot'):
        boot = request.GET.get('Boot')
        rel_data = json.loads(boot)
        if rel_data:
            sn = EleList.objects.get(SerilNo = rel_data['SN'])
            if sn:
                if sn.Status == 'Active':
                    return HttpResponse(content = 'Conflict device.', status = 409)
                elif sn.Status == 'No Active':
                    sn.Status = 'Active'
                    sn.ConTime = time.localtime(time.time())
            else:
                EleList(SerialNo = rel_data['SN'],
                        IpAddr = rel_data['IP'],
                        Location = rel_data['Loc'],
                        Vendor = rel_data['Ven'],
                        Model = rel_data['Model'],
                        Period = rel_data['Period'],
                        Longit = rel_data['Longit'],
                        Latit = rel_data['Latit']).save()

                EleAlarm(SerialNo = rel_data['SN'],
                         Alarm = 0,
                         Datetime = sn.ConTime).save()

                return HttpResponse()
        else:
            return HttpResponse(content = 'No data.', status = 400)

    elif request.GET.get('Update'):
        update = request.GET.get('Update')
        rel_data = json.loads(update)
        if rel_data:
            sn = EleList.objects.get(SerilNo = rel_data['SN'])
            if sn:
                EleList(SerialNo = rel_data['SN'],
                        IpAddr = rel_data['IP'],
                        Location = rel_data['Loc'],
                        Vendor = rel_data['Ven'],
                        Model = rel_data['Model'],
                        Period = rel_data['Period'],
                        Longit = rel_data['Longit'],
                        Latit = rel_data['Latit']).save()

                EleAlarm(SerialNo = rel_data['SN'],
                         Alarm = rel_data['Alarm'],
                         Datetime = time.localtime(time.time())).save()

                return HttpResponse()
            else:
                return HttpResponse(content = 'No data', status = 400)

    elif request.GET.get('GetParameter'):
        # For App or Web.
        getp = request.GET.get('GetParameter')
        print 'getparameter is ' + getp
        res = {}
        items = EleList.objects.all()
        for item in items:
            res[item.SerialNo] = {'Period':item.Period, 'IP':item.IpAddr, 'Ven':item.Vendor,
                       'Model':item.Model, 'ConTime':item.ConTime.strftime('%Y-%m-%d-%H:%M:%S'),
                       'Longit':item.Longit, 'Latit':item.Latit,
                       'Alarm':EleAlarm.objects.get(SerialNo = getp).Alarm}
        return HttpResponse(content = json.dumps(res))
    elif request.GET.get('BootStrap'):
        # for App: We need to send the customer data after analysis.
        # And, I think we need to get the customer name, and just send the 
        # dev info which he/she response.
        #boot = request.GET.get('BootStrap')
        items = EleAlarm.objects.all()
        if items:
            res = {}
            for item in items:
                
                loc = item.SerialNo.Location
                datetime = item.Datetime
                res[item.SerialNo.SerialNo] = {'Alarm':item.Alarm, 'Loc':loc,
                                      'Datetime':datetime.strftime('%Y-%m-%d-%H:%M:%S')}
            if res:
                return HttpResponse(content = json.dumps(res))
            else:
                return HttpResponse(content = 'Internal Error: No response',
                                                               status = 500)
        else:
            return HttpResponse(content = 'No alarm dev')

    elif request.GET.get('Contrl'):
        ''' You need to give SN and Action (for stop or run elevtor).
            Format: SN:<>, Action:<RUN/STOP>
        '''
        getp = request.GET.get('Contrl')
        print getp
        rel_data = json.loads(getp)
        print('Got control request: {}'.format(rel_data))
        if rel_data:
            print rel_data['SN']
            sn = EleList.objects.get(SerilNo = rel_data['SN'])
            if sn:
                print 'sn is get from control GET'
                try:
                    proc = multiprocessing.Process(target=_contrl,
                                   args=(sn.IpAddr, rel_data['Action']))
                    proc.start()
                except Exception as ex:
                    print ex

    return HttpResponse(content = 'Bad Request', status = 400)

def do_post(request):
    return HttpResponse(status = 200)

def do(request):
    if request.method == 'GET':
        return do_get(request)
    elif request.method == 'POST':
        return do_post(request)    
