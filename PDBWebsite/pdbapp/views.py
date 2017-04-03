from django.shortcuts import render, get_object_or_404
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

    protdb = Pdb.objects.order_by('id_pdb_chain')\
    [:len(Pdb.objects.order_by('id_pdb_chain'))]
    
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


def detail(request, id_pdb_chain):

    pdb = get_object_or_404(Pdb, id_pdb_chain=id_pdb_chain)
    
    context = {
        'pdb': pdb
    }
    
    return render(request, 'pdbapp/pdbstat.html', context)