from django.shortcuts import render
from django.http import HttpResponse
from django.template import loader
from .models import MethodesRes, Pdb

def home(request):
    mresol = MethodesRes.objects.order_by('meth_res')\
    [:len(MethodesRes.objects.order_by('meth_res'))]

    context = {
        'mresol': mresol
    }

    return render(request, 'pdbapp/home.html', context) 

def pdbinfo(request):

    protdb = Pdb.objects.order_by('id_pdb')\
    [:len(Pdb.objects.order_by('id_pdb'))]
    
    context = {
        'protdb': protdb
    }
    
    return render(request, 'pdbapp/pdbinfo.html', context)

def about(request):
    
    namelist = ['Quentin LETOURNEUR', 'Yoann PAGEAUD']
    
    context = {
        'namelist': namelist
    } 
    
    return render(request, 'pdbapp/about.html', context)

def detail(request, id_pdb):

    pdbid = id_pdb   

    context = {
	'pdbid': pdbid
    }
    
    return render(request, 'pdbapp/pdbstat.html', context)
    #return HttpResponse("You're looking at question %s." % id_pdb)
    
