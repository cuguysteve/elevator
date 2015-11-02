# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='EleAlarm',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('Alarm', models.IntegerField()),
                ('Datetime', models.DateTimeField(verbose_name=b'data published')),
            ],
        ),
        migrations.CreateModel(
            name='EleList',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('SerialNo', models.CharField(max_length=20)),
                ('IpAddr', models.CharField(max_length=15)),
                ('Location', models.CharField(max_length=50)),
                ('Vendor', models.CharField(max_length=20)),
                ('Model', models.CharField(max_length=20)),
                ('Status', models.CharField(max_length=20)),
                ('ConTime', models.DateTimeField(verbose_name=b'date published')),
                ('Period', models.IntegerField()),
            ],
            options={
                'ordering': ['id'],
            },
        ),
        migrations.AddField(
            model_name='elealarm',
            name='SerialNo',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='my_elevator.EleList'),
        ),
    ]
