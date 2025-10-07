	.data
	.globl	matrix_a
matrix_a:
	.quad	1
	.quad	2
	.quad	3
	.quad	4
	.data
	.globl	matrix_b
matrix_b:
	.quad	5
	.quad	6
	.quad	7
	.quad	8
	.data
	.globl	result
result:
	.quad	0
	.quad	0
	.quad	0
	.quad	0
	.text
	.globl	validate_matrix
validate_matrix:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -32(%rbp)
	subq	$40, %rsp
	movq	-40(%rbp), %rax
	movq	$2, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	sete	%al
	movq	%rax, -8(%rbp)
	movq	-32(%rbp), %rax
	movq	$2, %rcx
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
	movq	$2, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -8(%rbp)
	movq	-48(%rbp), %rax
	movq	$2, %rcx
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
	imulq	$32, %rcx
	addq	%rcx, %rax
	movq	-64(%rbp), %rcx
	imulq	$16, %rcx
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
	.globl	set_element
set_element:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -48(%rbp)
	movq	%rcx, -72(%rbp)
	subq	$72, %rsp
	movq	-64(%rbp), %rax
	movq	$2, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -8(%rbp)
	movq	-48(%rbp), %rax
	movq	$2, %rcx
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
	je	set_element.invalid
	jmp	set_element.valid
	.text
set_element.valid:
	movq	-56(%rbp), %rax
	movq	$0, %rcx
	imulq	$32, %rcx
	addq	%rcx, %rax
	movq	-64(%rbp), %rcx
	imulq	$16, %rcx
	addq	%rcx, %rax
	movq	-48(%rbp), %rcx
	imulq	$8, %rcx
	addq	%rcx, %rax
	movq	%rax, -32(%rbp)
	movq	-72(%rbp), %rax
	movq	-32(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	set_element.end
	.text
set_element.invalid:
	jmp	set_element.end
	.text
set_element.end:
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	multiply_matrices
multiply_matrices:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$296, %rsp
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -288(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -272(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -280(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -296(%rbp)
	movq	$0, %rax
	movq	-288(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	multiply_matrices.outer_loop
	.text
multiply_matrices.outer_loop:
	movq	-288(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	$2, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	cmpq	$0, %rax
	je	multiply_matrices.done
	jmp	multiply_matrices.inner_loop
	.text
multiply_matrices.inner_loop:
	movq	-272(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -144(%rbp)
	movq	-144(%rbp), %rax
	movq	$2, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -152(%rbp)
	movq	-152(%rbp), %rax
	cmpq	$0, %rax
	je	multiply_matrices.next_row
	jmp	multiply_matrices.compute
	.text
multiply_matrices.compute:
	movq	$0, %rax
	movq	-296(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-280(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	multiply_matrices.k_loop
	.text
multiply_matrices.k_loop:
	movq	-280(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -160(%rbp)
	movq	-160(%rbp), %rax
	movq	$2, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -168(%rbp)
	movq	-168(%rbp), %rax
	cmpq	$0, %rax
	je	multiply_matrices.store_result
	jmp	multiply_matrices.multiply
	.text
multiply_matrices.multiply:
	movq	-288(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -176(%rbp)
	movq	-280(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -184(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	leaq	matrix_a(%rip), %rdi
	movq	-176(%rbp), %rsi
	movq	-184(%rbp), %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -192(%rbp)
	movq	-280(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -16(%rbp)
	movq	-272(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -24(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	leaq	matrix_b(%rip), %rdi
	movq	-16(%rbp), %rsi
	movq	-24(%rbp), %rdx
	leaq	get_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -32(%rbp)
	movq	-192(%rbp), %rax
	movq	-32(%rbp), %rcx
	imulq	%rcx, %rax
	movq	%rax, -40(%rbp)
	movq	-296(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rcx
	addq	%rcx, %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	-296(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-280(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	$1, %rcx
	addq	%rcx, %rax
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	-280(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	multiply_matrices.k_loop
	.text
multiply_matrices.store_result:
	movq	-288(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -80(%rbp)
	movq	-272(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -88(%rbp)
	movq	-296(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -104(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	leaq	result(%rip), %rdi
	movq	-80(%rbp), %rsi
	movq	-88(%rbp), %rdx
	movq	-104(%rbp), %rcx
	leaq	set_element(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -200(%rbp)
	movq	-272(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	$1, %rcx
	addq	%rcx, %rax
	movq	%rax, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	-272(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	multiply_matrices.inner_loop
	.text
multiply_matrices.next_row:
	movq	-288(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -128(%rbp)
	movq	-128(%rbp), %rax
	movq	$1, %rcx
	addq	%rcx, %rax
	movq	%rax, -136(%rbp)
	movq	-136(%rbp), %rax
	movq	-288(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-272(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	multiply_matrices.outer_loop
	.text
multiply_matrices.done:
	movq	$1, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	compute_checksum
compute_checksum:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$184, %rsp
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -184(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -176(%rbp)
	subq	$8, %rsp
	movq	%rsp, %rax
	movq	%rax, -168(%rbp)
	movq	$0, %rax
	movq	-184(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-176(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	compute_checksum.outer_loop
	.text
compute_checksum.outer_loop:
	movq	-176(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	$2, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	cmpq	$0, %rax
	je	compute_checksum.done
	jmp	compute_checksum.inner_loop
	.text
compute_checksum.inner_loop:
	movq	-168(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	$2, %rcx
	cmpq	%rcx, %rax
	movq	$0, %rax
	setl	%al
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	cmpq	$0, %rax
	je	compute_checksum.next_row
	jmp	compute_checksum.add_element
	.text
compute_checksum.add_element:
	movq	-176(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -80(%rbp)
	movq	-168(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -88(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	leaq	result(%rip), %rdi
	movq	-80(%rbp), %rsi
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
	movq	-184(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	-96(%rbp), %rcx
	addq	%rcx, %rax
	movq	%rax, -112(%rbp)
	movq	-112(%rbp), %rax
	movq	-184(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	-168(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	$1, %rcx
	addq	%rcx, %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	-168(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	compute_checksum.inner_loop
	.text
compute_checksum.next_row:
	movq	-176(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	$1, %rcx
	addq	%rcx, %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	-176(%rbp), %rcx
	movq	%rax, (%rcx)
	movq	$0, %rax
	movq	-168(%rbp), %rcx
	movq	%rax, (%rcx)
	jmp	compute_checksum.outer_loop
	.text
compute_checksum.done:
	movq	-184(%rbp), %rcx
	movq	(%rcx), %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
	.globl	test_bitcast
test_bitcast:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	leaq	result(%rip), %rax
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
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	subq	$64, %rsp
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	movq	$2, %rdi
	movq	$2, %rsi
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
	leaq	multiply_matrices(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -24(%rbp)
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq	%r8 
	pushq	%r9 
	leaq	compute_checksum(%rip), %rax
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
	leaq	test_bitcast(%rip), %rax
	callq	*%rax
	popq	%r9 
	popq	%r8 
	popq	%rdi
	popq	%rsi
	popq	%rdx
	popq	%rcx
	movq	%rax, -40(%rbp)
	movq	-32(%rbp), %rax
	movq	-40(%rbp), %rcx
	addq	%rcx, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	
	.text
main.invalid_size:
	movq	$0, %rax
	movq	%rbp, %rsp
	popq	%rbp
	retq	