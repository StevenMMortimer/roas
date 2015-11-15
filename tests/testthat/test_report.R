context("OAS Report")

roas_setup <- readRDS("roas_setup.rds")
options(roas.account = roas_setup$account)
options(roas.username = roas_setup$username)
options(roas.password = roas_setup$password)

credentials <- oas_build_credentials()
site <- roas_setup$site

test_that("oas_report", {
  
  site_delivery <- oas_report(credentials=credentials, 
                              report_type='Site Delivery',
                              report_name='Executive Summary',
                              id=site,
                              start_date='2015-09-01', 
                              end_date='2015-09-30')
  
  expected_names <- c('Site', 'Impressions', 'Clicks', 
                      'CTR', 'ReportStart', 
                      'ReportEnd')
  
  expect_true(is.data.frame(site_delivery))
  expect_equal(names(site_delivery), expected_names)
  expect_true(all(c('TimethattheReportwasRun', 'StartDate', 'EndDate') %in% names(attributes(site_delivery))))
  
})
