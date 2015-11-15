#' List Items in API Database
#' 
#' This function returns a data.frame listing items in Xaxis for Publishers. 
#' Only the most important details are returned. Certain search criteria may 
#' be added to the request to narrow the results returned.
#'
#' @usage oas_list(credentials, 
#'                     request_type=c('Advertiser', 'AdvertiserCategory', 'Affiliate',
#'                                    'Agency', 'CampaignGroup', 'CompanionPosition',
#'                                    'CompetitiveCategory', 'ConversionProcess', 
#'                                    'CreativeType',
#'                                    'Event', 'InsertionOrder', 'Notification',
#'                                    'Page', 'Product', 'RichMediaTemplate', 
#'                                    'SalesPerson', 'Section', 'Site',
#'                                    'SiteGroup', 'Transaction', 'Position',
#'                                    'Keyword', 'Keyname', 'Publisher', 
#'                                    'Campaign', 
#'                                    'CreativeTarget', 'Creative'),
#'                      search_criteria_attributes = NULL, 
#'                      search_criteria = NULL, verbose = FALSE)
#' @concept api list
#' @include utils.R
#' @param credentials a character string as returned by \link{oas_build_credentials}
#' @param request_type a character string in one of the supported 
#' object types for the API database list action
#' @param search_criteria_attributes a named character vector of attributes 
#' to add to the SearchCriteria node. Acceptable parameters are pageSize and 
#' pageIndex to support paginated requests. Default pageSize for request types Campaign, 
#' CampaignGroup, and Creatives is: 30,000, while all others have a default pageSize of 1000.
#' @param search_criteria an XML document specifying the children to be 
#' added to the SearchCriteria Node in the request
#' @param verbose a boolean indicating whether messages should be printed while making the request
#' @return A \code{data.frame} listing all objects of the specified type that 
#' also met the supplied search criteria
#' @note Most objects have a unique list of searchable criteria. Please consult the 
#' API documentation for a complete coverage.
#' Here are the options for Campaigns:
#' \itemize{
#'   \item Type: 'RM' for regular campaign, 'CLT' for CLT Campaign, 'ALL' for whole campaign
#'   \item Status: Search by Campaign Status. See Codes to Use in Single Character Fields
#'   \item Id: Search by Campaign ID. If "exact" attribute is "true", API returns exact campaign 
#'   having defined value. Otherwise, API returns all campaigns containing defined value in campaign ID.
#'   \item Url: Search by Scheduled Page URL
#'   \item SectionId: Search by Scheduled Section ID
#'   \item AdvertiserId: Search by Scheduled Advertiser ID
#'   \item AgencyId: Search by associated Agency ID
#'   \item CampaignGroupId: Search by associated Campaign Group ID
#'   \item StartDate: Search by Start Date. Date value with YYYY-MM-DD format is required. 
#'   "condition" attribute can be defined among EQ, GE,LE,GT and LT. Multiple StartDate can be used.
#'   \item EndDate: Search by End Date. Date value with YYYY-MM-DD format is required. 
#'   "condition" attribute can be defined among EQ, GE,LE,GT and LT. Multiple StartDate can be used.
#'   \item WhenCreated: Search by When the campaign was created. Date value with YYYY-MM-DD hh:mm:ss 
#'   format is required( Time part is optional). "condition" attribute can be defined among EQ, 
#'   GE,LE,GT and LT. Multiple WhenCreated can be used.
#'   \item WhenModified: Search by When the campaign was modified. Date value with YYYY-MM-DD hh:mm:ss 
#'   format is required( Time part is optional). "condition" attribute can be defined among EQ, 
#'   GE,LE,GT and LT. Multiple WhenCreated can be used.
#'   \item PriorityLevel: Search by Campaign Priority Level. Available value is 1 to 20. 
#'   "condition" attribute can be defined among EQ, GE,LE,GT and LT. Multiple PriorityLevel can be used.   
#'   \item Completion: Search by Completion Type. 
#'   See Codes to Use in Single Character Fields for available abbreviation code.   
#'   \item Reach: Search by Reach Type. 
#'   See Codes to Use in Single Character Fields for available abbreviation code.   
#'   \item PurchaseOrder: Search by Purchase Order #. 
#'   "condition" attribute can be defined among EQ, GE,LE,GT,LT and also LK
#'   \item InsertionOrderId: Search by associated Insertion Order ID
#'   \item CampaignManager: Search by associated CampaignManager
#' }
#' The condition attribute values of "EQ, GE, LE, GT, LT" stand for equality operators
#' @examples
#' \dontrun{
#' my_credentials <- build_credentials('myaccount', 
#'                                     'myusername', 
#'                                     'mypassword')
#' list_of_sites <- oas_list(credentials=my_credentials, request_type='Site')
#' list_of_100_pages <- oas_list(credentials=my_credentials, request_type='Page',
#'                                   search_criteria_attributes = c(pageSize="100"))
#' list_campaigns <- oas_list(credentials=my_credentials, request_type='Campaign', 
#'                                search_criteria_attributes = c(pageSize="100"), 
#'                                search_criteria=list(newXMLNode("EndDate", 
#'                                                     attrs = c(condition = "GT"), 
#'                                                     '2014-12-31')))
#' list_by_criteria <- oas_list(credentials=my_credentials, 
#'                                  request_type='Page',
#'                                  search_criteria_attributes = c(pageSize="100"), 
#'                                  search_criteria=list(newXMLNode("Domain", "mySite"), 
#'                                                       newXMLNode("Url", "001"), 
#'                                                       newXMLNode("SectionId", "Ar%ves"), 
#'                                                       newXMLNode("SiteId", "ApiSite"),
#'                                                       newXMLNode("Description", "My Page"), 
#'                                                       newXMLNode("LocationKey", "7"), 
#'                                                       newXMLNode("WhenCreated", 
#'                                                                  attrs = c(condition = "GT"), 
#'                                                                  '2014-12-31'),
#'                                                       newXMLNode("WhenModified", 
#'                                                                  attrs = c(condition = "GT"), 
#'                                                                  '2013-12-31')))
#' }
#' @export
oas_list <- function(credentials, 
                         request_type=c('Advertiser', 'AdvertiserCategory', 'Affiliate',
                                        'Agency', 'CampaignGroup', 'CompanionPosition',
                                        'CompetitiveCategory', 'ConversionProcess', 
                                        'CreativeType',
                                        'Event', 'InsertionOrder', 'Notification',
                                        'Page', 'Product', 'RichMediaTemplate', 
                                        'SalesPerson', 'Section', 'Site',
                                        'SiteGroup', 'Transaction', 'Position',
                                        'Keyword', 'Keyname', 'Publisher', 
                                        'Campaign', 
                                        'CreativeTarget', 'Creative'),
                         search_criteria_attributes = NULL, 
                         search_criteria = NULL, verbose = FALSE){
  
  adxml_node <- newXMLNode("AdXML")
  request_node <- newXMLNode("Request", attrs = c(type = request_type), 
                             parent = adxml_node)
  if (request_type %in% c('Campaign', 'Notification', 'InsertionOrder', 'CreativeTarget', 'Creative')){
    database_node <- newXMLNode(request_type, attrs = c(action = "list"), 
                                parent = request_node)
  } else {
    database_node <- newXMLNode("Database", attrs = c(action = "list"), 
                                parent = request_node)
  }
  search_criteria_node <- newXMLNode("SearchCriteria", 
                                     attrs=search_criteria_attributes, 
                                     parent = database_node)
  for (node in search_criteria){
    addChildren(search_criteria_node, node)
  }
  adxml_string <- as(adxml_node, "character")
  
  xmlBody <- request_builder(credentials=credentials, 
                             adxml_request=adxml_string)
  
  result <- perform_request(xmlBody)
  
  parsed_result <- list_result_parser(result_text=result$text$value(), 
                                      request_type=request_type, 
                                      verbose=verbose)
  
  return(parsed_result)
}

