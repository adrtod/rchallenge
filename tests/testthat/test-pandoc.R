test_that("pandoc available", {
  expect_true(rmarkdown::pandoc_available('1.12.3'))
})
