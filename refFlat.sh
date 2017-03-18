
#!/bin/bash 

## this one is to generate Picard tools "refflat" type annotation from the Gencode GTFs.  

GTF=$1
TAG=$2
gtfToGenePred -ignoreGroupsWithoutExons $GTF $TAG.$$.tmp1
sort -k1,1 $TAG.$$.tmp1 > $TAG.$$.tmp2
grep -P "\ttranscript\t" $GTF | perl -ne 'print "$1\t$2\n" if m/transcript_id \"(.*)\"\; gene_type.*gene_name \"(.*)\"\; transcript_type/g' | sort -k1,1 | uniq | awk '{print $2}' > $TAG.$$.tmp3
paste $TAG.$$.tmp3 $TAG.$$.tmp2 | sort -k3,3 -k5,5n > $TAG.refFlat.txt

rm *.$$.tmp?
