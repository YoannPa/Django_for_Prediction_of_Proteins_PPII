-- Creation Database M2BI_Projet_PPII

create database M2BI_Projet_PPII;

#Display Databases	
show databases; 

#Choose the database M2BI_Projet_PPII
use M2BI_Projet_PPII;

#Tables creation

create table PDB(
	id_PDB char(4) not null PRIMARY KEY,
	nom_Proteine VARCHAR(255) not null,
	sequence_Proteine TEXT not null,
	taille_Proteine FLOAT not null,
	pourcentage_PPII FLOAT not null,
	nombre_PPII INT not null, 
	resolution_PDB FLOAT not null,
	header VARCHAR(255) not null
);

create table methodes_analyse(
	nom_Analyse VARCHAR(7) not null PRIMARY KEY,
	id_PDB char(4) not null,
	FOREIGN KEY (id_PDB) REFERENCES PDB(id_PDB) 
);

create table methodes_resolution(
	methode_Resolution BIT not null PRIMARY KEY,
	id_PDB char(4) not null,
	FOREIGN KEY (id_PDB) REFERENCES PDB(id_PDB)
);

create table structures_secondaires(
	id_structure_second INT not null AUTO_INCREMENT PRIMARY KEY,
	structure_Predite TEXT not null,
	id_PDB char(4) not null,
	nom_Analyse VARCHAR(7) not null,
	FOREIGN KEY (id_PDB) REFERENCES PDB(id_PDB),
	FOREIGN KEY (nom_Analyse) REFERENCES methodes_analyse(nom_Analyse)
);


#Show created tables
show tables;


#Show attributes of tables:
show columns from PDB;
show columns from methodes_analyse;
show columns from methodes_resolution;
show columns from structures_secondaires;


-- Insertion de Données dans les tables
