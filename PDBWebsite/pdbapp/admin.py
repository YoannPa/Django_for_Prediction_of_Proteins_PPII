from django.contrib import admin

from .models import Pdb
from .models import MethodesAnalyse
from .models import MethodesRes
from .models import StructSec

admin.site.register(Pdb)
admin.site.register(MethodesAnalyse)
admin.site.register(MethodesRes)
admin.site.register(StructSec)
