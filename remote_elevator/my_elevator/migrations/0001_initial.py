# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Elevator',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('details', models.IntegerField(default=2)),
            ],
        ),
        migrations.CreateModel(
            name='ElevatorList',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('sn', models.IntegerField(default=0)),
                ('address', models.CharField(max_length=200)),
                ('contact_person', models.CharField(max_length=200)),
                ('contact_number', models.CharField(max_length=200)),
                ('status', models.IntegerField(default=2)),
                ('pub_date', models.DateTimeField(verbose_name=b'date published')),
            ],
        ),
        migrations.AddField(
            model_name='elevator',
            name='elevator',
            field=models.ForeignKey(to='my_elevator.ElevatorList'),
        ),
    ]
