context("OAS Inventory")

roas_setup <- readRDS("roas_setup.rds")
options(roas.account = roas_setup$account)
options(roas.username = roas_setup$username)
options(roas.password = roas_setup$password)

credentials <- build_credentials()
site <- roas_setup$site

test_that("oas_basic_inventory", {
  
  overview <- oas_basic_inventory(credentials=credentials, 
                                  report_type='Overview', 
                                  report_name='All Sites Forecast',
                                  start_date='2015-12-01', 
                                  end_date='2015-12-31')
  expected_names <- c('Site', 'ImpressionsTotal', 
                      'ImpressionsBooked', 'ImpressionsRemnant', 
                      'ImpressionsAvailable')
  
  expect_true(is.data.frame(overview))
  expect_equal(names(overview), expected_names)
  expect_true(all(c('TimethattheReportwasRun', 'StartDate', 'EndDate') %in% names(attributes(overview))))
  
})

test_that("oas_search_inventory", {
  
  keyword_stats <- oas_search_inventory(credentials=my_credentials, 
                                 report_type='KeywordStatistics', 
                                 report_name='Statistics by Keyword',
                                 keywords='sale',
                                 position=c('Bottom'),
                                 start_date='2015-12-01', 
                                 end_date='2015-12-31')
  expected_names <- c('Keyword', 'AverageperDayImpressions', 
                      'AverageperDayClickthrus', 'CTR')
  expected_attributes <- c('TimethattheReportwasRun','Positions', 
                           'Sites', 'Sections', 'MaxRowPerTable')
  
  expect_true(is.data.frame(keyword_stats))
  expect_equal(names(keyword_stats), expected_names)
  expect_true(all(expected_attributes %in% names(attributes(keyword_stats))))
  
})

test_that("oas_geo_inventory", {
  
  site_geo <- oas_geo_inventory(credentials=credentials, 
                                    report_type='Site', 
                                    report_geo='State',
                                    report_outlook='Statistics',
                                    id=site,
                                    start_date='2015-09-01', 
                                    end_date='2015-09-30')
  expected_names <- c('State', 'AverageperDayImpressions', 
                      'AverageperDayClicks', 'CTR')
  expected_attributes <- c('TimethattheReportwasRun', 'Site',
                           'Positions', 'MaxRowPerTable')
  
  expect_true(is.data.frame(site_geo))
  expect_equal(names(site_geo), expected_names)
  expect_true(all(expected_attributes %in% names(attributes(site_geo))))
  
})

test_that("oas_zone_inventory", {
  
  expect_error(oas_zone_inventory(credentials=credentials, 
                                    report_name='Statistics by Zone',
                                    site_id=site,
                                    max_row='100',
                                    zone_name='UNKNOWN',
                                    start_date='2015-09-01', 
                                    end_date='2015-09-31'))
  
})
