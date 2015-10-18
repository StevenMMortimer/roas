#' Retrieve Basic Inventory Reports
#' 
#' This function returns a data.frame of inventory statistics for
#' 18 different report types
#'
#' @usage basic_inventory_request(credentials, 
#'                                request_type=c('Configuration', 'Overview',
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
    stop('report_id not found')
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
  
  parsed_result <- basic_inventory_result_parser(result_text=result$text$value())
  
  return(parsed_result)
}

basic_inventory_result_parser <- function(result_text){
  
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





#search_inventory_request
#geo_inventory_request
#zone_inventory_request