#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#define HASHSIZE  8191
clock_t start,end;
void win(){ 
	printf("win\n"); exit(0);
}
void lose(){ 
	printf("lose\n"); exit(1);
}

int hash(char *key) {
    int i,v = 0;
    for (i = 0; key[i]!='\0'; i++) {
        v = (v * 256 + key[i]) % HASHSIZE;
    }
    return v;
}

int main(void) {
    int m=0;
    char word[100];
    scanf("%s",word);
    printf("HASHSIZE = %d\n", HASHSIZE);
	printf("%2d\n", hash(word));
	m = hash(word);
	if(m==566){
	    win();	//2909
	}else if(m==565){
		printf("ok");
	}else{
		lose();
	}
	return 0;
}
