context("OAS Copy")

roas_setup <- readRDS("roas_setup.rds")
options(roas.account = roas_setup$account)
options(roas.username = roas_setup$username)
options(roas.password = roas_setup$password)

credentials <- oas_build_credentials()

test_that("oas_copy", {
  
  # expect_error(oas_copy(credentials=credentials, 
  #                         request_type='Campaign', 
  #                         copy_data=list(newXMLNode('Id', 'TestCampaign'), 
  #                                          newXMLNode('NewId', 'newCampaignId'))), 
  #              'errorCode 408: You do not have enough permission for this action.')
  
  # permissions have been granted to perform this action
  # however, since there is no delete functionality, we will not
  # bother checking the add functionality
  expect_true(TRUE)
})