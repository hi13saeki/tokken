	.file	"chklic.c"
	.globl	ACTIVATION_CODE
	.data
	.align 4
	.type	ACTIVATION_CODE, @object
	.size	ACTIVATION_CODE, 4
ACTIVATION_CODE:
	.long	42
	.globl	EXPIRE_TIME
	.align 32
	.type	EXPIRE_TIME, @object
	.size	EXPIRE_TIME, 56
EXPIRE_TIME:
	.long	0
	.long	0
	.long	0
	.long	10
	.long	8
	.long	115
	.long	0
	.long	0
	.long	0
	.zero	20
	.section	.rodata
.LC0:
	.string	"Your license is renewed."
.LC1:
	.string	"ok"
	.text
	.globl	renewlicense
	.type	renewlicense, @function
renewlicense:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$.LC0, %edi
	call	puts
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	renewlicense, .-renewlicense
	.section	.rodata
.LC2:
	.string	"Your license is expired."
.LC3:
	.string	"Enter activation code: "
.LC4:
	.string	"%s"
.LC5:
	.string	"code"
.LC6:
	.string	"OK"
.LC7:
	.string	"Wrong code."
	.text
	.globl	checklicense
	.type	checklicense, @function
checklicense:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	time
	movl	$EXPIRE_TIME, %edi
	call	mktime
	movq	%rax, %rdx
	movq	-56(%rbp), %rax
	cmpq	%rax, %rdx
	jge	.L3
	movl	$.LC2, %edi
	call	puts
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
	leaq	-48(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC4, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	leaq	-48(%rbp), %rax
	movl	$.LC5, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L4
	movl	$.LC6, %edi
	call	puts
	call	renewlicense
	jmp	.L3
.L4:
	movl	$.LC7, %edi
	call	puts
	movl	$-1, %eax
	jmp	.L6
.L3:
	movl	$0, %eax
.L6:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L7
	call	__stack_chk_fail
.L7:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	checklicense, .-checklicense
	.globl	main
	.type	main, @function
main:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	call	checklicense
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.12) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
