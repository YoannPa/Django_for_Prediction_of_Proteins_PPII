# Projet BD M2BI - README

Author: Yoann PAGEAUD
Date: 15-04-2017


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
<img src="https://goo.gl/xAHv96">
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
The choice has been made to use a standard MySQL database better suited for web use.  
We decided to create 4 different tables : one for PDB informations, one for Predictions informations, and 2 others for prediction methods and resolution methods.   
The detailled conceptual framework of our database is available below:

IMAGE

The database has been created following the steps in the **Setup Database** part in the **README.md** (for details about how to install Python, MySQL, and Django, please refer the **Prerequesites** part in the **README.md** file)
## Distribution of tasks
Project report: Quentin & Yoann   
Database conception: Quentin & Yoann  
Predictions generation: Quentin  
Website conception: Yoann
README: Yoann
