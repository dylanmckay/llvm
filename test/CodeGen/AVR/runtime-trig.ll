; RUN: llc < %s -march=avr | FileCheck %s

; Checks that `sin` and `cos` nodes are expanded into calls to
; the `sin` and `cos` runtime library functions.
; On AVR, the only floats supported are 32-bits, and so the
; function names have no `f` or `d` suffix.

declare float @llvm.sin.f32(float %x) addrspace(1)
declare float @llvm.cos.f32(float %x) addrspace(1)

define float @do_sin(float %a) addrspace(1) {
; CHECK-LABEL: do_sin:
; CHECK: {{sin$}}
    %result = call float @llvm.sin.f32(float %a)
    ret float %result
}

; CHECK-LABEL: do_cos:
; CHECK: {{cos$}}
define float @do_cos(float %a) addrspace(1) {
    %result = call float @llvm.cos.f32(float %a)
    ret float %result
}
