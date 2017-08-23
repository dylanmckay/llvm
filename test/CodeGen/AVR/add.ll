; RUN: llc -mattr=addsubiw < %s -march=avr | FileCheck %s

define i32 @add32_reg_reg(i32 %a, i32 %b) {
; CHECK-LABEL: add32_reg_reg:
; CHECK: add r22, r18
; CHECK: adc r23, r19
; CHECK: adc r24, r20
; CHECK: adc r25, r21
    %result = add i32 %a, %b
    ret i32 %result
}
