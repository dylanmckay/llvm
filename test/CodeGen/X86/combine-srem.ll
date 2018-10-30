; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=CHECK --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX2

; fold (srem x, 1) -> 0
define i32 @combine_srem_by_one(i32 %x) {
; CHECK-LABEL: combine_srem_by_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %1 = srem i32 %x, 1
  ret i32 %1
}

define <4 x i32> @combine_vec_srem_by_one(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_by_one:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_by_one:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = srem <4 x i32> %x, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %1
}

; fold (srem x, -1) -> 0
define i32 @combine_srem_by_negone(i32 %x) {
; CHECK-LABEL: combine_srem_by_negone:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %1 = srem i32 %x, -1
  ret i32 %1
}

define <4 x i32> @combine_vec_srem_by_negone(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_by_negone:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_by_negone:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = srem <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %1
}

; TODO fold (srem x, INT_MIN)
define i32 @combine_srem_by_minsigned(i32 %x) {
; CHECK-LABEL: combine_srem_by_minsigned:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    sarl $31, %eax
; CHECK-NEXT:    shrl %eax
; CHECK-NEXT:    addl %edi, %eax
; CHECK-NEXT:    andl $-2147483648, %eax # imm = 0x80000000
; CHECK-NEXT:    leal (%rax,%rdi), %eax
; CHECK-NEXT:    retq
  %1 = srem i32 %x, -2147483648
  ret i32 %1
}

