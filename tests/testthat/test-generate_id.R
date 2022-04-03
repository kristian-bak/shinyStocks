test_that("Test: generate_id", {
  
  set.seed(1)
  
  out <- generate_id()
  
  expect_equal(out, "5GnYw9drQ44MaH")
  
})
