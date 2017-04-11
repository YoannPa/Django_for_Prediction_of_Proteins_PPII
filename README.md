# PDB Database

## Prerequesites

* Update your packages already installed

```bash
sudo apt update
```

* Install **Python 2.7**

```bash
sudo apt install python2.7
```

* Install MySQL

* Install **libmysqlclient-dev** and **MySQL-python**:

```bash
sudo apt install libmysqlclient-dev
sudo pip install MySQL-python
```

* Set your working directory to the folder containing the file **create_db.sql**

* Launch Mysql:

```bash
mysql -u root -p
```

* Create Database:

```sql
create database M2BI_Projet_PPII;
```

* Leave Mysql:

```sql
quit;
```

* Load Tables in M2BI_Projet_PPII;

```bash
mysql -u root -p M2BI_Projet_PPII < create_db.sql
```

Tables are now created. 


* Create the Django project PDBWebsite:

```bash
django-admin startproject PDBWebsite
```

* cd into the project.
 
* Create pdbapp:

```bash
python manage.py startapp pdbapp
```

* Configure project settings for Database: in settings.py replace:

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

Then add 'pdbapp.apps.PdbappConfig' in **INSTALLED_APPS** :

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

* Go into the **PDBWesite/** directory and generate Django models:

```bash
cd PDBWesite/
python manage.py inspectdb > models.py
```

* Replace models.py file in the folder pdbapp by the one you generated. 

* Migrate new parameters to the database:

```bash
python manage.py makemigrations pdbapp
python manage.py migrate
```

The database will be updated with the tables necessary for the communication
between MySQL and the Django app.

* Create new Superuser account:

```bash
python manage.py createsuperuser
```

Follow instructions.

* Launch server:

```bash
python manage.py runserver
```

* In your web browser go to [localhost:8000](http://localhost:8000) and then
 [localhost:8000/admin/](http://localhost:8000/admin/) to sign in with the
 username and password you just define.  
You can now administrate all informations in the database to be displayed on the
 website.



## In case of problems with the MySQL database:

To show existing tables:

```sql
show tables;
```

To show tables columns:

```sql
show columns from PDB;
show columns from methodes_analyse;
show columns from methodes_res;
show columns from struct_sec;
```

To Delete the database:

```sql
drop database M2BI_Projet_PPII;
```

To display all databases:

```sql
show databases;
```

