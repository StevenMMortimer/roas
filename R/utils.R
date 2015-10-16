#' Build AdXML Request for API
#' 
#' This function is an internal helper that combines the credentials 
#' string with the AdXML body to create a properly formatted API request.
#'
#' @usage request_builder(credentials, adxml_request)
#' @concept api request
#' @param credentials a character string as returned by \link{build_credentials}
#' @param adxml_request an XML document formatted as AdXML that forms the basis of the API request. The AdXML will vary depending on the request being made.
#' @return A \code{character}, formatted as XML, that is ready for a POST to the API endpoint
request_builder <- function(credentials, adxml_request){
  return(paste0(credentials, 
                '<String_4>
                <![CDATA[
                <?xml version="1.0"?>',
                adxml_request, 
                ']]>
                </String_4>
                </n1:',  getOption("roas.method_name"), '>',
                '</env:Body>
                </env:Envelope>'))
}

#' POST AdXML Request to API
#' 
#' This function is an internal helper actually makes the POST request
#'
#' @usage perform_request(xmlBody)
#' @concept api request
#' @param xmlBody character string formatted to look like XML in order to make the request
#' @return A \code{list}, with header and text gatherers
perform_request <- function(xmlBody){
  
  #TODO - let global RCurl handle options to set ssl.verify, etc.
  h <- basicHeaderGatherer()
  t <- basicTextGatherer()
  httpHeader <- c('soapAction'= getOption("roas.method_name"), "Accept-Type"="text/xml", 'Content-Type'="text/xml")
  curlPerform(url=getOption("roas.url_endpoint"),
                      httpheader=httpHeader, 
                      headerfunction = h$update, 
                      writefunction = t$update, 
                      ssl.verifypeer=F, postfields=xmlBody)
  
  return(list(header=h, text=t))
}
