; ModuleID = 'test_bop.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"%d: %d\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %1, align 4
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  store i32 5, i32* %n, align 4
  store i32 1, i32* %j, align 4
  br label %4

; <label>:4                                       ; preds = %24, %0
  %5 = load i32, i32* %j, align 4
  %6 = icmp sle i32 %5, 5
  br i1 %6, label %7, label %27

; <label>:7                                       ; preds = %4
  %8 = load i32, i32* %j, align 4
  %9 = sub nsw i32 %8, 1
  %10 = mul nsw i32 4, %9
  store i32 %10, i32* %i, align 4
  br label %11

; <label>:11                                      ; preds = %20, %7
  %12 = load i32, i32* %i, align 4
  %13 = load i32, i32* %j, align 4
  %14 = mul nsw i32 4, %13
  %15 = icmp slt i32 %12, %14
  br i1 %15, label %16, label %23

; <label>:16                                      ; preds = %11
  %17 = load i32, i32* %j, align 4
  %18 = load i32, i32* %i, align 4
  %19 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i32 0, i32 0), i32 %17, i32 %18)
  br label %20

; <label>:20                                      ; preds = %16
  %21 = load i32, i32* %i, align 4
  %22 = add nsw i32 %21, 1
  store i32 %22, i32* %i, align 4
  br label %11

; <label>:23                                      ; preds = %11
  br label %24

; <label>:24                                      ; preds = %23
  %25 = load i32, i32* %j, align 4
  %26 = add nsw i32 %25, 1
  store i32 %26, i32* %j, align 4
  br label %4

; <label>:27                                      ; preds = %4
  ret i32 0
}

declare i32 @printf(i8*, ...) #1

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.0 (branches/release_38 259745) (llvm/branches/release_38 259685)"}
