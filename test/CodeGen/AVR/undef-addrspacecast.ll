; RUN: llc -mattr=avr6 < %s -march=avr | FileCheck %s

; CHECK-LABEL: foo
define void @foo(i16 addrspace(1)* %a) addrspace(1) {
start:
  %b = addrspacecast i16 addrspace(1)* %a to i16*
  store i16* %b, i16** undef, align 1
  ret void
}

