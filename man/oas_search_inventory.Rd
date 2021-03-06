% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inventory.R
\name{oas_search_inventory}
\alias{oas_search_inventory}
\title{Retrieve Search Inventory Reports}
\usage{
oas_search_inventory(credentials, 
                                report_type=c('KeywordForecast', 
                                              'KeywordStatistics', 
                                              'KeywordBooked'), 
                                report_name,
                                keywords,
                                max_row="100",
                                position=NULL,
                                campaign_id=NULL,
                                site_domain=NULL,
                                section_id=NULL,
                                start_date=NULL,
                                end_date=NULL)
}
\arguments{
\item{credentials}{a character string as returned by \link{oas_build_credentials}}

\item{report_type}{a character string in of the supported keyword
search inventory reports}

\item{report_name}{a character string of the report name. Please see the 
dataset \link{inventory_reports} and filter to inventory_type=="search" for 
a complete list of available report_type and report_name combinations for this
function.}

\item{keywords}{a character string containing comma separated keywords value 
for filtering inventory report.}

\item{max_row}{a character integer limiting the number of rows returned matching the
supplied keywords. A character is recommended to avoid larger numbers being formatted
in scientific notation and not being properly interpreted by the API.}

\item{position}{a character vector containing position names. 
Multiple "position" elements can be specified at once, hence a vector is accepted
instead of a string}

\item{campaign_id}{a character vector containing campaign ids. 
Multiple "campaign_id" elements can be specified at once, hence a vector is accepted
instead of a string}

\item{site_domain}{a character vector containing site domains. 
Multiple "site_domain" elements can be specified at once, hence a vector is accepted
instead of a string}

\item{section_id}{a character vector containing section ids. 
Multiple "section_id" elements can be specified at once, hence a vector is accepted
instead of a string}

\item{start_date}{a character string for inquiring inventory detail report. 
This field is optional and must be in the yyyy-mm-dd format.}

\item{end_date}{a character string for inquiring the inventory detail report by 
given schedule. This field is optional and must be in the yyyy-mm-dd format.}
}
\value{
A \code{data.frame} of inventory data in the format of the specified
report_type and report_name
}
\description{
This function returns a data.frame of search inventory statistics 
based on Keyword
}
\note{
Search inventory requests are only available if the Search module is enabled on the account

The arguments for position, campaign_id, site_domain, section_id are optional, but helpful 
in narrowing the focus for the resultset to shorten request and parsing time.
}
\examples{
\dontrun{
my_credentials <- build_credentials('myaccount', 
                                    'myusername', 
                                    'mypassword')
                                    
stats <- oas_search_inventory(credentials=my_credentials, 
                                  report_type='KeywordStatistics', 
                                  report_name='Statistics By Keyword',
                                  keywords='Kw1,Kw2', 
                                  position=c('Bottom', 'Bottom1'),
                                  section_id=c('Books'),
                                  site_domain=c('www.mysite.com'))
                                   
booked <- oas_search_inventory(credentials=my_credentials, 
                                   report_type='KeywordBooked', 
                                   report_name='Campaign Targets',
                                   keywords='Kw1,Kw2', 
                                   position=c('Bottom', 'Bottom1'),
                                   campaign_id=c('Test_Campaign'),
                                   site_domain=c('www.mysite.com'),
                                   start_date='2015-12-01', 
                                   end_date='2015-12-31')
                                     
}
}
\concept{
api inventory search report
}

