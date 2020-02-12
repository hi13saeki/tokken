#!/bin/bash

FILE=$1

gcc -coverage ${FILE}.c -o ${FILE} -lm
for i in `seq 0 100`;
do
	rm *gcda*
	echo $i | ./${FILE}
	gcov ${FILE}
	mv ${FILE}.c.gcov tests/${FILE}.c.gcov.$i
done 

