; RUN: opt -S -mtriple=avr -latesimplifycfg < %s | FileCheck %s

target datalayout = "e-p:16:16:16-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-n8-P1"

; Switch lookup tables should be placed in program memory (address space 1).

%MyType = type { i8, [0 x i8], [0 x i8] }

define i8 @foo(i8 %arg) {
start:
  %_0 = alloca %MyType

; CHECK: @switch.table.foo = {{.*}}addrspace(1) constant {{.*}}
  switch i8 %arg, label %bb7 [
    i8 0, label %bb1
    i8 1, label %bb2
    i8 2, label %bb3
    i8 3, label %bb4
    i8 4, label %bb5
    i8 14, label %bb6
  ]

bb1:                                              ; preds = %start
  %tmp = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 1, i8* %tmp
  br label %bb8

bb2:                                              ; preds = %start
  %tmp1 = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 1, i8* %tmp1
  br label %bb8

bb3:                                              ; preds = %start
  %tmp2 = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 1, i8* %tmp2
  br label %bb8

bb4:                                              ; preds = %start
  %tmp3 = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 1, i8* %tmp3
  br label %bb8

bb5:                                              ; preds = %start
  %tmp4 = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 1, i8* %tmp4
  br label %bb8

bb6:                                              ; preds = %start
  %tmp5 = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 1, i8* %tmp5
  br label %bb8

bb7:                                              ; preds = %start
  %tmp6 = getelementptr inbounds %MyType, %MyType* %_0, i32 0, i32 0
  store i8 0, i8* %tmp6
  br label %bb8

bb8:                                              ; preds = %bb7, %bb6, %bb5, %bb4, %bb3, %bb2, %bb1
  %tmp7 = bitcast %MyType* %_0 to i8*
  %tmp8 = load i8, i8* %tmp7, align 1
  ret i8 %tmp8
}
