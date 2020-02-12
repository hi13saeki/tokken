#!/bin/dash

FILE=$1
gene=$2
STDIN=$3
OP="$4"

gcc -coverage ${FILE}.c -o ${FILE} -lm
dir=`find testgen -type d `

if [ " $dir" != " testgen" ] ; then  
	mkdir testgen
else
	echo "already directory"
fi

if [ " $gene" = " -g" ]; then
#	while 
	if [ $(echo $OP | grep -e "int") ]; then
		for i in `seq -10000 10000`; 
#	seq -10000 10000 | xargs -I{} sh -c './totient {}; gcov totient; rm *gcda*; mv totient.c.gcov testgen/totient.c.gcov.{}'
		do
			if [ " $STDIN" = " stdin" ]; then
				echo $i | ./${FILE}		
			else 
				./${FILE} $i
			fi
			gcov ${FILE} 
			echo $i
			ls
			mv ${FILE}.c.gcov testgen/${FILE}.c.gcov.$i
			rm *gcda*		
		done 
	elif [ " $OP" = " char" ]; then
		for i in `seq 0 25`; #A to Z and a to z
		do
			sa=$(echo a | tr $(printf %${i}s | tr ' ' '.' | tac)\a-z a-za-z)#atoz
			LA=$(echo A | tr $(printf %${i}s | tr ' ' '.' | tac)\A-Z A-ZA-Z)#AtoZ
			if [ ${STDIN} = "stdin" ]; then
				echo $LA | ./${FILE}	
				echo $i
				echo $LA
			else 
				./${FILE} $LA
			fi
			gcov ${FILE} 
			mv ${FILE}.c.gcov testgen/${FILE}.c.gcov.$LA
			rm *gcda*		
		done 
		echo ${OPS}
	#elif [[ ${OP} =~ .txt ]]; then
	fi
fi


#最少スイートを自動でプログラムに適用し，コードカバレッジ計測
RESULT=`python set_cover_delete.py ${FILE}.c`
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
