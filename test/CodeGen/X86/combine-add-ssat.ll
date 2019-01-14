; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefixes=CHECK,SSE,SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE42
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=CHECK,AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,AVX,AVX512,AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefixes=CHECK,AVX,AVX512,AVX512BW

declare  i32 @llvm.sadd.sat.i32  (i32, i32)
declare  i64 @llvm.sadd.sat.i64  (i64, i64)
declare  <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16>, <8 x i16>)

; fold (sadd_sat c1, c2) -> c3
define i32 @combine_constfold_i32() {
; CHECK-LABEL: combine_constfold_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-NEXT:    retq
  %res = call i32 @llvm.sadd.sat.i32(i32 2147483647, i32 100)
  ret i32 %res
}

define <8 x i16> @combine_constfold_v8i16() {
; SSE-LABEL: combine_constfold_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [1,0,256,65534,0,65280,32768,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_constfold_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [1,0,256,65534,0,65280,32768,0]
; AVX-NEXT:    retq
  %res = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> <i16 0, i16 1, i16 255, i16 65535, i16 -1, i16 -255, i16 -32760, i16 1>, <8 x i16> <i16 1, i16 65535, i16 1, i16 65535, i16 1, i16 65535, i16 -10, i16 65535>)
  ret <8 x i16> %res
}

define <8 x i16> @combine_constfold_undef_v8i16() {
; SSE-LABEL: combine_constfold_undef_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm0 = <u,1,u,65535,65535,65281,32776,1>
; SSE-NEXT:    paddsw {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_constfold_undef_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovdqa {{.*#+}} xmm0 = <u,1,u,65535,65535,65281,32776,1>
; AVX-NEXT:    vpaddsw {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %res = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> <i16 undef, i16 1, i16 undef, i16 65535, i16 -1, i16 -255, i16 -32760, i16 1>, <8 x i16> <i16 1, i16 undef, i16 undef, i16 65535, i16 1, i16 65535, i16 -10, i16 65535>)
  ret <8 x i16> %res
}

; fold (sadd_sat c, x) -> (sadd_sat x, c)
define i32 @combine_constant_i32(i32 %a0) {
; CHECK-LABEL: combine_constant_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    movl %edi, %ecx
; CHECK-NEXT:    incl %ecx
; CHECK-NEXT:    setns %al
; CHECK-NEXT:    addl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-NEXT:    incl %edi
; CHECK-NEXT:    cmovnol %edi, %eax
; CHECK-NEXT:    retq
  %res = call i32 @llvm.sadd.sat.i32(i32 1, i32 %a0)
  ret i32 %res
}

define <8 x i16> @combine_constant_v8i16(<8 x i16> %a0) {
; SSE-LABEL: combine_constant_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    paddsw {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_constant_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpaddsw {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %res = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>, <8 x i16> %a0)
  ret <8 x i16> %res
}

; fold (sadd_sat c, 0) -> x
define i32 @combine_zero_i32(i32 %a0) {
; CHECK-LABEL: combine_zero_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %1 = call i32 @llvm.sadd.sat.i32(i32 %a0, i32 0)
  ret i32 %1
}

define <8 x i16> @combine_zero_v8i16(<8 x i16> %a0) {
; CHECK-LABEL: combine_zero_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %1 = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> %a0, <8 x i16> zeroinitializer)
  ret <8 x i16> %1
}

; fold (sadd_sat x, y) -> (add x, y) iff no overflow
define i32 @combine_no_overflow_i32(i32 %a0, i32 %a1) {
; CHECK-LABEL: combine_no_overflow_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sarl $16, %edi
; CHECK-NEXT:    shrl $16, %esi
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    movl %edi, %ecx
; CHECK-NEXT:    addl %esi, %ecx
; CHECK-NEXT:    setns %al
; CHECK-NEXT:    addl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-NEXT:    addl %edi, %esi
; CHECK-NEXT:    cmovnol %esi, %eax
; CHECK-NEXT:    retq
  %1 = ashr i32 %a0, 16
  %2 = lshr i32 %a1, 16
  %3 = call i32 @llvm.sadd.sat.i32(i32 %1, i32 %2)
  ret i32 %3
}

define <8 x i16> @combine_no_overflow_v8i16(<8 x i16> %a0, <8 x i16> %a1) {
; SSE-LABEL: combine_no_overflow_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    psraw $10, %xmm0
; SSE-NEXT:    psrlw $10, %xmm1
; SSE-NEXT:    paddsw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_no_overflow_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsraw $10, %xmm0, %xmm0
; AVX-NEXT:    vpsrlw $10, %xmm1, %xmm1
; AVX-NEXT:    vpaddsw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = ashr <8 x i16> %a0, <i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10>
  %2 = lshr <8 x i16> %a1, <i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10, i16 10>
  %3 = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> %1, <8 x i16> %2)
  ret <8 x i16> %3
}
