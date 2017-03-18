#!/bin/bash

# NTAG - name of a final file
# REFNAME - .gtf reference
# ANNNAME - .3col.ann file - annotation with only gene ids, names and gene types

NTAG=$1
ANNNAME=$2
ANN="/Molly/pkozyulina/reference/$ANNNAME"

DIR=`pwd`


echo -e "Gene_id\tSymbol\tGene_type" > names

cat $ANN | sort | awk '{print $1, $2, $3}' >> $DIR/names



for i in *_per_gene.tsv
do
	TAG=${i%%_per_gene.tsv}
RE_="/Molly/pkozyulina/reference/$REFNAME"
	echo "Processing sample $TAG..."
	echo $TAG >> $TAG.tmp
	sort ${TAG}_per_gene.tsv | awk '{print $2}'>> $TAG.tmp

done

paste names *.tmp > $NTAG.all_gene.kallisto.counts
rm *.tmp names
