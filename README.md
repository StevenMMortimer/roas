<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.org/ReportMort/roas.svg?branch=master)](https://travis-ci.org/ReportMort/roas) [![codecov.io](https://codecov.io/github/ReportMort/roas/coverage.svg?branch=master)](https://codecov.io/github/ReportMort/roas?branch=master)

Open Ad Stream API from R
-------------------------

Interact with the Open Ad Stream (OAS) API from R

Features:

-   oas\_build\_credentials(): One-time create authentication credentials and re-use
-   oas\_list(): List OAS Objects into data.frame
-   oas\_read(): Read all fields on an OAS Object
-   oas\_report(): Run over 800 different template reports
    -   Campaign Delivery
    -   Account Revenue
    -   More...
-   oas\_basic\_inventory(): Run inventory reports over 18 different types
    -   Site
    -   Section
    -   Campaign
    -   More...
-   oas\_search\_inventory(): Run inventory reports based on keyword search terms
-   oas\_geo\_inventory(): Run Site or Secton inventory across geography types
    -   Country
    -   State
    -   Postal Code
    -   DMA
    -   More...
-   oas\_zone\_inventory(): Run zone inventory reports for a site

Install from Github using devtools
----------------------------------

``` r
devtools::install_github('ReportMort/roas')
```

``` r
library('roas')
```

Settings
--------

There is a set of 8 package options. These may need to be configured based on your API instance. Set them using the `options()` function.

``` r

# defaults
roas.account = NULL
roas.username = NULL
roas.password = NULL
roas.url_endpoint = "https://openadstream18.247realmedia.com/oasapi/OaxApi"
roas.namespace = "https://api.oas.tfsm.com/"
roas.service_name = "OaxApiService"
roas.port_name = "OaxApiPort"
roas.method_name = "OasXmlRequest"

# setting authentication parameters
options(roas.account = "myaccountname")
options(roas.username = "myusername")
options(roas.password = "mypassword")

# setting a new endpoint to use for requests
options(roas.url_endpoint = "https://openadstream11.247realmedia.com/oasapi/OaxApi")
```

Functions
---------

The functions are named to mimic each OAS request action ('Add', 'List', 'Update', 'Delete', 'Read', 'Copy', 'Upload', 'RunLive', 'Reports', 'Inventory'), but many of these actions are reserved words, so the functions are named {oas\_action}(). For example, running the 'List' action is done with the function oas\_list().

Examples
--------

### oas\_build\_credentials()

Build credentials for authorization and pass them into subsequent request function calls. The credentials can be reused as many times as needed.

``` r
my_credentials <- oas_build_credentials('myaccount', 'myusername', 'mypassword')
```

### oas\_list()

List all sites in your account.

``` r
list_of_sites <- oas_list(credentials=my_credentials, request_type='Site')
```

List all pages with a particular search criteria.

``` r
list_w_criteria <- oas_list(credentials=my_credentials, request_type='Page', 
                                search_criteria_attributes = c(pageSize=100), 
                                search_criteria=list(newXMLNode("Domain", "mySite"), 
                                                     newXMLNode("Url", "001"), 
                                                     newXMLNode("SectionId", "Ar%ves"), 
                                                     newXMLNode("SiteId", "ApiSite"), 
                                                     newXMLNode("Description", "My Page"), 
                                                     newXMLNode("LocationKey", "7"), 
                                                     newXMLNode("WhenCreated", 
                                                                attrs = c(condition = "GT"), 
                                                                '2014-12-31'), 
                                                     newXMLNode("WhenModified", 
                                                                attrs = c(condition = "GT"), 
                                                                '2013-12-31')))
```

### oas\_list\_code()

List DMA Codes

``` r
dma_codes <- oas_list_code(credentials=my_credentials, code_type='DMA')
```

List City Codes for the US

``` r
country_criteria_node = newXMLNode("Country", parent = search_criteria_node)
country_code_node = newXMLNode("Code", "US", parent = country_criteria_node)
us_city_codes <- oas_list_code(credentials=my_credentials, code_type='City', 
                                   search_criteria_attributes = c(pageSize="20000"), 
                                   search_criteria=list(country_code_node))
```

### oas\_read()

Retrieve all available fields on a site and a particular campaign

``` r
site_details <- oas_read(credentials=my_credentials, 
                             request_type='Site', 
                             id='www.mysite.com')
campaign_details <- oas_read(credentials=my_credentials, 
                                 request_type='Campaign', 
                                 id='one_campaign_id')
```

### oas\_report()

Retrieve a template executive summary report on campaign delivery

``` r
campaign_delivery <- oas_report(credentials=my_credentials, 
                                    report_type='Campaign Delivery',
                                    report_name='Executive Summary',
                                    start_date='2015-09-01', 
                                    end_date='2015-09-30')
```

### oas\_basic\_inventory()

Retrieve an inventory forecast for all sites

``` r

# Note that start and end dates must be greater than or equal to 
# Sys.Date() otherwise forecast reprots will return a 0 row data.frame
overview <- oas_basic_inventory(credentials=my_credentials, 
                                    report_type='Overview', 
                                    report_name='All Sites Forecast',
                                    start_date='2015-12-01', 
                                    end_date='2015-12-31')
```

### oas\_search\_inventory()

Retrieve booked inventory based on two keywords (Kw1, Kw2) for a particular campaign on a site

``` r

booked <- oas_search_inventory(credentials=my_credentials, 
                                   report_type='KeywordBooked', 
                                   report_name='Campaign Targets',
                                   keywords='Kw1,Kw2',
                                   campaign_id=c('Test_Campaign'),
                                   site_domain=c('www.mysite.com'),
                                   start_date='2015-12-01', 
                                   end_date='2015-12-31')
```

### oas\_geo\_inventory()

Retrieve an inventory forecast for two positions on the "Books" section broken down by DMA

``` r

section_geo <- oas_geo_inventory(credentials=my_credentials, 
                                     report_type='Section', 
                                     report_geo='DMA',
                                     report_outlook='Forecast',
                                     id='Books',
                                     max_row="20000",
                                     position=c('Bottom', 'Bottom1'),
                                     start_date='2015-12-01', 
                                     end_date='2015-12-31')
```

TODO
----

| function                | description                                                            |
|:------------------------|:-----------------------------------------------------------------------|
| oas\_add                | Add an instance of an OAS object (requires elevated permissions)       |
| oas\_update             | Update an instance of an OAS object (requires elevated permissions)    |
| oas\_copy               | Copy an instance of an OAS object (requires elevated permissions)      |
| oas\_upload             | Upload an OAS object (requires elevated permissions)                   |
| oas\_analytics\_report  | Run an template report (e.g. Acquisition, Nagivation, Retention, etc.) |
