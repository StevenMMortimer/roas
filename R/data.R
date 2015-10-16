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
#' data(error_codes)
#' 
#' head(error_codes)
#' #  errorCode                                       Type             Explanation
#' #1         0                                    Success Not normally presented.
#' #2       300 Authentication Failed: Incorrect Password.   Credentials incorrect
#' #3       302  Authentication Failed: Account Incorrect.   Credentials incorrect
NULL