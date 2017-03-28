USE M2BI_Projet_PPII

DROP TABLE IF EXISTS struct_sec;
DROP TABLE IF EXISTS PDB;
DROP TABLE IF EXISTS methodes_analyse;
DROP TABLE IF EXISTS methodes_res;

CREATE TABLE IF NOT EXISTS methodes_res(
	meth_Res VARCHAR(7) NOT NULL PRIMARY KEY
)
ENGINE=InnoDB;
/*VARCHAR(10) NOT NULL PRIMARY KEY*/

INSERT INTO methodes_res (meth_Res) VALUES ('X-RAY'), ('NMR');

CREATE TABLE IF NOT EXISTS methodes_analyse(
	nom_Analyse VARCHAR(7) NOT NULL PRIMARY KEY
)
ENGINE=InnoDB;

INSERT INTO methodes_analyse (nom_Analyse) VALUES ('DSSP'), ('PROSS');

CREATE TABLE IF NOT EXISTS PDB(
	id_PDB_chain CHAR(5) NOT NULL PRIMARY KEY,
    id_PDB CHAR(4) NOT NULL,
	chaine VARCHAR(3) NOT NULL,
	header VARCHAR(255) NOT NULL,
	sequence_Proteine TEXT NOT NULL,
    start_seq INT NOT NULL,
	taille_Proteine INT NOT NULL,
	resolution_PDB FLOAT NOT NULL,
    meth_Res VARCHAR(10) NOT NULL,
	CONSTRAINT fk_metho_res FOREIGN KEY (meth_Res) REFERENCES methodes_res(meth_Res) ON DELETE CASCADE
)
ENGINE=InnoDB;

LOAD DATA INFILE '/var/lib/mysql-files/pdb_table.tsv' INTO TABLE PDB;

CREATE TABLE IF NOT EXISTS struct_sec(
	id_struct_sec INT NOT NULL PRIMARY KEY,
    start_pred INT NOT NULL,
	structure_Predite TEXT NOT NULL,
	nombre_PPII INT NOT NULL,
	pourcentage_PPII FLOAT NOT NULL, 
	angle_phi TEXT NOT NULL,
	angle_psi TEXT NOT NULL,
    id_PDB CHAR(5) ,
	nom_Analyse VARCHAR(7) NOT NULL,
	FOREIGN KEY (id_PDB) REFERENCES PDB(id_PDB_chain),
	FOREIGN KEY (nom_Analyse) REFERENCES methodes_analyse(nom_Analyse) 
)
ENGINE=InnoDB;

LOAD DATA INFILE '/var/lib/mysql-files/sspred_table.tsv' INTO TABLE struct_sec;

