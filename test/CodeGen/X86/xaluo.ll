; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-darwin-unknown < %s | FileCheck %s --check-prefix=SDAG
; RUN: llc -mtriple=x86_64-darwin-unknown -fast-isel -fast-isel-abort=1 < %s | FileCheck %s --check-prefix=FAST
; RUN: llc -mtriple=x86_64-darwin-unknown -mcpu=knl < %s | FileCheck %s --check-prefix=SDAG

;
; Get the actual value of the overflow bit.
;
; SADDO reg, reg
define zeroext i1 @saddoi8(i8 signext %v1, i8 signext %v2, i8* %res) {
; SDAG-LABEL: saddoi8:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addb %sil, %dil
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movb %dil, (%rdx)
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoi8:
; FAST:       ## %bb.0:
; FAST-NEXT:    addb %sil, %dil
; FAST-NEXT:    seto %al
; FAST-NEXT:    movb %dil, (%rdx)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i8, i1} @llvm.sadd.with.overflow.i8(i8 %v1, i8 %v2)
  %val = extractvalue {i8, i1} %t, 0
  %obit = extractvalue {i8, i1} %t, 1
  store i8 %val, i8* %res
  ret i1 %obit
}

define zeroext i1 @saddoi16(i16 %v1, i16 %v2, i16* %res) {
; SDAG-LABEL: saddoi16:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addw %si, %di
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movw %di, (%rdx)
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoi16:
; FAST:       ## %bb.0:
; FAST-NEXT:    addw %si, %di
; FAST-NEXT:    seto %al
; FAST-NEXT:    movw %di, (%rdx)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i16, i1} @llvm.sadd.with.overflow.i16(i16 %v1, i16 %v2)
  %val = extractvalue {i16, i1} %t, 0
  %obit = extractvalue {i16, i1} %t, 1
  store i16 %val, i16* %res
  ret i1 %obit
}

define zeroext i1 @saddoi32(i32 %v1, i32 %v2, i32* %res) {
; SDAG-LABEL: saddoi32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addl %esi, %edi
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movl %edi, (%rdx)
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoi32:
; FAST:       ## %bb.0:
; FAST-NEXT:    addl %esi, %edi
; FAST-NEXT:    seto %al
; FAST-NEXT:    movl %edi, (%rdx)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.sadd.with.overflow.i32(i32 %v1, i32 %v2)
  %val = extractvalue {i32, i1} %t, 0
  %obit = extractvalue {i32, i1} %t, 1
  store i32 %val, i32* %res
  ret i1 %obit
}

define zeroext i1 @saddoi64(i64 %v1, i64 %v2, i64* %res) {
; SDAG-LABEL: saddoi64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addq %rsi, %rdi
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movq %rdi, (%rdx)
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoi64:
; FAST:       ## %bb.0:
; FAST-NEXT:    addq %rsi, %rdi
; FAST-NEXT:    seto %al
; FAST-NEXT:    movq %rdi, (%rdx)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %v1, i64 %v2)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  store i64 %val, i64* %res
  ret i1 %obit
}

; SADDO reg, 1 | INC
define zeroext i1 @saddoinci8(i8 %v1, i8* %res) {
; SDAG-LABEL: saddoinci8:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    incb %dil
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movb %dil, (%rsi)
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoinci8:
; FAST:       ## %bb.0:
; FAST-NEXT:    incb %dil
; FAST-NEXT:    seto %al
; FAST-NEXT:    movb %dil, (%rsi)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i8, i1} @llvm.sadd.with.overflow.i8(i8 %v1, i8 1)
  %val = extractvalue {i8, i1} %t, 0
  %obit = extractvalue {i8, i1} %t, 1
  store i8 %val, i8* %res
  ret i1 %obit
}

define zeroext i1 @saddoinci16(i16 %v1, i16* %res) {
; SDAG-LABEL: saddoinci16:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    incw %di
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movw %di, (%rsi)
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoinci16:
; FAST:       ## %bb.0:
; FAST-NEXT:    incw %di
; FAST-NEXT:    seto %al
; FAST-NEXT:    movw %di, (%rsi)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i16, i1} @llvm.sadd.with.overflow.i16(i16 %v1, i16 1)
  %val = extractvalue {i16, i1} %t, 0
  %obit = extractvalue {i16, i1} %t, 1
  store i16 %val, i16* %res
  ret i1 %obit
}

define zeroext i1 @saddoinci32(i32 %v1, i32* %res) {
; SDAG-LABEL: saddoinci32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    incl %edi
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movl %edi, (%rsi)
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoinci32:
; FAST:       ## %bb.0:
; FAST-NEXT:    incl %edi
; FAST-NEXT:    seto %al
; FAST-NEXT:    movl %edi, (%rsi)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.sadd.with.overflow.i32(i32 %v1, i32 1)
  %val = extractvalue {i32, i1} %t, 0
  %obit = extractvalue {i32, i1} %t, 1
  store i32 %val, i32* %res
  ret i1 %obit
}

