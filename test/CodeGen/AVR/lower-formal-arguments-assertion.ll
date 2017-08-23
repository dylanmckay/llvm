; RUN: llc < %s -march=avr | FileCheck %s

define void @foo(i1) addrspace(1) {
; CHECK-LABEL: foo:
; CHECK: ret
  ret void
}
