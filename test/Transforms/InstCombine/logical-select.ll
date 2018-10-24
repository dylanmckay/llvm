; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s


define i32 @foo(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    [[E:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[E]], i32 [[C:%.*]], i32 [[D:%.*]]
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %e = icmp slt i32 %a, %b
  %f = sext i1 %e to i32
  %g = and i32 %c, %f
  %h = xor i32 %f, -1
  %i = and i32 %d, %h
  %j = or i32 %g, %i
  ret i32 %j
}

define i32 @bar(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @bar(
; CHECK-NEXT:    [[E:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[E]], i32 [[C:%.*]], i32 [[D:%.*]]
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %e = icmp slt i32 %a, %b
  %f = sext i1 %e to i32
  %g = and i32 %c, %f
  %h = xor i32 %f, -1
  %i = and i32 %d, %h
  %j = or i32 %i, %g
  ret i32 %j
}

define i32 @goo(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @goo(
; CHECK-NEXT:    [[T0:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[T0]], i32 [[C:%.*]], i32 [[D:%.*]]
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %t0 = icmp slt i32 %a, %b
  %iftmp.0.0 = select i1 %t0, i32 -1, i32 0
  %t1 = and i32 %iftmp.0.0, %c
  %not = xor i32 %iftmp.0.0, -1
  %t2 = and i32 %not, %d
  %t3 = or i32 %t1, %t2
  ret i32 %t3
}

define i32 @poo(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @poo(
; CHECK-NEXT:    [[T0:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = select i1 [[T0]], i32 [[C:%.*]], i32 [[D:%.*]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t0 = icmp slt i32 %a, %b
  %iftmp.0.0 = select i1 %t0, i32 -1, i32 0
  %t1 = and i32 %iftmp.0.0, %c
  %iftmp = select i1 %t0, i32 0, i32 -1
  %t2 = and i32 %iftmp, %d
  %t3 = or i32 %t1, %t2
  ret i32 %t3
}

; PR32791 - https://bugs.llvm.org//show_bug.cgi?id=32791
; The 2nd compare/select are canonicalized, so CSE and another round of instcombine or some other pass will fold this.

define i32 @fold_inverted_icmp_preds(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @fold_inverted_icmp_preds(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[SEL1:%.*]] = select i1 [[CMP1]], i32 [[C:%.*]], i32 0
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[A]], [[B]]
; CHECK-NEXT:    [[SEL2:%.*]] = select i1 [[CMP2]], i32 0, i32 [[D:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %cmp1 = icmp slt i32 %a, %b
  %sel1 = select i1 %cmp1, i32 %c, i32 0
  %cmp2 = icmp sge i32 %a, %b
  %sel2 = select i1 %cmp2, i32 %d, i32 0
  %or = or i32 %sel1, %sel2
  ret i32 %or
}

; The 2nd compare/select are canonicalized, so CSE and another round of instcombine or some other pass will fold this.

define i32 @fold_inverted_icmp_preds_reverse(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @fold_inverted_icmp_preds_reverse(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[SEL1:%.*]] = select i1 [[CMP1]], i32 0, i32 [[C:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[A]], [[B]]
; CHECK-NEXT:    [[SEL2:%.*]] = select i1 [[CMP2]], i32 [[D:%.*]], i32 0
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %cmp1 = icmp slt i32 %a, %b
  %sel1 = select i1 %cmp1, i32 0, i32 %c
  %cmp2 = icmp sge i32 %a, %b
  %sel2 = select i1 %cmp2, i32 0, i32 %d
  %or = or i32 %sel1, %sel2
  ret i32 %or
}

; TODO: Should fcmp have the same sort of predicate canonicalization as icmp?

define i32 @fold_inverted_fcmp_preds(float %a, float %b, i32 %c, i32 %d) {
; CHECK-LABEL: @fold_inverted_fcmp_preds(
; CHECK-NEXT:    [[CMP1:%.*]] = fcmp olt float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[SEL1:%.*]] = select i1 [[CMP1]], i32 [[C:%.*]], i32 0
; CHECK-NEXT:    [[CMP2:%.*]] = fcmp uge float [[A]], [[B]]
; CHECK-NEXT:    [[SEL2:%.*]] = select i1 [[CMP2]], i32 [[D:%.*]], i32 0
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %cmp1 = fcmp olt float %a, %b
  %sel1 = select i1 %cmp1, i32 %c, i32 0
  %cmp2 = fcmp uge float %a, %b
  %sel2 = select i1 %cmp2, i32 %d, i32 0
  %or = or i32 %sel1, %sel2
  ret i32 %or
}

; The 2nd compare/select are canonicalized, so CSE and another round of instcombine or some other pass will fold this.

define <2 x i32> @fold_inverted_icmp_vector_preds(<2 x i32> %a, <2 x i32> %b, <2 x i32> %c, <2 x i32> %d) {
; CHECK-LABEL: @fold_inverted_icmp_vector_preds(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq <2 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[SEL1:%.*]] = select <2 x i1> [[CMP1]], <2 x i32> zeroinitializer, <2 x i32> [[C:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq <2 x i32> [[A]], [[B]]
; CHECK-NEXT:    [[SEL2:%.*]] = select <2 x i1> [[CMP2]], <2 x i32> [[D:%.*]], <2 x i32> zeroinitializer
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i32> [[SEL1]], [[SEL2]]
; CHECK-NEXT:    ret <2 x i32> [[OR]]
;
  %cmp1 = icmp ne <2 x i32> %a, %b
  %sel1 = select <2 x i1> %cmp1, <2 x i32> %c, <2 x i32> <i32 0, i32 0>
  %cmp2 = icmp eq <2 x i32> %a, %b
  %sel2 = select <2 x i1> %cmp2, <2 x i32> %d, <2 x i32> <i32 0, i32 0>
  %or = or <2 x i32> %sel1, %sel2
  ret <2 x i32> %or
}

define i32 @par(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @par(
; CHECK-NEXT:    [[T0:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[T0]], i32 [[C:%.*]], i32 [[D:%.*]]
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %t0 = icmp slt i32 %a, %b
  %iftmp.1.0 = select i1 %t0, i32 -1, i32 0
  %t1 = and i32 %iftmp.1.0, %c
  %not = xor i32 %iftmp.1.0, -1
  %t2 = and i32 %not, %d
  %t3 = or i32 %t1, %t2
  ret i32 %t3
}

; In the following tests (8 commutation variants), verify that a bitcast doesn't get
; in the way of a select transform. These bitcasts are common in SSE/AVX and possibly
; other vector code because of canonicalization to i64 elements for vectors.

; The fptosi instructions are included to avoid commutation canonicalization based on
; operator weight. Using another cast operator ensures that both operands of all logic
; ops are equally weighted, and this ensures that we're testing all commutation
; possibilities.

define <2 x i64> @bitcast_select_swap0(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap0(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> [[B:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[TMP4]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %bc1, %sia
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %bc2, %sib
  %or = or <2 x i64> %and1, %and2
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap1(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap1(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> [[B:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[TMP4]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %bc1, %sia
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %bc2, %sib
  %or = or <2 x i64> %and2, %and1
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap2(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap2(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> [[B:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[TMP4]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %bc1, %sia
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %sib, %bc2
  %or = or <2 x i64> %and1, %and2
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap3(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap3(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> [[B:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[TMP4]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %bc1, %sia
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %sib, %bc2
  %or = or <2 x i64> %and2, %and1
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap4(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap4(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> [[B:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[TMP4]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %sia, %bc1
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %bc2, %sib
  %or = or <2 x i64> %and1, %and2
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap5(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap5(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> [[B:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[TMP4]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %sia, %bc1
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %bc2, %sib
  %or = or <2 x i64> %and2, %and1
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap6(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap6(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> [[B:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[TMP4]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %sia, %bc1
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %sib, %bc2
  %or = or <2 x i64> %and1, %and2
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_swap7(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @bitcast_select_swap7(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> [[B:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64> [[SIA]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[SIB]] to <4 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x i32> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[TMP4]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %sia, %bc1
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %sib, %bc2
  %or = or <2 x i64> %and2, %and1
  ret <2 x i64> %or
}

define <2 x i64> @bitcast_select_multi_uses(<4 x i1> %cmp, <2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: @bitcast_select_multi_uses(
; CHECK-NEXT:    [[SEXT:%.*]] = sext <4 x i1> [[CMP:%.*]] to <4 x i32>
; CHECK-NEXT:    [[BC1:%.*]] = bitcast <4 x i32> [[SEXT]] to <2 x i64>
; CHECK-NEXT:    [[AND1:%.*]] = and <2 x i64> [[BC1]], [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <4 x i32> [[SEXT]] to <2 x i64>
; CHECK-NEXT:    [[BC2:%.*]] = xor <2 x i64> [[TMP1]], <i64 -1, i64 -1>
; CHECK-NEXT:    [[AND2:%.*]] = and <2 x i64> [[BC2]], [[B:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i64> [[AND2]], [[AND1]]
; CHECK-NEXT:    [[ADD:%.*]] = add <2 x i64> [[AND2]], [[BC2]]
; CHECK-NEXT:    [[SUB:%.*]] = sub <2 x i64> [[OR]], [[ADD]]
; CHECK-NEXT:    ret <2 x i64> [[SUB]]
;
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %bc1 = bitcast <4 x i32> %sext to <2 x i64>
  %and1 = and <2 x i64> %a, %bc1
  %neg = xor <4 x i32> %sext, <i32 -1, i32 -1, i32 -1, i32 -1>
  %bc2 = bitcast <4 x i32> %neg to <2 x i64>
  %and2 = and <2 x i64> %b, %bc2
  %or = or <2 x i64> %and2, %and1
  %add = add <2 x i64> %and2, %bc2
  %sub = sub <2 x i64> %or, %add
  ret <2 x i64> %sub
}

define i1 @bools(i1 %a, i1 %b, i1 %c) {
; CHECK-LABEL: @bools(
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[C:%.*]], i1 [[B:%.*]], i1 [[A:%.*]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %not = xor i1 %c, -1
  %and1 = and i1 %not, %a
  %and2 = and i1 %c, %b
  %or = or i1 %and1, %and2
  ret i1 %or
}

; Form a select if we know we can get replace 2 simple logic ops.

define i1 @bools_multi_uses1(i1 %a, i1 %b, i1 %c) {
; CHECK-LABEL: @bools_multi_uses1(
; CHECK-NEXT:    [[NOT:%.*]] = xor i1 [[C:%.*]], true
; CHECK-NEXT:    [[AND1:%.*]] = and i1 [[NOT]], [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[C]], i1 [[B:%.*]], i1 [[A]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i1 [[TMP1]], [[AND1]]
; CHECK-NEXT:    ret i1 [[XOR]]
;
  %not = xor i1 %c, -1
  %and1 = and i1 %not, %a
  %and2 = and i1 %c, %b
  %or = or i1 %and1, %and2
  %xor = xor i1 %or, %and1
  ret i1 %xor
}

; Don't replace a cheap logic op with a potentially expensive select
; unless we can also eliminate one of the other original ops.

define i1 @bools_multi_uses2(i1 %a, i1 %b, i1 %c) {
; CHECK-LABEL: @bools_multi_uses2(
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[C:%.*]], i1 [[B:%.*]], i1 [[A:%.*]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %not = xor i1 %c, -1
  %and1 = and i1 %not, %a
  %and2 = and i1 %c, %b
  %or = or i1 %and1, %and2
  %add = add i1 %and1, %and2
  %and3 = and i1 %or, %add
  ret i1 %and3
}

define <4 x i1> @vec_of_bools(<4 x i1> %a, <4 x i1> %b, <4 x i1> %c) {
; CHECK-LABEL: @vec_of_bools(
; CHECK-NEXT:    [[TMP1:%.*]] = select <4 x i1> [[C:%.*]], <4 x i1> [[B:%.*]], <4 x i1> [[A:%.*]]
; CHECK-NEXT:    ret <4 x i1> [[TMP1]]
;
  %not = xor <4 x i1> %c, <i1 true, i1 true, i1 true, i1 true>
  %and1 = and <4 x i1> %not, %a
  %and2 = and <4 x i1> %b, %c
  %or = or <4 x i1> %and2, %and1
  ret <4 x i1> %or
}

define i4 @vec_of_casted_bools(i4 %a, i4 %b, <4 x i1> %c) {
; CHECK-LABEL: @vec_of_casted_bools(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i4 [[A:%.*]] to <4 x i1>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i4 [[B:%.*]] to <4 x i1>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[C:%.*]], <4 x i1> [[TMP2]], <4 x i1> [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x i1> [[TMP3]] to i4
; CHECK-NEXT:    ret i4 [[TMP4]]
;
  %not = xor <4 x i1> %c, <i1 true, i1 true, i1 true, i1 true>
  %bc1 = bitcast <4 x i1> %not to i4
  %bc2 = bitcast <4 x i1> %c to i4
  %and1 = and i4 %a, %bc1
  %and2 = and i4 %bc2, %b
  %or = or i4 %and1, %and2
  ret i4 %or
}

; Inverted 'and' constants mean this is a select which is canonicalized to a shuffle.

define <4 x i32> @vec_sel_consts(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: @vec_sel_consts(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i32> [[A:%.*]], <4 x i32> [[B:%.*]], <4 x i32> <i32 0, i32 5, i32 6, i32 3>
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %and1 = and <4 x i32> %a, <i32 -1, i32 0, i32 0, i32 -1>
  %and2 = and <4 x i32> %b, <i32 0, i32 -1, i32 -1, i32 0>
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}

define <3 x i129> @vec_sel_consts_weird(<3 x i129> %a, <3 x i129> %b) {
; CHECK-LABEL: @vec_sel_consts_weird(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <3 x i129> [[B:%.*]], <3 x i129> [[A:%.*]], <3 x i32> <i32 3, i32 1, i32 5>
; CHECK-NEXT:    ret <3 x i129> [[TMP1]]
;
  %and1 = and <3 x i129> %a, <i129 -1, i129 0, i129 -1>
  %and2 = and <3 x i129> %b, <i129 0, i129 -1, i129 0>
  %or = or <3 x i129> %and2, %and1
  ret <3 x i129> %or
}

; The mask elements must be inverted for this to be a select.

define <4 x i32> @vec_not_sel_consts(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: @vec_not_sel_consts(
; CHECK-NEXT:    [[AND1:%.*]] = and <4 x i32> [[A:%.*]], <i32 -1, i32 0, i32 0, i32 0>
; CHECK-NEXT:    [[AND2:%.*]] = and <4 x i32> [[B:%.*]], <i32 0, i32 -1, i32 0, i32 -1>
; CHECK-NEXT:    [[OR:%.*]] = or <4 x i32> [[AND1]], [[AND2]]
; CHECK-NEXT:    ret <4 x i32> [[OR]]
;
  %and1 = and <4 x i32> %a, <i32 -1, i32 0, i32 0, i32 0>
  %and2 = and <4 x i32> %b, <i32 0, i32 -1, i32 0, i32 -1>
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}

define <4 x i32> @vec_not_sel_consts_undef_elts(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: @vec_not_sel_consts_undef_elts(
; CHECK-NEXT:    [[AND1:%.*]] = and <4 x i32> [[A:%.*]], <i32 -1, i32 undef, i32 0, i32 0>
; CHECK-NEXT:    [[AND2:%.*]] = and <4 x i32> [[B:%.*]], <i32 0, i32 -1, i32 0, i32 undef>
; CHECK-NEXT:    [[OR:%.*]] = or <4 x i32> [[AND1]], [[AND2]]
; CHECK-NEXT:    ret <4 x i32> [[OR]]
;
  %and1 = and <4 x i32> %a, <i32 -1, i32 undef, i32 0, i32 0>
  %and2 = and <4 x i32> %b, <i32 0, i32 -1, i32 0, i32 undef>
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}

; The inverted constants may be operands of xor instructions.

define <4 x i32> @vec_sel_xor(<4 x i32> %a, <4 x i32> %b, <4 x i1> %c) {
; CHECK-LABEL: @vec_sel_xor(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <4 x i1> [[C:%.*]], <i1 false, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[TMP2:%.*]] = select <4 x i1> [[TMP1]], <4 x i32> [[A:%.*]], <4 x i32> [[B:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %mask = sext <4 x i1> %c to <4 x i32>
  %mask_flip1 = xor <4 x i32> %mask, <i32 -1, i32 0, i32 0, i32 0>
  %not_mask_flip1 = xor <4 x i32> %mask, <i32 0, i32 -1, i32 -1, i32 -1>
  %and1 = and <4 x i32> %not_mask_flip1, %a
  %and2 = and <4 x i32> %mask_flip1, %b
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}

; Allow the transform even if the mask values have multiple uses because
; there's still a net reduction of instructions from removing the and/and/or.

define <4 x i32> @vec_sel_xor_multi_use(<4 x i32> %a, <4 x i32> %b, <4 x i1> %c) {
; CHECK-LABEL: @vec_sel_xor_multi_use(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <4 x i1> [[C:%.*]], <i1 true, i1 false, i1 false, i1 false>
; CHECK-NEXT:    [[MASK_FLIP1:%.*]] = sext <4 x i1> [[TMP1]] to <4 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = xor <4 x i1> [[C]], <i1 false, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[TMP2]], <4 x i32> [[A:%.*]], <4 x i32> [[B:%.*]]
; CHECK-NEXT:    [[ADD:%.*]] = add <4 x i32> [[TMP3]], [[MASK_FLIP1]]
; CHECK-NEXT:    ret <4 x i32> [[ADD]]
;
  %mask = sext <4 x i1> %c to <4 x i32>
  %mask_flip1 = xor <4 x i32> %mask, <i32 -1, i32 0, i32 0, i32 0>
  %not_mask_flip1 = xor <4 x i32> %mask, <i32 0, i32 -1, i32 -1, i32 -1>
  %and1 = and <4 x i32> %not_mask_flip1, %a
  %and2 = and <4 x i32> %mask_flip1, %b
  %or = or <4 x i32> %and1, %and2
  %add = add <4 x i32> %or, %mask_flip1
  ret <4 x i32> %add
}

; The 'ashr' guarantees that we have a bitmask, so this is select with truncated condition.

define i32 @allSignBits(i32 %cond, i32 %tval, i32 %fval) {
; CHECK-LABEL: @allSignBits(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp slt i32 [[COND:%.*]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 [[TVAL:%.*]], i32 [[FVAL:%.*]]
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %bitmask = ashr i32 %cond, 31
  %not_bitmask = xor i32 %bitmask, -1
  %a1 = and i32 %tval, %bitmask
  %a2 = and i32 %not_bitmask, %fval
  %sel = or i32 %a1, %a2
  ret i32 %sel
}

define <4 x i8> @allSignBits_vec(<4 x i8> %cond, <4 x i8> %tval, <4 x i8> %fval) {
; CHECK-LABEL: @allSignBits_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt <4 x i8> [[COND:%.*]], <i8 -1, i8 -1, i8 -1, i8 -1>
; CHECK-NEXT:    [[TMP2:%.*]] = select <4 x i1> [[TMP1]], <4 x i8> [[FVAL:%.*]], <4 x i8> [[TVAL:%.*]]
; CHECK-NEXT:    ret <4 x i8> [[TMP2]]
;
  %bitmask = ashr <4 x i8> %cond, <i8 7, i8 7, i8 7, i8 7>
  %not_bitmask = xor <4 x i8> %bitmask, <i8 -1, i8 -1, i8 -1, i8 -1>
  %a1 = and <4 x i8> %tval, %bitmask
  %a2 = and <4 x i8> %fval, %not_bitmask
  %sel = or <4 x i8> %a2, %a1
  ret <4 x i8> %sel
}

; Negative test - make sure that bitcasts from FP do not cause a crash.

define <2 x i64> @fp_bitcast(<4 x i1> %cmp, <2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: @fp_bitcast(
; CHECK-NEXT:    [[SIA:%.*]] = fptosi <2 x double> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    [[SIB:%.*]] = fptosi <2 x double> [[B:%.*]] to <2 x i64>
; CHECK-NEXT:    [[BC1:%.*]] = bitcast <2 x double> [[A]] to <2 x i64>
; CHECK-NEXT:    [[AND1:%.*]] = and <2 x i64> [[SIA]], [[BC1]]
; CHECK-NEXT:    [[BC2:%.*]] = bitcast <2 x double> [[B]] to <2 x i64>
; CHECK-NEXT:    [[AND2:%.*]] = and <2 x i64> [[SIB]], [[BC2]]
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i64> [[AND2]], [[AND1]]
; CHECK-NEXT:    ret <2 x i64> [[OR]]
;
  %sia = fptosi <2 x double> %a to <2 x i64>
  %sib = fptosi <2 x double> %b to <2 x i64>
  %bc1 = bitcast <2 x double> %a to <2 x i64>
  %and1 = and <2 x i64> %sia, %bc1
  %bc2 = bitcast <2 x double> %b to <2 x i64>
  %and2 = and <2 x i64> %sib, %bc2
  %or = or <2 x i64> %and2, %and1
  ret <2 x i64> %or
}

define <4 x i32> @computesignbits_through_shuffles(<4 x float> %x, <4 x float> %y, <4 x float> %z) {
; CHECK-LABEL: @computesignbits_through_shuffles(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ole <4 x float> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SEXT:%.*]] = sext <4 x i1> [[CMP]] to <4 x i32>
; CHECK-NEXT:    [[S1:%.*]] = shufflevector <4 x i32> [[SEXT]], <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 1, i32 1>
; CHECK-NEXT:    [[S2:%.*]] = shufflevector <4 x i32> [[SEXT]], <4 x i32> undef, <4 x i32> <i32 2, i32 2, i32 3, i32 3>
; CHECK-NEXT:    [[SHUF_OR1:%.*]] = or <4 x i32> [[S1]], [[S2]]
; CHECK-NEXT:    [[S3:%.*]] = shufflevector <4 x i32> [[SHUF_OR1]], <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 1, i32 1>
; CHECK-NEXT:    [[S4:%.*]] = shufflevector <4 x i32> [[SHUF_OR1]], <4 x i32> undef, <4 x i32> <i32 2, i32 2, i32 3, i32 3>
; CHECK-NEXT:    [[SHUF_OR2:%.*]] = or <4 x i32> [[S3]], [[S4]]
; CHECK-NEXT:    [[NOT_OR2:%.*]] = xor <4 x i32> [[SHUF_OR2]], <i32 -1, i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    [[XBC:%.*]] = bitcast <4 x float> [[X]] to <4 x i32>
; CHECK-NEXT:    [[ZBC:%.*]] = bitcast <4 x float> [[Z:%.*]] to <4 x i32>
; CHECK-NEXT:    [[AND1:%.*]] = and <4 x i32> [[NOT_OR2]], [[XBC]]
; CHECK-NEXT:    [[AND2:%.*]] = and <4 x i32> [[SHUF_OR2]], [[ZBC]]
; CHECK-NEXT:    [[SEL:%.*]] = or <4 x i32> [[AND1]], [[AND2]]
; CHECK-NEXT:    ret <4 x i32> [[SEL]]
;
  %cmp = fcmp ole <4 x float> %x, %y
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %s1 = shufflevector <4 x i32> %sext, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 1, i32 1>
  %s2 = shufflevector <4 x i32> %sext, <4 x i32> undef, <4 x i32> <i32 2, i32 2, i32 3, i32 3>
  %shuf_or1 = or <4 x i32> %s1, %s2
  %s3 = shufflevector <4 x i32> %shuf_or1, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 1, i32 1>
  %s4 = shufflevector <4 x i32> %shuf_or1, <4 x i32> undef, <4 x i32> <i32 2, i32 2, i32 3, i32 3>
  %shuf_or2 = or <4 x i32> %s3, %s4
  %not_or2 = xor <4 x i32> %shuf_or2, <i32 -1, i32 -1, i32 -1, i32 -1>
  %xbc = bitcast <4 x float> %x to <4 x i32>
  %zbc = bitcast <4 x float> %z to <4 x i32>
  %and1 = and <4 x i32> %not_or2, %xbc
  %and2 = and <4 x i32> %shuf_or2, %zbc
  %sel = or <4 x i32> %and1, %and2
  ret <4 x i32> %sel
}

