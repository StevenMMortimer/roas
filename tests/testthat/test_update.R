context("OAS Update")

roas_setup <- readRDS("roas_setup.rds")
options(roas.account = roas_setup$account)
options(roas.username = roas_setup$username)
options(roas.password = roas_setup$password)

credentials <- oas_build_credentials()
site <- roas_setup$site

test_that("oas_update", {
  
  advertiser_list <- oas_list(credentials=credentials, request_type='Advertiser')
  
  expect_error(oas_update(credentials=credentials, 
                          request_type='Advertiser', 
                          update_data=list(newXMLNode('Id', advertiser_list$Id[10]), 
                                           newXMLNode('ContactTitle', 'new Title'))), 
               'errorCode 408: You do not have enough permission for this action.')
})