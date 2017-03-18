#!/bin/bash

WDIR=`pwd`
GTF=$1
FA=$2
TAG=$3


#!/bin/sh
#PBS -N rsem_star_$TAG
#PBS -l nodes=1:ppn=1,walltime=8:00:00,vmem=6gb
#PBS -o $TAG.rsem_star.log
#PBS -j oe 
#PBS -q dque_smp
 
cd $WDIR
mkdir $TAG
cd $TAG
##rsem-prepare-reference --no-polyA --gtf $GTF $FA $TAG  ## <-- for OLD RSEM versions.
/Molly/mholmatov/bin/RSEM-1.3.0/rsem-prepare-reference --gtf $GTF $FA $TAG               ## new versions do not add polyA by default. 

