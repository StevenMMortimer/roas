#' Read/Retrieve all details for a requested object
#' 
#' This function returns a lists of all the available data points for 
#' requested data type specified in the read_request. Most elements support the 
#' READ function except Companion Position, Competitive Category and Code.
#'
#' @usage read_request(credentials, 
#'                     request_type=c('Advertiser', 'AdvertiserCategory', 
#'                                    'Affiliate', 'Agency', 'CampaignGroup', 
#'                                    'ConversionProcess', 'Zone', 'CreativeType',
#'                                    'Event', 'InsertionOrder', 'RichMediaTemplate', 
#'                                    'Product', 'SalesPerson', 
#'                                    'Site', 'SiteGroup', 'Publisher', 
#'                                    'Page', 'Section', 'Transaction',
#'                                    'Keyname', 'Keyword', 
#'                                    'Campaign', 'CreativeTarget', 
#'                                    'Creative', 'Notification'),
#'                     Id, CampaignId=NULL)
#' @concept api read
#' @include utils.R
#' @param credentials a character string as returned by \link{build_credentials}
#' @param request_type a character string in one of the supported 
#' object types for the API database read action
#' @param Id a character string that uniquely identifies an item to retrieve. For the request
#' of  some objects Id serves as the Name (Affiliate, ConversionProcess, Event, Transaction, Keyname)
#' @param CampaignId a character string that identifies a campaign when CreativeTarget, Creative
#' or Notification reads are being performed, otherwise this value will be ignored
#' @return A \code{list} of all fields available for the specified request type
#' @examples
#' \dontrun{
#' my_credentials <- build_credentials('myaccount', 
#'                                     'myusername', 
#'                                     'mypassword')
#' site_details <- read_request(credentials=my_credentials, 
#'                                  request_type='SIte', 
#'                                  Id='www.mysite.com')
#' campaign_details <- read_request(credentials=my_credentials, 
#'                                  request_type='Campaign', 
#'                                  Id='one_campaign_id')
#' creative_details <- read_request(credentials=my_credentials, 
#'                                  request_type='Creative', 
#'                                  Id='one_creative_id', 
#'                                  CampaignId='one_campaign_id')
#' }
#' @export
read_request <- function(credentials, 
                         request_type=c('Advertiser', 'AdvertiserCategory', 
                                        'Affiliate', 'Agency', 'CampaignGroup', 
                                        'ConversionProcess', 'Zone', 'CreativeType',
                                        'Event', 'InsertionOrder', 'RichMediaTemplate', 
                                        'Product', 'SalesPerson', 
                                        'Site', 'SiteGroup', 'Publisher', 
                                        'Page', 'Section', 'Transaction',
                                        'Keyname', 'Keyword', 
                                        'Campaign', 'CreativeTarget', 
                                        'Creative', 'Notification'),
                         Id, CampaignId=NULL){
  
  adxml_node <- newXMLNode("AdXML")
  request_node <- newXMLNode("Request", attrs = c(type = request_type), 
                             parent = adxml_node)
  if(request_type %in% c('Campaign', 'InsertionOrder', 'CreativeTarget', 
                         'Creative', 'Notification')){
    type_node <- newXMLNode(request_type, attrs = c(action = "read"), 
                            parent = request_node)
  } else {
    database_node <- newXMLNode("Database", attrs = c(action = "read"), 
                               parent = request_node)
    type_node <- newXMLNode(request_type, parent = database_node)
  }
  
  if(request_type %in% c('Affiliate', 'ConversionProcess', 'Event', 
                         'Transaction', 'Keyname')){
    id_node <- newXMLNode("Name", Id, parent = type_node)
  } else if(request_type == 'Zone'){
    id_node <- newXMLNode("Code", Id, parent = type_node)
  } else if(request_type == 'Page'){
    id_node <- newXMLNode("Url", Id, parent = type_node)
  } else if (request_type == 'Campaign'){
    overview_node <- newXMLNode("Overview", parent = type_node)
    id_node <- newXMLNode("Id", Id, parent = overview_node)
  } else if (request_type == 'CreativeTarget') {
    ctoverview_node <- newXMLNode("CTOverview", parent = type_node)
    parentcampaignid_node <- newXMLNode("ParentCampaignId", CampaignId, 
                                        parent = ctoverview_node)
    id_node <- newXMLNode("Id", Id, parent = ctoverview_node)
  } else if (request_type == 'Creative') {
    campaign_node <- newXMLNode("CampaignId", CampaignId, parent = type_node)
    id_node <- newXMLNode("Id", Id, parent = type_node)
  } else if (request_type == 'Notification') {
    campaign_node <- newXMLNode("CampaignId", CampaignId, parent = type_node)
    id_node <- newXMLNode("EventName", Id, parent = type_node)
  } else {
    id_node <- newXMLNode("Id", Id, parent = type_node)
  }

  adxml_string <- as(adxml_node, "character")
  
  xmlBody <- request_builder(credentials=credentials, 
                             adxml_request=adxml_string)
  
  result <- perform_request(xmlBody)
  
  parsed_result <- read_result_parser(result_text=result$text$value(), 
                                      request_type=request_type, 
                                      verbose=verbose)
  
  return(parsed_result)
}

read_result_parser <- function(result_text, request_type, verbose = FALSE){
  
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

  return(result_list)
}