define zeroext i1 @saddoinci64(i64 %v1, i64* %res) {
; SDAG-LABEL: saddoinci64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    incq %rdi
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movq %rdi, (%rsi)
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoinci64:
; FAST:       ## %bb.0:
; FAST-NEXT:    incq %rdi
; FAST-NEXT:    seto %al
; FAST-NEXT:    movq %rdi, (%rsi)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %v1, i64 1)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  store i64 %val, i64* %res
  ret i1 %obit
}

; SADDO reg, imm | imm, reg
; FIXME: DAG doesn't optimize immediates on the LHS.
define zeroext i1 @saddoi64imm1(i64 %v1, i64* %res) {
; SDAG-LABEL: saddoi64imm1:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movl $2, %ecx
; SDAG-NEXT:    addq %rdi, %rcx
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movq %rcx, (%rsi)
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoi64imm1:
; FAST:       ## %bb.0:
; FAST-NEXT:    addq $2, %rdi
; FAST-NEXT:    seto %al
; FAST-NEXT:    movq %rdi, (%rsi)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 2, i64 %v1)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  store i64 %val, i64* %res
  ret i1 %obit
}

; Check boundary conditions for large immediates.
define zeroext i1 @saddoi64imm2(i64 %v1, i64* %res) {
; SDAG-LABEL: saddoi64imm2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addq $-2147483648, %rdi ## imm = 0x80000000
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movq %rdi, (%rsi)
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoi64imm2:
; FAST:       ## %bb.0:
; FAST-NEXT:    addq $-2147483648, %rdi ## imm = 0x80000000
; FAST-NEXT:    seto %al
; FAST-NEXT:    movq %rdi, (%rsi)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %v1, i64 -2147483648)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  store i64 %val, i64* %res
  ret i1 %obit
}

define zeroext i1 @saddoi64imm3(i64 %v1, i64* %res) {
; SDAG-LABEL: saddoi64imm3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movabsq $-21474836489, %rcx ## imm = 0xFFFFFFFAFFFFFFF7
; SDAG-NEXT:    addq %rdi, %rcx
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movq %rcx, (%rsi)
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoi64imm3:
; FAST:       ## %bb.0:
; FAST-NEXT:    movabsq $-21474836489, %rax ## imm = 0xFFFFFFFAFFFFFFF7
; FAST-NEXT:    addq %rdi, %rax
; FAST-NEXT:    seto %cl
; FAST-NEXT:    movq %rax, (%rsi)
; FAST-NEXT:    andb $1, %cl
; FAST-NEXT:    movzbl %cl, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %v1, i64 -21474836489)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  store i64 %val, i64* %res
  ret i1 %obit
}

define zeroext i1 @saddoi64imm4(i64 %v1, i64* %res) {
; SDAG-LABEL: saddoi64imm4:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addq $2147483647, %rdi ## imm = 0x7FFFFFFF
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movq %rdi, (%rsi)
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoi64imm4:
; FAST:       ## %bb.0:
; FAST-NEXT:    addq $2147483647, %rdi ## imm = 0x7FFFFFFF
; FAST-NEXT:    seto %al
; FAST-NEXT:    movq %rdi, (%rsi)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %v1, i64 2147483647)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  store i64 %val, i64* %res
  ret i1 %obit
}

define zeroext i1 @saddoi64imm5(i64 %v1, i64* %res) {
; SDAG-LABEL: saddoi64imm5:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movl $2147483648, %ecx ## imm = 0x80000000
; SDAG-NEXT:    addq %rdi, %rcx
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movq %rcx, (%rsi)
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoi64imm5:
; FAST:       ## %bb.0:
; FAST-NEXT:    movl $2147483648, %eax ## imm = 0x80000000
; FAST-NEXT:    addq %rdi, %rax
; FAST-NEXT:    seto %cl
; FAST-NEXT:    movq %rax, (%rsi)
; FAST-NEXT:    andb $1, %cl
; FAST-NEXT:    movzbl %cl, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %v1, i64 2147483648)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  store i64 %val, i64* %res
  ret i1 %obit
}

; UADDO
define zeroext i1 @uaddoi32(i32 %v1, i32 %v2, i32* %res) {
; SDAG-LABEL: uaddoi32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addl %esi, %edi
; SDAG-NEXT:    setb %al
; SDAG-NEXT:    movl %edi, (%rdx)
; SDAG-NEXT:    retq
;
; FAST-LABEL: uaddoi32:
; FAST:       ## %bb.0:
; FAST-NEXT:    addl %esi, %edi
; FAST-NEXT:    setb %al
; FAST-NEXT:    movl %edi, (%rdx)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.uadd.with.overflow.i32(i32 %v1, i32 %v2)
  %val = extractvalue {i32, i1} %t, 0
  %obit = extractvalue {i32, i1} %t, 1
  store i32 %val, i32* %res
  ret i1 %obit
}

