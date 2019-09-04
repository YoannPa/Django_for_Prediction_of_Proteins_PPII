from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse
from django.template import loader
from .models import MethodesRes, Pdb, StructSec
from django.db.models import Avg
from django.db.models import Sum


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


def strucinfo(request):
    strucsnd = StructSec.objects.order_by('id_pdb_chain')\
    [:len(StructSec.objects.order_by('id_pdb_chain'))]
    
    context = {
        'strucsnd': strucsnd
    }
    
    return render(request, 'pdbapp/strucinfo.html', context)


def about(request):
    
    pdbcount = Pdb.objects.count()
    structcount = StructSec.objects.count()
    dsspcount = StructSec.objects.filter(nom_analyse='DSSP').count()
    prosscount = StructSec.objects.filter(nom_analyse='PROSS').count()
    avgstartseq = list(Pdb.objects.aggregate(Avg('start_seq')).values())[0]
    avgsize = list(Pdb.objects.aggregate(Avg('taille_proteine')).values())[0]
    avgres = round(list(Pdb.objects.aggregate(Avg('resolution_pdb')).values())[0],3)
    avgstartpred = list(StructSec.objects.aggregate(Avg('start_pred')).values())[0]
    totppii = list(StructSec.objects.aggregate(Sum('nombre_ppii')).values())[0]
    avgpcppii = round(list(StructSec.objects.aggregate(Avg('pourcentage_ppii')).values())[0],2)
    namelist = ['Quentin LETOURNEUR', 'Yoann PAGEAUD']

    context = {
        'namelist': namelist,
	'pdbcount': pdbcount,
	'structcount': structcount,
	'dsspcount': dsspcount,
	'prosscount': prosscount,
	'avgstartseq': avgstartseq,
	'avgsize': avgsize,
	'avgres': avgres,
	'avgstartpred': avgstartpred,
	'totppii': totppii,
	'avgpcppii': avgpcppii
    } 
    
    return render(request, 'pdbapp/about.html', context)


def detail(request, id_pdb_chain):

    pdb = get_object_or_404(Pdb, id_pdb_chain=id_pdb_chain)
    strpred = StructSec.objects.filter(id_pdb_chain=id_pdb_chain)

    context = {
        'pdb': pdb,
	'strpred':strpred
    }
    
    return render(request, 'pdbapp/pdbstat.html', context)


def strdetail(request, id_struct_sec):
    strpred = get_object_or_404(StructSec, id_struct_sec=id_struct_sec)

    context = {       
	'strpred': strpred
    }
    
    return render(request, 'pdbapp/strucstat.html', context)
