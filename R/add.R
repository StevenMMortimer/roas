#' Add Items in API Database
#' 
#' This function adds items in Xaxis for Publishers.
#'
#' @usage oas_add(credentials, 
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
#'                      add_data, verbose = FALSE)
#' @concept api add
#' @importFrom methods as
#' @include utils.R
#' @param credentials a character string as returned by \link{oas_build_credentials}
#' @param request_type a character string in one of the supported 
#' object types for the API database list action
#' @param add_data an XML document specifying the data to add when creating the request_type
#' @param verbose a boolean indicating whether messages should be printed while making the request
#' @return A \code{logical} being TRUE if the add was successful
#' @note We recommend using the \link{oas_list} function to first understand
#' what attributes are available on each object type in Xaxis for Publishers
#' before attempting to add existing objects, especially for complicated types, 
#' such as, Campaigns which have many configurable attributes.
#' @examples
#' \dontrun{
#' my_credentials <- oas_build_credentials('myaccount', 
#'                                         'myusername', 
#'                                         'mypassword')
#'                                     
#' adver_add <- oas_add(credentials=my_credentials, 
#'                            request_type='Advertiser', 
#'                            update_data=list(addChildren(
#'                                             newXMLNode('Advertiser'), 
#'                                                list(newXMLNode('Id', 'MyAdvertiserId'), 
#'                                                     newXMLNode('ContactTitle', 'new Title')))))
#'                                             
#' }
#' @export
oas_add <- function(credentials, 
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
                       add_data, verbose = FALSE){
  
  adxml_node <- newXMLNode("AdXML")
  request_node <- newXMLNode("Request", attrs = c(type = request_type), 
                             parent = adxml_node)
  if (request_type %in% c('Campaign', 'Notification', 'InsertionOrder', 'CreativeTarget', 'Creative')){
    database_node <- newXMLNode(request_type, attrs = c(action = "add"), 
                                parent = request_node)
  } else {
    database_node <- newXMLNode("Database", attrs = c(action = "add"), 
                                parent = request_node)
  }
  for (node in add_data){
    addChildren(database_node, node)
  }
  
  if(verbose)
    print(adxml_node)
  
  adxml_string <- as(adxml_node, "character")
  
  xmlBody <- request_builder(credentials=credentials, 
                             adxml_request=adxml_string)
  
  result <- perform_request(xmlBody)
  
  parsed_result <- add_result_parser(result_text=result$text$value(), 
                                        request_type=request_type)
  
  return(parsed_result)
}

add_result_parser <- function(result_text, request_type){
  
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
    stop(paste0('errorCode ', errorcode, ": ", errormessage), call. = F)
  }
  
  # else simply return true as updated
  return(TRUE)
}