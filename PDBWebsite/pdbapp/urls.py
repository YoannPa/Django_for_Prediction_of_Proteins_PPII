from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^home/$', views.home, name='home'),
    url(r'^pdbinfo/$', views.pdbinfo, name='pdbinfo'),
    url(r'^about/$', views.about, name='about'),
]
