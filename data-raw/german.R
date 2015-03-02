require(caret)
data(GermanCredit)

dummy_to_factor <- function(X, levels, ordered=FALSE) {
  prefix = strsplit(names(X)[1], '\\.')[[1]]
  labels <- sapply(names(X), FUN=function(x) paste(strsplit(x, paste0(prefix, '\\.'))[[1]][-1], sep = '.'), USE.NAMES = FALSE)
  if (missing(levels))
    levels = labels
  factor(apply(as.matrix(X), 1, function(x) labels[as.logical(x)]), levels = levels, ordered = ordered)
}

german = cbind(data.frame(lapply(GermanCredit[,1:7], as.numeric)),
               Telephone = factor(GermanCredit$Telephone, labels=c("none", "yes")),
               ForeignWorker = factor(GermanCredit$ForeignWorker, labels=c("no", "yes")),
               CheckingAccountStatus = dummy_to_factor(GermanCredit[,11:14]),
               CreditHistory = dummy_to_factor(GermanCredit[,15:19]),
               Purpose = dummy_to_factor(GermanCredit[,20:30]),
               SavingsAccountBonds = dummy_to_factor(GermanCredit[,31:35]),
               EmploymentDuration = dummy_to_factor(GermanCredit[,36:40]),
               Personal = dummy_to_factor(GermanCredit[,41:45]),
               OtherDebtorsGuarantors = dummy_to_factor(GermanCredit[,46:48]),
               Property = dummy_to_factor(GermanCredit[,49:52]),
               OtherInstallmentPlans = dummy_to_factor(GermanCredit[,53:55]),
               Housing = dummy_to_factor(GermanCredit[,56:58]),
               Job = dummy_to_factor(GermanCredit[,59:62]),
               Class = GermanCredit$Class)

require(devtools)
devtools::use_data(german)
