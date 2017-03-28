# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from __future__ import unicode_literals

from django.db import models


class Pdb(models.Model):
    id_pdb_chain = models.CharField(db_column='id_PDB_chain', primary_key=True, max_length=5)  # Field name made lowercase.
    id_pdb = models.CharField(db_column='id_PDB', max_length=4)  # Field name made lowercase.
    chaine = models.CharField(max_length=3)
    header = models.CharField(max_length=255)
    sequence_proteine = models.TextField(db_column='sequence_Proteine')  # Field name made lowercase.
    start_seq = models.IntegerField()
    taille_proteine = models.IntegerField(db_column='taille_Proteine')  # Field name made lowercase.
    resolution_pdb = models.FloatField(db_column='resolution_PDB')  # Field name made lowercase.
    meth_res = models.ForeignKey('MethodesRes', models.DO_NOTHING, db_column='meth_Res')  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'PDB'


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=80)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.SmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class MethodesAnalyse(models.Model):
    nom_analyse = models.CharField(db_column='nom_Analyse', primary_key=True, max_length=7)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'methodes_analyse'


class MethodesRes(models.Model):
    meth_res = models.CharField(db_column='meth_Res', primary_key=True, max_length=7)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'methodes_res'


class StructSec(models.Model):
    id_struct_sec = models.IntegerField(primary_key=True)
    start_pred = models.IntegerField()
    structure_predite = models.TextField(db_column='structure_Predite')  # Field name made lowercase.
    nombre_ppii = models.IntegerField(db_column='nombre_PPII')  # Field name made lowercase.
    pourcentage_ppii = models.FloatField(db_column='pourcentage_PPII')  # Field name made lowercase.
    angle_phi = models.TextField()
    angle_psi = models.TextField()
    id_pdb = models.ForeignKey(Pdb, models.DO_NOTHING, db_column='id_PDB', blank=True, null=True)  # Field name made lowercase.
    nom_analyse = models.ForeignKey(MethodesAnalyse, models.DO_NOTHING, db_column='nom_Analyse')  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'struct_sec'
