; RUN: llc -mattr=avr6 < %s -march=avr | FileCheck %s

; CHECK-LABEL: foo
define void @foo() addrspace(1) {
start:
  %a = addrspacecast {} addrspace(1)* undef to {}*
  store {}* %a, {}** undef, align 1
  ret void
}

