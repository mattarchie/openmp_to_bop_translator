#===- runtime/Makefile -------------------------*- Makefile -*-===##

# Relative path to the top of the source tree.
#
LEVEL=..

#LLVM_BIN_DIR=/u/cs255/build-llvm-38/bin
CLANG_BIN_DIR=/u/cs255/build-llvm-38/bin
LLVM_BIN_DIR=/u/cs255/dc_llvm/build/bin

OPT= $(LLVM_BIN_DIR)/opt
LLC= $(LLVM_BIN_DIR)/llc
CC= $(CLANG_BIN_DIR)/clang

check: test.c
	$(CC) -O0 -fopenmp -I/u/marchiba/openmp/build/runtime/src -I/u/marchiba/cbop/ -I/u/marchiba/cbop/ipa -c -emit-llvm test.c -o test.bc
	$(OPT) -load ../Debug+Asserts/lib/libLLVMOpenMPtoBOP.so -openmp-to-bop <test.bc> test.bc.opt
	$(LLC) -filetype=obj test.bc.opt -o test.o
	$(CC) test.o -o test
# ../Debug+Asserts/lib/libOpenMPtoBOP_rt.a

clean:
	rm -f *.bc *.opt *.o test

