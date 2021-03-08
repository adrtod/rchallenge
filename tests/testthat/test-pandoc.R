test_that("pandoc available", {
  skip_on_cran()
  expect_true(rmarkdown::pandoc_available('1.12.3'))
})
