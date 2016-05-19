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
#'                      search_criteria_attributes = c(pageIndex="-1", pageSize="1000"), 
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
#' @param verbose a boolean indicating whether to print the request XML as a message
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
                         search_criteria_attributes = c(pageIndex="-1", pageSize="1000"), 
                         search_criteria = NULL, verbose = FALSE){
  
  paginate <- FALSE
  if(!('pageIndex' %in% names(search_criteria_attributes)) | 
      search_criteria_attributes['pageIndex'] == "-1"){
    search_criteria_attributes['pageIndex'] <- "1" 
    paginate <- TRUE
  } else {
    if(!('pageSize' %in% names(search_criteria_attributes))){
      stop('Must supply a pageSize if using the pageIndex search criteria attribute')
    }
  }
  
  # both paging parameters must be specified  
  stopifnot(all(c('pageIndex', 'pageSize') %in% names(search_criteria_attributes)))
  
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
  
  if(verbose){
    message(xmlBody)
  }
  
  result <- perform_request(xmlBody)
  
  parsed_result <- list_result_parser(xmlBody = xmlBody, 
                                      paginate = paginate,
                                      result_text = result$text$value(), 
                                      request_type = request_type, 
                                      verbose = verbose)
  
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
#'                          search_criteria_attributes = c(pageIndex="-1", pageSize="1000"),
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
#' @param verbose a boolean indicating whether to print the request XML as a message
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
                              search_criteria_attributes = c(pageIndex="-1", pageSize="1000"),
                              search_criteria = NULL, verbose = FALSE){
  
    code_type <- if(code_type=='DMA') 'Dma' else code_type
    code_type <- if(code_type=='MSA') 'Msa' else code_type
    
    paginate <- FALSE
    if(!('pageIndex' %in% names(search_criteria_attributes)) | 
       search_criteria_attributes['pageIndex'] == "-1"){
      search_criteria_attributes['pageIndex'] <- "1" 
      paginate <- TRUE
    } else {
      if(!('pageSize' %in% names(search_criteria_attributes))){
        stop('Must supply a pageSize if using the pageIndex search criteria attribute')
      }
    }
    
    # both paging parameters must be specified  
    stopifnot(all(c('pageIndex', 'pageSize') %in% names(search_criteria_attributes)))
    
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
    
    if(verbose){
      message(xmlBody)
    }
    
    result <- perform_request(xmlBody)
    
    parsed_result <- list_result_parser(xmlBody = xmlBody, 
                                        paginate = paginate,
                                        result_text = result$text$value(), 
                                        request_type = code_type, 
                                        verbose = verbose)
    
    return(parsed_result)
}

doc_result_converter <- function(result_text){
  
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
  
  return(result_body_doc)
  
}

#' Parse List Recordsets with Pagination Support
#' 
#' This function takes an initial API return message with parameters
#' on how to paginate and parse the message and subsequent calls if needed
#'
#' @usage list_result_parser(xmlBody, paginate, result_text, request_type, verbose = FALSE)
#' @concept api list
#' @include utils.R
#' @importFrom plyr rbind.fill
#' @param xmlBody a character string that appears as XML of the original request
#' sent over to the API
#' @param paginate a \code{logical} indicating whether pagination is needed
#' @param result_text a character string that appears as XML as 
#' returned by an API call
#' @param request_type a character string in one of the supported 
#' object types for the API database list action
#' @param verbose a boolean indicating whether to print the request XML as a message
#' @return A \code{data.frame} listing all objects of the specified type that 
#' also met the supplied search criteria
list_result_parser <- function(xmlBody, paginate, result_text, request_type, 
                               verbose = FALSE){
  
  # pull out the results and format as XML
  # this takes some redundant steps to get the AdXML recognized as XML for parsing
  result_body_doc <- doc_result_converter(result_text)

  # check the total number of matching entries because we might need to
  # paginate through other resultsets
  total_n <- as.integer(xmlAttrs(getNodeSet(result_body_doc, 
                                            "//List")[[1]])['totalNumberOfEntries'])
  number_of_rows <- as.integer(xmlAttrs(getNodeSet(result_body_doc, 
                                            "//List")[[1]])['numberOfRows'])
  pageSize <- as.integer(xmlAttrs(getNodeSet(result_body_doc, 
                                                   "//List")[[1]])['pageSize'])
  
  result_df <- xmlToDataFrame(nodes = 
                                getNodeSet(result_body_doc, 
                                           paste0("//List/", request_type)), 
                              collectNames = F, stringsAsFactors = F)
  
  result_dfs <- list()
  result_dfs[[1]] <- result_df
  
  if(paginate & total_n > number_of_rows){
    
    batches_quotient <- total_n %/% pageSize
    batches_remainder <- total_n %% pageSize
    
    total_calls <- if(batches_remainder == 0) batches_quotient else batches_quotient + 1
    
    if(total_calls >= 2){
      for (i in 2:total_calls){
        
        # sub in new pageIndex and request
        xmlBody_next_page <- gsub('pageIndex="[0-9]+"', sprintf('pageIndex="%s"', i), xmlBody)
        if(verbose){
          message(xmlBody_next_page)
        }
        result <- exponential_backoff_retry(perform_request(xmlBody_next_page))
        # pull out the XML as text
        result_text <- result$text$value()
        result_body_doc <- doc_result_converter(result_text)
        result_df <- xmlToDataFrame(nodes = 
                                      getNodeSet(result_body_doc, 
                                                 paste0("//List/", request_type)), 
                                    collectNames = F, stringsAsFactors = F)
        result_dfs[[i]] <- result_df
      }
    }
  }
  
  final_df <- rbind.fill(result_dfs)
  
  return(final_df)
}