#include <stdio.h>
#include "omp.h"

int main(int argc, char ** argv){
    int n = 5;
    omp_set_num_threads(n);
	int i;
	#pragma omp parallel for private(i)
	for(i=20/5*(omp_get_thread_num()-1); i < 20/5*omp_get_thread_num(); i++){
		printf("%d: %d\n",omp_get_thread_num(), i);
	}

	return 0;
}
