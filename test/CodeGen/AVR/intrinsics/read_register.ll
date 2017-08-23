; RUN: llc -O0 < %s -march=avr | FileCheck %s

; CHECK-LABEL: foo
define void @foo() addrspace(1) {
entry:
  %val1 = call i16 @llvm.read_register.i16(metadata !0)
  %val2 = call i16 @llvm.read_register.i16(metadata !1)
  %val3 = call i8 @llvm.read_register.i8(metadata !2)
  ret void
}

declare i8 @llvm.read_register.i8(metadata) addrspace(1)
declare i16 @llvm.read_register.i16(metadata) addrspace(1)

!0 = !{!"r28"}
!1 = !{!"Z"}
!2 = !{!"r0"}
