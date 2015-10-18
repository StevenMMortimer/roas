#' Run Template Reports
#' 
#' This function runs a precanned report that is also available via
#' the OAS UI. Only one report is available at a time. The report_type
#' and report_name provided will be checked against the data.frame
#' available_reports before submitting requests, so please consult
#' that data if unsure whether a particular report is supported.
#'
#' @usage report_request(credentials, 
#'                       report_type, 
#'                       report_name, 
#'                       id=NULL,
#'                       start_date=NULL, 
#'                       end_date=NULL, 
#'                       threshold=NULL)
#' @concept api report
#' @include utils.R data.R
#' @param credentials a character string as returned by \link{build_credentials}
#' @param report_type a character string naming the type of report being requested
#' @param report_name a character string naming the report name. Please see the 
#' dataset \link{available_reports} for a complete list of available report_type and report_name
#' combinations
#' @param id a character string that identifies one object to report on, for example
#' a campaign id if reporting on one campaign's revenue
#' @param start_date a character string representing a date formatted as YYYY-MM-DD of 
#' when to start the reporting from
#' @param end_date a character string representing a date formatted as YYYY-MM-DD of 
#' when to end the reporting on
#' @param threshold a mandatory integer when requesting Over/Under Campaign Delivery Health
#' Status reports. Ignored otherwise.
#' @return A \code{data.frame} of all fields available for the specified report name and type
#' @note For Site reports the Site's Domain has to be used as the Id 
#' element (e.g. www.mysite.com)
#' @examples
#' \dontrun{
#' my_credentials <- build_credentials('myaccount', 
#'                                     'myusername', 
#'                                     'mypassword')
#' site_delivery_info <- report_request(credentials=my_credentials, 
#'                                      report_type='Site Delivery', 
#'                                      report_name='Executive Summary', 
#'                                      id='www.mysite.com',
#'                                      start_date='2015-09-01', 
#'                                      end_date='2015-09-30')
#' pos_delivery_info <- report_request(credentials=my_credentials, 
#'                                     report_type='Campaign Delivery',
#'                                     report_name='Position Delivery Information',  
#'                                     id='one_campaign_id')
#' overunder_campaigns <- report_request(credentials=my_credentials, 
#'                                       report_type='Daily Health Status', 
#'                                       report_name='Over Delivery Campaigns', 
#'                                       threshold=20)
#' }
#' @export
report_request <- function(credentials, 
                           report_type, 
                           report_name, 
                           id=NULL,
                           start_date=NULL, 
                           end_date=NULL, 
                           threshold=NULL){
  
  if(!any(available_reports$report_type==tolower(report_type))){
    stop('report_type not found')
  }
  if(!any(available_reports$report_name==tolower(report_name))){
    stop('report_name not found')
  }
  which_report_row <- ((available_reports$report_type==tolower(report_type)) & 
                         (available_reports$report_name==tolower(report_name)))
  report_id <- available_reports[which_report_row, 'report_id']
  report_attribute_type <- available_reports[which_report_row, 'report_attribute_type']
  if(length(report_id)!=1){
    stop('report_id not found')
  }

  adxml_node <- newXMLNode("AdXML")

  if (grepl('Status', report_type)){
    request_node <- newXMLNode("Request", attrs = c(type = "StatusReport"), 
                               parent = adxml_node)
    report_node <- newXMLNode("StatusReport", 
                              attrs = c(type = report_attribute_type), 
                              parent = request_node)
    if (!is.null(threshold)){
      threshold_node <- newXMLNode("Threshold", threshold, parent = report_node)
    }
    if (!is.null(id) & report_attribute_type!='DailyHealthStatus'){
      id_node <- newXMLNode("Id", id, parent = report_node)
    }
  } else if(report_attribute_type == 'PagePriority') {
    request_node <- newXMLNode("Request", 
                               attrs = c(type = paste0(report_attribute_type, "Report")), 
                               parent = adxml_node)
    report_node <- newXMLNode(paste0(report_attribute_type, "Report"), 
                              parent = request_node)
    if (!is.null(id)){
      id_node <- newXMLNode("Id", id, parent = report_node)
    }
  } else if(report_attribute_type == 'ReachAndFrequency') {
    request_node <- newXMLNode("Request", 
                               attrs = c(type = paste0(report_attribute_type)), 
                               parent = adxml_node)
    report_node <- newXMLNode(report_attribute_type, 
                              attrs = c(type = gsub('[[:space:]]', 
                                                    '', 
                                                    gsub('Reach & Frequency', 
                                                         '', report_type))),
                              parent = request_node)
    if (!is.null(id)){
      id_node <- newXMLNode("Id", id, parent = report_node)
    }
    start_date_node <- newXMLNode("StartDate", start_date, parent = report_node)
    end_date_node <- newXMLNode("EndDate", end_date, parent = report_node)
  } else if(report_attribute_type == 'SitePerformance') {
    request_node <- newXMLNode("Request", 
                               attrs = c(type = paste0(report_attribute_type, "Report")), 
                               parent = adxml_node)
    report_node <- newXMLNode(paste0(report_attribute_type, "Report"), 
                              parent = request_node)
    if (!is.null(id)){
      id_node <- newXMLNode("Id", id, parent = report_node)
    }
    start_date_node <- newXMLNode("StartDate", start_date, parent = report_node)
    end_date_node <- newXMLNode("EndDate", end_date, parent = report_node)
  } else {
    request_node <- newXMLNode("Request", attrs = c(type = "Report"), 
                               parent = adxml_node)
    report_node <- newXMLNode("Report", 
                              attrs = c(type = report_attribute_type), 
                              parent = request_node)
    if (!is.null(id)){
      id_node <- newXMLNode("Id", id, parent = report_node)
    }
    start_date_node <- newXMLNode("StartDate", start_date, parent = report_node)
    end_date_node <- newXMLNode("EndDate", end_date, parent = report_node)
  }
  table_node <- newXMLNode("Table", report_id, parent = report_node)
  
  adxml_string <- as(adxml_node, "character")
  
  xmlBody <- request_builder(credentials=credentials, 
                             adxml_request=adxml_string)
  
  result <- perform_request(xmlBody)
  
  parsed_result <- report_result_parser(result_text=result$text$value())
  
  return(parsed_result)
}

report_result_parser <- function(result_text){
  
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