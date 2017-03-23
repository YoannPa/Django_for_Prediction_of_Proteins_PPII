# PDB Database

## Prerequesites

* Install **libmysqlclient-dev** and **MySQL-python**:

```bash
sudo apt-get install libmysqlclient-dev
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

* Generate Django models:

```bash
python manage.py inspectdb > models.py
```

* Replace models.py file in the folder pdbapp by the one you generated. 

* Migrate new parameters to the database:

```bash
python manage.py makemigrations pdbapp
python manage.py migrate
```

The database will be updated with the tables necessary for the communication between MySQL and the Django app.
