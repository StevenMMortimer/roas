#' Execute Run Live Campaigns Command
#' 
#' This function allows you to run 3 different RLC operations
#'
#' @usage oas_run_live(credentials, 
#'                     action = c('TestLiveCampaigns', 
#'                                'RunLiveCampaigns', 'LastStatusRLC'), 
#'                     verbose = FALSE)
#' @concept api run_live
#' @include utils.R
#' @param credentials a character string as returned by \link{oas_build_credentials}
#' @param action a character string in one of the supported run live operations
#' @param verbose a boolean indicating whether messages should be printed while making the request
#' @return A \code{list} of the resulting operation
#' @examples
#' \dontrun{
#' my_credentials <- oas_build_credentials('myaccount', 
#'                                         'myusername', 
#'                                         'mypassword')
#'                                         
#' tlc_result <- oas_run_live(credentials, 
#'                            action='TestLiveCampaigns')
#'                            
#' rlc_result <- oas_run_live(credentials, 
#'                            action='RunLiveCampaigns')
#'                            
#' last_rlc_result <- oas_run_live(credentials, 
#'                                 action='LastStatusRLC')
#'                                             
#' }
#' @export
oas_run_live <- function(credentials, 
                         action=c('TestLiveCampaigns', 
                                  'RunLiveCampaigns', 'LastStatusRLC'), 
                         verbose=FALSE){
  
  adxml_node <- newXMLNode("AdXML")
  request_node <- newXMLNode("Request", 
                             attrs = c(type = "Campaign"), 
                             parent = adxml_node)
  run_node <- newXMLNode('Campaign', 
                              attrs = c(action = "run"), 
                              parent = request_node)
  rlc_node <- newXMLNode(action, parent = run_node)

  if(verbose)
    print(adxml_node)
  
  adxml_string <- as(adxml_node, "character")
  
  xmlBody <- request_builder(credentials=credentials, 
                             adxml_request=adxml_string)
  
  result <- perform_request(xmlBody)
  
  parsed_result <- run_live_result_parser(result_text=result$text$value(), 
                                          request_type=action)
  
  return(parsed_result)
}

run_live_result_parser <- function(result_text, request_type){
  
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
  
  result_list <- xmlToList(result_body_doc)
  
  return(result_list)
}