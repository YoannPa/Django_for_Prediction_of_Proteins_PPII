#!bin/bash

#$1 : sspred_table file
#$2 : pdb_table file

if [ "$#" -ne 2 ];then
	echo -e "\tUsage : align_sequence_and_prediction.sh sspred_table pdb_table"
	echo -e "\tsspred_table.tsv : path to sspred_table.tsv file"
	echo -e "\tpdb_table.csv : path to the pdb_table.csv file"
	exit
fi

if [ -f sspred_table_aligned.tsv ]; then
	rm sspred_table_aligned.tsv
fi

IFS=$'\n'
for line in `cat $1`;do
	id_pdb_chain=`echo -e $line | cut -f 8 -d $'\t'`
	start_pred=`echo -e $line | cut -f 2 -d $'\t'`
	res=`egrep -w "$id_pdb_chain" $2`
	start_seq=`echo $res | cut -f 6 -d ";"`
	diff=$(( start_pred - start_seq ))
	if [ $diff -gt 0 ];then
		bf_pred=`echo -e $line | cut -f 1-2 -d $'\t'`
		pred=`echo -e $line | cut -f 3 -d $'\t'`
		af_pred=`echo -e $line | cut -f 4-9 -d $'\t'`
		fill=`printf '%0.s-' $(seq 1 $diff)`
		pred=`echo $fill$pred`
		echo -e $bf_pred"\t"$pred"\t"$af_pred >> sspred_table_aligned.tsv
	else
		echo -e $line >> sspred_table_aligned.tsv
	fi
done

