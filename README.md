<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.org/ReportMort/roas.svg?branch=master)](https://travis-ci.org/ReportMort/roas)

Open Ad Stream API from R
-------------------------

Interact with the Open Ad Stream (OAS) API from R

Features:

-   list\_request(): List OAS Objects into data.frame
-   read\_request(): Read all fields on an OAS Object
-   report\_request(): Run over 800 different template reports (Campaign Delivery, Account Revenue, etc.)
-   basic\_inventory\_request(): Run inventory reports over 18 different types (Site, Section, Campaign, etc.)
-   search\_inventory\_request(): Run inventory reports based on keyword search terms

### Install from Github using devtools

``` r
devtools::install_github('ReportMort/roas')
```

``` r
library('roas')
```

### Function naming convention

The functions are named to mimic each OAS request action ('Add', 'List', 'Update', 'Delete', 'Read', 'Copy', 'Upload', 'RunLive', 'Reports', 'Inventory'), but many of these actions are reserved words, so the functions are named {action}\_request(). For example, running the 'List' action is done with the function list\_request()

### Common Usage

list\_request()
---------------

List all sites in your account. Note that you first must build credentials for authorization and pass them to the request function. The credentials can be reused as many times as needed.

``` r
my_credentials <- build_credentials('myaccount', 'myusername', 'mypassword')
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

read\_request()
---------------

Retrieve all available fields on a site and a particular campaign

``` r
site_details <- read_request(credentials=my_credentials, 
                             request_type='Site', 
                             id='www.mysite.com')
campaign_details <- read_request(credentials=my_credentials, 
                                 request_type='Campaign', 
                                 id='one_campaign_id')
```

report\_request()
-----------------

Retrieve a template executive summary report on campaign delivery

``` r
campaign_delivery <- report_request(credentials=my_credentials, 
                                    report_type='Campaign',
                                    report_name='Executive Summary,
                                    start_date='2015-09-01', 
                                    end_date='2015-09-30')
```

basic\_inventory\_request()
---------------------------

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

### Overview of functions

| function                   | description                                                      | status  |
|:---------------------------|:-----------------------------------------------------------------|:--------|
| build\_credentials         | Create credentials to authorize each request                     | Done    |
| list\_request              | List instances of a particular OAS object                        | Done    |
| list\_code\_request        | List code maps for a particular OAS field                        | Done    |
| read\_request              | Read details of a particular OAS instance                        | Done    |
| report\_request            | Retrieve templatized OAS report                                  | Done    |
| basic\_inventory\_request  | Run templatized reports on inventory                             | Done    |
| search\_inventory\_request | Run templatized reports on inventory by search parameters        | TODO    |
| geo\_inventory\_request    | Run templatized reports on inventory by geolocations             | TODO    |
| zone\_inventory\_request   | Run templatized reports on inventory by zone                     | TODO    |
| add\_request               | Add an instance of an OAS object (requires elevated permissions) | UNKNOWN |
