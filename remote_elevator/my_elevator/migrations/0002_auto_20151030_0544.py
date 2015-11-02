# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('my_elevator', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='elelist',
            name='Latit',
            field=models.CharField(default='31.225243', max_length=20),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='elelist',
            name='Longit',
            field=models.CharField(default='121.361517', max_length=20),
            preserve_default=False,
        ),
    ]
