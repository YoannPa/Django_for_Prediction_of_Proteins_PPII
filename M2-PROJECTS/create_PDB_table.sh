#!bin/bash

# this dcript take a list of PDB ID with a chain concatenated to it and parse
# PDB files to retrieve various informations that will be put into the database
# take as argument : - ($1) the list of PDB ids with chain -> list_wth_chain.txt
#					 - ($2) path to the PDB_files directory

if [ "$#" -ne 3 ];then
	echo -e "\tUsage : create_PDB_table.sh list_with_chain.txt PDB_files/"
	echo -e "\tlist_with_chain.txt : path to the list of PDB ids with chain"
	echo -e "\tPDB_files/ : path to the PDB_files directory"
	exit
fi

# delete the file if it already exist to create it anew
if [ -f pdb_table.tsv ]; then
	rm pdb_table.tsv
fi

PDB_files_dir=`echo $2 | sed 's/\/$//'`

# for each PDB ID
for id_chn in `cat $1`;do
	id=${id_chn:0:4}
	chain=${id_chn: -1}
	file=`echo "$id.pdb" | tr '[:upper:]' '[:lower:]'`
	header=`grep -oE "^HEADER +(\w+[ /])+" $PDB_files_dir/$file | sed -E -e 's/HEADER +//' -e 's/ $//' -e 's/\\n//'`
	seq=`grep -E "ATOM +\w+ +CA *\w+ $chain" $PDB_files_dir/$file | cut -c 18-20 | \
	sed -e 's/ALA/A/g' -e 's/CYS/C/g' -e 's/ASP/D/g' \
	-e 's/GLU/E/g' -e 's/PHE/F/g' -e 's/GLY/G/g' \
	-e 's/HIS/H/g' -e 's/ILE/I/g' -e 's/LYS/K/g' \
	-e 's/LEU/L/g' -e 's/MET/M/g' -e 's/PRO/P/g' \
	-e 's/ARG/R/g' -e 's/GLN/Q/g' -e 's/ASN/N/g' \
	-e 's/SER/S/g' -e 's/THR/T/g' -e 's/TRP/W/g' \
	-e 's/TYR/Y/g' -e 's/VAL/V/g' -e 's/ASX/B/g' \
	-e 's/GLX/Z/g' -e 's/SEC/U/g'`
	# if there is a modified amino acid replace it by X
	seq=`echo $seq | sed -E -e 's/\w{3}/X/g' -e 's/ //g'`
	# number of the first residue of the PDB
	start=`grep -m 1 -E "ATOM +\w+ +CA *\w+ $chain" $PDB_files_dir/$file | cut -c 23-26 | egrep -o "\-?[0-9]+"`
	# number of the first missing residue
	start_msg=`grep -Eo -m1 "REMARK 465 +\w{3} $chain +[0-9]+" $PDB_files_dir/$file | awk '{print $5}'`
	if [ "$start_msg" == "" ];then
		start_msg=0
	fi
	
	IFS=$'\n'
	# place missing resisdues in the sequence
	# they will be in lower case
	for msg_res in `grep -Eo "REMARK 465 +\w{3} $chain +[0-9]+" $PDB_files_dir/$file`;do
		
		mres=`echo $msg_res | awk '{print $3}' | sed -E -e 's/ALA/a/' -e 's/CYS/c/' -e 's/ASP/d/' \
														-e 's/GLU/e/' -e 's/PHE/f/' -e 's/GLY/g/' \
														-e 's/HIS/h/' -e 's/ILE/i/' -e 's/LYS/k/' \
														-e 's/LEU/l/' -e 's/MET/m/' -e 's/PRO/p/' \
														-e 's/ARG/r/' -e 's/GLN/q/' -e 's/ASN/n/' \
														-e 's/SER/s/' -e 's/THR/t/' -e 's/TRP/w/' \
														-e 's/TYR/y/' -e 's/VAL/v/' -e 's/ASX/b/' \
														-e 's/GLX/z/' -e 's/SEC/u/' -e 's/\w{3}/x/'`
		pos=`echo $msg_res | awk '{print $5}'`
		# take only missing residues with a positive number
		if [ "$pos" == "" ];then
			pos=0
		fi
		if [ $pos -gt 0 ];then
			if [[ $pos -lt $start && $pos -le $start_msg ]];then
				seq="$mres$seq"
			else
				seq="${seq:0:$((pos - 1))}$mres${seq:$((pos - 1)):${#seq}}"
			fi
		fi
	done
		
	if [[ $start_msg -lt $start && "$start_msg" -gt "0" ]];then
		start=$start_msg
	fi
	length=`grep -E "ATOM +\w+ +CA *\w+ $chain" $PDB_files_dir/$file | tail -n 1 | cut -c 23-26 | grep -Eo "[0-9]+"`
	length_msg_res=`grep -Eo "REMARK 465 +\w{3} $chain +[0-9]+" $PDB_files_dir/$file | tail -n 1 | awk '{print $5}'`
	if [[ $length_msg_res != '' && $length_msg_res -gt $length ]];then
			length=$length_msg_res
	fi
	
	reso=`grep -E "REMARK.+RESOLUTION\." $PDB_files_dir/$file | grep -oE "[0-9]\.[0-9]+"`
	
	meth_res=`grep -i "experiment type" $PDB_files_dir/$file | grep -Eio "x-ray|nmr"`
	
	# write parsed informations to pdb_table.tsv
	echo -e "$id_chn\t$id\t$chain\t$header\t$seq\t$start\t$length\t$reso\t$meth_res" >> pdb_table.tsv
done

