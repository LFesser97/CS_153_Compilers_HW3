define i64 @bar(i64 %x1) {
  ret i64 1
}

define i64 @foo(i64 %x1) {
  %1 = call i64 @bar(i64 0)
  ret i64 %x1
}

define i64 @main(i64 %argc, i8** %arcv) {
  %1 = call i64 @foo(i64 1)
  ret i64 %1
}
