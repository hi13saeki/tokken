#!/bin/dash

FILE=$1
gene=$2
STDIN=$3
OP="$4"
end=$(echo `expr $# - 2`)
c=0
OPS=""
in=""
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
	fi
done
echo $end

if [ " $gene" = " -g" ]; then #gcovファイルを生成する場合
	for i in `seq -100 100`; 
	do
		in=""
		for j in "$@"
		do
			c=$((c+1))
			if [ $c -eq 4 ]; then
				if [ " $j" = " int" ]; then #intの場合
					in="$i" #入力が複数ある場合のまとめる処理
                elif [" $j" = " char" ]; then
					sa=$(echo a | tr $(printf %${i}s | tr ' ' '.' | tac)\a-z a-za-z)#atoz
					LA=$(echo A | tr $(printf %${i}s | tr ' ' '.' | tac)\A-Z A-ZA-Z)#AtoZ
					if [ $i <= 26 ]; then
						in="$sa"
					elif [ $i > 26 && $i <=52 ]; then
						in="$LA" 
					fi
				fi
			fi
#			if [ $c -ge 5 ];then
#				for si in `seq -100 100`
#				do							
#					if [ " $j" = " int" ]; then #intの場合
#						in="$in $si"
#               		elif [ " $j" = " char" ]; then
#						sa=$(echo a | tr $(printf %${si}s | tr ' ' '.' | tac)\a-z a-za-z)#atoz
#						LA=$(echo A | tr $(printf %${si}s | tr ' ' '.' | tac)\A-Z A-ZA-Z)#AtoZ
#						if [ $si <= 26 ]; then
#							in="$in $sa"
#						elif [ $si > 26 && $si <=52 ]; then
#							in="$in $LA" 
#						fi
#					fi
#				done
#			fi
		done
			#echo $in
		if [ " $STDIN" = " stdin" ]; then
				echo $in | ./${FILE}		
			else 
				./${FILE} $in
		fi
	
			#力が複数ある場合ファイル名に必要な数字の間に_を入れる
		in=$(echo $in | tr ' ' '_') 
			
		echo $in
		mv ${FILE}.c.gcov testgen/${FILE}.c.gcov.$in
		rm *gcda*		
		in=" "
			 
#		elif [ " $OP" = " char" ]; then
#			for i in `seq 0 25`; #A to Z and a to z
#			do
#				sa=$(echo a | tr $(printf %${i}s | tr ' ' '.' | tac)\a-z a-za-z)#atoz
#				LA=$(echo A | tr $(printf %${i}s | tr ' ' '.' | tac)\A-Z A-ZA-Z)#AtoZ
#				if [ ${STDIN} = "stdin" ]; then
#					echo $LA | ./${FILE}	
#				else 
#					./${FILE} $LA
#				fi
#				gcov ${FILE} 
#				mv ${FILE}.c.gcov testgen/${FILE}.c.gcov.$LA
#				rm *gcda*		
#			done 
#			echo ${OPS}
		#elif [[ ${OP} =~ .txt ]]; then
		
	done
fi

end=5-$end

#最少スイートを自動でプログラムに適用し，コードカバレッジ計測
RESULT=`python set_cover_delete.py ${FILE}.c $end`
echo;
echo $RESULT 
echo;

#last=`echo $RESULT | tr ' ' '\n' | tail -n1`
for n in `seq 4 14`;
do
	NOW=`echo $RESULT | cut -d' ' -f $n`
	if [ "X$NOW" != "X" ];
	then
		echo $NOW
		echo $NOW | ./${FILE}
		echo;
	else
		echo "quit!"
		break
	fi
done
gcov ${FILE}
