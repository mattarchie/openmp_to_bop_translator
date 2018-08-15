#include <stdio.h>
#include <stdlib.h>

int loops_found;

void increase(){ // TODO adjust this to do something useful
	loops_found++;
}

void print_loops(){
	printf("Number of loops: %d\n\n",loops_found);
/*	printf("Dominance relations: %s\n\n",dom_map); // TODO
	printf("Back edges: %s\n\n",back_edges); // TODO
	for(int i=0; i<loops_found; ++i)
	    printf("Basic blocks in loop %d: %s\n\n",i,blocks[i]); // TODO
 */}

void init(){ //TODO change this
	loops_found=0;
	/* other variables? */
	atexit(print_loops);
}