define <4 x i32> @combine_vec_srem_by_minsigned(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_by_minsigned:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $31, %xmm1
; SSE-NEXT:    psrld $1, %xmm1
; SSE-NEXT:    paddd %xmm0, %xmm1
; SSE-NEXT:    pand {{.*}}(%rip), %xmm1
; SSE-NEXT:    psubd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_srem_by_minsigned:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm1
; AVX1-NEXT:    vpsrld $1, %xmm1, %xmm1
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; AVX1-NEXT:    vpand {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_srem_by_minsigned:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrad $31, %xmm0, %xmm1
; AVX2-NEXT:    vpsrld $1, %xmm1, %xmm1
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [2147483648,2147483648,2147483648,2147483648]
; AVX2-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = srem <4 x i32> %x, <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
  ret <4 x i32> %1
}

; TODO fold (srem 0, x) -> 0
define i32 @combine_srem_zero(i32 %x) {
; CHECK-LABEL: combine_srem_zero:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    idivl %edi
; CHECK-NEXT:    movl %edx, %eax
; CHECK-NEXT:    retq
  %1 = srem i32 0, %x
  ret i32 %1
}

define <4 x i32> @combine_vec_srem_zero(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_zero:
; SSE:       # %bb.0:
; SSE-NEXT:    pextrd $1, %xmm0, %ecx
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    xorl %edx, %edx
; SSE-NEXT:    idivl %ecx
; SSE-NEXT:    movl %edx, %ecx
; SSE-NEXT:    movd %xmm0, %esi
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    xorl %edx, %edx
; SSE-NEXT:    idivl %esi
; SSE-NEXT:    movd %edx, %xmm1
; SSE-NEXT:    pinsrd $1, %ecx, %xmm1
; SSE-NEXT:    pextrd $2, %xmm0, %ecx
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    xorl %edx, %edx
; SSE-NEXT:    idivl %ecx
; SSE-NEXT:    pinsrd $2, %edx, %xmm1
; SSE-NEXT:    pextrd $3, %xmm0, %ecx
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    xorl %edx, %edx
; SSE-NEXT:    idivl %ecx
; SSE-NEXT:    pinsrd $3, %edx, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_zero:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrd $1, %xmm0, %ecx
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    xorl %edx, %edx
; AVX-NEXT:    idivl %ecx
; AVX-NEXT:    movl %edx, %ecx
; AVX-NEXT:    vmovd %xmm0, %esi
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    xorl %edx, %edx
; AVX-NEXT:    idivl %esi
; AVX-NEXT:    vmovd %edx, %xmm1
; AVX-NEXT:    vpinsrd $1, %ecx, %xmm1, %xmm1
; AVX-NEXT:    vpextrd $2, %xmm0, %ecx
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    xorl %edx, %edx
; AVX-NEXT:    idivl %ecx
; AVX-NEXT:    vpinsrd $2, %edx, %xmm1, %xmm1
; AVX-NEXT:    vpextrd $3, %xmm0, %ecx
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    xorl %edx, %edx
; AVX-NEXT:    idivl %ecx
; AVX-NEXT:    vpinsrd $3, %edx, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = srem <4 x i32> zeroinitializer, %x
  ret <4 x i32> %1
}

; fold (srem x, x) -> 0
define i32 @combine_srem_dupe(i32 %x) {
; CHECK-LABEL: combine_srem_dupe:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %1 = srem i32 %x, %x
  ret i32 %1
}

define <4 x i32> @combine_vec_srem_dupe(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_dupe:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_dupe:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = srem <4 x i32> %x, %x
  ret <4 x i32> %1
}

; fold (srem x, y) -> (urem x, y) iff x and y are positive
define <4 x i32> @combine_vec_srem_by_pos0(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_by_pos0:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_srem_by_pos0:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_srem_by_pos0:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vbroadcastss {{.*#+}} xmm1 = [3,3,3,3]
; AVX2-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = and <4 x i32> %x, <i32 255, i32 255, i32 255, i32 255>
  %2 = srem <4 x i32> %1, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_srem_by_pos1(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_by_pos1:
; SSE:       # %bb.0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_by_pos1:
; AVX:       # %bb.0:
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = and <4 x i32> %x, <i32 255, i32 255, i32 255, i32 255>
  %2 = srem <4 x i32> %1, <i32 1, i32 4, i32 8, i32 16>
  ret <4 x i32> %2
}

; fold (srem x, (1 << c)) -> x - (x / (1 << c)) * (1 << c).
define <4 x i32> @combine_vec_srem_by_pow2a(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_by_pow2a:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $31, %xmm1
; SSE-NEXT:    psrld $30, %xmm1
; SSE-NEXT:    paddd %xmm0, %xmm1
; SSE-NEXT:    pand {{.*}}(%rip), %xmm1
; SSE-NEXT:    psubd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_srem_by_pow2a:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm1
; AVX1-NEXT:    vpsrld $30, %xmm1, %xmm1
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; AVX1-NEXT:    vpand {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_srem_by_pow2a:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrad $31, %xmm0, %xmm1
; AVX2-NEXT:    vpsrld $30, %xmm1, %xmm1
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [4294967292,4294967292,4294967292,4294967292]
; AVX2-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = srem <4 x i32> %x, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_srem_by_pow2a_neg(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_by_pow2a_neg:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $31, %xmm1
; SSE-NEXT:    psrld $30, %xmm1
; SSE-NEXT:    paddd %xmm0, %xmm1
; SSE-NEXT:    psrad $2, %xmm1
; SSE-NEXT:    pxor %xmm2, %xmm2
; SSE-NEXT:    psubd %xmm1, %xmm2
; SSE-NEXT:    pslld $2, %xmm2
; SSE-NEXT:    paddd %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_by_pow2a_neg:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsrad $31, %xmm0, %xmm1
; AVX-NEXT:    vpsrld $30, %xmm1, %xmm1
; AVX-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vpsrad $2, %xmm1, %xmm1
; AVX-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vpsubd %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vpslld $2, %xmm1, %xmm1
; AVX-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = srem <4 x i32> %x, <i32 -4, i32 -4, i32 -4, i32 -4>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_srem_by_pow2b(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_by_pow2b:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrld $31, %xmm1
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    psrad $31, %xmm2
; SSE-NEXT:    movdqa %xmm2, %xmm3
; SSE-NEXT:    psrld $29, %xmm3
; SSE-NEXT:    pblendw {{.*#+}} xmm3 = xmm1[0,1,2,3],xmm3[4,5,6,7]
; SSE-NEXT:    psrld $30, %xmm2
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1,2,3],xmm2[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; SSE-NEXT:    paddd %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm2
; SSE-NEXT:    psrad $3, %xmm2
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    psrad $1, %xmm3
; SSE-NEXT:    pblendw {{.*#+}} xmm3 = xmm3[0,1,2,3],xmm2[4,5,6,7]
; SSE-NEXT:    psrad $2, %xmm1
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm0[0,1],xmm1[2,3,4,5,6,7]
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm1
; SSE-NEXT:    psubd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_srem_by_pow2b:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrld $31, %xmm0, %xmm1
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm2
; AVX1-NEXT:    vpsrld $29, %xmm2, %xmm3
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1,2,3],xmm3[4,5,6,7]
; AVX1-NEXT:    vpsrld $30, %xmm2, %xmm2
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm3[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm2[0,1],xmm1[2,3],xmm2[4,5],xmm1[6,7]
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; AVX1-NEXT:    vpsrad $3, %xmm1, %xmm2
; AVX1-NEXT:    vpsrad $1, %xmm1, %xmm3
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm3[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vpsrad $2, %xmm1, %xmm1
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm0[0,1],xmm1[2,3,4,5,6,7]
; AVX1-NEXT:    vpmulld {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_srem_by_pow2b:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrad $31, %xmm0, %xmm1
; AVX2-NEXT:    vpsrlvd {{.*}}(%rip), %xmm1, %xmm1
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = [0,1,2,3]
; AVX2-NEXT:    vpsravd %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} xmm1 = xmm0[0],xmm1[1,2,3]
; AVX2-NEXT:    vpsllvd %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = srem <4 x i32> %x, <i32 1, i32 2, i32 4, i32 8>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_srem_by_pow2b_neg(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_by_pow2b_neg:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $31, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm2
; SSE-NEXT:    psrld $28, %xmm2
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    psrld $30, %xmm3
; SSE-NEXT:    pblendw {{.*#+}} xmm3 = xmm3[0,1,2,3],xmm2[4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    psrld $31, %xmm2
; SSE-NEXT:    psrld $29, %xmm1
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm2[0,1,2,3],xmm1[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; SSE-NEXT:    paddd %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm2
; SSE-NEXT:    psrad $4, %xmm2
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    psrad $2, %xmm3
; SSE-NEXT:    pblendw {{.*#+}} xmm3 = xmm3[0,1,2,3],xmm2[4,5,6,7]
; SSE-NEXT:    movdqa %xmm1, %xmm2
; SSE-NEXT:    psrad $3, %xmm2
; SSE-NEXT:    psrad $1, %xmm1
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1,2,3],xmm2[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm3[2,3],xmm1[4,5],xmm3[6,7]
; SSE-NEXT:    pmulld {{.*}}(%rip), %xmm1
; SSE-NEXT:    paddd %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_srem_by_pow2b_neg:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm1
; AVX1-NEXT:    vpsrld $28, %xmm1, %xmm2
; AVX1-NEXT:    vpsrld $30, %xmm1, %xmm3
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm3[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vpsrld $31, %xmm0, %xmm3
; AVX1-NEXT:    vpsrld $29, %xmm1, %xmm1
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm3[0,1,2,3],xmm1[4,5,6,7]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; AVX1-NEXT:    vpsrad $4, %xmm1, %xmm2
; AVX1-NEXT:    vpsrad $2, %xmm1, %xmm3
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm3[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vpsrad $3, %xmm1, %xmm3
; AVX1-NEXT:    vpsrad $1, %xmm1, %xmm1
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1,2,3],xmm3[4,5,6,7]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; AVX1-NEXT:    vpmulld {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_srem_by_pow2b_neg:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrad $31, %xmm0, %xmm1
; AVX2-NEXT:    vpsrlvd {{.*}}(%rip), %xmm1, %xmm1
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; AVX2-NEXT:    vpsravd {{.*}}(%rip), %xmm1, %xmm1
; AVX2-NEXT:    vpmulld {{.*}}(%rip), %xmm1, %xmm1
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = srem <4 x i32> %x, <i32 -2, i32 -4, i32 -8, i32 -16>
  ret <4 x i32> %1
}

; OSS-Fuzz #6883
; https://bugs.chromium.org/p/oss-fuzz/issues/detail?id=6883
define i32 @ossfuzz6883() {
; CHECK-LABEL: ossfuzz6883:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl (%rax), %ecx
; CHECK-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    idivl %ecx
; CHECK-NEXT:    movl %eax, %esi
; CHECK-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    divl %ecx
; CHECK-NEXT:    movl %eax, %edi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %edi
; CHECK-NEXT:    movl %edx, %esi
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %esi
; CHECK-NEXT:    movl %edx, %edi
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    divl %esi
; CHECK-NEXT:    andl %edi, %eax
; CHECK-NEXT:    retq
  %B17 = or i32 0, 2147483647
  %L6 = load i32, i32* undef
  %B11 = sdiv i32 %B17, %L6
  %B13 = udiv i32 %B17, %L6
  %B14 = srem i32 %B11, %B13
  %B16 = srem i32 %L6, %B14
  %B10 = udiv i32 %L6, %B14
  %B6 = and i32 %B16, %B10
  ret i32 %B6
}

define i1 @bool_srem(i1 %x, i1 %y) {
; CHECK-LABEL: bool_srem:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
  %r = srem i1 %x, %y
  ret i1 %r
}
define <4 x i1> @boolvec_srem(<4 x i1> %x, <4 x i1> %y) {
; SSE-LABEL: boolvec_srem:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: boolvec_srem:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %r = srem <4 x i1> %x, %y
  ret <4 x i1> %r
}
