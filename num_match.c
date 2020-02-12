#include<stdio.h>

int main(){
	int a,b,c;
	printf("aの値を入力してください：");
	scanf("%d",&a);
	printf("bの値を入力してください：");
	scanf("%d",&b);
	printf("cの値を入力してください：");
	scanf("%d",&c);

	if(a==b && b==c){
		printf("全て等しい値です。\n");
	}else if(a==b || b==c || a==c){
		printf("値が等しい組が1つあります。\n");
	}else if(a!=b && b!=c && a!=c){
		printf("すべて異なる値です。\n");
	}

	return 0;
}
