#' Update Items in API Database
#' 
#' This function updates items in Xaxis for Publishers.
#'
#' @usage oas_update(credentials, 
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
#'                      update_data, verbose = FALSE)
#' @concept api update
#' @include utils.R
#' @param credentials a character string as returned by \link{oas_build_credentials}
#' @param request_type a character string in one of the supported 
#' object types for the API database list action
#' @param update_data an XML document specifying the data to be updated based on the request_type
#' @param verbose a boolean indicating whether messages should be printed while making the request
#' @return A \code{logical} being TRUE if the update was successful
#' @note We recommend using the \link{oas_list} function to first understand
#' what attributes are available to be updated on each object type in Xaxis for Publishers
#' before attempting to update existing objects.
#' @examples
#' \dontrun{
#' my_credentials <- oas_build_credentials('myaccount', 
#'                                         'myusername', 
#'                                         'mypassword')
#'                                     
#' adver_update <- oas_update(credentials=my_credentials, 
#'                            request_type='Advertiser', 
#'                            update_data=list(addChildren(
#'                                             newXMLNode('Advertiser'), 
#'                                                list(newXMLNode('Id', 'thisadvertiserid'), 
#'                                                     newXMLNode('ContactTitle', 'new Title')))))
#'                                             
#' campaign_update <- oas_update(credentials=my_credentials, 
#'                               request_type='Campaign', 
#'                               update_data=list(addChildren(
#'                                  newXMLNode('Overview'), 
#'                                  list(newXMLNode('Id', 'myExistingCampaignId'), 
#'                                  newXMLNode('Status', 'L'),
#'                                  addChildren(
#'                                  newXMLNode('CompetitiveCategories'),
#'                                  list(newXMLNode('CompetitiveCategoryId','Airlines'), 
#'                                       newXMLNode('CompetitiveCategoryId','Travel')))))))
#'                                             
#' }
#' @export
oas_update <- function(credentials, 
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
                       update_data, verbose = FALSE){
  
  adxml_node <- newXMLNode("AdXML")
  request_node <- newXMLNode("Request", attrs = c(type = request_type), 
                             parent = adxml_node)
  if (request_type %in% c('Campaign', 'Notification', 'InsertionOrder', 'CreativeTarget', 'Creative')){
    database_node <- newXMLNode(request_type, attrs = c(action = "update"), 
                                parent = request_node)
  } else {
    database_node <- newXMLNode("Database", attrs = c(action = "update"), 
                                parent = request_node)
  }
  for (node in update_data){
    addChildren(database_node, node)
  }
  
  if(verbose)
    print(adxml_node)
  
  adxml_string <- as(adxml_node, "character")
  
  xmlBody <- request_builder(credentials=credentials, 
                             adxml_request=adxml_string)
  
  result <- perform_request(xmlBody)
  
  parsed_result <- update_result_parser(result_text=result$text$value(), 
                                        request_type=request_type)
  
  return(parsed_result)
}

update_result_parser <- function(result_text, request_type){
  
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