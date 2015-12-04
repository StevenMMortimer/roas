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
#' @return A \code{data.frame} listing all objects of the specified type that 
#' also met the supplied search criteria
#' @note We recommend using the \link{oas_list} function to first understand
#' what attributes are available to be updated on each object type in Xaxis for Publishers
#' before attempting to update existing objects.
#' @examples
#' \dontrun{
#' my_credentials <- build_credentials('myaccount', 
#'                                     'myusername', 
#'                                     'mypassword')
#' adver_update <- oas_update(credentials=my_credentials, 
#'                            request_type='Advertiser', 
#'                            update_data=list(newXMLNode('Id', 'thisadvertiserid'), 
#'                                             newXMLNode('ContactTitle', 'new Title')))
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
  database_node <- newXMLNode("Database", attrs = c(action = "update"), 
                              parent = request_node)
  update_data_node <- newXMLNode(request_type,
                                 parent = database_node)
  for (node in update_data){
    addChildren(update_data_node, node)
  }
  adxml_string <- as(adxml_node, "character")
  
  xmlBody <- request_builder(credentials=credentials, 
                             adxml_request=adxml_string)
  
  result <- perform_request(xmlBody)
  
  parsed_result <- update_result_parser(result_text=result$text$value(), 
                                        request_type=request_type, 
                                        verbose=verbose)
  
  return(parsed_result)
}

update_result_parser <- function(result_text, request_type, verbose = FALSE){
  
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
  
  # retrieve result metadata
  result_list <- xmlToList(result_body_doc)
  
  if (verbose){
   message(result_list[['Response']][[request_type]])
  }
  
  # pull back only the results of this record type
  result_df <- xmlToDataFrame(nodes = getNodeSet(result_body_doc, 
                                                 paste0("//Update/", request_type)), collectNames = F)
  
  # add metadata as attributes
  result_attributes <- NULL
  if (nrow(result_df)==0){
    result_attributes <- as.list(result_list[['Response']][['Update']])
  } else {
    result_attributes <- as.list(result_list[['Response']][['Update']][['.attrs']])
  }
  attributes(result_df) <- c(attributes(result_df), result_attributes)
                     
  return(result_df)
}