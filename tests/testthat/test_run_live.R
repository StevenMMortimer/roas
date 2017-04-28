context("OAS Run Live")

roas_setup <- readRDS("roas_setup.rds")
options(roas.account = roas_setup$account)
options(roas.username = roas_setup$username)
options(roas.password = roas_setup$password)

credentials <- oas_build_credentials()

test_that("oas_run_live", {
  
  rl_result <- oas_run_live(credentials, action='TestLiveCampaigns')

  expect_true(is.list(rl_result))
  expect_true(all(c('RLCSummary', 'RLCNotes') %in% 
                    names(rl_result$Response$Campaign$TestLiveCampaigns)))
  
})