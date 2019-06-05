; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -early-cse | FileCheck %s
; RUN: opt < %s -S -basicaa -early-cse-memssa | FileCheck %s

define void @test1(float %A, float %B, float* %PA, float* %PB) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[C:%.*]] = fadd float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store float [[C]], float* [[PA:%.*]]
; CHECK-NEXT:    store float [[C]], float* [[PB:%.*]]
; CHECK-NEXT:    ret void
;
  %C = fadd float %A, %B
  store float %C, float* %PA
  %D = fadd float %B, %A
  store float %D, float* %PB
  ret void
}

define void @test2(float %A, float %B, i1* %PA, i1* %PB) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[C:%.*]] = fcmp oeq float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store i1 [[C]], i1* [[PA:%.*]]
; CHECK-NEXT:    store i1 [[C]], i1* [[PB:%.*]]
; CHECK-NEXT:    ret void
;
  %C = fcmp oeq float %A, %B
  store i1 %C, i1* %PA
  %D = fcmp oeq float %B, %A
  store i1 %D, i1* %PB
  ret void
}

define void @test3(float %A, float %B, i1* %PA, i1* %PB) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[C:%.*]] = fcmp uge float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store i1 [[C]], i1* [[PA:%.*]]
; CHECK-NEXT:    store i1 [[C]], i1* [[PB:%.*]]
; CHECK-NEXT:    ret void
;
  %C = fcmp uge float %A, %B
  store i1 %C, i1* %PA
  %D = fcmp ule float %B, %A
  store i1 %D, i1* %PB
  ret void
}

define void @test4(i32 %A, i32 %B, i1* %PA, i1* %PB) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[C:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store i1 [[C]], i1* [[PA:%.*]]
; CHECK-NEXT:    store i1 [[C]], i1* [[PB:%.*]]
; CHECK-NEXT:    ret void
;
  %C = icmp eq i32 %A, %B
  store i1 %C, i1* %PA
  %D = icmp eq i32 %B, %A
  store i1 %D, i1* %PB
  ret void
}

define void @test5(i32 %A, i32 %B, i1* %PA, i1* %PB) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store i1 [[C]], i1* [[PA:%.*]]
; CHECK-NEXT:    store i1 [[C]], i1* [[PB:%.*]]
; CHECK-NEXT:    ret void
;
  %C = icmp sgt i32 %A, %B
  store i1 %C, i1* %PA
  %D = icmp slt i32 %B, %A
  store i1 %D, i1* %PB
  ret void
}

; Min/max operands may be commuted in the compare and select.

