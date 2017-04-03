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
    chaine = models.CharField(max_length=10)
    header = models.CharField(max_length=255)
    sequence_proteine = models.TextField(db_column='sequence_Proteine')  # Field name made lowercase.
    start_seq = models.IntegerField()
    taille_proteine = models.IntegerField(db_column='taille_Proteine')  # Field name made lowercase.
    resolution_pdb = models.FloatField(db_column='resolution_PDB')  # Field name made lowercase.
    meth_res = models.ForeignKey('MethodesRes', models.DO_NOTHING, db_column='meth_Res')  # Field name made lowercase.

    def __unicode__(self):
        return self.id_pdb

    class Meta:
        managed = False
        db_table = 'PDB'


class MethodesAnalyse(models.Model):
    nom_analyse = models.CharField(db_column='nom_Analyse', primary_key=True, max_length=7)  # Field name made lowercase.

    def __unicode__(self):
        return self.nom_analyse

    class Meta:
        managed = False
        db_table = 'methodes_analyse'


class MethodesRes(models.Model):
    meth_res = models.CharField(db_column='meth_Res', primary_key=True, max_length=5)  # Field name made lowercase.

    def __unicode__(self):
        return self.meth_res

    class Meta:
        managed = False
        db_table = 'methodes_res'


class StructSec(models.Model):
    id_struct_sec = models.AutoField(primary_key=True)
    start_pred = models.IntegerField()
    structure_predite = models.TextField(db_column='structure_Predite')  # Field name made lowercase.
    nombre_ppii = models.IntegerField(db_column='nombre_PPII')  # Field name made lowercase.
    pourcentage_ppii = models.FloatField(db_column='pourcentage_PPII')  # Field name made lowercase.
    angle_phi = models.TextField()
    angle_psi = models.TextField()
    id_pdb_chain = models.ForeignKey(Pdb, models.DO_NOTHING, db_column='id_PDB_chain')  # Field name made lowercase.
    nom_analyse = models.ForeignKey(MethodesAnalyse, models.DO_NOTHING, db_column='nom_Analyse')  # Field name made lowercase.

    def __unicode__(self):
        return self.structure_predite

    class Meta:
        managed = False
        db_table = 'struct_sec'
