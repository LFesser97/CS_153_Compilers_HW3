	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -16(%rbp)
	movq	%rsi, -8(%rbp)
	subq	$16, %rsp
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	