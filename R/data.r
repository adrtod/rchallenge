#' German Credit Data
#' 
#' Data from Dr. Hans Hofmann of the University of Hamburg.
#' 
#' These data have two classes for the credit worthiness: Good or Bad. There are 
#' predictors related to attributes, such as: checking account status, duration, 
#' credit history, purpose of the loan, amount of the loan, savings accounts or 
#' bonds, employment duration, Installment rate in percentage of disposable income, 
#' personal information, other debtors/guarantors, residence duration, property, age, 
#' other installment plans, housing, number of existing credits, job information, 
#' Number of people being liable to provide maintenance for, telephone, and foreign 
#' worker status.
#' 
#' This is a transformed version of the \code{\link[caret]{GermanCredit}} data set
#' with factors instead of dummy variables
#'
#' @format A \code{data.frame} with 1000 rows and 21 variables
#' @source UCI Machine Learning Repository 
#'   \url{https://archive.ics.uci.edu/ml/datasets/Statlog+(German+Credit+Data)}
"german"


#' Split a data.frame into training and test sets 
#' @param data    data.frame
#' @param varname string. output variable name
#' @param p_test  real. proportion of samples in the test set
#' @param p_quiz  real. proportion of samples from the test set in the quiz set
#' @return list with members
#'   \item{train}{training set with output variable}
#'   \item{test}{test set without output variable}
#'   \item{y_test}{test set output variable}
#'   \item{ind_quiz}{indices of quiz samples in the test set}
#' @export
#' @seealso \code{\link[caret]{createDataPartition}}
#' @importFrom caret createDataPartition
data_split <- function(data=german, varname="Class",
                       p_test = .2, p_quiz = .5) {
  ind_test <- caret::createDataPartition(data[[varname]], p = p_test, list = FALSE)
  
  train <- data[-ind_test, -which(names(data)==varname)]
  train[[varname]] <- data[-ind_test, varname]
  rownames(train) = NULL
  
  test <- data[ind_test,]
  y_test <- test[,varname]
  test <- test[,-which(names(test)==varname)]
  rownames(test) = NULL
  
  ind_quiz <- caret::createDataPartition(y_test, p = p_quiz, list = FALSE)
  
  return(list(train=train, test=test, y_test=y_test, ind_quiz=ind_quiz))
}