from django.contrib import admin

from .models import Pdb, MethodesAnalyse, MethodesRes, StructSec


class PdbInline(admin.TabularInline):
    model = Pdb

class PdbAdmin(admin.ModelAdmin):
    list_display = ('id_pdb','header','chaine','taille_proteine','meth_res')
    list_filter = ['chaine','meth_res']
    search_fields = ['id_pdb_chain','header']


class MethodesAnalyseInline(admin.TabularInline):
    model = MethodesAnalyse

class MethodesAnalyseAdmin(admin.ModelAdmin):
    list_display = ('nom_analyse')


class MethodesResInline(admin.TabularInline):
    model = MethodesRes

class MethodesResAdmin(admin.ModelAdmin):
    list_display = ('meth_res')


class StructSecInline(admin.TabularInline):
    model = StructSec

class StructSecAdmin(admin.ModelAdmin):
    list_display = ('id_pdb_chain','id_struct_sec','start_pred','nombre_ppii','pourcentage_ppii','nom_analyse')
    search_fields = ['id_pdb_chain','nombre_ppii']
    list_filter = ['nom_analyse']

admin.site.register(Pdb,PdbAdmin)
admin.site.register(MethodesAnalyse)
admin.site.register(MethodesRes)
admin.site.register(StructSec,StructSecAdmin)
