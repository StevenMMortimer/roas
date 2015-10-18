#' Retrieve Basic Inventory Reports
#' 
#' This function returns a data.frame of inventory statistics for
#' 18 different report types
#'
#' @usage basic_inventory_request(credentials, 
#'                                report_type=c('Configuration', 'Overview',
#'                                    'Campaign', 'Campaign.Detail',
#'                                    'Page', 'Page.Detail', 
#'                                    'Position', 'Position.Detail',
#'                                    'Section', 'Section.Detail',
#'                                    'Site', 'Site.Detail',
#'                                    'PageAtPosition', 'PageAtPosition.Detail',
#'                                    'SectionAtPosition', 'SectionAtPosition.Detail',
#'                                    'SiteAtPosition', 'SiteAtPosition.Detail'), 
#'                                report_name,
#'                                keywords=NULL,
#'                                position=NULL,
#'                                id=NULL,
#'                                start_date=NULL,
#'                                end_date=NULL)
#' @concept api inventory report
#' @include utils.R data.R
#' @param credentials a character string as returned by \link{build_credentials}
#' @param report_type a character string in one of eighteen supported 
#' inventory report types
#' @param report_name a character string of the report name. Please see the 
#' dataset \link{inventory_reports} and filter to inventory_type=="basic" for 
#' a complete list of available report_type and report_name combinations for this
#' function.
#' @param keywords a character string containing comma separated keywords value 
#' for filtering inventory report.
#' @param position a character vector containing position names. 
#' Multiple "position" elements be specified at once, hence a vector is accepted
#' instead of a string
#' @param id a character string This element is used for defining id 
#' (Campaign, Site, Page, Section) for inquiring the inventory detail report. Only
#' necessary for detail report types (e.g. Position.Detail)
#' @param start_date a character string for inquiring inventory detail report. 
#' This field is optional and must be in the yyyy-mm-dd format.
#' @param end_date a character string for inquiring the inventory detail report by 
#' given schedule. This field is optional and must be in the yyyy-mm-dd format.
#' @return A \code{data.frame} of inventory data in the format of the specified
#' report_type and report_name
#' @examples
#' \dontrun{
#' my_credentials <- build_credentials('myaccount', 
#'                                     'myusername', 
#'                                     'mypassword')
#' config <- basic_inventory_request(credentials=my_credentials, 
#'                                   report_type='Configuration', 
#'                                   report_name='Configuration')
#' # note that forecast start and end dates must be greater than or equal to 
#' Sys.Date() otherwise it will return a 0 row data.frame
#' overview <- basic_inventory_request(credentials=my_credentials, 
#'                                     report_type='Overview', 
#'                                     report_name='All Sites Forecast',
#'                                     start_date='2015-12-01', 
#'                                     end_date='2015-12-31')
#' # leaving position argument NULL means all positions are returned
#' # specifying the position argument NULL means only those will be returned
#' page_pos_forecast <- basic_inventory_request(credentials=my_credentials, 
#'                                              report_type='PageAtPosition.Detail',
#'                                              report_name='Detail Forecast',
#'                                              id='www.site.com/page@@x01', 
#'                                              start_date='2015-12-01', 
#'                                              end_date='2015-12-31')                                  
#' }
#' @export
basic_inventory_request <- function(credentials, 
                                    report_type=c('Configuration', 'Overview',
                                                   'Campaign', 'Campaign.Detail',
                                                   'Page', 'Page.Detail', 
                                                   'Position', 'Position.Detail',
                                                   'Section', 'Section.Detail',
                                                   'Site', 'Site.Detail',
                                                   'PageAtPosition', 'PageAtPosition.Detail',
                                                   'SectionAtPosition', 'SectionAtPosition.Detail',
                                                   'SiteAtPosition', 'SiteAtPosition.Detail'), 
                                    report_name,
                                    keywords=NULL,
                                    position=NULL,
                                    id=NULL,
                                    start_date=NULL,
                                    end_date=NULL){
  
  if(!any(inventory_reports$report_type==tolower(report_type))){
    stop('report_type not found')
  }
  if(!any(inventory_reports$report_name==tolower(report_name))){
    stop('report_name not found')
  }
  which_report_row <- ((inventory_reports$inventory_type=='basic') & 
                         (inventory_reports$report_type==tolower(report_type)) & 
                         (inventory_reports$report_name==tolower(report_name)))
  keywords_type <- inventory_reports[which_report_row, 'keywords_type']
  report_id <- inventory_reports[which_report_row, 'report_id']
  if(length(report_id)!=1){
    stop('report_id not found, please refer to dataset inventory_reports for correct report_type and report_name')
  }
  
  adxml_node <- newXMLNode("AdXML")
  request_node <- newXMLNode("Request", 
                             attrs = c(type = "Inventory"), 
                             parent = adxml_node)
  report_node <- newXMLNode("BasicInventory", 
                            attrs = c(type = report_type), 
                            parent = request_node)
  if (!is.null(keywords)){
    keyword_node <- newXMLNode("Keywords", keywords, 
                               attrs = c(type = keywords_type), 
                               parent = report_node)
  }
  if (!is.null(position)){
    for (p in position){
      position_node <- newXMLNode("Position", p, parent = report_node)
    }
  }
  if (!is.null(id)){
    id_node <- newXMLNode("Id", id, parent = report_node)
  }
  if (!is.null(start_date)){
    start_date_node <- newXMLNode("StartDate", start_date, parent = report_node)
  }
  if (!is.null(end_date)){
    end_date_node <- newXMLNode("EndDate", end_date, parent = report_node)
  }
  table_node <- newXMLNode("Table", report_id, parent = report_node)
  
  adxml_string <- as(adxml_node, "character")
  
  xmlBody <- request_builder(credentials=credentials, 
                             adxml_request=adxml_string)
  
  result <- perform_request(xmlBody)
  
  parsed_result <- inventory_result_parser(result_text=result$text$value())
  
  return(parsed_result)
}

