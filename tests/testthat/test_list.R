context("OAS List")

roas_setup <- readRDS("roas_setup.rds")
options(roas.account = roas_setup$account)
options(roas.username = roas_setup$username)
options(roas.password = roas_setup$password)

credentials <- oas_build_credentials()
site <- roas_setup$site

test_that("oas_list", {
  
  site_list <- oas_list(credentials=credentials, request_type='Site')
  
  expect_true(is.data.frame(site_list))
  expect_true(all(c('Id', 'Name', 'Domain') %in% names(site_list)))
  
  campaign_list <- oas_list(credentials=credentials, request_type='Campaign', 
                             search_criteria = list(newXMLNode("Status", "L"), 
                                                    newXMLNode("EndDate", 
                                                               attrs = c(condition = "GT"), 
                                                               '2015-12-31')), 
                             search_criteria_attributes = c(pageSize="10"))
  expected_names <- c('Type', 'CampaignKey', 'Id', 'Status', 'StartDate', 'EndDate',
                      'ImpDelivered', 'ClicksDelivered', 'WhenModified')
  
  expect_true(is.data.frame(campaign_list))
  expect_true(all(expected_names %in% names(campaign_list)))
  expect_true(all(as.character(campaign_list$Status)=='L'))
  expect_true(nrow(campaign_list)<=10)
  
})

test_that("oas_list_code", {
  
  dma_code_list <- oas_list_code(credentials=credentials, code_type='DMA')
  
  expect_true(is.data.frame(dma_code_list))
  expect_true(all(c('Code', 'Name') %in% names(dma_code_list)))
  expect_true(nrow(dma_code_list)>200)
  
})
