

-- Creation Database M2BI_Projet_PPII
create table methodes_res(
	meth_Res VARCHAR(10) not null PRIMARY KEY
);

create table methodes_analyse(
	nom_Analyse VARCHAR(7) not null PRIMARY KEY
);

create table PDB(
	id_PDB CHAR(4) not null PRIMARY KEY,
	nom_Proteine VARCHAR(255) not null,
	chaine VARCHAR(10) not null,
	sequence_Proteine TEXT not null,
	taille_Proteine INT not null,
	resolution_PDB FLOAT not null,
	header VARCHAR(255) not null,
	meth_Res VARCHAR(10) not null,
	FOREIGN KEY (meth_Res) REFERENCES methodes_res(meth_Res) ON DELETE CASCADE
);

create table struct_sec(
	id_struct_sec INT not null AUTO_INCREMENT PRIMARY KEY,
	structure_Predite TEXT not null,
	nombre_PPII INT not null,
	pourcentage_PPII FLOAT not null, 
	angle_phi TEXT not null,
	angle_psi TEXT not null,
	id_PDB CHAR(4) not null,
	nom_Analyse VARCHAR(7) not null,
	FOREIGN KEY (id_PDB) REFERENCES PDB(id_PDB) ON DELETE CASCADE,
	FOREIGN KEY (nom_Analyse) REFERENCES methodes_analyse(nom_Analyse) ON DELETE CASCADE 
);

-- Insertion de Données dans les tables
