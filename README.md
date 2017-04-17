# Projet BD M2BI - README

*Author: Yoann PAGEAUD*  
*Date: 15-04-2017*


This document explain every steps of install and configuration necessary to the project.

## Prerequesites


* Update packages already installed:

```bash
sudo apt update
```

* Install **Python 2.7**:

```bash
sudo apt install python2.7
```

* Install **MySQL and dependencies**:

```bash
sudo apt install mysql-client
sudo apt install mysql-common
sudo apt install mysql-server
sudo apt install mysql-sandbox
sudo apt install libmysqlclient-dev
```

* Install **MySQL-python**:

```bash
sudo pip install MySQL-python
sudo pip install mysqlclient
```

* Install **Django**:

```bash
sudo pip install Django
sudo pip install django-autocomplete-light
sudo pip install django-simple-menu
```


* Set your working directory to the folder containing the file **create_db.sql**

* Launch Mysql:

```bash
mysql -u root -p
```

## Set up Database


* Create Database:

```sql
create database M2BI_Projet_PPII;
```

* Leave Mysql:

```sql
quit;
```

* Load Tables in M2BI_Projet_PPII using the file **create_db.sql**;

```bash
mysql -u root -p M2BI_Projet_PPII < create_db.sql
```

Once tables are created you can move to the Set up of Django 

## Set up Django

