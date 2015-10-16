.onLoad <- function(libname, pkgname) {
  
  op <- options()
  op.roas <- list(
    roas.url_endpoint = "https://openadstream18.247realmedia.com/oasapi/OaxApi",
    roas.namespace = "https://api.oas.tfsm.com/",
    roas.service_name = "OaxApiService",
    roas.port_name = "OaxApiPort",
    roas.method_name = "OasXmlRequest"
  )
  toset <- !(names(op.roas) %in% names(op))
  if(any(toset)) options(op.roas[toset])
  
  invisible()
  
}