define zeroext i1 @uaddoi64(i64 %v1, i64 %v2, i64* %res) {
; SDAG-LABEL: uaddoi64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addq %rsi, %rdi
; SDAG-NEXT:    setb %al
; SDAG-NEXT:    movq %rdi, (%rdx)
; SDAG-NEXT:    retq
;
; FAST-LABEL: uaddoi64:
; FAST:       ## %bb.0:
; FAST-NEXT:    addq %rsi, %rdi
; FAST-NEXT:    setb %al
; FAST-NEXT:    movq %rdi, (%rdx)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.uadd.with.overflow.i64(i64 %v1, i64 %v2)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  store i64 %val, i64* %res
  ret i1 %obit
}

; UADDO reg, 1 | NOT INC
define zeroext i1 @uaddoinci8(i8 %v1, i8* %res) {
; SDAG-LABEL: uaddoinci8:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addb $1, %dil
; SDAG-NEXT:    setb %al
; SDAG-NEXT:    movb %dil, (%rsi)
; SDAG-NEXT:    retq
;
; FAST-LABEL: uaddoinci8:
; FAST:       ## %bb.0:
; FAST-NEXT:    addb $1, %dil
; FAST-NEXT:    setb %al
; FAST-NEXT:    movb %dil, (%rsi)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i8, i1} @llvm.uadd.with.overflow.i8(i8 %v1, i8 1)
  %val = extractvalue {i8, i1} %t, 0
  %obit = extractvalue {i8, i1} %t, 1
  store i8 %val, i8* %res
  ret i1 %obit
}

define zeroext i1 @uaddoinci16(i16 %v1, i16* %res) {
; SDAG-LABEL: uaddoinci16:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addw $1, %di
; SDAG-NEXT:    setb %al
; SDAG-NEXT:    movw %di, (%rsi)
; SDAG-NEXT:    retq
;
; FAST-LABEL: uaddoinci16:
; FAST:       ## %bb.0:
; FAST-NEXT:    addw $1, %di
; FAST-NEXT:    setb %al
; FAST-NEXT:    movw %di, (%rsi)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i16, i1} @llvm.uadd.with.overflow.i16(i16 %v1, i16 1)
  %val = extractvalue {i16, i1} %t, 0
  %obit = extractvalue {i16, i1} %t, 1
  store i16 %val, i16* %res
  ret i1 %obit
}

define zeroext i1 @uaddoinci32(i32 %v1, i32* %res) {
; SDAG-LABEL: uaddoinci32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addl $1, %edi
; SDAG-NEXT:    setb %al
; SDAG-NEXT:    movl %edi, (%rsi)
; SDAG-NEXT:    retq
;
; FAST-LABEL: uaddoinci32:
; FAST:       ## %bb.0:
; FAST-NEXT:    addl $1, %edi
; FAST-NEXT:    setb %al
; FAST-NEXT:    movl %edi, (%rsi)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.uadd.with.overflow.i32(i32 %v1, i32 1)
  %val = extractvalue {i32, i1} %t, 0
  %obit = extractvalue {i32, i1} %t, 1
  store i32 %val, i32* %res
  ret i1 %obit
}

define zeroext i1 @uaddoinci64(i64 %v1, i64* %res) {
; SDAG-LABEL: uaddoinci64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addq $1, %rdi
; SDAG-NEXT:    setb %al
; SDAG-NEXT:    movq %rdi, (%rsi)
; SDAG-NEXT:    retq
;
; FAST-LABEL: uaddoinci64:
; FAST:       ## %bb.0:
; FAST-NEXT:    addq $1, %rdi
; FAST-NEXT:    setb %al
; FAST-NEXT:    movq %rdi, (%rsi)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.uadd.with.overflow.i64(i64 %v1, i64 1)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  store i64 %val, i64* %res
  ret i1 %obit
}

; SSUBO
define zeroext i1 @ssuboi32(i32 %v1, i32 %v2, i32* %res) {
; SDAG-LABEL: ssuboi32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    subl %esi, %edi
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movl %edi, (%rdx)
; SDAG-NEXT:    retq
;
; FAST-LABEL: ssuboi32:
; FAST:       ## %bb.0:
; FAST-NEXT:    subl %esi, %edi
; FAST-NEXT:    seto %al
; FAST-NEXT:    movl %edi, (%rdx)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.ssub.with.overflow.i32(i32 %v1, i32 %v2)
  %val = extractvalue {i32, i1} %t, 0
  %obit = extractvalue {i32, i1} %t, 1
  store i32 %val, i32* %res
  ret i1 %obit
}

