context("OAS Read")

roas_setup <- readRDS("roas_setup.rds")
options(roas.account = roas_setup$account)
options(roas.username = roas_setup$username)
options(roas.password = roas_setup$password)

credentials <- build_credentials()
site <- roas_setup$site

test_that("oas_read", {
  
  site_details <- oas_read(credentials=credentials, 
                           request_type='Site', 
                           id=site)
  
  expect_true(is.list(site_details))
  expect_equal(length(site_details), 1)
  expect_true(all(c('Id', 'Name', 'Domain') %in% names(site_details$Response$Site)))
  
})
