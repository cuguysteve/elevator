from django.db import models

class ElevatorList(models.Model):

    sn  = models.IntegerField(default=0)
    address = models.CharField(max_length=200)
    contact_person = models.CharField(max_length=200)
    contact_number = models.CharField(max_length=200)
    status = models.IntegerField(default=2)
    pub_date = models.DateTimeField('date published')

    def __str__(self):
        return ''+ str(self.sn) + self.address


class Elevator(models.Model):
    elevator = models.ForeignKey(ElevatorList)
    details = models.IntegerField(default=2)

