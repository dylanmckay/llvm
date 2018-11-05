; RUN: llc < %s -march=avr | FileCheck %s

; CHECK-LABEL: ret_i8
define i8 @ret_i8() {
  ; CHECK: ldi r24, 64
  ret i8 64
}

; CHECK-LABEL: ret_i16
define i16 @ret_i16() {
  ; CHECK:      ldi     r24, 0
  ; CHECK-NEXT: ldi     r25, 4
  ret i16 1024
}

; CHECK-LABEL: ret_i32
define i32 @ret_i32() {
  ; CHECK:      ldi     r22, 78
  ; CHECK-NEXT: ldi     r23, 97
  ; CHECK-NEXT: ldi     r24, 188
  ; CHECK-NEXT: ldi     r25, 0
  ret i32 12345678
}

; CHECK-LABEL: ret_i64
define i64 @ret_i64() {
  ; CHECK:      ldi     r18, 0
  ; CHECK-NEXT: ldi     r19, 255
  ; CHECK-NEXT: mov     r20, r18
  ; CHECK-NEXT: mov     r21, r19
  ; CHECK-NEXT: mov     r22, r18
  ; CHECK-NEXT: mov     r23, r19
  ; CHECK-NEXT: mov     r24, r18
  ; CHECK-NEXT: mov     r25, r19
  ret i64 18374966859414961920
}

; CHECK-LABEL: ret_struct1
define { i8, i32 } @ret_struct1() {
start:
  ; CHECK: ldi   r22, 221
  ; CHECK: ldi   r23, 204
  ; CHECK: ldi   r20, 187
  ; CHECK: ldi   r21, 170
  ; CHECK: ldi   r24, 111
  ret { i8, i32 } { i8 111, i32 2864434397 } ; { 0x6f, 0xaabbccdd }
}

; CHECK-LABEL: ret_struct2
define { i8, i8, i8, i8, i8 } @ret_struct2() {
start:
  ret { i8, i8, i8, i8, i8 } { i8 111, i8 221, i8 204, i8 187, i8 170 } ; { 0x6f, 0xaabbccdd }
}

; CHECK-LABEL: ret_struct3
define { i32, i32 } @ret_struct3() {
start:
  ret { i32, i32 } zeroinitializer
}

; CHECK-LABEL: ret_struct4
define { i8, i64 } @ret_struct4() {
start:
  ret { i8, i64 } zeroinitializer
}

; CHECK-LABEL: ret_struct5
define { i8, i32, i16 } @ret_struct5() {
start:
  ret { i8, i32, i16 } zeroinitializer
}

; CHECK-LABEL: ret_struct6
define { i8, i32, i32 } @ret_struct6() {
start:
  ret { i8, i32, i32 } zeroinitializer
}

; Structs of size 1 should be returned in registers.
;
; This matches avr-gcc behaviour.
;
; CHECK-LABEL: ret_struct_size1
define { i8 } @ret_struct_size1() {
  ; CHECK: ldi r24, 123
  ret { i8 } { i8 123 }
}

; Structs of size 2 are currently returned on the stack.
;
; BUG(PR39251): avr-gcc returns all structs of four bytes or less in registers.
;
; CHECK-LABEL: ret_struct_size2
define { i8, i8 } @ret_struct_size2() {
  ret { i8, i8 } { i8 123, i8 234 }
}

; Structs of size 3 are currently returned on the stack.
;
; BUG(PR39251): avr-gcc returns all structs of four bytes or less in registers.
;
; CHECK-LABEL: ret_struct_size3
define { i8, i8, i8 } @ret_struct_size3() {
  ret { i8, i8, i8 } { i8 123, i8 234, i8 255 }
}

; Structs of size 4 are currently returned on the stack.
;
; BUG(PR39251): avr-gcc returns all structs of four bytes or less in registers.
;
; CHECK-LABEL: ret_struct_size4
define { i8, i8, i8, i8 } @ret_struct_size4() {
  ret { i8, i8, i8, i8 } { i8 123, i8 234, i8 255, i8 11 }
}

; Structs of size 5 should be returned on the stack.
;
; This matches avr-gcc behaviour.
;
; CHECK-LABEL: ret_struct_size5
define { i8, i8, i8, i8, i8 } @ret_struct_size5() {
  ret { i8, i8, i8, i8, i8 } { i8 123, i8 234, i8 255, i8 11, i8 22 }
}

; Structs of size 6 should be returned on the stack.
;
; This matches avr-gcc behaviour.
;
; CHECK-LABEL: ret_struct_size6
define { i8, i8, i8, i8, i8, i8 } @ret_struct_size6() {
  ret { i8, i8, i8, i8, i8, i8 } { i8 123, i8 234, i8 255, i8 11, i8 22, i8 33 }
}

; Structs of size 7 should be returned on the stack.
;
; This matches avr-gcc behaviour.
;
; CHECK-LABEL: ret_struct_size7
define { i8, i8, i8, i8, i8, i8, i8 } @ret_struct_size7() {
  ret { i8, i8, i8, i8, i8, i8, i8 } { i8 123, i8 234, i8 255, i8 11, i8 22, i8 33, i8 44 }
}

; Structs of size 8 should be returned on the stack.
;
; This matches avr-gcc behaviour.
;
; CHECK-LABEL: ret_struct_size8
define { i8, i8, i8, i8, i8, i8, i8, i8 } @ret_struct_size8() {
  ret { i8, i8, i8, i8, i8, i8, i8, i8 } { i8 123, i8 234, i8 255, i8 11, i8 22, i8 33, i8 44, i8 55 }
}
