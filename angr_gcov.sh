#!/bin/bash

FILE=$1
gene=$2
in=""

gcc -coverage -g ${FILE}.c -o ${FILE} -lm #実行ファイル作成
dir=`find tests -type d ` #gcovファイル用のディレクトリ

if [ " $dir" != " tests" ] ; then  
	mkdir tests
else
	echo "already directory"
fi
n=1
if [ " $gene" = " -g" ]; then #gcovファイルを生成する場合
	address=`gdb -q -x gdb.py ${FILE}` #最初と最後の行のアドレスの取得
	s=`echo $address | cut -d' ' -f 5` #ここで２つの変数を使う(start,end)
	e=`echo $address | cut -d' ' -f 6` #ここで２つの変数を使う(start,end)
	echo $s
	echo $e
	inputs=`python3 all3.py ${FILE} $s $e` #NOW→  start,end
	#ここで入力を一気に出力
	#angrの出力結果
	result=`echo $inputs | sed -e "s/+/ +/" | sed -e "s/-/ -/"`
	NOW=`echo $inputs | cut -d' ' -f $n` #n番目の入力
	#echo "result="$result
	while [ "X$NOW" != "X" ];
	do
		#if [ " $STDIN" = " stdin" ]; then
		echo $NOW | ./${FILE}		
		#else 
			#./${FILE} ${result[@]}
		#fi
	
		#力が複数ある場合ファイル名に必要な数字の間に_を入れる
		#echo "echo="$input	
		gcov ${FILE}
		input=`echo $NOW | sed -e "s/+/_+/" | sed -e "s/-/_-/"`
		
		mv ${FILE}.c.gcov ./tests/${FILE}.c.gcov.$NOW
		rm *gcda*		
		input=" "
		n=$((n+1))
		result=`echo $inputs | sed -e "s/+/ +/" | sed -e "s/-/ -/"`
		NOW=`echo $inputs | cut -d' ' -f $n` #n番目の入力
	done
fi

#最少スイートを自動でプログラムに適用し，コードカバレッジ計測
min_input=`python angr_case.py ${FILE}`
	
echo --------------min_inputs---------------;
#echo $RESULT 
echo $min_input | cut -d' ' -f 2-
c=1
# sat test suite:のあとからの最小スイートの入力(14-4個)
for n in `seq 4 14`;
do
	ANS=`echo $min_input | cut -d' ' -f $n` 
	#| tr '_' ' '` 

	if [ "X$ANS" != "X" ];
	then
		echo "input"$c $ANS
		echo "output"$c
		echo  $ANS | ./${FILE}
		echo;
		echo;
		c=$((c+1))
		
	else
		#echo "quit!"
		break
	fi
done
echo `gcov ${FILE}` | cut -d' ' -f 3-6
