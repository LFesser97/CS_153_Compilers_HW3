	.data
	.globl	matrix
matrix:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.quad	5
	.quad	6
	.quad	7
	.quad	8
	.quad	9
	.text
	.globl	validate_matrix
validate_matrix:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -32(%rbp)
	subq	$40, %rsp
	movq	-40(%rbp), %rax
	movq	$3, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -8(%rbp)
	movq	-32(%rbp), %rax
	movq	$3, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %rcx
	andq	%rcx, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	get_element
get_element:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -48(%rbp)
	subq	$64, %rsp
	movq	-64(%rbp), %rax
	movq	$3, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -8(%rbp)
	movq	-48(%rbp), %rax
	movq	$3, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %rcx
	andq	%rcx, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	cmpq	$0, %rax
	je	get_element.invalid
	jmp	get_element.valid
	.text
get_element.valid:
	movq	-56(%rbp), %rax
	movq	$0, %rcx
	imulq	$72, %rcx
	addq	%rcx, %rax
	movq	-64(%rbp), %rcx
	imulq	$24, %rcx
	addq	%rcx, %rax
	movq	-48(%rbp), %rcx
	imulq	$8, %rcx
	addq	%rcx, %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
get_element.invalid:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	det2x2
det2x2:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -32(%rbp)
	movq	%rsi, -40(%rbp)
	movq	%rdx, -48(%rbp)
	movq	%rcx, -56(%rbp)
	subq	$56, %rsp
	movq	-32(%rbp), %rax
	movq	-56(%rbp), %rcx
	imulq	%rcx, %rax
	movq	%rax, -8(%rbp)
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rcx
	imulq	%rcx, %rax
	movq	%rax, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %rcx
	subq	%rcx, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	get_minor
get_minor:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -568(%rbp)
	movq	%rsi, -576(%rbp)
	movq	%rdx, -560(%rbp)
	subq	$576, %rsp
	movq	-576(%rbp), %rax
	movq	$0, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -8(%rbp)
	movq	-560(%rbp), %rax
	movq	$0, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -96(%rbp)
	movq	-8(%rbp), %rax
	movq	-96(%rbp), %rcx
	andq	%rcx, %rax
	movq	%rax, -184(%rbp)
	movq	-184(%rbp), %rax
	cmpq	$0, %rax
	je	get_minor.check_01
	jmp	get_minor.minor_00
	.text
