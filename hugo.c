#include<stdio.h>

int main(){
	int num;
	printf("値を入力してください:");
	scanf("%d",&num);

	if(num<0){
		printf("負の値です\n");
	}else if(num == 0){
		printf("0です");
	}else if(num>0){
		printf("正の値です\n");
	}
	return 0;
}
