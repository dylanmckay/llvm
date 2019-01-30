; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare { i8, i32 } @llvm.x86.addcarry.32(i8, i32, i32)
declare { i8, i64 } @llvm.x86.addcarry.64(i8, i64, i64)

define i32 @no_carryin_i32(i32 %x, i32 %y, i8* %p) {
; CHECK-LABEL: @no_carryin_i32(
; CHECK-NEXT:    [[S:%.*]] = call { i8, i32 } @llvm.x86.addcarry.32(i8 0, i32 [[X:%.*]], i32 [[Y:%.*]])
; CHECK-NEXT:    [[OV:%.*]] = extractvalue { i8, i32 } [[S]], 0
; CHECK-NEXT:    store i8 [[OV]], i8* [[P:%.*]], align 1
; CHECK-NEXT:    [[R:%.*]] = extractvalue { i8, i32 } [[S]], 1
; CHECK-NEXT:    ret i32 [[R]]
;
  %s = call { i8, i32 } @llvm.x86.addcarry.32(i8 0, i32 %x, i32 %y)
  %ov = extractvalue { i8, i32 } %s, 0
  store i8 %ov, i8* %p
  %r = extractvalue { i8, i32 } %s, 1
  ret i32 %r
}

define i64 @no_carryin_i64(i64 %x, i64 %y, i8* %p) {
; CHECK-LABEL: @no_carryin_i64(
; CHECK-NEXT:    [[S:%.*]] = call { i8, i64 } @llvm.x86.addcarry.64(i8 0, i64 [[X:%.*]], i64 [[Y:%.*]])
; CHECK-NEXT:    [[OV:%.*]] = extractvalue { i8, i64 } [[S]], 0
; CHECK-NEXT:    store i8 [[OV]], i8* [[P:%.*]], align 1
; CHECK-NEXT:    [[R:%.*]] = extractvalue { i8, i64 } [[S]], 1
; CHECK-NEXT:    ret i64 [[R]]
;
  %s = call { i8, i64 } @llvm.x86.addcarry.64(i8 0, i64 %x, i64 %y)
  %ov = extractvalue { i8, i64 } %s, 0
  store i8 %ov, i8* %p
  %r = extractvalue { i8, i64 } %s, 1
  ret i64 %r
}

