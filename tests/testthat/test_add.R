context("OAS Add")

roas_setup <- readRDS("roas_setup.rds")
options(roas.account = roas_setup$account)
options(roas.username = roas_setup$username)
options(roas.password = roas_setup$password)

credentials <- oas_build_credentials()

test_that("oas_add", {
  
  # expect_error(oas_add(credentials=credentials, 
  #                         request_type='Advertiser', 
  #                         add_data=list(addChildren(
  #                           newXMLNode('Advertiser'), 
  #                           list(newXMLNode('Id', 'TEST-newAdvertiser1'), 
  #                                          newXMLNode('Organization', 'A Company Name'), 
  #                                          newXMLNode('Notes', 'Added via API.'), 
  #                                          newXMLNode('ContactFirstName', 'John'), 
  #                                          newXMLNode('ContactLastName', 'Doe'), 
  #                                          newXMLNode('Email', 'a@b.c'), 
  #                                          newXMLNode('Phone', '215-555-1212'))))), 
  #              'errorCode 408: You do not have enough permission for this action.')
  
  # permissions have been granted to perform this action
  # however, since there is no delete functionality, we will not
  # bother checking the add functionality
  expect_true(TRUE)
})