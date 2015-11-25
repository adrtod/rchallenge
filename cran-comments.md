## Resubmission
This is a resubmission. In this version I have:

* changed datascience to "data science" in the description and title

* provided URLs for Dropbox and Kaggle in agle brackets in the description

## Test environments
* ubuntu 14.04 64-bit, R 3.2.2
* win-builder (release)

## R CMD check results
There were no ERRORs or WARNINGs.

There was one NOTE:

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Adrien Todeschini <adrien.todeschini@gmail.com>’

Possibly mis-spelled words in DESCRIPTION:
  Dropbox (6:74)
  Kaggle (8:15)
  
  These words are correct.

## Existing problems

<https://cran.rstudio.com/web/checks/check_results_rchallenge.html>

* I have added the importFrom instructions to NAMESPACE

* I am unable to solve dependency problem on pandoc for these platforms:
  r-patched-solaris-sparc, r-patched-solaris-x86, r-release-osx-x86_64-mavericks

## Downstream dependencies
There are currently no downstream dependencies for this package.
