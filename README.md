<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.org/ReportMort/roas.svg?branch=master)](https://travis-ci.org/ReportMort/roas)

Open Ad Stream API from R
-------------------------

Interact with the Open Ad Stream (OAS) API from R

Features:

-   build\_credentials(): One-time create authentication credentials and re-use
-   list\_request(): List OAS Objects into data.frame
-   read\_request(): Read all fields on an OAS Object
-   report\_request(): Run over 800 different template reports
    -   Campaign Delivery
    -   Account Revenue
    -   More...
-   basic\_inventory\_request(): Run inventory reports over 18 different types
    -   Site
    -   Section
    -   Campaign
    -   More...
-   search\_inventory\_request(): Run inventory reports based on keyword search terms
-   geo\_inventory\_request(): Run Site or Secton inventory across geography types
    -   Country
    -   State
    -   Postal Code
    -   DMA
    -   More...
-   zone\_inventory\_request(): Run zone inventory reports for a site

Install from Github using devtools
----------------------------------

``` r
devtools::install_github('ReportMort/roas')
```

``` r
library('roas')
```

Function naming convention
--------------------------

The functions are named to mimic each OAS request action ('Add', 'List', 'Update', 'Delete', 'Read', 'Copy', 'Upload', 'RunLive', 'Reports', 'Inventory'), but many of these actions are reserved words, so the functions are named {action}\_request(). For example, running the 'List' action is done with the function list\_request()

Common Usage
------------

### build\_credentials()

Build credentials for authorization and pass them into subsequent request function calls. The credentials can be reused as many times as needed.

``` r
my_credentials <- build_credentials('myaccount', 'myusername', 'mypassword')
```

### Setting options

There is a set of 5 package options that are default set upon load. These may need to be configured based on your API instance. Set them using the `option()`

``` r

# defaults
roas.url_endpoint = "https://openadstream18.247realmedia.com/oasapi/OaxApi",
roas.namespace = "https://api.oas.tfsm.com/",
roas.service_name = "OaxApiService",
roas.port_name = "OaxApiPort",
roas.method_name = "OasXmlRequest"

# setting a new endpoint to use for requests
options(roas.url_endpoint = "https://openadstream11.247realmedia.com/oasapi/OaxApi")
```

### list\_request()

List all sites in your account.

``` r
list_of_sites <- list_request(credentials=my_credentials, request_type='Site')
```

List all pages with a particular search criteria.

``` r
list_w_criteria <- list_request(credentials=my_credentials, request_type='Page', 
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

### list\_code\_request()

List DMA Codes

``` r
dma_codes <- list_code_request(credentials=my_credentials, code_type='DMA')
```

List City Codes for the US

``` r
country_criteria_node = newXMLNode("Country", parent = search_criteria_node)
country_code_node = newXMLNode("Code", "US", parent = country_criteria_node)
us_city_codes <- list_code_request(credentials=my_credentials, code_type='City', 
                                   search_criteria_attributes = c(pageSize="20000"), 
                                   search_criteria=list(country_code_node))
```

### read\_request()

Retrieve all available fields on a site and a particular campaign

``` r
site_details <- read_request(credentials=my_credentials, 
                             request_type='Site', 
                             id='www.mysite.com')
campaign_details <- read_request(credentials=my_credentials, 
                                 request_type='Campaign', 
                                 id='one_campaign_id')
```

### report\_request()

Retrieve a template executive summary report on campaign delivery

``` r
campaign_delivery <- report_request(credentials=my_credentials, 
                                    report_type='Campaign',
                                    report_name='Executive Summary,
                                    start_date='2015-09-01', 
                                    end_date='2015-09-30')
```

### basic\_inventory\_request()

Retrieve an inventory forecast for all sites

``` r

# Note that start and end dates must be greater than or equal to 
# Sys.Date() otherwise forecast reprots will return a 0 row data.frame
overview <- basic_inventory_request(credentials=my_credentials, 
                                    report_type='Overview', 
                                    report_name='All Sites Forecast',
                                    start_date='2015-12-01', 
                                    end_date='2015-12-31')
```

### search\_inventory\_request()

Retrieve booked inventory based on two keywords (Kw1, Kw2) for a particular campaign on a site

``` r

booked <- search_inventory_request(credentials=my_credentials, 
                                   report_type='KeywordBooked', 
                                   report_name='Campaign Targets',
                                   keywords='Kw1,Kw2',
                                   campaign_id=c('Test_Campaign'),
                                   site_domain=c('www.mysite.com'),
                                   start_date='2015-12-01', 
                                   end_date='2015-12-31')
```

### geo\_inventory\_request()

Retrieve an inventory forecast for two positions on the "Books" section broken down by DMA

``` r

section_geo <- geo_inventory_request(credentials=my_credentials, 
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

| function                   | description                                                            |
|:---------------------------|:-----------------------------------------------------------------------|
| add\_request               | Add an instance of an OAS object (requires elevated permissions)       |
| update\_request            | Update an instance of an OAS object (requires elevated permissions)    |
| copy\_request              | Copy an instance of an OAS object (requires elevated permissions)      |
| upload\_request            | Upload an OAS object (requires elevated permissions)                   |
| analytics\_report\_request | Run an template report (e.g. Acquisition, Nagivation, Retention, etc.) |
