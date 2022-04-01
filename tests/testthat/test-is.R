test_that("Test: is_blank + is_is_not_blank + is_not_null", {
  
  expect_true(is_blank(""))
  
  expect_true(is_not_blank("a"))
  
  expect_true(is_not_null("a"))
  
})
