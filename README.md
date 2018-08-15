# openmp\_to\_bop\_translater
BOP-based implementation of OpenMP for LLVM

This is a translation layer for BOP to implement OpenMP annotated code. The purpose is to provide OpenMP coders a way to safely run their code without worrying about the accuracy of their OpenMP annotations or how the resulting parallelism affects their code. This means that the translator provides programs a way to verify their algorithms without having to change their code.

Note that this code has the following limitations:
- 0 or 1 shared variables in an omp parallel section
  - in the case of 1, the BOP read and write functions have not yet been added
- omp\_set\_num\_threads is required
  - this is how BOP knows how many times to attempt the PPR
- omp\_get\_thread\_num is currently replaced by getpid
  - this is incorrect if the thread number is used in the loop condition or loop body
  - creating the LoadInst to use the value of %.global\_tid. to replace the omp call is not yet working
- currently only 1 thread can be used because the outer loop that is necessary for BOP to attempt the same number of PPRs as OpenMP threads is not in place
  - the following is the list of instructions that need to be in place:
    - %x = alloca i32
    - load 1, %x
    - :loop\_cond
    - %b = sle %x, %num\_threads
    - br %b, :loop\_body, :end
    - :loop\_body
    - call BOP\_ppr\_begin(i32)
    - call OpenMP generated function with parallel region
    - call BOP\_ppr\_begin(i32)
    - %n = add %x, 1
    - store %n, %x
    - br :loop\_cond

See test/ dir for test code and llvm outputs. test.c is the same as test\_omp.c, but test.c is what is used in make check that outputs the results of the -openmp-to-bop pass (which was redirected to test\_translator.out). test\_omp.ll and test\_bop.ll contain the LLVM IR for their respective source files.