* **cd** into the Django project **PDBWebsite/**.
 

* Configure project settings for Database: in **settings.py** replace:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
```

By:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'M2BI_Projet_PPII',
        'USER': 'root',
        'PASSWORD': '<your own root password>',
        'HOST': '',
        'PORT': '',
    }
}
```

Don't forget to replace **<your own root password>** by your root password.

Then add **'pdbapp.apps.PdbappConfig'** in **INSTALLED_APPS**:

```python
INSTALLED_APPS = [
    'pdbapp.apps.PdbappConfig',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]
```

And save modifications. 

* Migrate new parameters to the database:

```bash
python manage.py makemigrations pdbapp
python manage.py migrate
```

The database will be updated with the tables necessary for the communication
between MySQL and the Django app.

## Set up a supertuser account:

* Create new Superuser account:

```bash
python manage.py createsuperuser
```

Follow instructions.

## Launch the webserver:

* Launch server:

```bash
python manage.py runserver
```

* In your web browser go to [localhost:8000](http://localhost:8000) and then
 [localhost:8000/admin/](http://localhost:8000/admin/) to sign in with the
 username and password you just define.  
You can now administrate all informations in the database to be displayed on the
 website.

## Contact

In case of any problems:  
Yoann PAGEAUD: [yoann.pageaud@gmail.com](yoann.pageaud@gmail.com)








<p align="center">
<img src="https://gitlab.com/Yoann.Pageaud/Projet_BD_M2BI/raw/master/Report_img/Banner_M2BI.png" style="width:100%">
</p>
<br>
# Projet M2BI Website & Database
<br>
**Authors: PAGEAUD Yoann ; LETOURNEUR Quentin.**  
[**Université Paris Diderot - Paris 7, France.**](http://www.univ-paris-diderot.fr/)  
<br>
## Introduction
TODO
## Materials and Methods
This project has been developped under the Linux distribution **Ubuntu 16.04** and was shared in a git repository hosted on GitLab.  
Various packages and tools had to be installed. Install steps are explained in the **Prerequesites** part of the **README.md** file. 

### Prediction Tools
TODO
### Database and web infrastructure
The choice has been made to use a standard MySQL database better suited for web
 use.  
We decided to create 4 different tables : one for PDB informations, one for
 predictions informations, and 2 others for prediction methods and resolution
 methods.   
The detailled conceptual framework of our database is available below:  

<p align="center">
<img src="https://gitlab.com/Yoann.Pageaud/Projet_BD_M2BI/raw/master/Report_img/Base%20de%20Donn%C3%A9es%20Projet%20M2BI.png" style="width:600px">
<b>Figure 1: Database conceptual framework.</b>
</p>
<br>
The database has been created following the steps in the **Setup Database** part
 in the **README.md** (for details about how to install Python, MySQL, and
 Django, please refer the **Prerequesites** part in the **README.md** file).  
Once the database has been created in MySQL, tables are created and filled with
 entries thanks to the **create_db.sql** file.  
This file contains queries necessary to the creation of the 4 tables and
 populate the tables **PDB** and **struct_sec** by calling 2 files:  
**pdb_table.csv** and **sspred_table.tsv**. **pdb_table.csv** contains all
 informations about the PDB files, while **sspred_table.tsv** contains all
 informations about the predictions generated with DSSP and PROSS.  
After the database has been populated, We had to found a way to access it easily
 if any further modification would be needed.  
For this purpose, the choice has been made to use Django.  
<br>
<p align="center">
<img src="https://gitlab.com/Yoann.Pageaud/Projet_BD_M2BI/raw/master/Report_img/386517.png" style="width:600px">
</p>
<p align="center">
<b>Figure 2: Django M.V.T model.</b>
</p>
<br>
Django is a widely used python framework thought for developping websites easily
 with short deadlines.  
It has made its prooves since it has been used to developped websites of renowed
 institutions like Instagram, Pinterest or NASA.  
It's based on the **"Model-View-Template" (M.V.T.)** model (**Fig. 2**) which is
 slightly different from the common "Model-View-Controller" (M.V.C.) model
 because Django manages the "Controller" part on its own.  
It also integrate modules simplifying the creation and configuration of an
 administration interface to access database entries easily and make small
 modifications on some of them in case of minor bugs.  
Moreover, Django is working with its own python functions to access the
 database. Administrator can use them to access the database by a
 **Django shell**.  
Thus, it has also been used to generate a **models.py** file defining models
 associated to the MySQL database tables (one class per table) as Python
 classes, and Django functions can be called in any views contained in the
 **views.py** file.  
For all these reasons Django perfectly suited our website project.  
Using Django, a Django project **PDBWebsite/**:

```bash
django-admin startproject PDBWebsite
```

and a Django application **pdbapp/** have been created:

```bash
cd PDBWebsite/
python manage.py startapp pdbapp
```

Multiple applications can be generated in a Django project, following the
 different needs. For our project, we decided to create only one application
 **pdbapp/** to answer to one biological question.  
The structure of a Django project follows some standards defined by the
 **Django Project** initiative (**Fig. 3**).  

<br>
<p align="center">
<img src="https://gitlab.com/Yoann.Pageaud/Projet_BD_M2BI/raw/master/Report_img/Tree_PDBWebsite.png" style="width:600px">
</p>
<p align="center">
<b>Figure 3: Structure of the Django project PDBWebsite.</b>
</p>
<br>

The views "home","pdbinfo","strucinfo","about","detail" and "strdetail" were
 created in the file **views.py**. In Django each view is associated to one
 corresponding HTML template.  
The corresponding HTML templates "home.html", "pdbinfo.html", "strucinfo.html",
 "about.html", "pdbstat.html" and "strucstat.html" were created.  
Views and templates are linked together by URLs in the files **urls.py**. The
 Django project has a **urls.py** file and each Django application has its own
 **urls.py**.  
URLs are listed as followed in the application **pdbapp/**:  

```python
app_name = 'pdbapp'

urlpatterns = [
    url(r'^home/$', views.home, name='home'),
    url(r'^pdbinfo/$', views.pdbinfo, name='pdbinfo'),
    url(r'^strucinfo/$', views.strucinfo, name='strucinfo'),
    url(r'^about/$', views.about, name='about'),
    url(r'^(?P<id_pdb_chain>.{5})/$', views.detail, name='detail'),
    url(r'^(?P<id_struct_sec>[0-9]+)/$', views.strdetail, name='strdetail')
]
```

and in the project **PDBWebsite/**:  

```python
from pdbapp.views import *

urlpatterns = [
	url(r'^$', home, name='home'),
	url(r'^pdbapp/', include('pdbapp.urls')),
	url(r'^admin/', admin.site.urls)
]
```

In the **views.py** file each view return a **context** containing all variables
 defined in the view that is called in the corresponding HTML template.  
Usually, variables refer to corresponding queries in the database.  
HTML templates can host each variable by calling them as followed:  

```html
{{ variable }}
```

If the variable is iterative, a Python **for** loop with **if** and **else**
 conditions can also be used inside the template. It allows to display any query
 results dynamically on a web page.  

To add some styles to HTML templates, CSS files have been created.
All CSS files are stored into a **static/pdbapp/** directory. A
 **static/pdbapp/images/** directory has also been created to store all images
 to be displayed on the web site.  

To make the tables generated dynamically, on the page **pdbinfo.html** and
 **strucinfo.html** more user-friendly, **javascript** files are also stored in
 the **static/pdbapp/** directory.
2 javascript files were used:  

* **jquery.searchable-1.0.0.min.js** to enable the search options.
* **jquery.tablesorter.min.js** to enable the sorting options.

Both scripts call functions defined in a well known javascript library:
 **JQuery** accessible in the file **jquery-3.2.0.min.js**.

To sum up everything about HTML display: 
Javascripts files call functions from JQuery.  
CSS files call images from the **static/pdbapp/images/** directory.  
HTML templates call:
* views contained in views.py to display queries results,
* CSS files to get the styles parameters.
* javascript files to enable user actions to search or sort entries.

The website can be navigated thanks to a menu bar on the top of each page.  
6 HTML templates were made:

* **home.html**: this page is an introduction to the website, The biological
 issue raised, and how it answers to it. Examples of use are also described. 
* **pdbinfo.html**: this page contain a table displaying all entries from the
 PDB table in the database. Rows can be sorted and filtered, and each PDB Id
 send to a page displaying every details about a specific PDB. 
* **strucinfo.html**: this page work exactly the same way than the PDBs page,
 except that from the table, you can access both PDBs details pages and
 predictions details pages.
* **about.html**: this page dynamically display interesting statistics about the
 database, and contains also authors informations. 
* **pdbstat.html**: this page contains PDB details for one PDB. It has an URL
 ending with the PDB Id concatenated to the PDB chain name.
* **strucstat.html**: this page contains Predictions details for one prediction.
 It has an URL ending by an integer corresponding to the prediction id.

Both **pdbstat.html** and **strucstat.html** pages contain links that simplifies
 the navigation between a PDB and its corresponding predictions.  
Furthermore, additional options have been added to the PDB details pages to have
 access to the corresponding **RCSB** page, to be able to
 **download the PDB file**, and to have a quick access to the online tool
 **RAMPAGE** which generate multiple Ramachandran plots, one especially
 representing the distribution of **Proline-favorable regions**.  

A menu bar has been added to the top of each HTML templates so that all pages
 are easily accessible.  

Every details relative to webpages, are available on the **Home** page
 when starting the web server in the **How to use the website ?** part.  

Alongside the user accessible part of our website, and administration interface
 have been configured (to access the admin interface you need to create a
 superuser account, see details in the README file for more informations).  
<br>
<p align="center">
<img src="https://gitlab.com/Yoann.Pageaud/Projet_BD_M2BI/raw/master/Report_img/adminhome.png" style="width:600px">
</p>
<p align="center">
<b>Figure 4: Administration main page.</b>
</p>
<br>
Access to entries in all database tables have been made available, with the
 posibility to remove entries or to modify them. Work groups and users list was
 already available from the default Django parameters. An history of
 modifications has also been added (**Fig. 4**). In the admin pages **Pdbs** and
 **Struct secs** entries have been displayed in tables. they can be accessed by
 a search bar or by sorting tables rows on both pages. Additionally, the
 **Pdbs** admin page entries can be filtered following their chain name, and/or
 the resolution method used to generate the PDBs (**Fig. 5**), while **Struct secs** admin
 page entries can be filtered following the method of prediction
 (DSSP or PROSS).  
<br>
<p align="center">
<img src="https://gitlab.com/Yoann.Pageaud/Projet_BD_M2BI/raw/master/Report_img/admin-pdb-exmpl.png" style="width:600px">
</p>
<p align="center">
<b>Figure 5: Administration page for PDBs.</b>
</p>
<br>
Settings of the administration part of the website rely on many different files.
 Most of them can be found in the **admin.py** file in **pdbapp/**. Each table
 is defined in it as a python class and the parameters to access entries in
 administration tables are defined under 3 differents standard variables:  

* **list_display**: it contains all table fields that should be displayed.
* **list_filter**: it contains all table fields to be used for filtering.
* **search_fields**: it contains all table fields to be searched using the
 search bar.  

To modify or delete any entry, just click it, the administrator is redirected to a modification page with all fields of the entry accessible.  
The user accessible part of the website has also been made accessible by
 clicking the link **VIEW SITE** in the top right corner of the interface, and
 redirects the administrator to the home page.  

## Discussion



##Conclusion


 
## Encountered difficulties
**Quentin**:  

**Yoann**:  
I had some difficulties in understanding how Django worked since I never
 developped any website before. It also means understanding how HTML, Python,
 CSS and Javascript join together to build a functionnal webpage. It was my
 choice to work on this part, and in the end I really learnt a lot, it was
 definitely worth it even if I did not had enough time to do everything I
 wanted.  
I also tried to use CanvasJS to generate ramachandran plots from the psi and phi
 angles, but without any tutorial available I didn't success in this step.
I should have also colored the PPII structures in predictions using javascript,
 but I didn't had enough time to try anything.
 
## Tasks distribution
Project report: Quentin & Yoann  
Database conception: Quentin & Yoann  
Predictions generation: Quentin  
Website conception: Yoann  
README: Yoann  