#' List Code Items from API Database
#' 
#' This function returns a data.frame listing codes associated to a particular 
#' field on an object in Xaxis for Publishers. Certain search criteria may 
#' be added to the request to narrow the results returned. This function is very similar to 
#' \code{list_request}; however it is specifically for returning code maps.
#'
#' @usage oas_list_code(credentials, 
#'                          code_type=c('Bandwidth', 'Browser', 'BrowserV', 'Continent',
#'                                      'Country', 'City', 'State', 'DMA', 'MSA', 
#'                                      'EventType', 'HourOfDay', 'WeekDay',
#'                                      'Omniture', 'OS', 'Position',
#'                                      'TopDomain', 'Zone'),
#'                          search_criteria_attributes = NULL, 
#'                          search_criteria = NULL, verbose = FALSE)
#' @concept api list
#' @include utils.R
#' @param credentials a character string as returned by \link{oas_build_credentials}
#' @param code_type a character string in one of the supported 
#' code types for the API database list action
#' @param search_criteria_attributes a named character vector of attributes 
#' to add to the SearchCriteria node. Acceptable parameters are pageSize and 
#' pageIndex to support paginated requests. Default pageSize for request types Campaign, 
#' CampaignGroup, and Creatives is: 30,000, while all others have a default pageSize of 1000.
#' @param search_criteria an XML document specifying the children to be 
#' added to the SearchCriteria Node in the request
#' @param verbose a boolean indicating whether messages should be printed while making the request
#' @return A \code{data.frame} listing all objects of the specified type that 
#' also met the supplied search criteria
#' @examples
#' \dontrun{
#' my_credentials <- build_credentials('myaccount', 
#'                                     'myusername', 
#'                                     'mypassword')
#'                                     
#' country_criteria_node = newXMLNode("Country", parent = search_criteria_node)
#' country_code_node = newXMLNode("Code", "US", parent = country_criteria_node)
#' us_city_codes <- oas_list_code(credentials=my_credentials, code_type='City', 
#'                                    search_criteria_attributes = c(pageSize="20000"), 
#'                                    search_criteria=list(country_code_node))
#' }
#' @export
oas_list_code <- function(credentials,
                              code_type=c('Bandwidth', 'Browser', 'BrowserV', 'Continent',
                                          'Country', 'City', 'State', 'DMA', 'MSA', 
                                          'EventType', 'HourOfDay', 'WeekDay',
                                          'Omniture', 'OS', 'Position',
                                          'TopDomain', 'Zone'),
                              search_criteria_attributes = NULL, 
                              search_criteria = NULL, verbose = FALSE){
  
    code_type <- if(code_type=='DMA') 'Dma' else code_type
    code_type <- if(code_type=='MSA') 'Msa' else code_type
    
    adxml_node <- newXMLNode("AdXML")
    request_node <- newXMLNode("Request", attrs = c(type = code_type), 
                               parent = adxml_node)
    database_node <- newXMLNode("Database", attrs = c(action = "list"), 
                                parent = request_node)
    search_criteria_node <- newXMLNode("SearchCriteria", 
                                       attrs=search_criteria_attributes, 
                                       parent = database_node)
    for (node in search_criteria){
      addChildren(search_criteria_node, node)
    }
    adxml_string <- as(adxml_node, "character")
    
    xmlBody <- request_builder(credentials=credentials, 
                               adxml_request=adxml_string)
    
    result <- perform_request(xmlBody)
    
    parsed_result <- list_result_parser(result_text=result$text$value(), 
                                        request_type=code_type, 
                                        verbose=verbose)
    
    return(parsed_result)
}

list_result_parser <- function(result_text, request_type, verbose = FALSE){
  
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
  
  # retrieve result metadata
  result_list <- xmlToList(result_body_doc)
  
  if (verbose){
   message(result_list[['Response']][[request_type]])
  }
  
  # pull back only the results of this record type
  result_df <- xmlToDataFrame(nodes = getNodeSet(result_body_doc, 
                                                 paste0("//List/", request_type)), collectNames = F)
  
  # add metadata as attributes
  result_attributes <- NULL
  if (nrow(result_df)==0){
    result_attributes <- as.list(result_list[['Response']][['List']])
  } else {
    result_attributes <- as.list(result_list[['Response']][['List']][['.attrs']])
  }
  attributes(result_df) <- c(attributes(result_df), result_attributes)
                     
  return(result_df)
}