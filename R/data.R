#' Error Codes Table
#'
#' This data.frame contains error codes and explanations
#' 
#' \itemize{
#'   \item errorCode: a numeric code indicating an error type
#'   \item Type: a brief statement of the type of error
#'   \item Explanation: a reason why that type of error occured
#' }
#'
#' @docType data
#' @keywords datasets
#' @name error_codes
#' @usage error_codes
#' @format a \code{data.frame} with 192 rows and 3 variables
#' @examples
#' \dontrun{
#' data(error_codes)
#' 
#' head(error_codes)
#' #  errorCode                                       Type             Explanation
#' #1         0                                    Success Not normally presented.
#' #2       300 Authentication Failed: Incorrect Password.   Credentials incorrect
#' #3       302  Authentication Failed: Account Incorrect.   Credentials incorrect
#' }
NULL

#' Available Reports Table
#'
#' This data.frame contains all of the reports available via
#' the \link{oas_report} function. Simply provide the 
#' same report_type and report_name as seen in this table
#' to retrive via that function
#' 
#' \itemize{
#'   \item report_type: the type of object the report covers
#'   \item report_id: an OAS id needed internally to request the report table
#'   \item report_name: a human readable name of the report
#' }
#'
#' @docType data
#' @keywords datasets
#' @name available_reports
#' @usage available_reports
#' @format a \code{data.frame} with 619 rows and 3 variables
#' @examples
#' \dontrun{
#' data(available_reports)
#' 
#' head(available_reports)
#' #          report_type                      report_id                       report_name
#' #  1 Campaign Delivery Delivery.Campaign.Base.T100.03                 Executive Summary
#' #  2 Campaign Delivery Delivery.Campaign.Base.T102.06                  Campaign Summary
#' #  3 Campaign Delivery Delivery.Campaign.Base.T110.02              Campaign Information
#' #  4 Campaign Delivery Delivery.Campaign.Base.T120.02   Advertiser & Agency Information
#' #  5 Campaign Delivery Delivery.Campaign.Base.T150.01 Day of Month Delivery Information
#' #  6 Campaign Delivery Delivery.Campaign.Base.T152.01  Day of Week Delivery Information
#' }
NULL

#' Inventory Reports Table
#'
#' This data.frame contains all of the inventory reports available via
#' the \link{oas_basic_inventory},  \link{oas_search_inventory}
#' \link{oas_geo_inventory}, and \link{oas_zone_inventory} functions. 
#' Simply provide the same report_type and report_name as seen in this table
#' to retrive via those functions
#' 
#' \itemize{
#'   \item inventory_type: the type of inventory function being called
#'   (e.g. basic, search, geo, or zone)
#'   \item keywords_type: a type attribute tagged to the keywords node
#'   if used in a report
#'   \item report_type: the type of object the report covers
#'   \item report_id: an OAS id needed internally to request the report table
#'   \item report_name: a human readable name of the report
#' }
#'
#' @docType data
#' @keywords datasets
#' @name inventory_reports
#' @usage inventory_reports
#' @format a \code{data.frame} with 121 rows and 5 variables
#' @examples
#' \dontrun{
#' data(inventory_reports)
#' 
#' head(inventory_reports)
#' #   inventory_type keywords_type   report_type           report_id           report_name
#' # 1          basic               configuration       Configuration         configuration
#' # 2          basic                    overview  AllCampaignsBooked  all campaigns booked
#' # 3          basic                    overview    AllSitesForecast    all sites forecast
#' # 4          basic                    overview AllSectionsForecast all sections forecast
#' # 5          basic                    overview     GlobalInventory      global inventory
#' # 6          basic      campaign      campaign        ListOverview         list overview
#' }
NULL