get_minor.minor_00:
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$1, %rsi
	movq	$1, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -272(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$2, %rsi
	movq	$2, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -360(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$1, %rsi
	movq	$2, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -448(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$2, %rsi
	movq	$1, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -536(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-272(%rbp), %rdi
	movq	-448(%rbp), %rsi
	movq	-536(%rbp), %rdx
	movq	-360(%rbp), %rcx
	leaq	det2x2(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -544(%rbp)
	movq	-544(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
get_minor.check_01:
	movq	-576(%rbp), %rax
	movq	$0, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -552(%rbp)
	movq	-560(%rbp), %rax
	movq	$1, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -16(%rbp)
	movq	-552(%rbp), %rax
	movq	-16(%rbp), %rcx
	andq	%rcx, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	cmpq	$0, %rax
	je	get_minor.check_02
	jmp	get_minor.minor_01
	.text
get_minor.minor_01:
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$1, %rsi
	movq	$0, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -32(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$2, %rsi
	movq	$2, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -40(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$1, %rsi
	movq	$2, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -48(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$2, %rsi
	movq	$0, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -56(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-32(%rbp), %rdi
	movq	-48(%rbp), %rsi
	movq	-56(%rbp), %rdx
	movq	-40(%rbp), %rcx
	leaq	det2x2(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
get_minor.check_02:
	movq	-576(%rbp), %rax
	movq	$0, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -72(%rbp)
	movq	-560(%rbp), %rax
	movq	$2, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -80(%rbp)
	movq	-72(%rbp), %rax
	movq	-80(%rbp), %rcx
	andq	%rcx, %rax
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	cmpq	$0, %rax
	je	get_minor.check_10
	jmp	get_minor.minor_02
	.text
get_minor.minor_02:
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$1, %rsi
	movq	$0, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -104(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$2, %rsi
	movq	$1, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -112(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$1, %rsi
	movq	$1, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -120(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$2, %rsi
	movq	$0, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -128(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-104(%rbp), %rdi
	movq	-120(%rbp), %rsi
	movq	-128(%rbp), %rdx
	movq	-112(%rbp), %rcx
	leaq	det2x2(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
get_minor.check_10:
	movq	-576(%rbp), %rax
	movq	$1, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -144(%rbp)
	movq	-560(%rbp), %rax
	movq	$0, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -152(%rbp)
	movq	-144(%rbp), %rax
	movq	-152(%rbp), %rcx
	andq	%rcx, %rax
	movq	%rax, -160(%rbp)
	movq	-160(%rbp), %rax
	cmpq	$0, %rax
	je	get_minor.check_11
	jmp	get_minor.minor_10
	.text
get_minor.minor_10:
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$0, %rsi
	movq	$1, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -168(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$2, %rsi
	movq	$2, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -176(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$0, %rsi
	movq	$2, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -192(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$2, %rsi
	movq	$1, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -200(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-168(%rbp), %rdi
	movq	-192(%rbp), %rsi
	movq	-200(%rbp), %rdx
	movq	-176(%rbp), %rcx
	leaq	det2x2(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -208(%rbp)
	movq	-208(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
get_minor.check_11:
	movq	-576(%rbp), %rax
	movq	$1, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -216(%rbp)
	movq	-560(%rbp), %rax
	movq	$1, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -224(%rbp)
	movq	-216(%rbp), %rax
	movq	-224(%rbp), %rcx
	andq	%rcx, %rax
	movq	%rax, -232(%rbp)
	movq	-232(%rbp), %rax
	cmpq	$0, %rax
	je	get_minor.check_12
	jmp	get_minor.minor_11
	.text
get_minor.minor_11:
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$0, %rsi
	movq	$0, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -240(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$2, %rsi
	movq	$2, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -248(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$0, %rsi
	movq	$2, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -256(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$2, %rsi
	movq	$0, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -264(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-240(%rbp), %rdi
	movq	-256(%rbp), %rsi
	movq	-264(%rbp), %rdx
	movq	-248(%rbp), %rcx
	leaq	det2x2(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -280(%rbp)
	movq	-280(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
get_minor.check_12:
	movq	-576(%rbp), %rax
	movq	$1, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -288(%rbp)
	movq	-560(%rbp), %rax
	movq	$2, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -296(%rbp)
	movq	-288(%rbp), %rax
	movq	-296(%rbp), %rcx
	andq	%rcx, %rax
	movq	%rax, -304(%rbp)
	movq	-304(%rbp), %rax
	cmpq	$0, %rax
	je	get_minor.check_20
	jmp	get_minor.minor_12
	.text
get_minor.minor_12:
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$0, %rsi
	movq	$0, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -312(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$2, %rsi
	movq	$1, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -320(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$0, %rsi
	movq	$1, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -328(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$2, %rsi
	movq	$0, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -336(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-312(%rbp), %rdi
	movq	-328(%rbp), %rsi
	movq	-336(%rbp), %rdx
	movq	-320(%rbp), %rcx
	leaq	det2x2(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -344(%rbp)
	movq	-344(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
get_minor.check_20:
	movq	-576(%rbp), %rax
	movq	$2, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -352(%rbp)
	movq	-560(%rbp), %rax
	movq	$0, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -368(%rbp)
	movq	-352(%rbp), %rax
	movq	-368(%rbp), %rcx
	andq	%rcx, %rax
	movq	%rax, -376(%rbp)
	movq	-376(%rbp), %rax
	cmpq	$0, %rax
	je	get_minor.check_21
	jmp	get_minor.minor_20
	.text
get_minor.minor_20:
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$0, %rsi
	movq	$1, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -384(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$1, %rsi
	movq	$2, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -392(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$0, %rsi
	movq	$2, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -400(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$1, %rsi
	movq	$1, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -408(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-384(%rbp), %rdi
	movq	-400(%rbp), %rsi
	movq	-408(%rbp), %rdx
	movq	-392(%rbp), %rcx
	leaq	det2x2(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -416(%rbp)
	movq	-416(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
get_minor.check_21:
	movq	-576(%rbp), %rax
	movq	$2, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -424(%rbp)
	movq	-560(%rbp), %rax
	movq	$1, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -432(%rbp)
	movq	-424(%rbp), %rax
	movq	-432(%rbp), %rcx
	andq	%rcx, %rax
	movq	%rax, -440(%rbp)
	movq	-440(%rbp), %rax
	cmpq	$0, %rax
	je	get_minor.minor_22
	jmp	get_minor.minor_21
	.text
get_minor.minor_21:
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$0, %rsi
	movq	$0, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -456(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$1, %rsi
	movq	$2, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -464(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$0, %rsi
	movq	$2, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -472(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$1, %rsi
	movq	$0, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -480(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-456(%rbp), %rdi
	movq	-472(%rbp), %rsi
	movq	-480(%rbp), %rdx
	movq	-464(%rbp), %rcx
	leaq	det2x2(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -488(%rbp)
	movq	-488(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
get_minor.minor_22:
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$0, %rsi
	movq	$0, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -496(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$1, %rsi
	movq	$1, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -504(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$0, %rsi
	movq	$1, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -512(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-568(%rbp), %rdi
	movq	$1, %rsi
	movq	$0, %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -520(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	-496(%rbp), %rdi
	movq	-512(%rbp), %rsi
	movq	-520(%rbp), %rdx
	movq	-504(%rbp), %rcx
	leaq	det2x2(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -528(%rbp)
	movq	-528(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	compute_determinant
compute_determinant:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$224, %rsp
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -200(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -208(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -216(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -224(%rbp)
	movq	$0, %rax
	movq	-200(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-208(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$1, %rax
	movq	-216(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	compute_determinant.loop
	.text
compute_determinant.loop:
	movq	-208(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	$3, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -80(%rbp)
	movq	-80(%rbp), %rax
	cmpq	$0, %rax
	je	compute_determinant.done
	jmp	compute_determinant.body
	.text
compute_determinant.body:
	movq	-208(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -88(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	leaq	matrix(%rip), %rdi
	movq	$0, %rsi
	movq	-88(%rbp), %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -96(%rbp)
	movq	-208(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -104(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	leaq	matrix(%rip), %rdi
	movq	$0, %rsi
	movq	-104(%rbp), %rdx
	leaq	get_minor(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -112(%rbp)
	movq	-96(%rbp), %rax
	movq	-112(%rbp), %rcx
	imulq	%rcx, %rax
	movq	%rax, -120(%rbp)
	movq	-216(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -128(%rbp)
	movq	-120(%rbp), %rax
	movq	-128(%rbp), %rcx
	imulq	%rcx, %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	movq	-224(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-200(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -16(%rbp)
	movq	-224(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -24(%rbp)
	movq	-16(%rbp), %rax
	movq	-24(%rbp), %rcx
	addq	%rcx, %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	-200(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-216(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	$-1, %rcx
	imulq	%rcx, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	-216(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-208(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	$1, %rcx
	addq	%rcx, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	-208(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	compute_determinant.loop
	.text
compute_determinant.done:
	movq	-200(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	test_bitcast
test_bitcast:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	leaq	matrix(%rip), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -32(%rbp)
	movq	%rsi, -40(%rbp)
	subq	$40, %rsp
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	$3, %rdi
	movq	$3, %rsi
	leaq	validate_matrix(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	$1, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	cmpq	$0, %rax
	je	main.invalid_size
	jmp	main.valid_size
	.text
main.valid_size:
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	leaq	compute_determinant(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
main.invalid_size:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	