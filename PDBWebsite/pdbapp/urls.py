from django.conf.urls import url

from . import views

app_name = 'pdbapp'

urlpatterns = [
    url(r'^home/$', views.home, name='home'),
    url(r'^pdbinfo/$', views.pdbinfo, name='pdbinfo'),
    url(r'^strucinfo/$', views.strucinfo, name='strucinfo'),
    url(r'^about/$', views.about, name='about'),
    url(r'^(?P<id_pdb_chain>.{5})/$', views.detail, name='detail'),
    url(r'^(?P<id_struct_sec>[0-9]+)/$', views.strdetail, name='strdetail')
]
