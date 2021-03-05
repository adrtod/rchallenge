
## Test environments
* Local, ubuntu 18.04.5: 4.0.4
* GitHub Actions, ubuntu-20.04: release, devel
* GitHub Actions, windows-latest: release
* Github Actions, macOS-latest: release
* R-hub builder, Windows Server 2008 R2 SP1: devel, 32/64 bit
* R-hub builder, Ubuntu Linux 20.04.1 LTS: release, GCC
* R-hub builder, Fedora Linux: devel, clang, gfortran
* win-builder: devel
          
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

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