#' Retrieve Search Inventory Reports
#' 
#' This function returns a data.frame of search inventory statistics 
#' based on Keyword
#'
#' @usage search_inventory_request(credentials, 
#'                                 report_type=c('KeywordForecast', 
#'                                               'KeywordStatistics', 
#'                                               'KeywordBooked'), 
#'                                 report_name,
#'                                 max_row="100",
#'                                 keywords=NULL,
#'                                 position=NULL,
#'                                 campaign_id=NULL,
#'                                 site_domain=NULL,
#'                                 section_id=NULL,
#'                                 start_date=NULL,
#'                                 end_date=NULL)
#' @concept api inventory search report
#' @include utils.R data.R
#' @param credentials a character string as returned by \link{build_credentials}
#' @param report_type a character string in of the supported keyword
#' search inventory reports
#' @param report_name a character string of the report name. Please see the 
#' dataset \link{inventory_reports} and filter to inventory_type=="search" for 
#' a complete list of available report_type and report_name combinations for this
#' function.
#' @param max_row a character integer limiting the number of rows returned matching the
#' supplied keywords. A character is recommended to avoid larger numbers being formatted
#' in scientific notation and not being properly interpreted by the API.
#' @param keywords a character string containing comma separated keywords value 
#' for filtering inventory report.
#' @param position a character vector containing position names. 
#' Multiple "position" elements can be specified at once, hence a vector is accepted
#' instead of a string
#' @param campaign_id a character vector containing campaign ids. 
#' Multiple "campaign_id" elements can be specified at once, hence a vector is accepted
#' instead of a string
#' @param site_domain a character vector containing site domains. 
#' Multiple "site_domain" elements can be specified at once, hence a vector is accepted
#' instead of a string
#' @param section_id a character vector containing section ids. 
#' Multiple "section_id" elements can be specified at once, hence a vector is accepted
#' instead of a string
#' @param start_date a character string for inquiring inventory detail report. 
#' This field is optional and must be in the yyyy-mm-dd format.
#' @param end_date a character string for inquiring the inventory detail report by 
#' given schedule. This field is optional and must be in the yyyy-mm-dd format.
#' @return A \code{data.frame} of inventory data in the format of the specified
#' report_type and report_name
#' @note Search inventory requests are only available if the Search module is enabled on the account
#' @note The arguments for position, campaign_id, site_domain, section_id are optional, but helpful 
#' in narrowing the focus for the resultset to shorten request and parsing time. 
#' @examples
#' \dontrun{
#' my_credentials <- build_credentials('myaccount', 
#'                                     'myusername', 
#'                                     'mypassword')
#'                                     
#' stats <- search_inventory_request(credentials=my_credentials, 
#'                                   report_type='KeywordStatistics', 
#'                                   report_name='Statistics By Keyword',
#'                                   keywords='Kw1,Kw2', 
#'                                   position=c('Bottom', 'Bottom1'),
#'                                   section_id=c('Books'),
#'                                   site_domain=c('www.mysite.com'))
#'                                    
#' booked <- search_inventory_request(credentials=my_credentials, 
#'                                    report_type='KeywordBooked', 
#'                                    report_name='Campaign Targets',
#'                                    keywords='Kw1,Kw2', 
#'                                    position=c('Bottom', 'Bottom1'),
#'                                    campaign_id=c('Test_Campaign'),
#'                                    site_domain=c('www.mysite.com'),
#'                                    start_date='2015-12-01', 
#'                                    end_date='2015-12-31')
#'                                      
#' }
#' @export
search_inventory_request <- function(credentials, 
                                     report_type=c('KeywordForecast', 
                                                   'KeywordStatistics', 
                                                   'KeywordBooked'), 
                                     report_name,
                                     max_row="100",
                                     keywords=NULL,
                                     position=NULL,
                                     campaign_id=NULL,
                                     site_domain=NULL,
                                     section_id=NULL,
                                     start_date=NULL,
                                     end_date=NULL){
  
  if(!any(inventory_reports$report_type==tolower(report_type))){
    stop('report_type not found')
  }
  if(!any(inventory_reports$report_name==tolower(report_name))){
    stop('report_name not found')
  }
  which_report_row <- ((inventory_reports$inventory_type=='search') & 
                         (inventory_reports$report_type==tolower(report_type)) & 
                         (inventory_reports$report_name==tolower(report_name)))
  report_id <- inventory_reports[which_report_row, 'report_id']
  if(length(report_id)!=1){
    stop('report_id not found, please refer to dataset inventory_reports for correct report_type and report_name')
  }
  
  adxml_node <- newXMLNode("AdXML")
  request_node <- newXMLNode("Request", 
                             attrs = c(type = "SearchInventory"), 
                             parent = adxml_node)
  report_node <- newXMLNode("SearchInventory", 
                            attrs = c(type = report_type, maxRow=max_row), 
                            parent = request_node)
  if (!is.null(keywords)){
    keyword_node <- newXMLNode("Keywords", 
                               keywords,
                               parent = report_node)
  }
  if (!is.null(position)){
    for (p in position){
      position_node <- newXMLNode("Position", p, parent = report_node)
    }
  }
  if (!is.null(campaign_id)){
    for (c in campaign_id){
      position_node <- newXMLNode("CampaignIds", c, parent = report_node)
    }
  }
  if (!is.null(site_domain)){
    for (s in site_domain){
      position_node <- newXMLNode("SiteDomain", s, parent = report_node)
    }
  }
  if (!is.null(section_id)){
    for (e in section_id){
      position_node <- newXMLNode("SectionId", e, parent = report_node)
    }
  }
  if (!is.null(start_date)){
    start_date_node <- newXMLNode("StartDate", start_date, parent = report_node)
  }
  if (!is.null(end_date)){
    end_date_node <- newXMLNode("EndDate", end_date, parent = report_node)
  }
  table_node <- newXMLNode("Table", report_id, parent = report_node)
  
  adxml_string <- as(adxml_node, "character")
  
  xmlBody <- request_builder(credentials=credentials, 
                             adxml_request=adxml_string)
  
  result <- perform_request(xmlBody)
  
  parsed_result <- inventory_result_parser(result_text=result$text$value())
  
  return(parsed_result)
}

