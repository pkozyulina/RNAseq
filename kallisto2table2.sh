#!/bin/bash

# NTAG - name of a final file
# REFNAME - .gtf reference
# ANNNAME - .3col.ann file - annotation with only gene ids, names and gene types

NTAG=$1
REFNAME=$2
ANNNAME=$3
REF="/Molly/pkozyulina/reference/$REFNAME"
ANN="/Molly/pkozyulina/reference/$ANNNAME"

DIR=`pwd`


echo -e "Gene_id\tSymbol\tGene_type" > names

cat $ANN | sort | awk '{print $1, $2, $3}' >> $DIR/names



for i in *.tsv
do
	TAG=${i%%.tsv}
	echo "Processing sample $i..."
	echo -e $i > $TAG.tmp
	/Molly/pkozyulina/scripts/kallisto_per_gene_counts.py -a $REF $i 
	sort ${TAG}_per_gene.tsv | awk '{print $2}'>> $TAG.tmp

done

paste names *.tmp > $NTAG.all_gene.kallisto.counts
rm *.tmp names
