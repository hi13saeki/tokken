unsigned phi(unsigned x)
{
    unsigned d, t;

    t = x;
    if (x % 2 == 0) {
        t /= 2;
        do {  x /= 2;  } while (x % 2 == 0);
    }
    d = 3;
    while (x / d >= d) {
        if (x % d == 0) {
            t = t / d * (d - 1);
            do {  x /= d;  } while (x % d == 0);
        }
        d += 2;
    }
    if (x > 1) t = t / x * (x - 1);
    return t;
}
#include <stdio.h>
#include <stdlib.h>

void cant(){
	printf("表示できません\n");
	printf("Hello,World!\n");
}

int main(int argc, char *argv[])
{
    int i;
	scanf("%d",&i);
	if(i!=0){
    	printf("オイラーの関数 φ(%d)\n     ",i);
		printf("%5d\n", phi(i));
	}else if(i==0){
		cant();
	}
    return 0;
}