#' Retrieve Geo Inventory Reports
#' 
#' This function returns a data.frame of inventory stats 
#' and forecasts broken down by a specified geography
#'
#' @usage geo_inventory_request(credentials, 
#'                                 report_type=c('Site', 
#'                                               'Section'), 
#'                                 report_geo=c('Executive Summary', 'Continent', 
#'                                              'Country', 'State', 
#'                                              'City', 'Postal Code', 
#'                                              'Telephone Area Code', 
#'                                              'DMA', 'MSA', 'Bandwidth'),
#'                                 report_outlook=c('Statistics', 'Forecast'),
#'                                 id,
#'                                 max_row="100",
#'                                 position=NULL,
#'                                 start_date=NULL,
#'                                 end_date=NULL)
#' @concept api inventory geo report
#' @include utils.R data.R
#' @param credentials a character string as returned by \link{build_credentials}
#' @param report_type a character string either "Site" or "Section" as these
#' are the only types supported for geo inventory reports
#' @param report_geo a character string from the list of options. "Summary" returns an
#' executive summary, while the rest provide a specific geographic breakdown.
#' @param report_outlook a character string specifying the report to be a descriptive
#' view or a forecast. Note that forecasts must have start and end dates greater than 
#' the current date, otherwise they will return 0 row data.frames.
#' @param id a character string containing an identifying name for a Site or Section
#' depending on the report_type
#' @param max_row a character integer limiting the number of rows returned. 
#' A character is recommended to avoid larger numbers being formatted
#' in scientific notation and not being properly interpreted by the API.
#' @param position a character vector containing position names. 
#' Multiple "position" elements can be specified at once, hence a vector is accepted
#' instead of a string
#' @param start_date a character string for inquiring inventory detail report. 
#' This field is optional and must be in the yyyy-mm-dd format.
#' @param end_date a character string for inquiring the inventory detail report by 
#' given schedule. This field is optional and must be in the yyyy-mm-dd format.
#' @return A \code{data.frame} of inventory data in the format of the specified
#' report_type and report_name
#' @note Search inventory requests are only available if the Search module is enabled on the account
#' @note The arguments for position, campaign_id, site_domain, section_id are optional, but helpful 
#' in narrowing the focus for the resultset to shorten request and parsing time. 
#' @examples
#' \dontrun{
#' my_credentials <- build_credentials('myaccount', 
#'                                     'myusername', 
#'                                     'mypassword')
#'                                     
#' site_geo <- geo_inventory_request(credentials=my_credentials, 
#'                                   report_type='Site', 
#'                                   report_geo='State',
#'                                   report_outlook='Statistics'
#'                                   id='www.mysite.com',
#'                                   start_date='2015-09-01', 
#'                                   end_date='2015-09-30')
#'                                   
#' # Note that forecast reports must have start and end dates >= Sys.Date()
#' otherwise they will return 0 row data.frames                                  
#' section_geo <- geo_inventory_request(credentials=my_credentials, 
#'                                      report_type='Section', 
#'                                      report_geo='DMA',
#'                                      report_outlook='Forecast',
#'                                      id='Books',
#'                                      max_row="20000",
#'                                      position=c('Bottom', 'Bottom1'),
#'                                      start_date='2015-12-01', 
#'                                      end_date='2015-12-31')
#'                                      
#' }
#' @export
geo_inventory_request <- function(credentials, 
                                  report_type=c('Site', 
                                                'Section'), 
                                  report_geo=c('Executive Summary', 'Continent', 
                                               'Country', 'State', 
                                               'City', 'Postal Code', 
                                               'Telephone Area Code', 
                                               'DMA', 'MSA', 'Bandwidth'), 
                                  report_outlook=c('Statistics', 'Forecast'),
                                  id,
                                  max_row="100",
                                  position=NULL,
                                  start_date=NULL,
                                  end_date=NULL){
  if(report_geo!='Executive Summary'){
    which_report_row <- ((inventory_reports$inventory_type=='geo') & 
                           (inventory_reports$report_type==tolower(report_type)) & 
                           (inventory_reports$report_name==
                              tolower(paste0(report_outlook, ' by ', report_geo))))
  } else {
    which_report_row <- ((inventory_reports$inventory_type=='geo') & 
                           (inventory_reports$report_type==tolower(report_type)) & 
                           (inventory_reports$report_name==tolower(report_geo)))
  }
  report_id <- inventory_reports[which_report_row, 'report_id']
  if(length(report_id)!=1){
    stop('report_id not found, please refer to dataset inventory_reports for correct report_type and report_name')
  }
  
  adxml_node <- newXMLNode("AdXML")
  request_node <- newXMLNode("Request", 
                             attrs = c(type = "GeoInventory"), 
                             parent = adxml_node)
  report_node <- newXMLNode("GeoInventory", 
                            attrs = c(type = report_type, maxRow=max_row), 
                            parent = request_node)
  id_node <- newXMLNode("Id", id, parent = report_node)
  
  if (!is.null(position)){
    for (p in position){
      position_node <- newXMLNode("Position", p, parent = report_node)
    }
  }
  if (!is.null(start_date)){
    start_date_node <- newXMLNode("StartDate", start_date, parent = report_node)
  }
  if (!is.null(end_date)){
    end_date_node <- newXMLNode("EndDate", end_date, parent = report_node)
  }
  table_node <- newXMLNode("Table", report_id, parent = report_node)
  
  adxml_string <- as(adxml_node, "character")
  
  xmlBody <- request_builder(credentials=credentials, 
                             adxml_request=adxml_string)
  
  result <- perform_request(xmlBody)
  
  parsed_result <- inventory_result_parser(result_text=result$text$value())
  
  return(parsed_result)
}