define i8 @smin_commute(i8 %a, i8 %b) {
; CHECK-LABEL: @smin_commute(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i8 [[B]], [[A]]
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[B]]
; CHECK-NEXT:    [[R:%.*]] = mul i8 [[M1]], [[M1]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp slt i8 %b, %a
  %m1 = select i1 %cmp1, i8 %a, i8 %b
  %m2 = select i1 %cmp2, i8 %b, i8 %a
  %r = mul i8 %m1, %m2
  ret i8 %r
}

; Min/max can also have a swapped predicate and select operands.

define i1 @smin_swapped(i8 %a, i8 %b) {
; CHECK-LABEL: @smin_swapped(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i8 [[A]], [[B]]
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[B]], i8 [[A]]
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp sgt i8 %a, %b
  %cmp2 = icmp slt i8 %a, %b
  %m1 = select i1 %cmp1, i8 %b, i8 %a
  %m2 = select i1 %cmp2, i8 %a, i8 %b
  %r = icmp eq i8 %m2, %m1
  ret i1 %r
}

; Min/max can also have an inverted predicate and select operands.
; TODO: Ensure we always recognize this (currently depends on hash collision)

define i1 @smin_inverted(i8 %a, i8 %b) {
; CHECK-LABEL: @smin_inverted(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = xor i1 [[CMP1]], true
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[B]]
; CHECK:         ret i1
;
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = xor i1 %cmp1, -1
  %m1 = select i1 %cmp1, i8 %a, i8 %b
  %m2 = select i1 %cmp2, i8 %b, i8 %a
  %r = icmp eq i8 %m1, %m2
  ret i1 %r
}

define i8 @smax_commute(i8 %a, i8 %b) {
; CHECK-LABEL: @smax_commute(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i8 [[B]], [[A]]
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[B]]
; CHECK-NEXT:    ret i8 0
;
  %cmp1 = icmp sgt i8 %a, %b
  %cmp2 = icmp sgt i8 %b, %a
  %m1 = select i1 %cmp1, i8 %a, i8 %b
  %m2 = select i1 %cmp2, i8 %b, i8 %a
  %r = urem i8 %m2, %m1
  ret i8 %r
}

define i8 @smax_swapped(i8 %a, i8 %b) {
; CHECK-LABEL: @smax_swapped(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i8 [[A]], [[B]]
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[B]], i8 [[A]]
; CHECK-NEXT:    ret i8 1
;
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp sgt i8 %a, %b
  %m1 = select i1 %cmp1, i8 %b, i8 %a
  %m2 = select i1 %cmp2, i8 %a, i8 %b
  %r = sdiv i8 %m1, %m2
  ret i8 %r
}

; TODO: Ensure we always recognize this (currently depends on hash collision)
define i1 @smax_inverted(i8 %a, i8 %b) {
; CHECK-LABEL: @smax_inverted(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = xor i1 [[CMP1]], true
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[B]]
; CHECK:         ret i1
;
  %cmp1 = icmp sgt i8 %a, %b
  %cmp2 = xor i1 %cmp1, -1
  %m1 = select i1 %cmp1, i8 %a, i8 %b
  %m2 = select i1 %cmp2, i8 %b, i8 %a
  %r = icmp eq i8 %m1, %m2
  ret i1 %r
}

define i8 @umin_commute(i8 %a, i8 %b) {
; CHECK-LABEL: @umin_commute(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i8 [[B]], [[A]]
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[B]]
; CHECK-NEXT:    ret i8 0
;
  %cmp1 = icmp ult i8 %a, %b
  %cmp2 = icmp ult i8 %b, %a
  %m1 = select i1 %cmp1, i8 %a, i8 %b
  %m2 = select i1 %cmp2, i8 %b, i8 %a
  %r = sub i8 %m2, %m1
  ret i8 %r
}

; Choose a vector type just to show that works.

define <2 x i8> @umin_swapped(<2 x i8> %a, <2 x i8> %b) {
; CHECK-LABEL: @umin_swapped(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt <2 x i8> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult <2 x i8> [[A]], [[B]]
; CHECK-NEXT:    [[M1:%.*]] = select <2 x i1> [[CMP1]], <2 x i8> [[B]], <2 x i8> [[A]]
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %cmp1 = icmp ugt <2 x i8> %a, %b
  %cmp2 = icmp ult <2 x i8> %a, %b
  %m1 = select <2 x i1> %cmp1, <2 x i8> %b, <2 x i8> %a
  %m2 = select <2 x i1> %cmp2, <2 x i8> %a, <2 x i8> %b
  %r = sub <2 x i8> %m2, %m1
  ret <2 x i8> %r
}

; TODO: Ensure we always recognize this (currently depends on hash collision)
define i1 @umin_inverted(i8 %a, i8 %b) {
; CHECK-LABEL: @umin_inverted(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = xor i1 [[CMP1]], true
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[B]]
; CHECK:         ret i1
;
  %cmp1 = icmp ult i8 %a, %b
  %cmp2 = xor i1 %cmp1, -1
  %m1 = select i1 %cmp1, i8 %a, i8 %b
  %m2 = select i1 %cmp2, i8 %b, i8 %a
  %r = icmp eq i8 %m1, %m2
  ret i1 %r
}

define i8 @umax_commute(i8 %a, i8 %b) {
; CHECK-LABEL: @umax_commute(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i8 [[B]], [[A]]
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[B]]
; CHECK-NEXT:    ret i8 1
;
  %cmp1 = icmp ugt i8 %a, %b
  %cmp2 = icmp ugt i8 %b, %a
  %m1 = select i1 %cmp1, i8 %a, i8 %b
  %m2 = select i1 %cmp2, i8 %b, i8 %a
  %r = udiv i8 %m1, %m2
  ret i8 %r
}

define i8 @umax_swapped(i8 %a, i8 %b) {
; CHECK-LABEL: @umax_swapped(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i8 [[A]], [[B]]
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[B]], i8 [[A]]
; CHECK-NEXT:    [[R:%.*]] = add i8 [[M1]], [[M1]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %cmp1 = icmp ult i8 %a, %b
  %cmp2 = icmp ugt i8 %a, %b
  %m1 = select i1 %cmp1, i8 %b, i8 %a
  %m2 = select i1 %cmp2, i8 %a, i8 %b
  %r = add i8 %m2, %m1
  ret i8 %r
}

; TODO: Ensure we always recognize this (currently depends on hash collision)
define i1 @umax_inverted(i8 %a, i8 %b) {
; CHECK-LABEL: @umax_inverted(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = xor i1 [[CMP1]], true
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[B]]
; CHECK:         ret i1
;
  %cmp1 = icmp ugt i8 %a, %b
  %cmp2 = xor i1 %cmp1, -1
  %m1 = select i1 %cmp1, i8 %a, i8 %b
  %m2 = select i1 %cmp2, i8 %b, i8 %a
  %r = icmp eq i8 %m1, %m2
  ret i1 %r
}

; Min/max may exist with non-canonical operands. Value tracking can match those.

define i8 @smax_nsw(i8 %a, i8 %b) {
; CHECK-LABEL: @smax_nsw(
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i8 [[A]], [[B]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i8 [[SUB]], 0
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 0, i8 [[SUB]]
; CHECK-NEXT:    ret i8 0
;
  %sub = sub nsw i8 %a, %b
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp sgt i8 %sub, 0
  %m1 = select i1 %cmp1, i8 0, i8 %sub
  %m2 = select i1 %cmp2, i8 %sub, i8 0
  %r = sub i8 %m2, %m1
  ret i8 %r
}

define i8 @abs_swapped(i8 %a) {
; CHECK-LABEL: @abs_swapped(
; CHECK-NEXT:    [[NEG:%.*]] = sub i8 0, [[A:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i8 [[A]], 0
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i8 [[A]], 0
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[NEG]]
; CHECK-NEXT:    ret i8 [[M1]]
;
  %neg = sub i8 0, %a
  %cmp1 = icmp sgt i8 %a, 0
  %cmp2 = icmp slt i8 %a, 0
  %m1 = select i1 %cmp1, i8 %a, i8 %neg
  %m2 = select i1 %cmp2, i8 %neg, i8 %a
  %r = or i8 %m2, %m1
  ret i8 %r
}

; TODO: Ensure we always recognize this (currently depends on hash collision)
define i8 @abs_inverted(i8 %a) {
; CHECK-LABEL: @abs_inverted(
; CHECK-NEXT:    [[NEG:%.*]] = sub i8 0, [[A:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i8 [[A]], 0
; CHECK-NEXT:    [[CMP2:%.*]] = xor i1 [[CMP1]], true
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[NEG]]
; CHECK:         ret i8
;
  %neg = sub i8 0, %a
  %cmp1 = icmp sgt i8 %a, 0
  %cmp2 = xor i1 %cmp1, -1
  %m1 = select i1 %cmp1, i8 %a, i8 %neg
  %m2 = select i1 %cmp2, i8 %neg, i8 %a
  %r = or i8 %m2, %m1
  ret i8 %r
}

define i8 @nabs_swapped(i8 %a) {
; CHECK-LABEL: @nabs_swapped(
; CHECK-NEXT:    [[NEG:%.*]] = sub i8 0, [[A:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i8 [[A]], 0
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i8 [[A]], 0
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[NEG]]
; CHECK-NEXT:    ret i8 0
;
  %neg = sub i8 0, %a
  %cmp1 = icmp slt i8 %a, 0
  %cmp2 = icmp sgt i8 %a, 0
  %m1 = select i1 %cmp1, i8 %a, i8 %neg
  %m2 = select i1 %cmp2, i8 %neg, i8 %a
  %r = xor i8 %m2, %m1
  ret i8 %r
}

; TODO: Ensure we always recognize this (currently depends on hash collision)
define i8 @nabs_inverted(i8 %a) {
; CHECK-LABEL: @nabs_inverted(
; CHECK-NEXT:    [[NEG:%.*]] = sub i8 0, [[A:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i8 [[A]], 0
; CHECK-NEXT:    [[CMP2:%.*]] = xor i1 [[CMP1]], true
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[NEG]]
; CHECK:         ret i8
;
  %neg = sub i8 0, %a
  %cmp1 = icmp slt i8 %a, 0
  %cmp2 = xor i1 %cmp1, -1
  %m1 = select i1 %cmp1, i8 %a, i8 %neg
  %m2 = select i1 %cmp2, i8 %neg, i8 %a
  %r = xor i8 %m2, %m1
  ret i8 %r
}

; These two tests make sure we still consider it a match when the RHS of the
; compares are different.
define i8 @abs_different_constants(i8 %a) {
; CHECK-LABEL: @abs_different_constants(
; CHECK-NEXT:    [[NEG:%.*]] = sub i8 0, [[A:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i8 [[A]], -1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i8 [[A]], 0
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[NEG]]
; CHECK-NEXT:    ret i8 [[M1]]
;
  %neg = sub i8 0, %a
  %cmp1 = icmp sgt i8 %a, -1
  %cmp2 = icmp slt i8 %a, 0
  %m1 = select i1 %cmp1, i8 %a, i8 %neg
  %m2 = select i1 %cmp2, i8 %neg, i8 %a
  %r = or i8 %m2, %m1
  ret i8 %r
}

define i8 @nabs_different_constants(i8 %a) {
; CHECK-LABEL: @nabs_different_constants(
; CHECK-NEXT:    [[NEG:%.*]] = sub i8 0, [[A:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i8 [[A]], 0
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i8 [[A]], -1
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[CMP1]], i8 [[A]], i8 [[NEG]]
; CHECK-NEXT:    ret i8 0
;
  %neg = sub i8 0, %a
  %cmp1 = icmp slt i8 %a, 0
  %cmp2 = icmp sgt i8 %a, -1
  %m1 = select i1 %cmp1, i8 %a, i8 %neg
  %m2 = select i1 %cmp2, i8 %neg, i8 %a
  %r = xor i8 %m2, %m1
  ret i8 %r
}

; https://bugs.llvm.org/show_bug.cgi?id=41101
; Detect equivalence of selects with commuted operands: 'not' cond.

define i32 @select_not_cond(i1 %cond, i32 %t, i32 %f) {
; CHECK-LABEL: @select_not_cond(
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[COND:%.*]], true
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[COND]], i32 [[T:%.*]], i32 [[F:%.*]]
; CHECK-NEXT:    ret i32 0
;
  %not = xor i1 %cond, -1
  %m1 = select i1 %cond, i32 %t, i32 %f
  %m2 = select i1 %not, i32 %f, i32 %t
  %r = xor i32 %m2, %m1
  ret i32 %r
}

; Detect equivalence of selects with commuted operands: 'not' cond with vector select.

define <2 x double> @select_not_cond_commute_vec(<2 x i1> %cond, <2 x double> %t, <2 x double> %f) {
; CHECK-LABEL: @select_not_cond_commute_vec(
; CHECK-NEXT:    [[NOT:%.*]] = xor <2 x i1> [[COND:%.*]], <i1 true, i1 true>
; CHECK-NEXT:    [[M1:%.*]] = select <2 x i1> [[COND]], <2 x double> [[T:%.*]], <2 x double> [[F:%.*]]
; CHECK-NEXT:    ret <2 x double> <double 1.000000e+00, double 1.000000e+00>
;
  %not = xor <2 x i1> %cond, <i1 -1, i1 -1>
  %m1 = select <2 x i1> %cond, <2 x double> %t, <2 x double> %f
  %m2 = select <2 x i1> %not, <2 x double> %f, <2 x double> %t
  %r = fdiv nnan <2 x double> %m1, %m2
  ret <2 x double> %r
}

; Negative test - select ops must be commuted.

define i32 @select_not_cond_wrong_select_ops(i1 %cond, i32 %t, i32 %f) {
; CHECK-LABEL: @select_not_cond_wrong_select_ops(
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[COND:%.*]], true
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[COND]], i32 [[T:%.*]], i32 [[F:%.*]]
; CHECK-NEXT:    [[M2:%.*]] = select i1 [[NOT]], i32 [[T]], i32 [[F]]
; CHECK-NEXT:    [[R:%.*]] = xor i32 [[M2]], [[M1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %not = xor i1 %cond, -1
  %m1 = select i1 %cond, i32 %t, i32 %f
  %m2 = select i1 %not, i32 %t, i32 %f
  %r = xor i32 %m2, %m1
  ret i32 %r
}

; Negative test - not a 'not'.

define i32 @select_not_cond_wrong_cond(i1 %cond, i32 %t, i32 %f) {
; CHECK-LABEL: @select_not_cond_wrong_cond(
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[COND:%.*]], i32 [[T:%.*]], i32 [[F:%.*]]
; CHECK-NEXT:    [[M2:%.*]] = select i1 [[COND]], i32 [[F]], i32 [[T]]
; CHECK-NEXT:    [[R:%.*]] = xor i32 [[M2]], [[M1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %not = xor i1 %cond, -2
  %m1 = select i1 %cond, i32 %t, i32 %f
  %m2 = select i1 %not, i32 %f, i32 %t
  %r = xor i32 %m2, %m1
  ret i32 %r
}

; Detect equivalence of selects with commuted operands: inverted pred with fcmps.

define i32 @select_invert_pred_cond(float %x, i32 %t, i32 %f) {
; CHECK-LABEL: @select_invert_pred_cond(
; CHECK-NEXT:    [[COND:%.*]] = fcmp ueq float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    [[INVCOND:%.*]] = fcmp one float [[X]], 4.200000e+01
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[COND]], i32 [[T:%.*]], i32 [[F:%.*]]
; CHECK-NEXT:    ret i32 0
;
  %cond = fcmp ueq float %x, 42.0
  %invcond = fcmp one float %x, 42.0
  %m1 = select i1 %cond, i32 %t, i32 %f
  %m2 = select i1 %invcond, i32 %f, i32 %t
  %r = xor i32 %m2, %m1
  ret i32 %r
}

; Detect equivalence of selects with commuted operands: inverted pred with icmps and vectors.

define <2 x i32> @select_invert_pred_cond_commute_vec(<2 x i8> %x, <2 x i32> %t, <2 x i32> %f) {
; CHECK-LABEL: @select_invert_pred_cond_commute_vec(
; CHECK-NEXT:    [[COND:%.*]] = icmp sgt <2 x i8> [[X:%.*]], <i8 42, i8 -1>
; CHECK-NEXT:    [[INVCOND:%.*]] = icmp sle <2 x i8> [[X]], <i8 42, i8 -1>
; CHECK-NEXT:    [[M1:%.*]] = select <2 x i1> [[COND]], <2 x i32> [[T:%.*]], <2 x i32> [[F:%.*]]
; CHECK-NEXT:    ret <2 x i32> zeroinitializer
;
  %cond = icmp sgt <2 x i8> %x, <i8 42, i8 -1>
  %invcond = icmp sle <2 x i8> %x, <i8 42, i8 -1>
  %m1 = select <2 x i1> %cond, <2 x i32> %t, <2 x i32> %f
  %m2 = select <2 x i1> %invcond, <2 x i32> %f, <2 x i32> %t
  %r = xor <2 x i32> %m1, %m2
  ret <2 x i32> %r
}

; Negative test - select ops must be commuted.

define i32 @select_invert_pred_wrong_select_ops(float %x, i32 %t, i32 %f) {
; CHECK-LABEL: @select_invert_pred_wrong_select_ops(
; CHECK-NEXT:    [[COND:%.*]] = fcmp ueq float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    [[INVCOND:%.*]] = fcmp one float [[X]], 4.200000e+01
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[COND]], i32 [[F:%.*]], i32 [[T:%.*]]
; CHECK-NEXT:    [[M2:%.*]] = select i1 [[INVCOND]], i32 [[F]], i32 [[T]]
; CHECK-NEXT:    [[R:%.*]] = xor i32 [[M2]], [[M1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %cond = fcmp ueq float %x, 42.0
  %invcond = fcmp one float %x, 42.0
  %m1 = select i1 %cond, i32 %f, i32 %t
  %m2 = select i1 %invcond, i32 %f, i32 %t
  %r = xor i32 %m2, %m1
  ret i32 %r
}

; Negative test - not an inverted predicate.

define i32 @select_invert_pred_wrong_cond(float %x, i32 %t, i32 %f) {
; CHECK-LABEL: @select_invert_pred_wrong_cond(
; CHECK-NEXT:    [[COND:%.*]] = fcmp ueq float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    [[INVCOND:%.*]] = fcmp une float [[X]], 4.200000e+01
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[COND]], i32 [[T:%.*]], i32 [[F:%.*]]
; CHECK-NEXT:    [[M2:%.*]] = select i1 [[INVCOND]], i32 [[F]], i32 [[T]]
; CHECK-NEXT:    [[R:%.*]] = xor i32 [[M2]], [[M1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %cond = fcmp ueq float %x, 42.0
  %invcond = fcmp une float %x, 42.0
  %m1 = select i1 %cond, i32 %t, i32 %f
  %m2 = select i1 %invcond, i32 %f, i32 %t
  %r = xor i32 %m2, %m1
  ret i32 %r
}

; Negative test - cmp ops must match.

define i32 @select_invert_pred_wrong_cmp_ops(float %x, i32 %t, i32 %f) {
; CHECK-LABEL: @select_invert_pred_wrong_cmp_ops(
; CHECK-NEXT:    [[COND:%.*]] = fcmp ueq float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    [[INVCOND:%.*]] = fcmp one float [[X]], 4.300000e+01
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[COND]], i32 [[T:%.*]], i32 [[F:%.*]]
; CHECK-NEXT:    [[M2:%.*]] = select i1 [[INVCOND]], i32 [[F]], i32 [[T]]
; CHECK-NEXT:    [[R:%.*]] = xor i32 [[M2]], [[M1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %cond = fcmp ueq float %x, 42.0
  %invcond = fcmp one float %x, 43.0
  %m1 = select i1 %cond, i32 %t, i32 %f
  %m2 = select i1 %invcond, i32 %f, i32 %t
  %r = xor i32 %m2, %m1
  ret i32 %r
}

; If we have both an inverted predicate and a 'not' op, recognize the double-negation.

define i32 @select_not_invert_pred_cond(i8 %x, i32 %t, i32 %f) {
; CHECK-LABEL: @select_not_invert_pred_cond(
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i8 [[X:%.*]], 42
; CHECK-NEXT:    [[INVCOND:%.*]] = icmp ule i8 [[X]], 42
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[INVCOND]], true
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[COND]], i32 [[T:%.*]], i32 [[F:%.*]]
; CHECK-NEXT:    ret i32 0
;
  %cond = icmp ugt i8 %x, 42
  %invcond = icmp ule i8 %x, 42
  %not = xor i1 %invcond, -1
  %m1 = select i1 %cond, i32 %t, i32 %f
  %m2 = select i1 %not, i32 %t, i32 %f
  %r = sub i32 %m1, %m2
  ret i32 %r
}

; If we have both an inverted predicate and a 'not' op, recognize the double-negation.

define i32 @select_not_invert_pred_cond_commute(i8 %x, i8 %y, i32 %t, i32 %f) {
; CHECK-LABEL: @select_not_invert_pred_cond_commute(
; CHECK-NEXT:    [[INVCOND:%.*]] = icmp ule i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[INVCOND]], true
; CHECK-NEXT:    [[M2:%.*]] = select i1 [[NOT]], i32 [[T:%.*]], i32 [[F:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i8 [[X]], [[Y]]
; CHECK-NEXT:    ret i32 0
;
  %invcond = icmp ule i8 %x, %y
  %not = xor i1 %invcond, -1
  %m2 = select i1 %not, i32 %t, i32 %f
  %cond = icmp ugt i8 %x, %y
  %m1 = select i1 %cond, i32 %t, i32 %f
  %r = sub i32 %m2, %m1
  ret i32 %r
}

; Negative test - not an inverted predicate.

define i32 @select_not_invert_pred_cond_wrong_pred(i8 %x, i8 %y, i32 %t, i32 %f) {
; CHECK-LABEL: @select_not_invert_pred_cond_wrong_pred(
; CHECK-NEXT:    [[INVCOND:%.*]] = icmp ult i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[INVCOND]], true
; CHECK-NEXT:    [[M2:%.*]] = select i1 [[NOT]], i32 [[T:%.*]], i32 [[F:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i8 [[X]], [[Y]]
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[COND]], i32 [[T]], i32 [[F]]
; CHECK-NEXT:    [[R:%.*]] = sub i32 [[M2]], [[M1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %invcond = icmp ult i8 %x, %y
  %not = xor i1 %invcond, -1
  %m2 = select i1 %not, i32 %t, i32 %f
  %cond = icmp ugt i8 %x, %y
  %m1 = select i1 %cond, i32 %t, i32 %f
  %r = sub i32 %m2, %m1
  ret i32 %r
}

; Negative test - cmp ops must match.

define i32 @select_not_invert_pred_cond_wrong_cmp_op(i8 %x, i8 %y, i32 %t, i32 %f) {
; CHECK-LABEL: @select_not_invert_pred_cond_wrong_cmp_op(
; CHECK-NEXT:    [[INVCOND:%.*]] = icmp ule i8 [[X:%.*]], 42
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[INVCOND]], true
; CHECK-NEXT:    [[M2:%.*]] = select i1 [[NOT]], i32 [[T:%.*]], i32 [[F:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[COND]], i32 [[T]], i32 [[F]]
; CHECK-NEXT:    [[R:%.*]] = sub i32 [[M2]], [[M1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %invcond = icmp ule i8 %x, 42
  %not = xor i1 %invcond, -1
  %m2 = select i1 %not, i32 %t, i32 %f
  %cond = icmp ugt i8 %x, %y
  %m1 = select i1 %cond, i32 %t, i32 %f
  %r = sub i32 %m2, %m1
  ret i32 %r
}

; Negative test - select ops must be same (and not commuted).

define i32 @select_not_invert_pred_cond_wrong_select_op(i8 %x, i8 %y, i32 %t, i32 %f) {
; CHECK-LABEL: @select_not_invert_pred_cond_wrong_select_op(
; CHECK-NEXT:    [[INVCOND:%.*]] = icmp ule i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[INVCOND]], true
; CHECK-NEXT:    [[M2:%.*]] = select i1 [[NOT]], i32 [[T:%.*]], i32 [[F:%.*]]
; CHECK-NEXT:    [[COND:%.*]] = icmp ugt i8 [[X]], [[Y]]
; CHECK-NEXT:    [[M1:%.*]] = select i1 [[COND]], i32 [[F]], i32 [[T]]
; CHECK-NEXT:    [[R:%.*]] = sub i32 [[M2]], [[M1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %invcond = icmp ule i8 %x, %y
  %not = xor i1 %invcond, -1
  %m2 = select i1 %not, i32 %t, i32 %f
  %cond = icmp ugt i8 %x, %y
  %m1 = select i1 %cond, i32 %f, i32 %t
  %r = sub i32 %m2, %m1
  ret i32 %r
}
