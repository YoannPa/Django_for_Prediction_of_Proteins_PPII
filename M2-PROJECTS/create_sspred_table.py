#!/usr/bin/env/python
# -*- coding: utf-8 -*-

import sys
import os
import subprocess as sp
import re
from glob import glob

args = sys.argv

if len(args) != 3:
    sys.exit("""Usage : create_sspred_table.py list_wth_chain.txt secondary_structure_predictions 
    list_wth_chain.txt : path to the file containing a list of PDB ids concatenated with a chain name
    secondary_structure_prediction : folder containning the secondary structure prediction of\
 SEGNO, DSSPPII, XTLRSTR and PROSS each in there respective folders""")

fil_out = open("sspred_table.tsv", "w")

if not os.path.exists(args[1]):
    fil_out.close()
    sys.exit("ERROR : wrong path to list_wth_chain.txt file")

with open(args[1], "r") as inpt:
    
    # count that will serve as primary key
    count = 1
    
    # for each PDB id in the list
    for line in inpt:
        pdb_id = line[:4]
        chain = line[4]
        pdb_file = pdb_id.lower()
        
        reg1 = re.compile(" *\d+ *\d+ " + chain)
        
        if args[2][-1] == "/":
            args[2] = args[2][:-1]
        
        if len(glob(args[2]+"/*/"+pdb_file+"*")) == 0:
            exit("ERROR : wrong path to the secondary structure directory or\
 there is no secondary structure prediction for the " + pdb_id + " PDB file")
                
        # for each secondary structure predictions on a chain of a PDB file 
        for files in glob(args[2]+"/*/"+pdb_file+"*"):
            with open(files, "r") as pred_file:
                
                sspred = ""
                start_pred = ""
                phi = ""
                psi = ""
                length = ""
                nbPPII = 0
                pctPPII = 0
                meth_ana = ""
                
                if files.find("PROSS") > -1:
                    
                    meth_ana = "PROSS"
                    pl == ""
                    
                    for lin in pred_file:
                        # at the start of the prediction for the wanted chain
                        if lin.find("Chain: "+chain) > -1:
                            # skip the header line
                            pred_file.next()
                            lin = next(pred_file,'')
                            start_pred = lin[1:5].strip()
                            sspred += lin[11]
                            if sspred[-1] == "P":
                                nbPPII += 1
                            phi += lin[17:24].strip() + ";"
                            psi += lin[26:33].strip() + ";"
                            
                            lin_suiv = next(pred_file, '')
                            pl = lin
                            # if there are missing residues
                            if lin_suiv.find("??") > -1:
                                st_gap = int(pl[3:6].strip())
                                end_gap = int(lin_suiv[3:6].strip())
                                
                                sspred += "x" * (end_gap - st_gap - 1)
                                
                                sspred += lin_suiv[11]
                                if sspred[-1] == "P":
                                    nbPPII += 1
                                # see if there is a need to modify values eq 999.99
                                phi += lin[17:24].strip() + ";"
                                psi += lin[26:33].strip() + ";"
                                
                            else:
                                sspred += lin_suiv[11]
                                if sspred[-1] == "P":
                                    nbPPII += 1
                                phi += lin_suiv[17:24].strip() + ";"
                                psi += lin_suiv[26:33].strip() + ";"
                                
                            break
                    
                    # go on in the file
                    for lin in pred_file:
                        # stop if arrive at the prediction of another chain
                        if lin.find("Chain:") > -1:
                            break
                        # could be the last line or that there are missing residues
                        elif lin.find("??") > -1:
                            sspred += lin[11]
                            if sspred[-1] == "P":
                                nbPPII += 1
                            # see if there is a need to modify values eq 999.99
                            phi += lin[17:24].strip() + ";"
                            psi += lin[26:33].strip() + ";"
                            pl = lin
                            
                            lin_suiv = next(pred_file, '')
                            
                            # if there are missing residues
                            if lin_suiv.find("??") > -1:
                                st_gap = int(pl[3:6].strip())
                                end_gap = int(lin_suiv[3:6].strip())
                                
                                sspred += "x" * (end_gap - st_gap - 1)
                                
                                sspred += lin_suiv[11]
                                if sspred[-1] == "P":
                                    nbPPII += 1
                                #voir si il faut gérer les 999.99
                                phi += lin[17:24].strip() + ";"
                                psi += lin[26:33].strip() + ";"
                                pl = lin_suiv
                                
                            # stop if arrive at the prediction of another chain or at EOF
                            elif lin_suiv.find("Chain:") > -1 or lin_suiv == "":
                                break
                            else:
                                sspred += lin_suiv[11]
                                if sspred[-1] == "P":
                                    nbPPII += 1
                                phi += lin_suiv[17:24].strip() + ";"
                                psi += lin_suiv[26:33].strip() + ";"
                                pl = lin_suiv
                        else:
                            sspred += lin[11]
                            if sspred[-1] == "P":
                                nbPPII += 1
                            phi += lin[17:24].strip() + ";"
                            psi += lin[26:33].strip() + ";"
                            pl = lin
                    
                    length = pl[1:5].strip()
                    pctPPII = (float(nbPPII) / float(length)) * 100
                    
                    
                elif files.find("DSSPPII") > -1:
                    
                    meth_ana = "DSSP"
                    
                    Start = False
                    pl = ""
                    for lin in pred_file:
                        # if lin correspond to prediction of the wanted chain
                        if re.match(reg1, lin):
                            if Start == False:
                                Start = True
                                start_pred = lin[6:10].strip()
                            sspred += lin[16]
                            if sspred[-1] == "P":
                                nbPPII += 1
                            phi += lin[103:109].strip() + ";"
                            psi += lin[109:115].strip() + ";"
                            pl = lin
                        
                        # if there are missing residues or the last line
                        elif Start and lin.find("! ") > -1:
                            st_gap = int(pl[6:10].strip())
                            
                            lin_suiv = next(pred_file, '')
                            
                            # if not the last line
                            if lin_suiv != '':
                                end_gap = int(lin_suiv[6:10].strip())
                                
                                sspred += "X" * (end_gap - st_gap - 1)
                                
                                sspred += lin_suiv[16]
                                if sspred[-1] == "P":
                                    nbPPII += 1
                                phi += lin_suiv[103:109].strip() + ";"
                                psi += lin_suiv[109:115].strip() + ";"
                                pl = lin_suiv
                        
                        # if encounter prediction of another chain stop
                        elif Start:
                            break
                        
                    length = pl[6:10].strip()
                    pctPPII = (float(nbPPII) / float(length)) * 100
                    
                #~ elif files.find("SEGNO") > -1:
                    #TO DO
                #~ elif files.find("XTLRSTR") > -1:
                    #TO DO
                
            # write info to the tsv file
            fil_out.write(str(count)+"\t"+start_pred+"\t"+sspred+"\t"+\
            str(nbPPII)+"\t"+str(pctPPII)+"\t"+phi[:-1]+"\t"+psi[:-1]+"\t"+\
            line[:-1]+"\t"+meth_ana+"\n")
            count = count + 1
            
fil_out.close()
