from django.db import models

# Create your models here.
class EleList(models.Model):
    ''' Elevator list. '''
    
    SerialNo = models.CharField(max_length = 20)
    IpAddr = models.CharField(max_length = 15)
    Location = models.CharField(max_length = 50)
    Vendor = models.CharField(max_length = 20)
    Model = models.CharField(max_length = 20)
    Status = models.CharField(max_length = 20)
    ConTime = models.DateTimeField('date published')
    Period = models.IntegerField()
    Longit = models.CharField(max_length = 20)
    Latit = models.CharField(max_length = 20)    

    def __unicode__(self):
        return self.SerialNo + self.Vendor + self.Status + self.Model
    
    class Meta:
        ordering = ["id"]
        
class EleAlarm(models.Model):
    ''' Record all alarms. '''
    
    SerialNo = models.ForeignKey(EleList)
    Alarm = models.IntegerField()
    Datetime = models.DateTimeField('data published')
