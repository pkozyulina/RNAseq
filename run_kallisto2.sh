#!/bin/bash 

## kallisto index has to be pre-made separately
SPECIES=$1
NTAG=$2
REFDIR=/Molly/pkozyulina/reference
REF=$REFDIR/${SPECIES}_kallisto
## same as with HTSeq, this is human Gencode v25 annotation, of primary assembly
GTF=$REFDIR/$SPECIES.primary_assembly.annotation.gtf
ANN=$REFDIR/$SPECIES.3col.ann


FQDIR=`pwd`

KK=`for i in *fastq.gz
do
	TAG1=${i%%.fastq.gz} 
	TAG2=${TAG1%%_?}
	echo $TAG2
done | sort | uniq`

#mkdir ../kallisto
#cd ../kallisto

for i in $KK
do

TAG=$i

if [[ $TAG == "" || $SPECIES == "" ]]
then 
	echo "ERROR: Please provide 1) output name (tag) assuming <tag>.fastq.gz or <tag>_1.fastq.gz/<tag>_2.fastq.gz; 2) species alias, e.g. gencode.v25"
	exit 1
fi

if [[ -e $TAG.fastq.gz ]]
then
	echo "Processing alignment as single-end, using kallisto index $REF"
	READS="${TAG}.fastq.gz"
	SINGLE="--single -l 200 -s 50"
elif [[ -e ${TAG}_1.fastq.gz && -e ${TAG}_2.fastq.gz ]]
then 
	echo "Processing alignment as paired-end, using kallisto index $REF"
	READS="${TAG}_1.fastq.gz ${TAG}_2.fastq.gz"
else
	echo "ERROR: the required .fastq.gz file are not found!"
	exit 1
fi

if [[ ! -e $REF ]]
then
	echo "ERROR: kalilsto index $REF does not exist!"
	exit 1
fi

echo "kallisto: quantifying expression for sample $i"
  ## kallisto is build with paired ends in mind, so "--single -l 200 -s 50" options are necessary for single-end reads. 
/Molly/pkozyulina/TOOLS/kallisto_linux-v0.43.0/kallisto quant -i $REF -t 4 $SINGLE --plaintext -o ${TAG}_kallisto $READS &> $TAG.kallisto.log   
done

wait

for i in $KK
do
TAG=$i
mv ${TAG}_kallisto/abundance.tsv ${TAG}.tsv
done


mkdir logs
mv *log logs 

## the folders only contain technical info, let's remove them
rm -rf *_kallisto

## this script simply sums per-transcript read counts and TPMs into per-gene counts and TPMs 
python /Molly/pkozyulina/scripts/kallisto_per_gene_counts.py -a $GTF *tsv

echo "kallisto: generating the expression table file"

for i in *_per_gene.tsv
do
  echo "processing file $i" 
  TAG=${i%%_per_gene.tsv}
  echo $TAG > $TAG.tmp
  ## floating point number rounding makes it compatible with integer count-based tools such as DESeq2
  awk '{if (NR>1) print}' $i | sort -k1,1 | awk '{printf "%.0f\n",$2}'   >> $TAG.tmp
done

## final per-GENE expression table 
paste $ANN *.tmp > $NTAG.all_gene.kallisto.counts
rm *.tmp

#cp $NTAG.all_gene.kallisto.counts ../download

echo "ALL KALLISTO CALCULATIONS ARE DONE!"
echo
echo
