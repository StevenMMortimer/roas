context("OAS Run Live")

roas_setup <- readRDS("roas_setup.rds")
options(roas.account = roas_setup$account)
options(roas.username = roas_setup$username)
options(roas.password = roas_setup$password)

credentials <- oas_build_credentials()

test_that("oas_run_live", {

  expect_error(oas_run_live(credentials, action='TestLiveCampaigns'), 
               "errorCode 680: Error 'Run Live Campaign' queueing Failed")
  
})