#' roas: Open Ad Stream API from R
#'
#' roas is a convience wrapper around with Open Ad Stream (OAS) API
#' 
#' @docType package
#' @name roas
#' @import XML
#' @importFrom methods as
#' @keywords package
#' @seealso XML RCurl
#' @examples
#' \dontrun{
#' 
#' options(stringsAsFactors = FALSE)
#' library(XML)
#' library(roas)
#' 
#' # create your credentials
#' my_credentials <- oas_build_credentials(account=myaccount, 
#'                                         username=myusername, 
#'                                         password=mypassword)
#' 
#' # get a list of sites from your OAS account
#' my_list_of_sites <- oas_list(credentials=my_credentials, request_type='Site')
#'                                   
#' # restrict lists with search criteria
#' list_by_criteria <- oas_list(credentials=my_credentials, request_type='Page', 
#'                                  search_criteria_attributes = c(pageSize=100), 
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
#'                                                                  '2013-12-31'))))
#'  
#' # retrieve geographic codes 
#' 
#' country_criteria_node = newXMLNode("Country")
#' country_code_node = newXMLNode("Code", "US", parent = country_criteria_node)
#' 
#' list_city_codes_by_country <- oas_list_code(credentials=my_credentials, code_type='City', 
#'                                             search_criteria_attributes = c(pageSize="1000"), 
#'                                             search_criteria=list(country_code_node))
#' )
#' 
#' # run a precanned report
#' site_delivery_info <- oas_report(credentials = my_credentials, 
#'                                  report_type = 'Site Delivery', 
#'                                  report_name = 'Executive Summary', 
#'                                  id = 'www.mysite.com')
#' }
NULL
