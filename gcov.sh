#!/bin/bash

FILE=$1
gene=$2
STDIN=$3
OP="$4"
end=$(echo `expr $# - 4`)
c=0
OPS=""
in=()
INT_MIN=-100
INT_MAX=100

gcc -coverage ${FILE}.c -o ${FILE} -lm #実行ファイル作成
dir=`find testgen -type d ` #gcovファイル用のディレクトリ

if [ " $dir" != " testgen" ] ; then  
	mkdir testgen
else
	echo "already directory"
fi

for i in "$@" #stdin以降の入力の型を取得
do
	c=$((c+1))
	if [ $c -ge 4 ]; then
		OPS="$OPS $i"
		if [ " $i"=" int" ]; then
			in[$((c-4))]=$INT_MIN
			echo ${in[$((c-4))]}
		elif [" $i"=" char"]; then
			in[$((c-4))]="a"
		fi
	fi
done

if [ " $gene" = " -g" ]; then #gcovファイルを生成する場合
	while [ ${in[$end]} -lt $INT_MAX ]; 
	do
		if [ " $STDIN" = " stdin" ]; then
			echo ${in[@]} | ./${FILE}		
		else 
			./${FILE} ${in[@]}
		fi
	
		#力が複数ある場合ファイル名に必要な数字の間に_を入れる
		input=$(echo ${in[@]} | tr ' ' '_') 
		echo $input	
		gcov ${FILE}
		mv ${FILE}.c.gcov testgen/${FILE}.c.gcov.$input
		rm *gcda*		
		input=" "
		for j in "$@";
		do
			c=$((c+1))
			if [ $c -ge 4 ]; then
				if [ " $j" = " int" ]; then #intの場合
					echo ""
					if [ ${in[0]} -lt $INT_MAX ]; then
						in[0]=$((${in[0]} + 1)) #入力が複数ある場合のまとめる処理
						break
					else
						for m in `seq 0 $((end-1))`
						do
							if [ ${in[$m]} -ge $INT_MAX ]; then
								in[$((m+1))]=$((${in[$((m+1))]}+1))
								in[$m]=$INT_MIN
							fi
							echo $m
							echo "no"
							if [ ${in[$((m+1))]} -le $INT_MAX ]; then
								break
							fi
						done
						break
					fi
 #               elif [" $j" = " char" ]; then
#					sa=$(echo a | tr $(printf %${i}s | tr ' ' '.' | tac)\a-z a-za-z)#atoz
#					LA=$(echo A | tr $(printf %${i}s | tr ' ' '.' | tac)\A-Z A-ZA-Z)#AtoZ
#					if [ $i <= 26 ]; then
#						in[$end]="$sa"
#					elif [ $i > 26 && $i <=52 ]; then
#						in[$end]="$LA" 
#					fi
				fi
			fi
		done
	done
fi

#最少スイートを自動でプログラムに適用し，コードカバレッジ計測
if [ $end -gt 1 ]; then
	RESULT=`python test_case.py ${FILE}.c $end`
else
	RESULT=`python test_case.py ${FILE}.c 2`
fi
	
echo;
echo $RESULT 
echo;

for n in `seq 4 14`;
do
	NOW=`echo $RESULT | cut -d' ' -f $n | tr '_' ' '` 

	if [ "X$NOW" != "X" ];
	then
		echo $NOW
		./${FILE} $NOW
		echo;
		echo;
	else
		echo "quit!"
		break
	fi
done
gcov ${FILE}