define zeroext i1 @ssuboi64(i64 %v1, i64 %v2, i64* %res) {
; SDAG-LABEL: ssuboi64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    subq %rsi, %rdi
; SDAG-NEXT:    seto %al
; SDAG-NEXT:    movq %rdi, (%rdx)
; SDAG-NEXT:    retq
;
; FAST-LABEL: ssuboi64:
; FAST:       ## %bb.0:
; FAST-NEXT:    subq %rsi, %rdi
; FAST-NEXT:    seto %al
; FAST-NEXT:    movq %rdi, (%rdx)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %v1, i64 %v2)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  store i64 %val, i64* %res
  ret i1 %obit
}

; USUBO
define zeroext i1 @usuboi32(i32 %v1, i32 %v2, i32* %res) {
; SDAG-LABEL: usuboi32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    subl %esi, %edi
; SDAG-NEXT:    setb %al
; SDAG-NEXT:    movl %edi, (%rdx)
; SDAG-NEXT:    retq
;
; FAST-LABEL: usuboi32:
; FAST:       ## %bb.0:
; FAST-NEXT:    subl %esi, %edi
; FAST-NEXT:    setb %al
; FAST-NEXT:    movl %edi, (%rdx)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.usub.with.overflow.i32(i32 %v1, i32 %v2)
  %val = extractvalue {i32, i1} %t, 0
  %obit = extractvalue {i32, i1} %t, 1
  store i32 %val, i32* %res
  ret i1 %obit
}

define zeroext i1 @usuboi64(i64 %v1, i64 %v2, i64* %res) {
; SDAG-LABEL: usuboi64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    subq %rsi, %rdi
; SDAG-NEXT:    setb %al
; SDAG-NEXT:    movq %rdi, (%rdx)
; SDAG-NEXT:    retq
;
; FAST-LABEL: usuboi64:
; FAST:       ## %bb.0:
; FAST-NEXT:    subq %rsi, %rdi
; FAST-NEXT:    setb %al
; FAST-NEXT:    movq %rdi, (%rdx)
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.usub.with.overflow.i64(i64 %v1, i64 %v2)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  store i64 %val, i64* %res
  ret i1 %obit
}

;
; Check the use of the overflow bit in combination with a select instruction.
;
define i32 @saddoselecti32(i32 %v1, i32 %v2) {
; SDAG-LABEL: saddoselecti32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movl %esi, %eax
; SDAG-NEXT:    movl %edi, %ecx
; SDAG-NEXT:    addl %esi, %ecx
; SDAG-NEXT:    cmovol %edi, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoselecti32:
; FAST:       ## %bb.0:
; FAST-NEXT:    movl %esi, %eax
; FAST-NEXT:    movl %edi, %ecx
; FAST-NEXT:    addl %esi, %ecx
; FAST-NEXT:    cmovol %edi, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.sadd.with.overflow.i32(i32 %v1, i32 %v2)
  %obit = extractvalue {i32, i1} %t, 1
  %ret = select i1 %obit, i32 %v1, i32 %v2
  ret i32 %ret
}

define i64 @saddoselecti64(i64 %v1, i64 %v2) {
; SDAG-LABEL: saddoselecti64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movq %rsi, %rax
; SDAG-NEXT:    movq %rdi, %rcx
; SDAG-NEXT:    addq %rsi, %rcx
; SDAG-NEXT:    cmovoq %rdi, %rax
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddoselecti64:
; FAST:       ## %bb.0:
; FAST-NEXT:    movq %rsi, %rax
; FAST-NEXT:    movq %rdi, %rcx
; FAST-NEXT:    addq %rsi, %rcx
; FAST-NEXT:    cmovoq %rdi, %rax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %v1, i64 %v2)
  %obit = extractvalue {i64, i1} %t, 1
  %ret = select i1 %obit, i64 %v1, i64 %v2
  ret i64 %ret
}

define i32 @uaddoselecti32(i32 %v1, i32 %v2) {
; SDAG-LABEL: uaddoselecti32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movl %esi, %eax
; SDAG-NEXT:    movl %edi, %ecx
; SDAG-NEXT:    addl %esi, %ecx
; SDAG-NEXT:    cmovbl %edi, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: uaddoselecti32:
; FAST:       ## %bb.0:
; FAST-NEXT:    movl %esi, %eax
; FAST-NEXT:    movl %edi, %ecx
; FAST-NEXT:    addl %esi, %ecx
; FAST-NEXT:    cmovbl %edi, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.uadd.with.overflow.i32(i32 %v1, i32 %v2)
  %obit = extractvalue {i32, i1} %t, 1
  %ret = select i1 %obit, i32 %v1, i32 %v2
  ret i32 %ret
}

