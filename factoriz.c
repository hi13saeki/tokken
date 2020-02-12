#include <stdio.h>
#include <stdlib.h>
void win() { puts("win!");}
void lose() { puts("lose");}

void check(int x) {
	int d, q;
	while (x >= 4 && x % 2 == 0) {
		x /= 2;
	}
	d = 3;
	q = x / d;
	while (q >= d) {
		if (x % d == 0) {
			if(d == 5) {win(); return;}
			x = q;
		} else d += 2;
		q = x / d;
	}
	lose();
}

int main(int argc, char *argv[]) {
	int i;
	scanf("%d", &i);
	check(i);
	return 0;
}
