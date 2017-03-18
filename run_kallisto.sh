#!/bin/bash 

SPECIES=$1

KK=`for i in *fastq.gz
do 
  TAG1=${i%%.fastq.gz}
  TAG2=${TAG1%%_?}
  echo $TAG2
done | sort | uniq`

for i in $KK
do 
/Molly/pkozyulina/scripts/kallisto_quant.sh $i $SPECIES &> $i.kallisto_stdout.log 
done