define i64 @uaddoselecti64(i64 %v1, i64 %v2) {
; SDAG-LABEL: uaddoselecti64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movq %rsi, %rax
; SDAG-NEXT:    movq %rdi, %rcx
; SDAG-NEXT:    addq %rsi, %rcx
; SDAG-NEXT:    cmovbq %rdi, %rax
; SDAG-NEXT:    retq
;
; FAST-LABEL: uaddoselecti64:
; FAST:       ## %bb.0:
; FAST-NEXT:    movq %rsi, %rax
; FAST-NEXT:    movq %rdi, %rcx
; FAST-NEXT:    addq %rsi, %rcx
; FAST-NEXT:    cmovbq %rdi, %rax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.uadd.with.overflow.i64(i64 %v1, i64 %v2)
  %obit = extractvalue {i64, i1} %t, 1
  %ret = select i1 %obit, i64 %v1, i64 %v2
  ret i64 %ret
}

define i32 @ssuboselecti32(i32 %v1, i32 %v2) {
; SDAG-LABEL: ssuboselecti32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movl %esi, %eax
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    cmovol %edi, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: ssuboselecti32:
; FAST:       ## %bb.0:
; FAST-NEXT:    movl %esi, %eax
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    cmovol %edi, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.ssub.with.overflow.i32(i32 %v1, i32 %v2)
  %obit = extractvalue {i32, i1} %t, 1
  %ret = select i1 %obit, i32 %v1, i32 %v2
  ret i32 %ret
}

define i64 @ssuboselecti64(i64 %v1, i64 %v2) {
; SDAG-LABEL: ssuboselecti64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movq %rsi, %rax
; SDAG-NEXT:    cmpq %rsi, %rdi
; SDAG-NEXT:    cmovoq %rdi, %rax
; SDAG-NEXT:    retq
;
; FAST-LABEL: ssuboselecti64:
; FAST:       ## %bb.0:
; FAST-NEXT:    movq %rsi, %rax
; FAST-NEXT:    cmpq %rsi, %rdi
; FAST-NEXT:    cmovoq %rdi, %rax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %v1, i64 %v2)
  %obit = extractvalue {i64, i1} %t, 1
  %ret = select i1 %obit, i64 %v1, i64 %v2
  ret i64 %ret
}

define i32 @usuboselecti32(i32 %v1, i32 %v2) {
; SDAG-LABEL: usuboselecti32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movl %esi, %eax
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    cmovbl %edi, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: usuboselecti32:
; FAST:       ## %bb.0:
; FAST-NEXT:    movl %esi, %eax
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    cmovbl %edi, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.usub.with.overflow.i32(i32 %v1, i32 %v2)
  %obit = extractvalue {i32, i1} %t, 1
  %ret = select i1 %obit, i32 %v1, i32 %v2
  ret i32 %ret
}

define i64 @usuboselecti64(i64 %v1, i64 %v2) {
; SDAG-LABEL: usuboselecti64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movq %rsi, %rax
; SDAG-NEXT:    cmpq %rsi, %rdi
; SDAG-NEXT:    cmovbq %rdi, %rax
; SDAG-NEXT:    retq
;
; FAST-LABEL: usuboselecti64:
; FAST:       ## %bb.0:
; FAST-NEXT:    movq %rsi, %rax
; FAST-NEXT:    cmpq %rsi, %rdi
; FAST-NEXT:    cmovbq %rdi, %rax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.usub.with.overflow.i64(i64 %v1, i64 %v2)
  %obit = extractvalue {i64, i1} %t, 1
  %ret = select i1 %obit, i64 %v1, i64 %v2
  ret i64 %ret
}

;
; Check the use of the overflow bit in combination with a branch instruction.
;
define zeroext i1 @saddobri32(i32 %v1, i32 %v2) {
; SDAG-LABEL: saddobri32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addl %esi, %edi
; SDAG-NEXT:    jo LBB31_1
; SDAG-NEXT:  ## %bb.2: ## %continue
; SDAG-NEXT:    movb $1, %al
; SDAG-NEXT:    retq
; SDAG-NEXT:  LBB31_1: ## %overflow
; SDAG-NEXT:    xorl %eax, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddobri32:
; FAST:       ## %bb.0:
; FAST-NEXT:    addl %esi, %edi
; FAST-NEXT:    jo LBB31_1
; FAST-NEXT:  ## %bb.2: ## %continue
; FAST-NEXT:    movb $1, %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
; FAST-NEXT:  LBB31_1: ## %overflow
; FAST-NEXT:    xorl %eax, %eax
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.sadd.with.overflow.i32(i32 %v1, i32 %v2)
  %val = extractvalue {i32, i1} %t, 0
  %obit = extractvalue {i32, i1} %t, 1
  br i1 %obit, label %overflow, label %continue, !prof !0

overflow:
  ret i1 false

continue:
  ret i1 true
}

