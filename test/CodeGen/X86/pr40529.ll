; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux -mcpu=x86-64 | FileCheck %s

define x86_fp80 @rem_pio2l_min(x86_fp80 %z) {
; CHECK-LABEL: rem_pio2l_min:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fnstcw -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movzwl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movw $3199, -{{[0-9]+}}(%rsp) # imm = 0xC7F
; CHECK-NEXT:    fldcw -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    fldt {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movw %ax, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    fistl -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    fldcw -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl %eax, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    fisubl -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    fnstcw -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    flds {{.*}}(%rip)
; CHECK-NEXT:    movzwl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movw $3199, -{{[0-9]+}}(%rsp) # imm = 0xC7F
; CHECK-NEXT:    fldcw -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    fmul %st, %st(1)
; CHECK-NEXT:    movw %ax, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    fxch %st(1)
; CHECK-NEXT:    fistl -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    fldcw -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movl %eax, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    fisubl -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    fmulp %st, %st(1)
; CHECK-NEXT:    retq
entry:
  %conv = fptosi x86_fp80 %z to i32
  %conv1 = sitofp i32 %conv to x86_fp80
  %sub = fsub x86_fp80 %z, %conv1
  %mul = fmul x86_fp80 %sub, 0xK40178000000000000000
  %conv2 = fptosi x86_fp80 %mul to i32
  %conv3 = sitofp i32 %conv2 to x86_fp80
  %sub4 = fsub x86_fp80 %mul, %conv3
  %mul5 = fmul x86_fp80 %sub4, 0xK40178000000000000000
  ret x86_fp80 %mul5
}
