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


echo -e "Gene_id\tSymbol\tGene_type" > $DIR/names

cat $ANN | sort | awk '{print $1, $2, $3}' >> $DIR/names

LIST=`ls | grep _kallisto`


for i in $LIST
do
        echo "Processing sample $i..."
        echo -e $i > $DIR/$i.tmp
        /Molly/pkozyulina/scripts/kallisto_per_gene_counts.py -a $REF $i/abundance.tsv
        sort $i/abundance_per_gene.tsv | awk '{print $2}'>> $DIR/$i.tmp

done

paste $DIR/names $DIR/*.tmp > $DIR/$NTAG.all_gene.kallisto.counts
rm $DIR/*.tmp names
