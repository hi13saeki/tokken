#!/bin/bash
FILE=$1
gcc -coverage -g -o ${FILE} ${FILE}.c 
inputs=`gdb -q -x gdb_totient.py`
n=1
NOW=`echo $inputs | cut -d' ' -f $n`
while [ "X$NOW" != "X" ];
do
	echo "$NOW"
	python all.py ${FILE} $NOW 
	n=$((n+1))
    NOW=`echo $inputs | cut -d' ' -f $n`
done
