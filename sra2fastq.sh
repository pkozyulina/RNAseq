#!/bin/bash 


for i in *.sra 
do 
	  echo "fastq-dump: processing sample $i"
	  /Molly/pkozyulina/TOOLS/sratoolkit.2.8.0-ubuntu64/bin/fastq-dump --gzip --split-3 $i &>> sra2fastq.log
 done
