
-- Database M2BI_Projet_PPII Creation

create table methodes_res(
	meth_Res VARCHAR(5) not null PRIMARY KEY
);

create table methodes_analyse(
	nom_Analyse VARCHAR(7) not null PRIMARY KEY
);

create table PDB(
	id_PDB CHAR(4) not null PRIMARY KEY,
	chaine VARCHAR(10) not null,
	header VARCHAR(255) NOT NULL,
	sequence_Proteine TEXT not null,
	start_seq INT NOT NULL,
	taille_Proteine INT not null,
	resolution_PDB FLOAT not null,
	meth_Res VARCHAR(10) not null,
	FOREIGN KEY (meth_Res) REFERENCES methodes_res(meth_Res) ON DELETE CASCADE
);

create table struct_sec(
	id_struct_sec INT not null AUTO_INCREMENT PRIMARY KEY,
	start_pred INT NOT NULL,
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


-- Data Insertion

INSERT INTO methodes_res (meth_Res) VALUES ('X-RAY'), ('NMR');

INSERT INTO methodes_analyse (nom_Analyse) VALUES ('DSSP'), ('PROSS');

LOAD DATA LOCAL INFILE 'pdb_table.tsv' INTO TABLE PDB;

LOAD DATA LOCAL INFILE 'sspred_table.tsv' INTO TABLE struct_sec;
