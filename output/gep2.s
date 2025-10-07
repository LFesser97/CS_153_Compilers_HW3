	.data
	.globl	tmp
tmp:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -32(%rbp)
	subq	$40, %rsp
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -8(%rbp)
	leaq	tmp(%rip), %rax
	movq	$0, %rcx
	imulq	$40, %rcx
	addq	%rcx, %rax
	movq	$3, %rcx
	imulq	$8, %rcx
	addq	%rcx, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	