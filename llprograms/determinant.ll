; 3x3 Matrix Determinant computation test case

%vec = type [3 x i64]
%mat = type [3 x %vec]

@matrix = global %mat [ %vec [ i64 1, i64 2, i64 3 ], 
                       %vec [ i64 4, i64 5, i64 6 ], 
                       %vec [ i64 7, i64 8, i64 9 ] ]

; Helper function to validate matrix dimensions
define i1 @validate_matrix(i64 %rows, i64 %cols) {
  %1 = icmp eq i64 %rows, 3
  %2 = icmp eq i64 %cols, 3
  %3 = and i1 %1, %2
  ret i1 %3
}

; Helper function to get element from matrix
define i64 @get_element(%mat* %matrix, i64 %row, i64 %col) {
  %1 = icmp slt i64 %row, 3
  %2 = icmp slt i64 %col, 3
  %3 = and i1 %1, %2
  br i1 %3, label %valid, label %invalid
  
valid:
  %4 = getelementptr %mat, %mat* %matrix, i32 0, i64 %row, i64 %col
  %5 = load i64, i64* %4
  ret i64 %5
  
invalid:
  ret i64 0
}

; Helper function to compute 2x2 determinant
define i64 @det2x2(i64 %a, i64 %b, i64 %c, i64 %d) {
  %1 = mul i64 %a, %d
  %2 = mul i64 %b, %c
  %3 = sub i64 %1, %2
  ret i64 %3
}

; Helper function to get minor matrix element (for determinant calculation)
define i64 @get_minor(%mat* %matrix, i64 %row, i64 %col) {
  %1 = icmp eq i64 %row, 0
  %2 = icmp eq i64 %col, 0
  %3 = and i1 %1, %2
  br i1 %3, label %minor_00, label %check_01
  
minor_00:
  %4 = call i64 @get_element(%mat* %matrix, i64 1, i64 1)
  %5 = call i64 @get_element(%mat* %matrix, i64 2, i64 2)
  %6 = call i64 @get_element(%mat* %matrix, i64 1, i64 2)
  %7 = call i64 @get_element(%mat* %matrix, i64 2, i64 1)
  %8 = call i64 @det2x2(i64 %4, i64 %6, i64 %7, i64 %5)
  ret i64 %8
  
check_01:
  %9 = icmp eq i64 %row, 0
  %10 = icmp eq i64 %col, 1
  %11 = and i1 %9, %10
  br i1 %11, label %minor_01, label %check_02
  
minor_01:
  %12 = call i64 @get_element(%mat* %matrix, i64 1, i64 0)
  %13 = call i64 @get_element(%mat* %matrix, i64 2, i64 2)
  %14 = call i64 @get_element(%mat* %matrix, i64 1, i64 2)
  %15 = call i64 @get_element(%mat* %matrix, i64 2, i64 0)
  %16 = call i64 @det2x2(i64 %12, i64 %14, i64 %15, i64 %13)
  ret i64 %16
  
check_02:
  %17 = icmp eq i64 %row, 0
  %18 = icmp eq i64 %col, 2
  %19 = and i1 %17, %18
  br i1 %19, label %minor_02, label %check_10
  
minor_02:
  %20 = call i64 @get_element(%mat* %matrix, i64 1, i64 0)
  %21 = call i64 @get_element(%mat* %matrix, i64 2, i64 1)
  %22 = call i64 @get_element(%mat* %matrix, i64 1, i64 1)
  %23 = call i64 @get_element(%mat* %matrix, i64 2, i64 0)
  %24 = call i64 @det2x2(i64 %20, i64 %22, i64 %23, i64 %21)
  ret i64 %24
  
check_10:
  %25 = icmp eq i64 %row, 1
  %26 = icmp eq i64 %col, 0
  %27 = and i1 %25, %26
  br i1 %27, label %minor_10, label %check_11
  
minor_10:
  %28 = call i64 @get_element(%mat* %matrix, i64 0, i64 1)
  %29 = call i64 @get_element(%mat* %matrix, i64 2, i64 2)
  %30 = call i64 @get_element(%mat* %matrix, i64 0, i64 2)
  %31 = call i64 @get_element(%mat* %matrix, i64 2, i64 1)
  %32 = call i64 @det2x2(i64 %28, i64 %30, i64 %31, i64 %29)
  ret i64 %32
  
check_11:
  %33 = icmp eq i64 %row, 1
  %34 = icmp eq i64 %col, 1
  %35 = and i1 %33, %34
  br i1 %35, label %minor_11, label %check_12
  
minor_11:
  %36 = call i64 @get_element(%mat* %matrix, i64 0, i64 0)
  %37 = call i64 @get_element(%mat* %matrix, i64 2, i64 2)
  %38 = call i64 @get_element(%mat* %matrix, i64 0, i64 2)
  %39 = call i64 @get_element(%mat* %matrix, i64 2, i64 0)
  %40 = call i64 @det2x2(i64 %36, i64 %38, i64 %39, i64 %37)
  ret i64 %40
  
check_12:
  %41 = icmp eq i64 %row, 1
  %42 = icmp eq i64 %col, 2
  %43 = and i1 %41, %42
  br i1 %43, label %minor_12, label %check_20
  
minor_12:
  %44 = call i64 @get_element(%mat* %matrix, i64 0, i64 0)
  %45 = call i64 @get_element(%mat* %matrix, i64 2, i64 1)
  %46 = call i64 @get_element(%mat* %matrix, i64 0, i64 1)
  %47 = call i64 @get_element(%mat* %matrix, i64 2, i64 0)
  %48 = call i64 @det2x2(i64 %44, i64 %46, i64 %47, i64 %45)
  ret i64 %48
  
check_20:
  %49 = icmp eq i64 %row, 2
  %50 = icmp eq i64 %col, 0
  %51 = and i1 %49, %50
  br i1 %51, label %minor_20, label %check_21
  
minor_20:
  %52 = call i64 @get_element(%mat* %matrix, i64 0, i64 1)
  %53 = call i64 @get_element(%mat* %matrix, i64 1, i64 2)
  %54 = call i64 @get_element(%mat* %matrix, i64 0, i64 2)
  %55 = call i64 @get_element(%mat* %matrix, i64 1, i64 1)
  %56 = call i64 @det2x2(i64 %52, i64 %54, i64 %55, i64 %53)
  ret i64 %56
  
check_21:
  %57 = icmp eq i64 %row, 2
  %58 = icmp eq i64 %col, 1
  %59 = and i1 %57, %58
  br i1 %59, label %minor_21, label %minor_22
  
minor_21:
  %60 = call i64 @get_element(%mat* %matrix, i64 0, i64 0)
  %61 = call i64 @get_element(%mat* %matrix, i64 1, i64 2)
  %62 = call i64 @get_element(%mat* %matrix, i64 0, i64 2)
  %63 = call i64 @get_element(%mat* %matrix, i64 1, i64 0)
  %64 = call i64 @det2x2(i64 %60, i64 %62, i64 %63, i64 %61)
  ret i64 %64
  
minor_22:
  %65 = call i64 @get_element(%mat* %matrix, i64 0, i64 0)
  %66 = call i64 @get_element(%mat* %matrix, i64 1, i64 1)
  %67 = call i64 @get_element(%mat* %matrix, i64 0, i64 1)
  %68 = call i64 @get_element(%mat* %matrix, i64 1, i64 0)
  %69 = call i64 @det2x2(i64 %65, i64 %67, i64 %68, i64 %66)
  ret i64 %69
}

