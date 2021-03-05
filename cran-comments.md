
## Test environments
* ubuntu 18.04.5, 64 bit, R 4.0.4 (local)
* win-builder (devel)
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit (R-hub builder)
* Ubuntu Linux 20.04.1 LTS, R-release, GCC (R-hub builder)
* Fedora Linux, R-devel, clang, gfortran (R-hub builder)

## R CMD check results
There were no ERRORs or WARNINGs.

There was one NOTE:

NOTE
  Maintainer: 'Adrien Todeschini <adrien.todeschini@gmail.com>'
  
  Found the following (possibly) invalid URLs:
    URL: https://adrtod.github.io (moved to https://adrien.tspace.fr/)
      From: man/rchallenge-package.Rd
      Status: 200
      Message: OK
    URL: https://adrtod.github.io/challenge-mimse2014/ (moved to https://adrien.tspace.fr/challenge-mimse2014/)
      From: man/rchallenge-package.Rd
      Status: 200
      Message: OK
    URL: https://adrtod.github.io/rchallenge (moved to https://adrien.tspace.fr/rchallenge/)
      From: DESCRIPTION
            man/rchallenge-package.Rd
      Status: 200
      Message: OK

I keep https://adrtod.github.io domain nevertheless, because https://adrien.tspace.fr is subject to change, while https://adrtod.github.io is permanent.

## revdepcheck results
