; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686--
; RUN: llc -pre-RA-sched=source < %s -mtriple=i686-unknown-linux -mcpu=corei7 | FileCheck %s --check-prefix=SOURCE-SCHED
; PR2748

@g_73 = external global i32
@g_5 = external global i32

define i32 @func_44(i16 signext %p_46) nounwind {
; SOURCE-SCHED-LABEL: func_44:
; SOURCE-SCHED:       # %bb.0: # %entry
; SOURCE-SCHED-NEXT:    subl $12, %esp
; SOURCE-SCHED-NEXT:    movl g_5, %eax
; SOURCE-SCHED-NEXT:    sarl %eax
; SOURCE-SCHED-NEXT:    xorl %ecx, %ecx
; SOURCE-SCHED-NEXT:    cmpl $1, %eax
; SOURCE-SCHED-NEXT:    setg %cl
; SOURCE-SCHED-NEXT:    movb g_73, %dl
; SOURCE-SCHED-NEXT:    xorl %eax, %eax
; SOURCE-SCHED-NEXT:    subl {{[0-9]+}}(%esp), %eax
; SOURCE-SCHED-NEXT:    testb %dl, %dl
; SOURCE-SCHED-NEXT:    jne .LBB0_2
; SOURCE-SCHED-NEXT:  # %bb.1: # %bb11
; SOURCE-SCHED-NEXT:    movzbl %al, %eax
; SOURCE-SCHED-NEXT:    # kill: def $eax killed $eax def $ax
; SOURCE-SCHED-NEXT:    divb %dl
; SOURCE-SCHED-NEXT:    movzbl %ah, %eax
; SOURCE-SCHED-NEXT:  .LBB0_2: # %bb12
; SOURCE-SCHED-NEXT:    xorl %edx, %edx
; SOURCE-SCHED-NEXT:    testb %al, %al
; SOURCE-SCHED-NEXT:    setne %dl
; SOURCE-SCHED-NEXT:    subl $4, %esp
; SOURCE-SCHED-NEXT:    pushl $0
; SOURCE-SCHED-NEXT:    pushl %ecx
; SOURCE-SCHED-NEXT:    pushl %edx
; SOURCE-SCHED-NEXT:    calll func_48
; SOURCE-SCHED-NEXT:    addl $28, %esp
; SOURCE-SCHED-NEXT:    retl
entry:
	%0 = load i32, i32* @g_5, align 4
	%1 = ashr i32 %0, 1
	%2 = icmp sgt i32 %1, 1
	%3 = zext i1 %2 to i32
	%4 = load i32, i32* @g_73, align 4
	%5 = zext i16 %p_46 to i64
	%6 = sub i64 0, %5
	%7 = trunc i64 %6 to i8
	%8 = trunc i32 %4 to i8
	%9 = icmp eq i8 %8, 0
	br i1 %9, label %bb11, label %bb12

bb11:
	%10 = urem i8 %7, %8
	br label %bb12

bb12:
	%.014.in = phi i8 [ %10, %bb11 ], [ %7, %entry ]
	%11 = icmp ne i8 %.014.in, 0
	%12 = zext i1 %11 to i32
	%13 = tail call i32 (...) @func_48( i32 %12, i32 %3, i32 0 ) nounwind
	ret i32 undef
}

declare i32 @func_48(...)
