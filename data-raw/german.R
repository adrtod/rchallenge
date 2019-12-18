#' @references Grömping, U. (2019). South German Credit Data: Correcting a 
#'   Widely Used Data Set. Report 4/2019, Reports in Mathematics, Physics and 
#'   Chemistry, Department II, Beuth University of Applied Sciences Berlin.
#' @source [http://www1.beuth-hochschule.de/FB_II/reports/Report-2019-004.pdf]
#' @author [Ulrike Grömping](https://prof.beuth-hochschule.de/groemping/)


dat <- read.table("https://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german/german.data", stringsAsFactors = FALSE)
## remove Ax portions from string columns
for (i in 1:ncol(dat))
  if (is.character(dat[[i]]))
    dat[[i]] <- as.integer(gsub(paste0("A",i), "", dat[[i]]))

## Now dat contains numbers for all variables.
## The rest is as in Appendix A,
##     except for credit_risk,
##                attribute 18: people_liable
##            and attribute 20: foreign_worker

nam_evtree <- c("status", "duration", "credit_history",
                "purpose", "amount", "savings", "employment_duration",
                "installment_rate", "personal_status_sex",
                "other_debtors", "present_residence", "property",
                "age", "other_installment_plans", "housing",
                "number_credits", "job", "people_liable", "telephone",
                "foreign_worker", "credit_risk")
names(dat) <- nam_evtree

## make factors for all except the numeric variables
## make sure that even empty level of factor purpose = verw (dat[[4]]) is included
for (i in setdiff(1:21, c(2,4,5,13)))
  dat[[i]] <- factor(dat[[i]])
## factor purpose
dat[[4]] <- factor(dat[[4]], levels=as.character(0:10))

## assign level codes
## make intrinsically ordered factors into class ordered
levels(dat$credit_risk) <- c("good", "bad")

levels(dat$status) = c("no checking account",
                       "... < 0 DM",
                       "0<= ... < 200 DM",
                       "... >= 200 DM / salary for at least 1 year")
## "critical account/other credits elsewhere" was
## "critical account/other credits existing (not at this bank)",
levels(dat$credit_history) <- c(
  "delay in paying off in the past",
  "critical account/other credits elsewhere",
  "no credits taken/all credits paid back duly",
  "existing credits paid back duly till now",
  "all credits at this bank paid back duly")
levels(dat$purpose) <- c(
  "others",
  "car (new)",
  "car (used)",
  "furniture/equipment",
  "radio/television",
  "domestic appliances",
  "repairs",
  "education",
  "vacation",
  "retraining",
  "business")
levels(dat$savings) <- c("unknown/no savings account",
                         "... < 100 DM",
                         "100 <= ... < 500 DM",
                         "500 <= ... < 1000 DM",
                         "... >= 1000 DM")
levels(dat$employment_duration) <-
  c( "unemployed",
     "< 1 yr",
     "1 <= ... < 4 yrs",
     "4 <= ... < 7 yrs",
     ">= 7 yrs")
dat$installment_rate <- ordered(dat$installment_rate)
levels(dat$installment_rate) <- c(">= 35",
                                  "25 <= ... < 35",
                                  "20 <= ... < 25",
                                  "< 20")
levels(dat$other_debtors) <- c(
  "none",
  "co-applicant",
  "guarantor"
)
## female : nonsingle was female : divorced/separated/married
levels(dat$personal_status_sex) <- c(
  "male : divorced/separated",
  "female : non-single or male : single",
  "male : married/widowed",
  "female : single")
dat$present_residence <- ordered(dat$present_residence)
levels(dat$present_residence) <- c("< 1 yr",
                                   "1 <= ... < 4 yrs",
                                   "4 <= ... < 7 yrs",
                                   ">= 7 yrs")
levels(dat$property) <- c(
  "unknown / no property",
  "car or other",
  "building soc. savings agr. / life insurance",
  "real estate"
)
levels(dat$other_installment_plans) <- c(
  "bank",
  "stores",
  "none"
)
levels(dat$housing) <- c("for free", "rent", "own")
dat$number_credits <- ordered(dat$number_credits)
levels(dat$number_credits) <- c("1", "2-3", "4-5", ">= 6")
## manager/self-empl/highly qualif. employee was
##   management/self-employed/highly qualified employee/officer
levels(dat$job) <- c(
  "unemployed/unskilled - non-resident",
  "unskilled - resident",
  "skilled employee/official",
  "manager/self-empl/highly qualif. employee"
)
levels(dat$people_liable) <- c("0 to 2", "3 or more")
levels(dat$telephone) <- c("no", "yes (under customer name)")
levels(dat$foreign_worker) <- c("no", "yes")


#' # save `dat` dataset as `data/german.rda`
require(usethis)
german <- dat
usethis::use_data(german, overwrite = TRUE)
