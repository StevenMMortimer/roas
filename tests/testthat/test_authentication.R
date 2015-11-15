context("Authentication")

roas_setup <- readRDS("roas_setup.rds")
options(roas.account = roas_setup$account)
options(roas.username = roas_setup$username)
options(roas.password = roas_setup$password)

test_that("Credentials are built", {
  
  credentials <- build_credentials()
  
  expect_true(is.character(credentials))
  expect_true(grepl('<String_1>', credentials))
  expect_true(grepl('<String_2>', credentials))
  expect_true(grepl('<String_3>', credentials))

})