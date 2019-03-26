# Django Website for Prediction of Protein Secondary Structure and Polyproline Helix II

**Authors: PAGEAUD Yoann ; LETOURNEUR Quentin.**  
[**Université Paris Diderot - Paris 7, France.**](http://www.univ-paris-diderot.fr/)  
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


## Introduction
Secondary structures play a key role in proteins shape and functions. their
 characteristics permits us to predict and assign them to a given protein
 sequence based on structural informations. There are three major secondary
 structures, α-helix, β-sheet and turns. But there are also other patterns like
 Polyproline II (PPII) which are less frequent and less studied. Although we
 know there existence since the 50's they were thought to be only present in
 fibrous proteins and in low frequencies^**2,9**. Since then, severals studies have
 shown that PPII are also present in globular proteins and that they can be
 present even without proline in them^**1**. They can play a main role for
 interactions between proteins and there flexibility is one of their interesting
 trait. What is most surprising about them is that unlike other regular
 secondary structures they don't seem to have stabilizing interactions (**1,fig. 1**)
 . However there is no gold standard prediction yet for there assignment and
 they are still understudied.  
For this project we built a MySQL database containing secondary structure
 predictions made from 2 prediction tools (DSSP and PROSS)^**6,10**. The database is
 accessible through a web interface designed with the **Python^14** framework
 Django.  
 Thanks to our website, a user can search for any PDB stored into the database
 to compare their associated secondary structure predictions with emphasis on
 PPII.  
<br>
<p align="center">
<img src="https://github.com/YoannPa/Django_Website_for_Prediction_of_Protein_Secondary_Structure_and_Polyproline_Helix_II/blob/master/Report_img/fig_PPII_struct.png" style="width:600px">
</p>
<p align="center">
<b>Figure 1:</b> Idealized major periodic structures: β-structure, α-helix, and PPII helix, modeled as the CA-trace helical axis projection <b>(b-1)</b> and perspective projection <b>(b-2)</b>, and the 10-Ala polypeptide chain <b>(b-3)</b>. PPII helix with n = −3 and d = 3.1 Å is a left-handed narrow and extended helix, the most extended helical structure occurring in proteins, and only slightly less extended than the β-structure. For α-helix, n = +3.6 and d = 1.5 Å; thus, PPII helix covers twice its length per residue. It does not form any regular pattern of local intra- or interchain hydrogen bonds. The CA-trace projection along the helical axis shows the PPII characteristic shape of a triangular prism <b>(b-1)</b>.
</p>
<br>
## Materials and Methods
This project has been developped under the Linux distribution **Ubuntu 16.04**
 and was shared in a git repository hosted on GitLab.  
Various packages and tools had to be installed. Install steps are explained in
 the **Prerequesites** part of the **README.md** file.
The website is compatible with both latest **Chromium** and **Firefox**
 versions.

### Prediction Tools

To generate predictions, two prediction tools DSSP and PROSS were used.  
DSSP Predict secondary structure using mainly H-bond patterns for alpha-helix
 and beta-strand/bridge, C-alpha positions for bends and backbone dihedral
 angles for chirality.  
Shown below is the description of characters used for secondary structure prediction:  
* H = alpha-helix
* E = beta-strand
* B = beta-bridge
* G = 3-helix (310-helix)
* I = 5-helix (pi-helix)
* T  = 3-, 4- or 5- turn
* S = bend
* P = PPII
* 'whitespace' = coil

PROSS predict secondary structure using only dihedral angles mesostates.  

<br>
<p align="center">
<img src="https://github.com/YoannPa/Django_Website_for_Prediction_of_Protein_Secondary_Structure_and_Polyproline_Helix_II/blob/master/Report_img/grid_pross.png" style="width:600px">
</p>
<p align="center">
<b>Figure 2: fine grain grid for mesostate assignment.For two given dihedral angles (phi and psi) of a residue the grid define its mesotate.</b>
</p>
<br>

* H = alpha-helix
* E = beta-strand
* T = beta-turn
* P = PPII
* C = coil

After launching DSSP and PROSS on the PDBs we downloaded, informations have been
 extracted from the PDBs and secondary structures predictions were placed to
 place them in the database.  

To do so we generated a bash and a python script : create_pdb_table.sh and
 create_sspred_table.py.  
The first script extracts severals informations from a PDB file like the header,
 the sequence, the protein size based on the number of the last residue.
To make the length of the sequence as close as possible to this number we
 retrieved and placed in the sequence the missing residues mentioned in the PDB
 file. To recognize them they were written in lowercase.  

The second script extracts informations from secondary structure prediction
 files from DSSP or PROSS like, for example, the sequence representing the
 secondary structure assignment, and the computed phi and psi angles by residue.  

Both tools detect missing residues (chain breaks) to avoid shift apparition
 between the sequence and the prediction chain. 'X' were inserted where there
 are missing residues.  

An additional script aligne_sequence_and_prediction.sh  has been made to add '-'
 at the start of the predictions if there is a shift in the sequence and the
 prediction due to misssing residues at the start of the sequence.  

### Database and web infrastructure
The choice has been made to use a standard **MySQL^8** database better suited for web
 use.  
We decided to create 4 different tables : one for PDB informations, one for
 predictions informations, and 2 others for prediction methods and resolution
 methods.   
The detailled conceptual framework of our database is available below:  

<p align="center">
<img src="https://github.com/YoannPa/Django_Website_for_Prediction_of_Protein_Secondary_Structure_and_Polyproline_Helix_II/blob/master/Report_img/Base%20de%20Donn%C3%A9es%20Projet%20M2BI.png" style="width:600px">
<b>Figure 3: Database conceptual framework.</b>
</p>
<br>
The database has been created following the steps in the **Setup Database** part
 in the **README.md** (for details about how to install Python, MySQL, and
 Django, please refer the **Prerequesites** part in the **README.md** file).  
Once the database has been created in MySQL, tables were created and filled with
 entries thanks to the **create_db.sql** file.  
This file contains queries necessary to the creation of the 4 tables and
 populate the tables **PDB** and **struct_sec** by calling 2 files:  
**pdb_table.csv** and **sspred_table.tsv**. **pdb_table.csv** contains all
 informations about the PDB files, while **sspred_table.tsv** contains all
 informations about the predictions generated with DSSP and PROSS.  
After the database has been populated, We had to found a way to access it easily
 if any further modification would be needed.  
For this purpose, the choice has been made to use **Django^13**.  
<br>
<p align="center">
<img src="https://github.com/YoannPa/Django_Website_for_Prediction_of_Protein_Secondary_Structure_and_Polyproline_Helix_II/blob/master/Report_img/386517.png" style="width:600px">
</p>
<p align="center">
<b>Figure 4: Django M.V.T model.</b>
</p>
<br>
Django is a widely used Python framework thought for developping websites easily
 with short deadlines.  
It has made its prooves since it has been used to developped websites of renowed
 institutions like Instagram, Pinterest or NASA.  
It's based on the **"Model-View-Template" (M.V.T.)** model (**Fig. 4**) which is
 slightly different from the common "Model-View-Controller" (M.V.C.) model
 because Django manages the "Controller" part on its own.  
It also integrate modules simplifying the creation and configuration of an
 administration interface to access database entries easily and make small
 modifications on some of them in case of minor bugs.  
Moreover, Django is working with its own Python functions to access the
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
 **Django Project** initiative (**Fig. 5**).  

<br>
<p align="center">
<img src="https://github.com/YoannPa/Django_Website_for_Prediction_of_Protein_Secondary_Structure_and_Polyproline_Helix_II/blob/master/Report_img/Tree_PDBWebsite.png" style="width:600px">
</p>
<p align="center">
<b>Figure 5: Structure of the Django project PDBWebsite.</b>
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

* **jquery.searchable-1.0.0.min.js^11** to enable the search options.
* **jquery.tablesorter.min.js^4** to enable the sorting options.

Both scripts call functions defined in a well known javascript library:
 **JQuery^5** accessible in the file **jquery-3.2.0.min.js**.

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
 access to the corresponding **RCSB^3** page, to be able to
 **download the PDB file**, and to have a quick access to the online tool
 **RAMPAGE^7** which generate multiple Ramachandran plots, one especially
 representing the distribution of **Proline-favorable regions**.  

A menu bar has been added to the top of each HTML templates so that all pages
 are easily accessible.  

Every details relative to webpages, are available on the **Home** page
 when starting the web server in the **How to use the website ?** part.  

Alongside the user accessible part of our website, an
 **administration interface^12** have been configured (to access the admin
 interface you need to create a superuser account, see details in the README
 file for more informations).  
<br>
<p align="center">
<img src="https://github.com/YoannPa/Django_Website_for_Prediction_of_Protein_Secondary_Structure_and_Polyproline_Helix_II/blob/master/Report_img/adminhome.png" style="width:600px">
</p>
<p align="center">
<b>Figure 6: Administration main page.</b>
</p>
<br>
Access to entries in all database tables have been made available, with the
 posibility to remove entries or to modify them. Work groups and users list was
 already available from the default Django parameters. An history of
 modifications has also been added (**Fig. 6**). In the admin pages **Pdbs** and
 **Struct secs** entries have been displayed in tables. they can be accessed by
 a search bar or by sorting tables rows on both pages. Additionally, the
 **Pdbs** admin page entries can be filtered following their chain name, and/or
 the resolution method used to generate the PDBs (**Fig. 7**), while
 **Struct secs** admin page entries can be filtered following the method of
 prediction (DSSP or PROSS).  
<br>
<p align="center">
<img src="https://github.com/YoannPa/Django_Website_for_Prediction_of_Protein_Secondary_Structure_and_Polyproline_Helix_II/blob/master/Report_img/admin-pdb-exmpl.png" style="width:600px">
</p>
<p align="center">
<b>Figure 7: Administration page for PDBs.</b>
</p>
<br>
Settings of the administration part of the website rely on many different files.
 Most of them can be found in the **admin.py** file in **pdbapp/**. Each table
 is defined in it as a Python class and the parameters to access entries in
 administration tables are defined under 3 differents standard variables:  

* **list_display**: it contains all table fields that should be displayed.
* **list_filter**: it contains all table fields to be used for filtering.
* **search_fields**: it contains all table fields to be searched using the
 search bar.  

To modify or delete any entry, just click it, the administrator is redirected to
 a modification page with all fields of the entry accessible.  
The user accessible part of the website has also been made accessible by
 clicking the link **VIEW SITE** in the top right corner of the interface, and
 redirects the administrator to the home page.  

## Discussion

We found that PROSS  was better than DSSP when it comes to PPII detection. This
 is due to the difference in there way of assigning secondary structure. PROSS
 is based only on dihedral angles and DSSP mainly on H-bond. Since there are
 few/none H-bonds in PPII, it may be more difficult for DSSP to detect them. But
 for other secondary structures, DSSP gives more detailed results because for
 example it differentiate between different types of helix while DSSP don't.

Using Django framework to develop a website confer many advantages (listed in
 the Materials and Methods part above) and give convenient tools to easily
 access the database and make modifications on a website.  
With Django, once the web server is launched, you do not need any interruption
 for maintenance of the website. Moreover, There are now 3 different ways to
 access the database, modify, delete and create entries:

* The normal way by MySQL in the Terminal.
* The Django way using Django shell (**> python manage.py shell**) with Django's
 functions.
* The Django-admin way using the administration interface to make minor
 modifications on entries.
 
The Display of Predictions just below a PDB sequence on the PDB details pages,
 make the interpretation of secondary structure prediction more easy.  
Supplementary tools like links to download PDB, display RCSB page, or access
 RAMPAGE, gave more options to the user to explore any other subsisting
 questions to which the website does not answer. 
Next improvments to be added could be a display of a ramachandran plot, for each
 prediction, coloration of structure prediction, and the support of more PDBs
 and more precition tools. 

## Conclusion

Using actual technologies from database to web interface, we made predictions for secondary structure and PPIIs available to a large public to answer.  
PROSS and DSSP predictions are stored in a MySQL database and available to any user on the dedicated webpages.
MySQL database containing secondary structure predictions made by PROSS and DSSP connected to a web interface using the python framework Django which has been a great help in our project. 
To able easy detection of PPII and comparison between softwares we designed pages containing the sequence and under its corresponding secondary structure predictions. The database can be search by multiple criteria like the PDB_ID and key words in the protein name.
This project can still be improved on many different ways.

## References

1- **Chebrek, Romain, Sylvain Leonard, Alexandre G. de Brevern, and Jean-Christophe Gelly**. _“PolyprOnline: Polyproline Helix II and Secondary Structure Assignment Database.”_ Database: The Journal of Biological Databases and Curation 2014 (November 6, 2014). doi:10.1093/database/bau102.  
2- **Cowan, Pauline M., Stewart McGAVIN, and A. C. T. North**. _“The Polypeptide Chain Configuration of Collagen.”_ Nature 176, no. 4492 (décembre 1955): 1062–64. doi:10.1038/1761062a0.  
3- **Deshpande, N.** _“The RCSB Protein Data Bank: A Redesigned Query System and Relational Database Based on the mmCIF Schema.”_ Nucleic Acids Research 33, no. Database issue (December 17, 2004): D233–37. doi:10.1093/nar/gki057.  
4- _“jQuery Plugin: Tablesorter 2.0.”_ Accessed April 10, 2017. http://tablesorter.com/docs/.  
5- _jquery.org, jquery Foundation-. “jQuery.”_ Accessed April 10, 2017. https://jquery.com/.  
6- **Kabsch, Wolfgang, and Christian Sander**. _“Dictionary of Protein Secondary Structure: Pattern Recognition of Hydrogen-Bonded and Geometrical Features.”_ Biopolymers 22, no. 12 (décembre 1983): 2577–2637. doi:10.1002/bip.360221211.  
7- **Lovell, Simon C., Ian W. Davis, W. Bryan Arendall, Paul IW de Bakker, J. Michael Word, Michael G. Prisant, Jane S. Richardson, and David C. Richardson.** _“Structure Validation by Cα Geometry: Φ, ψ and Cβ Deviation.”_ Proteins: Structure, Function, and Bioinformatics 50, no. 3 (2003): 437–450.  
8- _“MySQL.”_ Accessed April 10, 2017. https://www.mysql.com/.  
9- **Pauling, Linus, and Robert B. Corey**. _“The Structure of Fibrous Proteins of the Collagen-Gelatin Group.”_ Proceedings of the National Academy of Sciences of the United States of America 37, no. 5 (May 1951): 272–81.  
10- _“PROSS: Dihedral Angle-Based Secondary Structure Assignment.”_ Accessed April 17, 2017. http://folding.chemistry.msstate.edu/utils/pross.html.  
11- _“Stidges/jquery-Searchable.”_ GitHub. Accessed April 10, 2017. https://github.com/stidges/jquery-searchable.  
12- _“The Django Admin Site | Django Documentation | Django.”_ Accessed April 10, 2017. https://docs.djangoproject.com/en/1.11/ref/contrib/admin/.  
13- _“The Web Framework for Perfectionists with Deadlines | Django.”_ Accessed April 10, 2017. https://www.djangoproject.com/.  
14- _“Welcome to Python.org.”_ Python.org. Accessed April 10, 2017. https://www.python.org/.  


## Encountered difficulties
**Quentin**:  
There may be others but I saw that there is a problem with the prediction of the
 1tke.pdb file with DSSP that take into account an heteroatom at the end of the
 prediction. We could have manually modified the errors in this entry using the
 Django administration interface.  

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
