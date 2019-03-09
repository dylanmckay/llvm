; RUN: llc -O1 < %s -march=avr | FileCheck %s

; CHECK-LABEL: setServoAngle1
define hidden i32 @setServoAngle1(i32) local_unnamed_addr {
entry:
  %1 = mul i32 %0, 19
; CHECK: ldi r18, 19
; CHECK: ldi r19, 0
; CHECK: ldi r20, 0
; CHECK: ldi r21, 0
; CHECK: call  __mulsi3
; CHECK: ret
  ret i32 %1
}

; CHECK-LABEL: setServoAngle2
define hidden i16 @setServoAngle2(i32) local_unnamed_addr {
entry:
  %1 = mul i32 %0, 19
; CHECK: ldi r18, 19
; CHECK: ldi r19, 0
; CHECK: ldi r20, 0
; CHECK: ldi r21, 0
; CHECK: call  __mulsi3
  %2 = trunc i32 %1 to i16
; CHECK: mov r24, r22
; CHECK: mov r25, r23
; CHECK: ret
  ret i16 %2
}

; CHECK-LABEL: setServoAngle3
define hidden i32 @setServoAngle3(i32) local_unnamed_addr {
entry:
  %1 = call i32 @myExternalFunction1(i32 %0, i32 119)
; CHECK: ldi r18, 119
; CHECK: ldi r19, 0
; CHECK: ldi r20, 0
; CHECK: ldi r21, 0
; CHECK: call  myExternalFunction1
; CHECK: ret
  ret i32 %1
}

; CHECK-LABEL: setServoAngle4
define hidden i16 @setServoAngle4(i32) local_unnamed_addr {
entry:
  %1 = call i32 @myExternalFunction1(i32 %0, i32 119)
; CHECK: ldi r18, 119
; CHECK: ldi r19, 0
; CHECK: ldi r20, 0
; CHECK: ldi r21, 0
; CHECK: call  myExternalFunction1
  %2 = trunc i32 %1 to i16
; CHECK: mov r24, r22
; CHECK: mov r25, r23
; CHECK: ret
  ret i16 %2
}

declare i32 @myExternalFunction1(i32, i32)