define zeroext i1 @saddobri64(i64 %v1, i64 %v2) {
; SDAG-LABEL: saddobri64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addq %rsi, %rdi
; SDAG-NEXT:    jo LBB32_1
; SDAG-NEXT:  ## %bb.2: ## %continue
; SDAG-NEXT:    movb $1, %al
; SDAG-NEXT:    retq
; SDAG-NEXT:  LBB32_1: ## %overflow
; SDAG-NEXT:    xorl %eax, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: saddobri64:
; FAST:       ## %bb.0:
; FAST-NEXT:    addq %rsi, %rdi
; FAST-NEXT:    jo LBB32_1
; FAST-NEXT:  ## %bb.2: ## %continue
; FAST-NEXT:    movb $1, %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
; FAST-NEXT:  LBB32_1: ## %overflow
; FAST-NEXT:    xorl %eax, %eax
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %v1, i64 %v2)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  br i1 %obit, label %overflow, label %continue, !prof !0

overflow:
  ret i1 false

continue:
  ret i1 true
}

define zeroext i1 @uaddobri32(i32 %v1, i32 %v2) {
; SDAG-LABEL: uaddobri32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addl %esi, %edi
; SDAG-NEXT:    jb LBB33_1
; SDAG-NEXT:  ## %bb.2: ## %continue
; SDAG-NEXT:    movb $1, %al
; SDAG-NEXT:    retq
; SDAG-NEXT:  LBB33_1: ## %overflow
; SDAG-NEXT:    xorl %eax, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: uaddobri32:
; FAST:       ## %bb.0:
; FAST-NEXT:    addl %esi, %edi
; FAST-NEXT:    jb LBB33_1
; FAST-NEXT:  ## %bb.2: ## %continue
; FAST-NEXT:    movb $1, %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
; FAST-NEXT:  LBB33_1: ## %overflow
; FAST-NEXT:    xorl %eax, %eax
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.uadd.with.overflow.i32(i32 %v1, i32 %v2)
  %val = extractvalue {i32, i1} %t, 0
  %obit = extractvalue {i32, i1} %t, 1
  br i1 %obit, label %overflow, label %continue, !prof !0

overflow:
  ret i1 false

continue:
  ret i1 true
}

define zeroext i1 @uaddobri64(i64 %v1, i64 %v2) {
; SDAG-LABEL: uaddobri64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    addq %rsi, %rdi
; SDAG-NEXT:    jb LBB34_1
; SDAG-NEXT:  ## %bb.2: ## %continue
; SDAG-NEXT:    movb $1, %al
; SDAG-NEXT:    retq
; SDAG-NEXT:  LBB34_1: ## %overflow
; SDAG-NEXT:    xorl %eax, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: uaddobri64:
; FAST:       ## %bb.0:
; FAST-NEXT:    addq %rsi, %rdi
; FAST-NEXT:    jb LBB34_1
; FAST-NEXT:  ## %bb.2: ## %continue
; FAST-NEXT:    movb $1, %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
; FAST-NEXT:  LBB34_1: ## %overflow
; FAST-NEXT:    xorl %eax, %eax
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.uadd.with.overflow.i64(i64 %v1, i64 %v2)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  br i1 %obit, label %overflow, label %continue, !prof !0

overflow:
  ret i1 false

continue:
  ret i1 true
}

define zeroext i1 @ssubobri32(i32 %v1, i32 %v2) {
; SDAG-LABEL: ssubobri32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    jo LBB35_1
; SDAG-NEXT:  ## %bb.2: ## %continue
; SDAG-NEXT:    movb $1, %al
; SDAG-NEXT:    retq
; SDAG-NEXT:  LBB35_1: ## %overflow
; SDAG-NEXT:    xorl %eax, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: ssubobri32:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    jo LBB35_1
; FAST-NEXT:  ## %bb.2: ## %continue
; FAST-NEXT:    movb $1, %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
; FAST-NEXT:  LBB35_1: ## %overflow
; FAST-NEXT:    xorl %eax, %eax
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.ssub.with.overflow.i32(i32 %v1, i32 %v2)
  %val = extractvalue {i32, i1} %t, 0
  %obit = extractvalue {i32, i1} %t, 1
  br i1 %obit, label %overflow, label %continue, !prof !0

overflow:
  ret i1 false

continue:
  ret i1 true
}

