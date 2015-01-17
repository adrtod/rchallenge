require(caret)
data(GermanCredit)

GermanCreditDummy = GermanCredit

dummy_to_factor <- function(X, levels, ordered=FALSE) {
  prefix = strsplit(names(X)[1], '\\.')[[1]]
  labels <- sapply(names(X), FUN=function(x) paste(strsplit(x, paste0(prefix, '\\.'))[[1]][-1], sep = '.'), USE.NAMES = FALSE)
  if (missing(levels))
    levels = labels
  x = factor(apply(as.matrix(X), 1, function(x) labels[as.logical(x)]), levels = levels, ordered = ordered)
}

GermanCredit = cbind(data.frame(lapply(GermanCreditDummy[,1:7], as.numeric)),
                     Telephone = factor(GermanCreditDummy$Telephone, labels=c("none", "yes")),
                     ForeignWorker = factor(GermanCreditDummy$ForeignWorker, labels=c("no", "yes")),
                     CheckingAccountStatus = dummy_to_factor(GermanCreditDummy[,11:14]),
                     CreditHistory = dummy_to_factor(GermanCreditDummy[,15:19]),
                     Purpose = dummy_to_factor(GermanCreditDummy[,20:30]),
                     SavingsAccountBonds = dummy_to_factor(GermanCreditDummy[,31:35]),
                     EmploymentDuration = dummy_to_factor(GermanCreditDummy[,36:40]),
                     Personal = dummy_to_factor(GermanCreditDummy[,41:45]),
                     OtherDebtorsGuarantors = dummy_to_factor(GermanCreditDummy[,46:48]),
                     Property = dummy_to_factor(GermanCreditDummy[,49:52]),
                     OtherInstallmentPlans = dummy_to_factor(GermanCreditDummy[,53:55]),
                     Housing = dummy_to_factor(GermanCreditDummy[,56:58]),
                     Job = dummy_to_factor(GermanCreditDummy[,59:62]),
                     Class = GermanCreditDummy$Class)

set.seed(3456)
testIndex <- createDataPartition(GermanCredit$Class, p = .2,
                                  list = FALSE,
                                  times = 1)

data_train = GermanCredit[-testIndex, -which(names(GermanCredit)=="Class")]
data_train$Class <- GermanCredit[-testIndex, "Class"]
rownames(data_train) = NULL

data_test <- GermanCredit[testIndex,]
Y_test <- data_test[,"Class"]
data_test <- data_test[,-which(names(data_test)=="Class")]
rownames(data_test) = NULL

quizIndex <- createDataPartition(Y_test, p = .3,
                                  list = FALSE,
                                  times = 1)

require(devtools)
devtools::use_data(data_train, data_test, Y_test, testIndex, quizIndex)



