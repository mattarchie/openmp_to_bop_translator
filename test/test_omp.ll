; ModuleID = 'test_omp.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%ident_t = type { i32, i32, i32, i32, i8* }

@.str = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@0 = private unnamed_addr constant %ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0) }, align 8
@.str.1 = private unnamed_addr constant [8 x i8] c"%d: %d\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %1, align 4
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  store i32 5, i32* %n, align 4
  %4 = load i32, i32* %n, align 4
  call void @omp_set_num_threads(i32 %4)
  call void (%ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%ident_t* @0, i32 0, void (i32*, i32*, ...)* bitcast (void (i32*, i32*)* @.omp_outlined. to void (i32*, i32*, ...)*))
  ret i32 0
}

declare void @omp_set_num_threads(i32) #1

; Function Attrs: nounwind uwtable
define internal void @.omp_outlined.(i32* noalias %.global_tid., i32* noalias %.bound_tid.) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32*, align 8
  %.omp.iv = alloca i32, align 4
  %.omp.last.iteration = alloca i32, align 4
  %i = alloca i32, align 4
  %.omp.lb = alloca i32, align 4
  %.omp.ub = alloca i32, align 4
  %.omp.stride = alloca i32, align 4
  %.omp.is_last = alloca i32, align 4
  %i1 = alloca i32, align 4
  %i2 = alloca i32, align 4
  store i32* %.global_tid., i32** %1, align 8
  store i32* %.bound_tid., i32** %2, align 8
  %3 = call i32 @omp_get_thread_num()
  %4 = mul nsw i32 4, %3
  %5 = call i32 @omp_get_thread_num()
  %6 = sub nsw i32 %5, 1
  %7 = mul nsw i32 4, %6
  %8 = sub nsw i32 %4, %7
  %9 = sub nsw i32 %8, 1
  %10 = add nsw i32 %9, 1
  %11 = sdiv i32 %10, 1
  %12 = sub nsw i32 %11, 1
  store i32 %12, i32* %.omp.last.iteration, align 4
  %13 = call i32 @omp_get_thread_num()
  %14 = sub nsw i32 %13, 1
  %15 = mul nsw i32 4, %14
  store i32 %15, i32* %i, align 4
  %16 = call i32 @omp_get_thread_num()
  %17 = sub nsw i32 %16, 1
  %18 = mul nsw i32 4, %17
  %19 = call i32 @omp_get_thread_num()
  %20 = mul nsw i32 4, %19
  %21 = icmp slt i32 %18, %20
  br i1 %21, label %22, label %58

; <label>:22                                      ; preds = %0
  store i32 0, i32* %.omp.lb, align 4
  %23 = load i32, i32* %.omp.last.iteration, align 4
  store i32 %23, i32* %.omp.ub, align 4
  store i32 1, i32* %.omp.stride, align 4
  store i32 0, i32* %.omp.is_last, align 4
  %24 = load i32*, i32** %1, align 8
  %25 = load i32, i32* %24, align 4
  call void @__kmpc_for_static_init_4(%ident_t* @0, i32 %25, i32 34, i32* %.omp.is_last, i32* %.omp.lb, i32* %.omp.ub, i32* %.omp.stride, i32 1, i32 1)
  %26 = load i32, i32* %.omp.ub, align 4
  %27 = load i32, i32* %.omp.last.iteration, align 4
  %28 = icmp sgt i32 %26, %27
  br i1 %28, label %29, label %31

; <label>:29                                      ; preds = %22
  %30 = load i32, i32* %.omp.last.iteration, align 4
  br label %33

; <label>:31                                      ; preds = %22
  %32 = load i32, i32* %.omp.ub, align 4
  br label %33

; <label>:33                                      ; preds = %31, %29
  %34 = phi i32 [ %30, %29 ], [ %32, %31 ]
  store i32 %34, i32* %.omp.ub, align 4
  %35 = load i32, i32* %.omp.lb, align 4
  store i32 %35, i32* %.omp.iv, align 4
  br label %36

; <label>:36                                      ; preds = %51, %33
  %37 = load i32, i32* %.omp.iv, align 4
  %38 = load i32, i32* %.omp.ub, align 4
  %39 = icmp sle i32 %37, %38
  br i1 %39, label %40, label %54

; <label>:40                                      ; preds = %36
  %41 = call i32 @omp_get_thread_num()
  %42 = sub nsw i32 %41, 1
  %43 = mul nsw i32 4, %42
  %44 = load i32, i32* %.omp.iv, align 4
  %45 = mul nsw i32 %44, 1
  %46 = add nsw i32 %43, %45
  store i32 %46, i32* %i1, align 4
  %47 = call i32 @omp_get_thread_num()
  %48 = load i32, i32* %i1, align 4
  %49 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.1, i32 0, i32 0), i32 %47, i32 %48)
  br label %50

; <label>:50                                      ; preds = %40
  br label %51

; <label>:51                                      ; preds = %50
  %52 = load i32, i32* %.omp.iv, align 4
  %53 = add nsw i32 %52, 1
  store i32 %53, i32* %.omp.iv, align 4
  br label %36

; <label>:54                                      ; preds = %36
  br label %55

; <label>:55                                      ; preds = %54
  %56 = load i32*, i32** %1, align 8
  %57 = load i32, i32* %56, align 4
  call void @__kmpc_for_static_fini(%ident_t* @0, i32 %57)
  br label %58

; <label>:58                                      ; preds = %55, %0
  ret void
}

declare i32 @omp_get_thread_num() #1

declare void @__kmpc_for_static_init_4(%ident_t*, i32, i32, i32*, i32*, i32*, i32*, i32, i32)

declare i32 @printf(i8*, ...) #1

declare void @__kmpc_for_static_fini(%ident_t*, i32)

declare void @__kmpc_fork_call(%ident_t*, i32, void (i32*, i32*, ...)*, ...)

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.0 (branches/release_38 259745) (llvm/branches/release_38 259685)"}
