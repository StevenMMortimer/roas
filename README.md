<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.org/reportmort/roas.svg?branch=master)](https://travis-ci.org/reportmort/roas)

Open Ad Stream API from R
-------------------------

Interact with the Open Ad Stream (OAS) API from R

Features:

-   List OAS Objects into data.frame

### Install from Github using devtools

``` r
devtools::install_github('reportmort/roas')
```

``` r
library("roas")
```

### Function naming convention

The functions are named to mimic each OAS request action ('Add', 'List', 'Update', 'Delete', 'Read', 'Copy', 'Upload', 'RunLive', 'Reports', 'Inventory'), but many of these actions are reserved words, so the functions are named {action\_request}. For example, running the 'List' action is done with the function list\_request()

### Common Usage

List all sites in your account. Note that you first must build credentials for authorization and pass them to the request function. The credentials can be reused as many times as needed.

``` r
my_credentials <- build_credentials('myaccount', 'myusername', 'mypassword')
list_of_sites <- list_request(credentials=my_credentials, request_type='Site')
```

List all pages with a particular search criteria.

``` r
list_by_criteria <- list_request(credentials=my_credentials, request_type='Page', 
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

### Overview of functions

| function                   | description                                                    | status  |
|:---------------------------|:---------------------------------------------------------------|:--------|
| build\_credentials         | Create credentials to authorize each request                   | Done    |
| list\_request              | List instances of a particular OAS object                      | Done    |
| list\_code\_request        | List code maps for a particular OAS field                      | Done    |
| read\_request              | Read details of a particular OAS instance                      | TODO    |
| report\_request            | Retrieve templatized OAS report                                | TODO    |
| inventory\_report\_request | Run templatized Inventory Reports                              | TODO    |
| add\_request               | Add an instance of an OAS object requires elevated permissions | UNKNOWN |
