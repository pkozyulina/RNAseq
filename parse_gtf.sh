#! /bin/bash

FILE=$1
SPECIES=$2

while read line; do
	
	cat $FILE | sed 's/\t/\t\t/g' | sed 's/transcript\t/transcript/g' | awk '{print $10, $18, $14}' | sed 's/["]//g' | sed 's/[;]/\t/g' | sed '/(KNOWN|NOVEL)/d' | sed '1,2d' | uniq > $SPECIES.3col.ann


