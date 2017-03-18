# /bin/bash

WD=`pwd`

cd $WD

FILE=$1
while read F  ; do
	echo 'Directly fastq-dumping sample $F'
        /Molly/pkozyulina/TOOLS/sratoolkit.2.8.0-ubuntu64/bin/fastq-dump --gzip --split-3 $F &>> sra2fastq.log &
done <$FILE.direct

wait
echo 'Hopefully all data is dumped'
/Molly/pkozyulina/scripts/run_kallisto2.sh gencode.v25 $FILE

