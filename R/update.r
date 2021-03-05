
#' Store new submission files.
#' 
#' \code{store_new_submissions} copies new files from the subdirectories of \code{submissions_dir} 
#' to the respective subdirectories of \code{hist_dir}.
#' Each team has a subdirectory.
#' The copied files in \code{hist_dir} are prefixed with the last modification date for uniqueness.
#' A file is considered new if its name and last modification time is new, i.e not present
#' in \code{hist_dir}.
#' The files must match \code{pattern} regular expression and must not
#' throw errors or warnings when given to the \code{valid_fun} function.
#' 
#' @param submissions_dir string. directory of the submissions. contains one subdirectory per team
#' @param hist_dir    string. directory where to store the history of the submissions. contains one subdirectory per team
#' @param deadline    POSIXct. deadline time for submissions. The files with last modification date after
#'   the deadline are skipped.
#' @param pattern     string. regular expression that new submission files must match (with \code{ignore.case=TRUE})
#' @param valid_fun   function that reads a submission file and throws errors or warnings if
#'   it is not valid.
#'   
#' @export
#' @return \code{store_new_submissions} returns a named list of errors or warnings caught during the process.
#'   Members named after the team names are lists with members named after the file
#'   that throws an error which contain the error object.
store_new_submissions <- function(submissions_dir = "submissions", hist_dir = "history", 
                                  deadline, pattern = ".*\\.csv$", valid_fun) {
  # get new submissions
  team_dirs = list.files(submissions_dir)
  
  read_err = list()
  
  for (i in seq(along=team_dirs)) {
    team = team_dirs[i]
    dir_submissions = file.path(submissions_dir, team)
    # skip if not a folder
    if (!file.info(dir_submissions)$isdir)
      next
    
    # get team submissions files info 
    files_submissions <- list.files(dir_submissions, pattern = pattern, ignore.case = TRUE, full.names = TRUE)
    info_submissions <- file.info(files_submissions)
    
    # get team history files info 
    dir_hist = file.path(hist_dir, team)
    files_hist = list.files(dir_hist, pattern = pattern, ignore.case = TRUE, full.names = TRUE)
    
    for (j in seq(along=files_submissions)) {
      
      # skip if is a folder
      if (info_submissions$isdir[j])
        next
      
      date = info_submissions$mtime[j] # last modification time
      file = paste0(format(date, format="%Y-%m-%d_%H-%M-%S_"), basename(files_submissions[j])) # prefix date for uniqueness
      
      # skip if is after deadline
      if (date>deadline)
        read_err[[team]][[files_submissions[j]]]$message <- "submitted after the deadline"
      
      # skip if existing in history
      if (any(basename(files_hist) == file))
        next
      
      # check submissions csv file
      tryCatch( valid_fun(files_submissions[j]),
                warning = function(w) { read_err[[team]][[files_submissions[j]]] <<- w },
                error = function(e) { read_err[[team]][[files_submissions[j]]] <<- e }
      )
      
      # skip if error in reading
      if (!is.null(read_err[[team]][[files_submissions[j]]]))
        next
      
      if (!file.exists(dir_hist)) {
        # make new directory
        dir.create(dir_hist)
      }
      
      # copy file to history
      file.copy(files_submissions[j], file.path(dir_hist, file), copy.date = TRUE)
    }
    
  }
  
  return(invisible(read_err))
}

#' Compute metrics of the submissions in the history.
#' 
#' @param hist_dir string. directory where the history of the submissions are stored. 
#'   contains one subdirectory per team.
#' @param metrics  named list of functions. Each function in the list computes
#'   a performance criterion and is defined as: \code{function(y_pred, y_test)}
#' @param y_test   character or numeric vector. the test set output.
#' @param ind_quiz indices of \code{y_test} in the quiz subset.
#' @param read_fun function that reads a submission file and returns a vector of predictions.
#'   
#' @export
#' @return \code{compute_metrics} returns a named list with one named member per team.
#'   Each member is a \code{data.frame} where the rows are the submission files sorted by date
#'   and the columns are:
#'   \item{date}{the date of the submission}
#'   \item{file}{the file name of the submission}
#'   \item{<metric name>.quiz}{the score obtained on the quiz subset}
#'   \item{<metric name>.test}{the score obtained on the test set}
compute_metrics <- function(hist_dir = "history", metrics, y_test, ind_quiz, read_fun) {
  team_dirs = list.files(hist_dir)
  
  history = list()
  
  for (i in seq(along=team_dirs)) {
    team = team_dirs[i]
    dir_hist = file.path(hist_dir, team)
    # skip if not a folder
    if (!file.info(dir_hist)$isdir)
      next
    
    # get team submissions files info 
    files_hist <- list.files(dir_hist, full.names = TRUE)
    info_hist <- file.info(files_hist)
    
    # sort by date
    ind = order(info_hist$mtime)
    info_hist = info_hist[ind,]
    files_hist = files_hist[ind]
    
    for (j in seq(along=files_hist)) {
      # skip if is a folder
      if (info_hist$isdir[j])
        next
      
      date = info_hist$mtime[j]
      file = basename(files_hist[j])
      
      # read submissions csv file (should not throw error or warning)
      y_pred <- read_fun(files_hist[j])
      
      # compute scores
      score_quiz = list()
      score_test = list()
      for (k in seq(along=metrics)) {
        metric = names(metrics)[k]
        score_quiz[[paste0(metric, ".quiz")]] = metrics[[k]](y_pred[ind_quiz], y_test[ind_quiz])
        score_test[[paste0(metric, ".test")]] = metrics[[k]](y_pred, y_test)
      }
      
      if (team %in% names(history)) {
        n = nrow(history[[team]])
        history[[team]][n+1,] = data.frame(date=date, file=file, score_quiz, score_test, stringsAsFactors = FALSE)
      } else {
        history[[team]] = data.frame(date=date, file=file, score_quiz, score_test, stringsAsFactors = FALSE)
      }
    }
  }
  
  return(history)
}

