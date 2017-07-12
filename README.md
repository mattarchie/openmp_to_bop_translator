# safeopenmp
BOP-based implementation of OpenMP for LLVM

This is a wrapper/translation layer for BOP to implement OpenMP annotated code. The purpose is to provide OpenMP coders a way to safely run their code without worrying about the accuracy of their OpenMP annotations or how the resulting parallelism affects their code. This means that SafeOpenMP provides programs a way to verify their algorithms without having to change their code at all.

At this point, this SafeOpenMP repo will not include BOP or OpenMP code. As, this code translates the resulting OpenMP code into BOP code, rather than interpreting the #pragma annotations itself, both BOP and OpenMP must be installed and used during compilation to successfully use SafeOpenMP. If possible, the flag for compiling with SafeOpenMP will eventually be enough to manually include and it will automagically include the OpenMP and BOP compilation flags for the programmer.
