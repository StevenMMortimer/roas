% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/list.R
\name{oas_list_code}
\alias{oas_list_code}
\title{List Code Items from API Database}
\usage{
oas_list_code(credentials, 
                         code_type=c('Bandwidth', 'Browser', 'BrowserV', 'Continent',
                                     'Country', 'City', 'State', 'DMA', 'MSA', 
                                     'EventType', 'HourOfDay', 'WeekDay',
                                     'Omniture', 'OS', 'Position',
                                     'TopDomain', 'Zone', 'Carrier', 
                                     'DeviceGroup', 'Device', 'Manufacturer'),
                         search_criteria_attributes = c(pageIndex="-1", pageSize="1000"),
                         search_criteria = NULL, verbose = FALSE)
}
\arguments{
\item{credentials}{a character string as returned by \link{oas_build_credentials}}

\item{code_type}{a character string in one of the supported 
code types for the API database list action}

\item{search_criteria_attributes}{a named character vector of attributes 
to add to the SearchCriteria node. Acceptable parameters are pageSize and 
pageIndex to support paginated requests. Default pageSize for request types Campaign, 
CampaignGroup, and Creatives is: 30,000, while all others have a default pageSize of 1000.}

\item{search_criteria}{an XML document specifying the children to be 
added to the SearchCriteria Node in the request}

\item{verbose}{a boolean indicating whether to print the request XML as a message}
}
\value{
A \code{data.frame} listing all objects of the specified type that 
also met the supplied search criteria
}
\description{
This function returns a data.frame listing codes associated to a particular 
field on an object in Xaxis for Publishers. Certain search criteria may 
be added to the request to narrow the results returned. This function is very similar to 
\code{list_request}; however it is specifically for returning code maps.
}
\examples{
\dontrun{
my_credentials <- build_credentials('myaccount', 
                                    'myusername', 
                                    'mypassword')
                                    
country_criteria_node = newXMLNode("Country", parent = search_criteria_node)
country_code_node = newXMLNode("Code", "US", parent = country_criteria_node)
us_city_codes <- oas_list_code(credentials=my_credentials, code_type='City', 
                                   search_criteria_attributes = c(pageSize="20000"), 
                                   search_criteria=list(country_code_node))
}
}
\concept{
api list
}

