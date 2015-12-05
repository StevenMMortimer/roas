context("OAS Copy")

roas_setup <- readRDS("roas_setup.rds")
options(roas.account = roas_setup$account)
options(roas.username = roas_setup$username)
options(roas.password = roas_setup$password)

credentials <- oas_build_credentials()

test_that("oas_copy", {
  
  campgn_list <- oas_list(credentials=credentials, request_type='Campaign')
  
  expect_error(oas_copy(credentials=credentials, 
                          request_type='Campaign', 
                          copy_data=list(newXMLNode('Id', campgn_list$Id[10]), 
                                           newXMLNode('NewId', 'newCampaignId'))), 
               'errorCode 408: You do not have enough permission for this action.')
})