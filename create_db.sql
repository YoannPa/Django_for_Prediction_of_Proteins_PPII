-- Database M2BI_Projet_PPII Creation

CREATE TABLE methodes_res(
	meth_Res VARCHAR(5) NOT NULL PRIMARY KEY
);

CREATE TABLE methodes_analyse(
	nom_Analyse VARCHAR(7) NOT NULL PRIMARY KEY
);

CREATE TABLE PDB(
	id_PDB_chain CHAR(5) NOT NULL PRIMARY KEY,
	id_PDB CHAR (4) NOT NULL,
	chaine VARCHAR(10) NOT NULL,
	header VARCHAR(255) NOT NULL,
	sequence_Proteine TEXT NOT NULL,
	start_seq INT NOT NULL,
	taille_Proteine INT NOT NULL,
	resolution_PDB FLOAT NOT NULL,
	meth_Res VARCHAR(10) NOT NULL,
	FOREIGN KEY (meth_Res) REFERENCES methodes_res(meth_Res) ON DELETE CASCADE
);

CREATE TABLE struct_sec(
	id_struct_sec INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	start_pred INT NOT NULL,
	structure_Predite TEXT NOT NULL,
	nombre_PPII INT NOT NULL,
	pourcentage_PPII FLOAT NOT NULL, 
	angle_phi TEXT NOT NULL,
	angle_psi TEXT NOT NULL,
	id_PDB_chain CHAR(5) NOT NULL,
	nom_Analyse VARCHAR(7) NOT NULL,
	FOREIGN KEY (id_PDB_chain) REFERENCES PDB(id_PDB_chain) ON DELETE CASCADE,
	FOREIGN KEY (nom_Analyse) REFERENCES methodes_analyse(nom_Analyse) ON DELETE CASCADE 
);


-- Data Insertion

INSERT INTO methodes_res (meth_Res) VALUES ('X-RAY'), ('NMR');

INSERT INTO methodes_analyse (nom_Analyse) VALUES ('DSSP'), ('PROSS');

LOAD DATA LOCAL INFILE 'pdb_table.tsv' INTO TABLE PDB;

LOAD DATA LOCAL INFILE 'sspred_table.tsv' INTO TABLE struct_sec;
