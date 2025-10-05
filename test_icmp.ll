define i64 @test_icmp(i64 %a, i64 %b) {
  %cmp = icmp eq i64 %a, %b
  br i1 %cmp, label %then, label %else
then:
  ret i64 1
else:
  ret i64 0
}