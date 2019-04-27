; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+sse2 | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+sse4.2 | FileCheck %s --check-prefixes=SSE,SSE42
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2,AVX2-SLOW
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx2,+fast-variable-shuffle | FileCheck %s --check-prefixes=AVX,AVX2,AVX2-FAST
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+xop | FileCheck %s --check-prefixes=AVX,XOP

define void @insert_v7i8_v2i16_2(<7 x i8> *%a0, <2 x i16> *%a1) nounwind {
; SSE2-LABEL: insert_v7i8_v2i16_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[0,3]
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[2,0,1,3]
; SSE2-NEXT:    movaps {{.*#+}} xmm1 = [255,255,255,255,255,255,255,255]
; SSE2-NEXT:    andps %xmm0, %xmm1
; SSE2-NEXT:    packuswb %xmm1, %xmm1
; SSE2-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; SSE2-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; SSE2-NEXT:    movb %al, 6(%rdi)
; SSE2-NEXT:    movd %xmm1, (%rdi)
; SSE2-NEXT:    pextrw $2, %xmm1, %eax
; SSE2-NEXT:    movw %ax, 4(%rdi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: insert_v7i8_v2i16_2:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE42-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE42-NEXT:    pmovzxbw {{.*#+}} xmm2 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[3],zero,zero,zero
; SSE42-NEXT:    pblendw {{.*#+}} xmm0 = xmm2[0,1],xmm0[2,3,4,5],xmm2[6,7]
; SSE42-NEXT:    packuswb %xmm0, %xmm0
; SSE42-NEXT:    pextrb $6, %xmm1, 6(%rdi)
; SSE42-NEXT:    pextrw $2, %xmm0, 4(%rdi)
; SSE42-NEXT:    movd %xmm0, (%rdi)
; SSE42-NEXT:    retq
;
; AVX1-LABEL: insert_v7i8_v2i16_2:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX1-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX1-NEXT:    vpmovzxbw {{.*#+}} xmm2 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; AVX1-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[3],zero,zero,zero
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm2[0,1],xmm0[2,3,4,5],xmm2[6,7]
; AVX1-NEXT:    vpackuswb %xmm0, %xmm0, %xmm0
; AVX1-NEXT:    vpextrb $6, %xmm1, 6(%rdi)
; AVX1-NEXT:    vpextrw $2, %xmm0, 4(%rdi)
; AVX1-NEXT:    vmovd %xmm0, (%rdi)
; AVX1-NEXT:    retq
;
; AVX2-LABEL: insert_v7i8_v2i16_2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX2-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-NEXT:    vpmovzxbw {{.*#+}} xmm2 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; AVX2-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[3],zero,zero,zero
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm2[0],xmm0[1,2],xmm2[3]
; AVX2-NEXT:    vpackuswb %xmm0, %xmm0, %xmm0
; AVX2-NEXT:    vpextrb $6, %xmm1, 6(%rdi)
; AVX2-NEXT:    vpextrw $2, %xmm0, 4(%rdi)
; AVX2-NEXT:    vmovd %xmm0, (%rdi)
; AVX2-NEXT:    retq
;
; XOP-LABEL: insert_v7i8_v2i16_2:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; XOP-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; XOP-NEXT:    vpextrb $6, %xmm1, 6(%rdi)
; XOP-NEXT:    insertq {{.*#+}} xmm1 = xmm1[0,1],xmm0[0,1,2,3],xmm1[6,7,u,u,u,u,u,u,u,u]
; XOP-NEXT:    vpextrw $1, %xmm0, 4(%rdi)
; XOP-NEXT:    vmovd %xmm1, (%rdi)
; XOP-NEXT:    retq
  %1 = load <2 x i16>, <2 x i16> *%a1
  %2 = bitcast <2 x i16> %1 to <4 x i8>
  %3 = shufflevector <4 x i8> %2, <4 x i8> undef, <7 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef>
  %4 = load <7 x i8>, <7 x i8> *%a0
  %5 = shufflevector <7 x i8> %4, <7 x i8> %3, <7 x i32> <i32 0, i32 1, i32 7, i32 8, i32 9, i32 10, i32 6>
  store <7 x i8> %5, <7 x i8>* %a0
  ret void
}
