#' @references Groemping, U. (2019). South German Credit Data: Correcting a 
#'   Widely Used Data Set. Report 4/2019, Reports in Mathematics, Physics and 
#'   Chemistry, Department II, Beuth University of Applied Sciences Berlin.
#' @source [http://www1.beuth-hochschule.de/FB_II/reports/Report-2019-004.pdf]
#' @source [https://archive.ics.uci.edu/ml/datasets/South+German+Credit]
#' @author [Ulrike Grömping](https://prof.beuth-hochschule.de/groemping/)

#' # download zip file
f <- tempfile()
download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/00522/SouthGermanCredit.zip", f)

#' # unzip
d <- tempdir()
unzip(f, exdir = file.path(d, "GermanCredit"))

#' # run script
cwd <- setwd(d)
source("GermanCredit/read_SouthGermanCredit.R")
setwd(cwd)

#' # save `dat` dataset as `data/german.rda`
require(usethis)
german <- dat
usethis::use_data(german, overwrite = TRUE)