#' Get the best submissions per team.
#' 
#' @param history   list of the submissions history per team as returned by \code{\link{compute_metrics}}
#' @param metrics   character vector. names of the metrics
#' @param test_name string. name of the test set used: \code{"quiz"} or \code{"test"}
#' @param decreasing logical. Should the sort order be increasing or decreasing? Must be of length 1 or with 
#'   the same length as \code{metrics}.
#' 
#' @export
#' @return \code{get_best} returns a \code{data.frame} where the rows are teams in sorted order of performance.
#'   The best submission per team is retained. The sort is based on possibly several metrics in the order 
#'   given by the \code{metrics} argument. 
#'   In case of ties on the first metric, the second metric is used to break the ties, and so on. Lastly, 
#'   the date is used in case of ties. The columns are:
#'   \item{team}{name of the team}
#'   \item{n_submissions}{total number of submissions}
#'   \item{date}{the date of the best submission}
#'   \item{file}{the file name of the best submission}
#'   \item{<metric name>.quiz}{the score obtained on the quiz subset}
#'   \item{<metric name>.test}{the score obtained on the test set}
#'   \item{rank}{the rank of the team}
#'   \item{rank_diff}{the rank difference is set to 0 temporarily.}
get_best <- function(history, metrics=names(metrics), test_name = "quiz", decreasing = FALSE) {
  stopifnot(is.logical(decreasing), length(decreasing) == 1 || length(decreasing) == length(metrics))
  if (length(decreasing) == 1)
    decreasing = rep(decreasing, length(metrics))
  
  cols = paste(metrics, test_name, sep='.')
  signs = sign(-decreasing+.5)
  best = data.frame()
  
  for (i in seq(along=history)) {
    team = names(history)[i]
    n_submissions = nrow(history[[i]])
    
    ind = do.call(order, c(mapply("*", signs, history[[team]][cols], SIMPLIFY = FALSE), history[[team]]["date"]))
    best = rbind(best, data.frame(rank=1, rank_diff=0, team=team, n_submissions=n_submissions, history[[team]][ind[1],], stringsAsFactors = FALSE))
  }
  
  if (nrow(best)>1) {
    ind = do.call(order, c(mapply("*", signs, best[cols], SIMPLIFY = FALSE), best["date"]))
    best = best[ind,]
    
    diffs = rbind(1, sapply(best[c(cols, "date")], diff)) != 0
    best$rank = cumsum(apply(diffs, FUN = any, MARGIN = 1))
  }
  
  return(best)
}

#' Update the rank differences of the teams.
#' 
#' @param best_new  \code{data.frame} of the best submissions per team as returned
#'   by \code{\link{get_best}}.
#' @param best_old  old \code{data.frame} of the best submissions per team and per metric.
#' 
#' @export
#' @return \code{update_rank_diff} returns the input \code{data.frame} \code{best_new} with an
#'   updated column \code{rank_diff} 
update_rank_diff <- function(best_new, best_old) {
  # new ranks
  rank_new = best_new$rank
  
  # get old ranks with teams in the same order as new
  default_rank_old = length(rank_new)+1 # for teams not present in old
  rank_old = rep(default_rank_old, length(rank_new)) # same length as new
  ind_old = match(best_old$team, best_new$team)
  rank_old[ind_old] = best_old$rank
  
  best_new$rank_diff = rank_new-rank_old
  
  # keep old values if no change
  if (all(best_new$rank_diff==0)) {
    rank_diff_old = rep(0, length(rank_new))
    rank_diff_old[ind_old] = best_old$rank_diff
    best_new$rank_diff = rank_diff_old
  }
  return(best_new)
}
