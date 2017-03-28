#!bin/bash

if [ -f pdb_table.tsv ]; then
	rm pdb_table.tsv
fi

for id_chn in `cat ~/Documents/M2BI/BDD/Progs_utils/liste_wth_chain.txt`;do
	id=${id_chn:0:4}
	chain=${id_chn: -1}
	file=`echo "$id.pdb" | tr '[:upper:]' '[:lower:]'`
	header=`grep -oE "^HEADER +(\w+[ /])+" ~/Documents/M2BI/BDD/PDB_files/$file | sed -E -e 's/HEADER +//' -e 's/ $//' -e 's/\\n//'`
	seq=`grep -E "ATOM +\w+ +CA *\w+ $chain" ~/Documents/M2BI/BDD/PDB_files/$file | cut -c 18-20 | \
	sed -e 's/ALA/A/g' -e 's/CYS/C/g' -e 's/ASP/D/g' \
	-e 's/GLU/E/g' -e 's/PHE/F/g' -e 's/GLY/G/g' \
	-e 's/HIS/H/g' -e 's/ILE/I/g' -e 's/LYS/K/g' \
	-e 's/LEU/L/g' -e 's/MET/M/g' -e 's/PRO/P/g' \
	-e 's/ARG/R/g' -e 's/GLN/Q/g' -e 's/ASN/N/g' \
	-e 's/SER/S/g' -e 's/THR/T/g' -e 's/TRP/W/g' \
	-e 's/TYR/Y/g' -e 's/VAL/V/g' -e 's/ASX/B/g' \
	-e 's/GLX/Z/g' -e 's/SEC/U/g'`
	seq=`echo $seq | sed -E -e 's/\w{3}/X/g' -e 's/ //g'`
	start=`grep -m 1 -E "ATOM +\w+ +CA *\w+ $chain" ~/Documents/M2BI/BDD/PDB_files/$file | cut -c 23-26 | egrep -o "\-?[0-9]+"`
	
	start_msg=`grep -Eo -m1 "REMARK 465 +\w{3} $chain +[0-9]+" ~/Documents/M2BI/BDD/PDB_files/$file | awk '{print $5}'`
	if [ "$start_msg" == "" ];then
		start_msg=0
	fi
	#echo -e "$file\nstart missing res : $start_msg"
	IFS=$'\n'
	for msg_res in `grep -Eo "REMARK 465 +\w{3} $chain +[0-9]+" ~/Documents/M2BI/BDD/PDB_files/$file`;do
		
		mres=`echo $msg_res | awk '{print $3}' | sed -E -e 's/ALA/a/' -e 's/CYS/c/' -e 's/ASP/d/' \
														-e 's/GLU/e/' -e 's/PHE/f/' -e 's/GLY/g/' \
														-e 's/HIS/h/' -e 's/ILE/i/' -e 's/LYS/k/' \
														-e 's/LEU/l/' -e 's/MET/m/' -e 's/PRO/p/' \
														-e 's/ARG/r/' -e 's/GLN/q/' -e 's/ASN/n/' \
														-e 's/SER/s/' -e 's/THR/t/' -e 's/TRP/w/' \
														-e 's/TYR/y/' -e 's/VAL/v/' -e 's/ASX/b/' \
														-e 's/GLX/z/' -e 's/SEC/u/' -e 's/\w{3}/x/'`
		pos=`echo $msg_res | awk '{print $5}'`
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
		
	if [[ $start_msg -lt $start && "$start_msg" != "0" ]];then
		start=$start_msg
	fi
	length=`grep -E "ATOM +\w+ +CA *\w+ $chain" ~/Documents/M2BI/BDD/PDB_files/$file | tail -n 1 | cut -c 23-26 | grep -Eo "[0-9]+"`
	length_msg_res=`grep -Eo "REMARK 465 +\w{3} $chain +[0-9]+" ~/Documents/M2BI/BDD/PDB_files/$file | tail -n 1 | awk '{print $5}'`
	if [[ $length_msg_res != '' && $length_msg_res -gt $length ]];then
			length=$length_msg_res
	fi
	
	reso=`grep -E "REMARK.+RESOLUTION\." ~/Documents/M2BI/BDD/PDB_files/$file | grep -oE "[0-9]\.[0-9]+"`
	#echo $file
	#echo $reso
	meth_res=`grep -i "experiment type" ~/Documents/M2BI/BDD/PDB_files/$file | grep -Eio "x-ray|nmr"`
	
	echo -e "$id_chn\t$id\t$chain\t$header\t$seq\t$start\t$length\t$reso\t$meth_res" >> pdb_table.tsv
done