#' Retrieve Zone Inventory Reports
#' 
#' This function returns a data.frame of inventory stats 
#' and forecasts broken down by a specified zone
#'
#' @usage zone_inventory_request(credentials, 
#'                               report_name=c('Statistics by Zone', 
#'                                             'Forecast by Zone', 
#'                                             'Detail Statistics',
#'                                             'Detail Forecast'), 
#'                               site_id,
#'                               max_row="100",
#'                               zone_name=NULL,
#'                               start_date=NULL,
#'                               end_date=NULL)
#' @concept api inventory zone report
#' @include utils.R data.R
#' @param credentials a character string as returned by \link{build_credentials}
#' @param report_name a character string one of the valid zone inventory reports
#' @param site_id a character string containing an identifying name for a Site
#' @param max_row a character integer limiting the number of rows returned. 
#' A character is recommended to avoid larger numbers being formatted
#' in scientific notation and not being properly interpreted by the API.
#' @param zone_name a character string of a particular zone name for reporting on. 
#' @param start_date a character string for inquiring inventory detail report. 
#' This field is optional and must be in the yyyy-mm-dd format.
#' @param end_date a character string for inquiring the inventory detail report by 
#' given schedule. This field is optional and must be in the yyyy-mm-dd format.
#' @return A \code{data.frame} of zone inventory data in the format of the specified
#' report_name
#' @note Zone inventory requests are only available if the Custom Zip Zone module is enabled on the account
#' @examples
#' \dontrun{
#' my_credentials <- build_credentials('myaccount', 
#'                                     'myusername', 
#'                                     'mypassword')
#'                                     
#' # Note that forecast reports must have start and end dates >= Sys.Date()
#' otherwise they will return 0 row data.frames                                  
#' zone_forecast <- zone_inventory_request(credentials=my_credentials, 
#'                                         report_name='Forecast by Zone',
#'                                         site_id='www.mysite.com',
#'                                         max_row='20000',
#'                                         zone_name='UNKNOWN'
#'                                         start_date='2015-12-01', 
#'                                         end_date='2015-12-31')
#'                                      
#' }
#' @export
zone_inventory_request <- function(credentials, 
                                  report_name=c('Statistics by Zone', 
                                                'Forecast by Zone', 
                                                'Detail Statistics', 
                                                'Detail Forecast'),
                                  site_id,
                                  max_row="100",
                                  zone_name=NULL,
                                  start_date=NULL,
                                  end_date=NULL){

  which_report_row <- ((inventory_reports$inventory_type=='zone') &
                         (inventory_reports$report_name==tolower(report_name)))
  
  report_id <- inventory_reports[which_report_row, 'report_id']
  if(length(report_id)!=1){
    stop('report_id not found, please refer to dataset inventory_reports for correct report_type and report_name')
  }
  
  adxml_node <- newXMLNode("AdXML")
  request_node <- newXMLNode("Request", 
                             attrs = c(type = "ZoneInventory"), 
                             parent = adxml_node)
  report_node <- newXMLNode("ZoneInventory", 
                            attrs = c(type = "Site", maxRow=max_row), 
                            parent = request_node)
  id_node <- newXMLNode("Id", site_id, parent = report_node)
  if (!is.null(zone_name)){
    zone_node <- newXMLNode("ZoneName", zone_name, parent = report_node)
  }
  if (!is.null(start_date)){
    start_date_node <- newXMLNode("StartDate", start_date, parent = report_node)
  }
  if (!is.null(end_date)){
    end_date_node <- newXMLNode("EndDate", end_date, parent = report_node)
  }
  table_node <- newXMLNode("Table", report_id, parent = report_node)
  
  adxml_string <- as(adxml_node, "character")
  
  xmlBody <- request_builder(credentials=credentials, 
                             adxml_request=adxml_string)
  
  result <- perform_request(xmlBody)
  
  parsed_result <- inventory_result_parser(result_text=result$text$value())
  
  return(parsed_result)
}