define zeroext i1 @ssubobri64(i64 %v1, i64 %v2) {
; SDAG-LABEL: ssubobri64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpq %rsi, %rdi
; SDAG-NEXT:    jo LBB36_1
; SDAG-NEXT:  ## %bb.2: ## %continue
; SDAG-NEXT:    movb $1, %al
; SDAG-NEXT:    retq
; SDAG-NEXT:  LBB36_1: ## %overflow
; SDAG-NEXT:    xorl %eax, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: ssubobri64:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpq %rsi, %rdi
; FAST-NEXT:    jo LBB36_1
; FAST-NEXT:  ## %bb.2: ## %continue
; FAST-NEXT:    movb $1, %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
; FAST-NEXT:  LBB36_1: ## %overflow
; FAST-NEXT:    xorl %eax, %eax
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %v1, i64 %v2)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  br i1 %obit, label %overflow, label %continue, !prof !0

overflow:
  ret i1 false

continue:
  ret i1 true
}

define zeroext i1 @usubobri32(i32 %v1, i32 %v2) {
; SDAG-LABEL: usubobri32:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    jb LBB37_1
; SDAG-NEXT:  ## %bb.2: ## %continue
; SDAG-NEXT:    movb $1, %al
; SDAG-NEXT:    retq
; SDAG-NEXT:  LBB37_1: ## %overflow
; SDAG-NEXT:    xorl %eax, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: usubobri32:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    jb LBB37_1
; FAST-NEXT:  ## %bb.2: ## %continue
; FAST-NEXT:    movb $1, %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
; FAST-NEXT:  LBB37_1: ## %overflow
; FAST-NEXT:    xorl %eax, %eax
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.usub.with.overflow.i32(i32 %v1, i32 %v2)
  %val = extractvalue {i32, i1} %t, 0
  %obit = extractvalue {i32, i1} %t, 1
  br i1 %obit, label %overflow, label %continue, !prof !0

overflow:
  ret i1 false

continue:
  ret i1 true
}

define zeroext i1 @usubobri64(i64 %v1, i64 %v2) {
; SDAG-LABEL: usubobri64:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpq %rsi, %rdi
; SDAG-NEXT:    jb LBB38_1
; SDAG-NEXT:  ## %bb.2: ## %continue
; SDAG-NEXT:    movb $1, %al
; SDAG-NEXT:    retq
; SDAG-NEXT:  LBB38_1: ## %overflow
; SDAG-NEXT:    xorl %eax, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: usubobri64:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpq %rsi, %rdi
; FAST-NEXT:    jb LBB38_1
; FAST-NEXT:  ## %bb.2: ## %continue
; FAST-NEXT:    movb $1, %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
; FAST-NEXT:  LBB38_1: ## %overflow
; FAST-NEXT:    xorl %eax, %eax
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %t = call {i64, i1} @llvm.usub.with.overflow.i64(i64 %v1, i64 %v2)
  %val = extractvalue {i64, i1} %t, 0
  %obit = extractvalue {i64, i1} %t, 1
  br i1 %obit, label %overflow, label %continue, !prof !0

overflow:
  ret i1 false

continue:
  ret i1 true
}

define {i64, i1} @uaddoovf(i64 %a, i64 %b) {
; SDAG-LABEL: uaddoovf:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movzbl %dil, %ecx
; SDAG-NEXT:    movzbl %sil, %eax
; SDAG-NEXT:    addq %rcx, %rax
; SDAG-NEXT:    xorl %edx, %edx
; SDAG-NEXT:    retq
;
; FAST-LABEL: uaddoovf:
; FAST:       ## %bb.0:
; FAST-NEXT:    movzbl %dil, %ecx
; FAST-NEXT:    movzbl %sil, %eax
; FAST-NEXT:    addq %rcx, %rax
; FAST-NEXT:    xorl %edx, %edx
; FAST-NEXT:    retq
  %1 = and i64 %a, 255
  %2 = and i64 %b, 255
  %t = call {i64, i1} @llvm.uadd.with.overflow.i64(i64 %1, i64 %2)
  ret {i64, i1} %t
}

define {i64, i1} @usuboovf(i64 %a, i64 %b) {
; SDAG-LABEL: usuboovf:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movq %rsi, %rax
; SDAG-NEXT:    notq %rax
; SDAG-NEXT:    xorl %edx, %edx
; SDAG-NEXT:    retq
;
; FAST-LABEL: usuboovf:
; FAST:       ## %bb.0:
; FAST-NEXT:    movq %rsi, %rax
; FAST-NEXT:    notq %rax
; FAST-NEXT:    xorl %edx, %edx
; FAST-NEXT:    retq
  %t0 = call {i64, i1} @llvm.usub.with.overflow.i64(i64 %a, i64 %a)
  %v0 = extractvalue {i64, i1} %t0, 0
  %o0 = extractvalue {i64, i1} %t0, 1
  %t1 = call {i64, i1} @llvm.usub.with.overflow.i64(i64 -1, i64 %b)
  %v1 = extractvalue {i64, i1} %t1, 0
  %o1 = extractvalue {i64, i1} %t1, 1
  %oo = or i1 %o0, %o1
  %t2 = call {i64, i1} @llvm.usub.with.overflow.i64(i64 %v1, i64 %v0)
  %v2 = extractvalue {i64, i1} %t2, 0
  %o2 = extractvalue {i64, i1} %t2, 1
  %ooo = or i1 %oo, %o2
  %t = insertvalue {i64, i1} %t2, i1 %ooo, 1
  ret {i64, i1} %t
}

