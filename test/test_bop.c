#include <stdio.h>
#include "bop_api.h"

int main(int argc, char ** argv){
    int n = 5;
	int i;
    for(int j=1; j <= 5; j++){
        BOP_ppr_begin(1);
        for(i=20/5*(j-1); i < 20/5*j; i++){
            printf("%d: %d\n",j, i);
        }
        BOP_ppr_end(1);
    }
	return 0;
}
