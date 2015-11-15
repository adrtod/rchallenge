## Test environments
* ubuntu 14.04 64-bit, R 3.2.2
* win-builder (release)

## R CMD check results
There were no ERRORs or WARNINGs.

There was one NOTE:

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Adrien Todeschini <adrien.todeschini@gmail.com>’

Possibly mis-spelled words in DESCRIPTION:
  Datascience (2:17)
  Dropbox (6:73)
  Kaggle (8:15)
  datascience (6:23)
  
  These words are correct.

## Existing problems

<https://cran.rstudio.com/web/checks/check_results_rchallenge.html>

* I have added the importFrom instructions to NAMESPACE
* I am unable to solve dependency problem on pandoc for these platforms:
  r-patched-solaris-sparc, r-patched-solaris-x86, r-release-osx-x86_64-mavericks

## Downstream dependencies
There are currently no downstream dependencies for this package.

