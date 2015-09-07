# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('my_elevator', '0002_remove_elevatorlist_sn'),
    ]

    operations = [
        migrations.AddField(
            model_name='elevatorlist',
            name='sn',
            field=models.IntegerField(default=0),
        ),
    ]
