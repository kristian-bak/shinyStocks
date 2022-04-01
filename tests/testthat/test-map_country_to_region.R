test_that("Test: map_country_to_region", {
  
  expect_equal(map_country_to_region(x = "Germany"), "Europe")
  
  expect_equal(map_country_to_region(x = "China"), "Emerging Markets")
  
  expect_equal(map_country_to_region(x = "Canada"), "Other")
  
  expect_equal(map_country_to_region(x = "United States"), "USA")
  
  expect_equal(map_country_to_region(x = "Denmark"), "Denmark")
  
  expect_equal(map_country_to_region(x = "Japan"), "Japan")
  
})
