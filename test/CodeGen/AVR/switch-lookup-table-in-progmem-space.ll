; RUN: opt -S -mtriple=avr -latesimplifycfg < %s | FileCheck %s

; Switch lookup tables should be placed in program memory (address space 1).

%MyType = type { i8, [0 x i8], [0 x i8] }

define i8 @foo(i8) {
start:
  %_0 = alloca %MyType

; CHECK: @switch.table.foo = {{.*}}addrspace(1) constant [15 x i8] c"\01\01\01\01\01\00\00\00\00\00\00\00\00\00\01"
  switch i8 %0, label %bb7 [
    i8 0, label %bb1
    i8 1, label %bb2
    i8 2, label %bb3
    i8 3, label %bb4
    i8 4, label %bb5
    i8 14, label %bb6
  ]

bb1:
  %1 = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 1, i8* %1
  br label %bb8

bb2:
  %2 = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 1, i8* %2
  br label %bb8

bb3:
  %3 = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 1, i8* %3
  br label %bb8

bb4:
  %4 = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 1, i8* %4
  br label %bb8

bb5:
  %5 = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 1, i8* %5
  br label %bb8

bb6:
  %6 = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 1, i8* %6
  br label %bb8

bb7:
  %7 = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 0, i8* %7
  br label %bb8

bb8:
  %8 = bitcast %MyType* %_0 to i8*
  %9 = load i8, i8* %8, align 1
  ret i8 %9
}

