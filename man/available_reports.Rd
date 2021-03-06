% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{available_reports}
\alias{available_reports}
\title{Available Reports Table}
\format{a \code{data.frame} with 619 rows and 3 variables}
\usage{
data(available_reports)
}
\description{
This data.frame contains all of the reports available via
the \link{oas_report} function. Simply provide the 
same report_type and report_name as seen in this table
to retrive via that function
}
\details{
\itemize{
  \item report_type: the type of object the report covers
  \item report_id: an OAS id needed internally to request the report table
  \item report_name: a human readable name of the report
}
}
\examples{
\dontrun{
data(available_reports)

head(available_reports)
#          report_type                      report_id                       report_name
#  1 Campaign Delivery Delivery.Campaign.Base.T100.03                 Executive Summary
#  2 Campaign Delivery Delivery.Campaign.Base.T102.06                  Campaign Summary
#  3 Campaign Delivery Delivery.Campaign.Base.T110.02              Campaign Information
#  4 Campaign Delivery Delivery.Campaign.Base.T120.02   Advertiser & Agency Information
#  5 Campaign Delivery Delivery.Campaign.Base.T150.01 Day of Month Delivery Information
#  6 Campaign Delivery Delivery.Campaign.Base.T152.01  Day of Week Delivery Information
}
}
\keyword{datasets}

