#!/bin/bash 
RMSK=$1 # RepeatMasker rRNA table from UCSC table browser (all fiels, not just GTF!)
GENCODE=$2 # GENCODE annotation in GTF
HEADER=$3 # Header from one of BAM files. It can be obtained using 'samtools view -H' command.
TAG=$4 ## e.g. 'gencode_vM6' or 'gencode.v24'
OUTDIR=$5
DR=/Molly/mholmatov/bin/bedtools2/bin

grep rRNA $RMSK | awk -F "\t" '{if ($6 !~ "_") print}' > $OUTDIR/rRNA_from_rmsk.table  ## we don't want any patches/scaffolds here since they won't be in Gencode notation. 
grep -P "\tgene\t" $GENCODE | grep rRNA > $OUTDIR/rRNA_from_gencode.gtf

awk '{printf "%s\t%s\t%s\t%s\t%s\t%s\n",$6,$7,$8,$11,$12,$10}' $OUTDIR/rRNA_from_rmsk.table | sort -k1,1V -k2,2n -k3,3n > $OUTDIR/rRNA_from_rmsk.bed
perl -ne 'm/(chr.*?)\tENSEMBL\tgene\t(\d+?)\t(\d+?)\t\.\t(.*?)\t.*gene_id \"(.*?)\".*gene_name \"(.*?)\"/; print "$1\t$2\t$3\t$6\t$5\t$4\n"' $OUTDIR/rRNA_from_gencode.gtf | sort -k1,1V -k2,2n -k3,3n > $OUTDIR/rRNA_from_gencode.bed

KK1=`awk '{sum+=$3-$2} END {print sum}' $OUTDIR/rRNA_from_rmsk.bed`
KK2=`awk '{sum+=$3-$2} END {print sum}' $OUTDIR/rRNA_from_gencode.bed`
KK3=`$DR/bedtools intersect -wao -a $OUTDIR/rRNA_from_gencode.bed -b $OUTDIR/rRNA_from_rmsk.bed | awk '{sum+=$13} END {print sum}'`

echo "overall coverage: $KK1 bp in rmsk intervals, $KK2 bp in gencode intervals, $KK3 bp common"

cat $OUTDIR/rRNA_from_gencode.bed $OUTDIR/rRNA_from_rmsk.bed | sort -k1,1V -k2,2n -k3,3n > $OUTDIR/rRNA_combined.bed
$DR/bedtools merge -c 4 -o collapse -s -i $OUTDIR/rRNA_combined.bed > $OUTDIR/rRNA_merged.bed
KK4=`awk '{sum+=$3-$2} END {print sum}' $OUTDIR/rRNA_merged.bed`

echo "coverage of the merged intervals file: $KK4 bp"
cat $HEADER $OUTDIR/rRNA_merged.bed > $OUTDIR/$TAG.rRNA_merged.intervals
