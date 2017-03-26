from django.shortcuts import render
from django.http import HttpResponse
from django.template import loader
from .models import MethodesRes, Pdb

def home(request):
    #return HttpResponse("HOME.")

    mresol = MethodesRes.objects.order_by('meth_res')[:2]
    #res = 'Resolution methods list: ', ', '.join([i.meth_res for i in mresol])
    #return HttpResponse(res)

    template = loader.get_template('pdbapp/home.html')
    context = {
        'mresol': mresol
    }
    return HttpResponse(template.render(context, request))

def pdbinfo(request):

    protdb = Pdb.objects.order_by('id_pdb')[:1]
    template = loader.get_template('pdbapp/pdbinfo.html')
    context = {
        'protdb': protdb
    }
    return HttpResponse(template.render(context, request))

def about(request):
    return HttpResponse("About us.")