inventory_result_parser <- function(result_text){
  
  # pull out the results and format as XML
  # this takes some redundant steps to get the AdXML recognized as XML for parsing
  doc <- xmlTreeParse(result_text, asText=T)
  result_body <- xmlToList(doc)$Body.OasXmlRequestResponse.result
  result_body_doc <- xmlParse(result_body)
  
  # Check for error
  errorcode <- NA
  errormessage <- NA
  try(errorcode <- xmlAttrs(getNodeSet(result_body_doc, 
                                       "//Exception")[[1]], 'errorCode'), silent = T)
  try(errormessage <- xmlValue(getNodeSet(result_body_doc, 
                                          "//Exception")[[1]]), silent = T)
  if(!is.na(errorcode) && !is.na(errormessage)){
    stop(paste0('errorCode ', errorcode, ": ", errormessage))
  }
  
  report_header <- getNodeSet(result_body_doc, "//reportTable")[[1]]
  report_body <- getNodeSet(result_body_doc, "//reportTable")[[2]]
  
  result_attributes <- xmlSApply(getNodeSet(report_header, 'row'), FUN=function(x){
    p <- list()
    p[[1]] <- xmlValue(xmlChildren(x)[[1]])
    names(p) <- xmlName(xmlChildren(x)[[1]])
    return(p)
  })
  # format is unnecessary
  result_attributes <- result_attributes[names(result_attributes)!='Format']
  
  # pull back only the results of this record type
  result_df <- xmlToDataFrame(nodes = getNodeSet(report_body, 'row'), collectNames = F)
  
  # add metadata as attributes
  if (nrow(result_df)>0){
    attributes(result_df) <- c(attributes(result_df), result_attributes)
  }
  
  return(result_df)
}