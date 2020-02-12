#!/bin/bash

FILE=$1
gcc -coverage -g ${FILE}.c -o ${FILE} -lm 
address=`gdb -q -x gdb.py ${FILE}` #最初と最後の行のアドレスの取得
s=`echo $address | cut -d' ' -f 5` #ここで２つの変数を使う(start,end)
e=`echo $address | cut -d' ' -f 6` #ここで２つの変数を使う(start,end)
echo $s
echo $e

