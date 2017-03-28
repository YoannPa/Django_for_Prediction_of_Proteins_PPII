#!/usr/bin/env/python
# -*- coding: utf-8 -*-

import sys
import os
import subprocess as sp
import re
from glob import glob

args = sys.argv

fil_out = open("sspred_table.tsv", "w")

with open(sys.argv[1], "r") as inpt:
    
    count = 1
    
    for line in inpt:
        pdb_id = line[:4]
        chain = line[4]
        pdb_file = pdb_id.lower()
        
        reg1 = re.compile(" *\d+ *\d+ " + chain)
        
        for files in glob("/home/letourneur/Documents/M2BI/BDD/pred_SS/*/"+pdb_file+"*"):
            with open(files, "r") as pred_file:
                
                sspred = ""
                start_pred = ""
                phi = ""
                psi = ""
                length = ""
                nbPPII = 0
                pctPPII = 0
                meth_ana = ""
                
                #~ Voir comment gérer les résidus manquants
                if files.find("PROSS") > -1:
                    
                    # faire passer une ligne pour ne pas prendre en compte le header
                    meth_ana = "PROSS"
                    
                    for lin in pred_file:
                        if lin.find("Chain: "+chain) > -1:
                            pred_file.next()
                            lin = next(pred_file,'')
                            start_pred = lin[1:5].strip()
                            sspred += lin[11]
                            if sspred[-1] == "P":
                                nbPPII += 1
                            phi += lin[17:24].strip() + ";"
                            psi += lin[26:33].strip() + ";"
                            pl = lin
                            
                            lin_suiv = next(pred_file, '')
                            
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
                            else:
                                sspred += lin_suiv[11]
                                if sspred[-1] == "P":
                                    nbPPII += 1
                                phi += lin_suiv[17:24].strip() + ";"
                                psi += lin_suiv[26:33].strip() + ";"
                                pl = lin_suiv
                            break
                    pl == ""
                    for lin in pred_file:
                        if lin.find("Chain:") > -1:
                            break
                        elif lin.find("??") > -1:
                            sspred += lin[11]
                            if sspred[-1] == "P":
                                nbPPII += 1
                            #voir si il faut gérer les 999.99
                            phi += lin[17:24].strip() + ";"
                            psi += lin[26:33].strip() + ";"
                            pl = lin
                            
                            lin_suiv = next(pred_file, '')
                            
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
                        
                        elif Start and lin.find("! ") > -1:
                            st_gap = int(pl[6:10].strip())
                            
                            lin_suiv = next(pred_file, '')
                            
                            if lin_suiv != '':
                                end_gap = int(lin_suiv[6:10].strip())
                                
                                sspred += "X" * (end_gap - st_gap - 1)
                                
                                sspred += lin_suiv[16]
                                if sspred[-1] == "P":
                                    nbPPII += 1
                                phi += lin_suiv[103:109].strip() + ";"
                                psi += lin_suiv[109:115].strip() + ";"
                                pl = lin_suiv
                        
                        elif Start:
                            break
                        
                    length = pl[6:10].strip()
                    #~ print length
                    pctPPII = (float(nbPPII) / float(length)) * 100
                    
                #~ elif files.find("SEGNO") > -1:
                    #~ #TO DO
                #~ elif files.find("XTLRSTR") > -1:
                    #TO DO
                
                
                
            # write info to the tsv file
            fil_out.write(str(count)+"\t"+start_pred+"\t"+sspred+"\t"+\
            str(nbPPII)+"\t"+str(pctPPII)+"\t"+phi[:-1]+"\t"+psi[:-1]+"\t"+\
            line[:-1]+"\t"+meth_ana+"\n")
            count = count + 1
            
fil_out.close()
