#include<stdio.h>

void ok(){
	printf("ok\n");
}
int main(void){
	int da,db,kasan;
	printf("実数daを入力してください:");
	scanf("%d",&da);
	printf("実数dbを入力してください:");
	scanf("%d",&db);
	printf("da + db:    %d\n",da+db);
	printf("da - db:    %d\n",da-db);
	printf("da * db:    %d\n",da*db);
	if(db != 0){
		printf("da / db:    %d\n",da/db);
	}else if (db == 0){
		printf("計算できません\n");
	}
    if(da==10){
		ok();
	}
	return 0;
}
