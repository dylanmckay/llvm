; RUN: llc < %s -march=avr | FileCheck %s

define i8 @com8(i8 %x) addrspace(1) {
; CHECK-LABEL: com8:
; CHECK: com r24
  %neg = xor i8 %x, -1
  ret i8 %neg
}

define i16 @com16(i16 %x) addrspace(1) {
; CHECK-LABEL: com16:
; CHECK: com r24
; CHECK: com r25
  %neg = xor i16 %x, -1
  ret i16 %neg
}

define i32 @com32(i32 %x) addrspace(1) {
; CHECK-LABEL: com32:
; CHECK: com r22
; CHECK: com r23
; CHECK: com r24
; CHECK: com r25
  %neg = xor i32 %x, -1
  ret i32 %neg
}

define i64 @com64(i64 %x) addrspace(1) {
; CHECK-LABEL: com64:
; CHECK: com r18
; CHECK: com r19
; CHECK: com r20
; CHECK: com r21
; CHECK: com r22
; CHECK: com r23
; CHECK: com r24
; CHECK: com r25
  %neg = xor i64 %x, -1
  ret i64 %neg
}