; Helper function to compute 3x3 determinant using Laplace expansion
define i64 @compute_determinant() {
  %det = alloca i64
  %i = alloca i64
  %sign = alloca i64
  %term = alloca i64
  
  store i64 0, i64* %det
  store i64 0, i64* %i
  store i64 1, i64* %sign
  br label %loop
  
loop:
  %1 = load i64, i64* %i
  %2 = icmp slt i64 %1, 3
  br i1 %2, label %body, label %done
  
body:
  %3 = load i64, i64* %i
  %4 = call i64 @get_element(%mat* @matrix, i64 0, i64 %3)
  %5 = load i64, i64* %i
  %6 = call i64 @get_minor(%mat* @matrix, i64 0, i64 %5)
  %7 = mul i64 %4, %6
  %8 = load i64, i64* %sign
  %9 = mul i64 %7, %8
  store i64 %9, i64* %term
  %10 = load i64, i64* %det
  %11 = load i64, i64* %term
  %12 = add i64 %10, %11
  store i64 %12, i64* %det
  %13 = load i64, i64* %sign
  %14 = mul i64 %13, -1
  store i64 %14, i64* %sign
  %15 = load i64, i64* %i
  %16 = add i64 %15, 1
  store i64 %16, i64* %i
  br label %loop
  
done:
  %17 = load i64, i64* %det
  ret i64 %17
}

; Helper function to test bitcast
define i64 @test_bitcast() {
  %1 = bitcast %mat* @matrix to i64*
  %2 = load i64, i64* %1
  ret i64 %2
}

; Main function
define i64 @main(i64 %argc, i8** %argv) {
  %1 = call i1 @validate_matrix(i64 3, i64 3)
  %2 = icmp eq i1 %1, 1
  br i1 %2, label %valid_size, label %invalid_size
  
valid_size:
  %3 = call i64 @compute_determinant()
  ret i64 %3
  
invalid_size:
  ret i64 0
}