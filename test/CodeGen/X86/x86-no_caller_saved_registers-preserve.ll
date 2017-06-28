; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py for function "bar"
; RUN: llc -mtriple=x86_64-unknown-unknown < %s | FileCheck %s

;; In functions with 'no_caller_saved_registers' attribute, all registers should
;; be preserved except for registers used for passing/returning arguments.
;; In the following function registers %RDI, %RSI and %XMM0 are used to store
;; arguments %a0, %a1 and %b0 accordingally. The value is returned in %RAX.
;; The above registers should not be preserved, however other registers
;; (that are modified by the function) should be preserved (%RDX and %XMM1).
define x86_64_sysvcc i32 @bar(i32 %a0, i32 %a1, float %b0) #0 {
; CHECK-LABEL: bar:
; CHECK:       # BB#0:
; CHECK-NEXT:    pushq %rdx
; CHECK-NEXT:  .Lcfi0:
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movaps %xmm1, -{{[0-9]+}}(%rsp) # 16-byte Spill
; CHECK-NEXT:  .Lcfi1:
; CHECK-NEXT:    .cfi_offset %rdx, -16
; CHECK-NEXT:  .Lcfi2:
; CHECK-NEXT:    .cfi_offset %xmm1, -32
; CHECK-NEXT:    #APP
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    movl $4, %eax
; CHECK-NEXT:    movaps -{{[0-9]+}}(%rsp), %xmm1 # 16-byte Reload
; CHECK-NEXT:    popq %rdx
; CHECK-NEXT:  .Lcfi3:
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
  call void asm sideeffect "", "~{rax},~{rdx},~{xmm1},~{rdi},~{rsi},~{xmm0}"()
  ret i32 4
}

;; Because "bar" has 'no_caller_saved_registers' attribute, function "foo"
;; doesn't need to preserve registers except for the arguments passed 
;; to "bar" (%ESI, %EDI and %XMM0).
define x86_64_sysvcc float @foo(i32 %a0, i32 %a1, float %b0) {
; CHECK-LABEL: foo
; CHECK:       movaps  %xmm0, %xmm1
; CHECK-NEXT:  movl  %esi, %ecx
; CHECK-NEXT:  movl  %edi, %edx
; CHECK-NEXT:  callq bar
; CHECK-NEXT:  addl  %edx, %eax
; CHECK-NEXT:  addl  %ecx, %eax
; CHECK-NEXT:  xorps %xmm0, %xmm0
; CHECK-NEXT:  cvtsi2ssl %eax, %xmm0
; CHECK-NEXT:  addss %xmm0, %xmm1
; CHECK:       retq
	%call = call i32 @bar(i32 %a0, i32 %a1, float %b0) #0
	%c0   = add i32 %a0, %call
	%c1   = add i32 %c0, %a1
	%c2 = sitofp i32 %c1 to float
	%c3 = fadd float %c2, %b0
	ret float %c3
}

attributes #0 = { "no_caller_saved_registers" }