; FIXME: We're selecting both an INC and an ADD here. One of them becomes an LEA.
define i32 @incovfselectstore(i32 %v1, i32 %v2, i32* %x) {
; SDAG-LABEL: incovfselectstore:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movl %esi, %eax
; SDAG-NEXT:    ## kill: def $edi killed $edi def $rdi
; SDAG-NEXT:    leal 1(%rdi), %ecx
; SDAG-NEXT:    movl %edi, %esi
; SDAG-NEXT:    addl $1, %esi
; SDAG-NEXT:    cmovol %edi, %eax
; SDAG-NEXT:    movl %ecx, (%rdx)
; SDAG-NEXT:    retq
;
; FAST-LABEL: incovfselectstore:
; FAST:       ## %bb.0:
; FAST-NEXT:    movl %esi, %eax
; FAST-NEXT:    movl %edi, %ecx
; FAST-NEXT:    incl %ecx
; FAST-NEXT:    cmovol %edi, %eax
; FAST-NEXT:    movl %ecx, (%rdx)
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.sadd.with.overflow.i32(i32 %v1, i32 1)
  %obit = extractvalue {i32, i1} %t, 1
  %ret = select i1 %obit, i32 %v1, i32 %v2
  %val = extractvalue {i32, i1} %t, 0
  store i32 %val, i32* %x
  ret i32 %ret
}

; FIXME: We're selecting both a DEC and a SUB here. DEC becomes an LEA and
; SUB becomes a CMP.
define i32 @decovfselectstore(i32 %v1, i32 %v2, i32* %x) {
; SDAG-LABEL: decovfselectstore:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movl %esi, %eax
; SDAG-NEXT:    ## kill: def $edi killed $edi def $rdi
; SDAG-NEXT:    leal -1(%rdi), %ecx
; SDAG-NEXT:    cmpl $1, %edi
; SDAG-NEXT:    cmovol %edi, %eax
; SDAG-NEXT:    movl %ecx, (%rdx)
; SDAG-NEXT:    retq
;
; FAST-LABEL: decovfselectstore:
; FAST:       ## %bb.0:
; FAST-NEXT:    movl %esi, %eax
; FAST-NEXT:    movl %edi, %ecx
; FAST-NEXT:    decl %ecx
; FAST-NEXT:    cmovol %edi, %eax
; FAST-NEXT:    movl %ecx, (%rdx)
; FAST-NEXT:    retq
  %t = call {i32, i1} @llvm.ssub.with.overflow.i32(i32 %v1, i32 1)
  %obit = extractvalue {i32, i1} %t, 1
  %ret = select i1 %obit, i32 %v1, i32 %v2
  %val = extractvalue {i32, i1} %t, 0
  store i32 %val, i32* %x
  ret i32 %ret
}

declare {i8,  i1} @llvm.sadd.with.overflow.i8 (i8,  i8 ) nounwind readnone
declare {i16, i1} @llvm.sadd.with.overflow.i16(i16, i16) nounwind readnone
declare {i32, i1} @llvm.sadd.with.overflow.i32(i32, i32) nounwind readnone
declare {i64, i1} @llvm.sadd.with.overflow.i64(i64, i64) nounwind readnone
declare {i8,  i1} @llvm.uadd.with.overflow.i8 (i8,  i8 ) nounwind readnone
declare {i16, i1} @llvm.uadd.with.overflow.i16(i16, i16) nounwind readnone
declare {i32, i1} @llvm.uadd.with.overflow.i32(i32, i32) nounwind readnone
declare {i64, i1} @llvm.uadd.with.overflow.i64(i64, i64) nounwind readnone
declare {i32, i1} @llvm.ssub.with.overflow.i32(i32, i32) nounwind readnone
declare {i64, i1} @llvm.ssub.with.overflow.i64(i64, i64) nounwind readnone
declare {i32, i1} @llvm.usub.with.overflow.i32(i32, i32) nounwind readnone
declare {i64, i1} @llvm.usub.with.overflow.i64(i64, i64) nounwind readnone

!0 = !{!"branch_weights", i32 0, i32 2147483647}
