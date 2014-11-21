#' Store new contribution files.
#' 
#' \code{store_new_contrib} copies new files from the subdirectories of \code{contrib_dir} 
#' to the respective subdirectories of \code{hist_dir}.
#' Each team has a subdirectory.
#' The copied files in \code{hist_dir} are prefixed with the last modification date for uniqueness.
#' A file is considered new if its name and last modification time is new, i.e not present
#' in \code{hist_dir}.
#' The files must match \code{pattern} regular expression and must not
#' throw errors or warnings when given to the \code{valid_fun} function.
#' 
#' @param contrib_dir string. directory of the contributions. contains one subdirectory per team
#' @param hist_dir    string. directory where to store the history of the contributions. contains one subdirectory per team
#' @param pattern     string. regular expression that new contribution files must match (with \code{ignore.case=TRUE})
#' @param valid_fun   function that reads a contribution file and throws errors or warnings if
#'   it is not valid.
#'   
#' @return \code{store_new_contrib} returns a named list of errors or warnings catched during the process.
#'   Members named after the team names are lists with members named after the file
#'   that throws an error which contain the error object.
store_new_contrib <- function(contrib_dir = "contrib", hist_dir = "history", 
                              pattern = ".*\\.csv$", 
                              valid_fun = function(file) read_pred(file, nrow(data_test))) {
  # get new contributions
  team_dirs = list.files(contrib_dir)
  
  read_err = list()
  
  for (i in seq(along=team_dirs)) {
    team = team_dirs[i]
    dir_contrib = file.path(contrib_dir, team)
    # skip if not a folder
    if (!file.info(dir_contrib)$isdir)
      next
    
    # get team contrib files info 
    files_contrib <- list.files(dir_contrib, pattern = pattern, ignore.case = TRUE, full.names = TRUE)
    info_contrib <- file.info(files_contrib)
    
    # get team history files info 
    dir_hist = file.path(hist_dir, team)
    files_hist = list.files(dir_hist, pattern = pattern, ignore.case = TRUE, full.names = TRUE)
    info_hist = file.info(files_hist)
    
    for (j in seq(along=files_contrib)) {
      
      # skip if is a folder
      if (info_contrib$isdir[j])
        next
      
      date = info_contrib$mtime[j] # last modification time
      file = paste0(format(date, format="%Y-%m-%d_%H-%M-%S_"), basename(files_contrib[j])) # prefix date for uniqueness
      
      # skip if existing in history
      if (any(basename(files_hist) == file))
        next
      
      # check contrib csv file
      Y_pred = tryCatch( valid_fun(files_contrib[j]),
                         warning = function(w) { read_err[[team]][[files_contrib[j]]] <<- w },
                         error = function(e) { read_err[[team]][[files_contrib[j]]] <<- e }
      )
      
      # skip if error in reading
      if (!is.null(read_err[[team]][[files_contrib[j]]]))
        next
      
      if (!file.exists(dir_hist)) {
        # make new directory
        dir.create(dir_hist)
      }
      
      # copy file to history
      file.copy(files_contrib[j], file.path(dir_hist, file), copy.date = TRUE)
    }
    
  }
  
  return(invisible(read_err))
}

#' Compute metrics of the contributions in the history.
#' 
#' @param hist_dir string. directory where the history of the contributions are stored. 
#'   contains one subdirectory per team.
#' @param metrics  named list of functions. Each function in the list computes
#'   a performance criterion and is defined as: \code{function(Y_pred, Y_test)}
#' @param Y_test    character or numeric vector. the test set.
#' @param quizIndex logical vector with the same length as \code{Y_test}. \code{quizIndex[i]=TRUE}
#'   if \code{Y_test[i]} in the quiz subset.
#'   
#' @return \code{compute_metrics} returns a named list with one named member per team.
#'   Each member is a \code{data.frame} where the rows are the contribution files sorted by date
#'   and the columns are:
#'   \item{date}{the date of the contribution}
#'   \item{file}{the file name of the contribution}
#'   \item{<metric name>.quiz}{the score obtained on the quiz subset}
#'   \item{<metric name>.test}{the score obtained on the test set}
compute_metrics <- function(hist_dir = "history", metrics, Y_test, quizIndex) {
  team_dirs = list.files(hist_dir)
  
  history = list()
  
  for (i in seq(along=team_dirs)) {
    team = team_dirs[i]
    dir_hist = file.path(hist_dir, team)
    # skip if not a folder
    if (!file.info(dir_hist)$isdir)
      next
    
    # get team contrib files info 
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
      
      # check contrib csv file
      Y_pred <- read_pred(files_hist[j], length(Y_test))
      
      # skip if error in reading
      if (!is.null(read_err[[team]][[files_hist[j]]]))
        next
      
      # compute scores
      score_quiz = list()
      score_test = list()
      for (k in seq(along=metrics)) {
        metric = names(metrics)[k]
        score_quiz[[paste0(metric, ".quiz")]] = metrics[[k]](Y_pred[quizIndex], Y_test[quizIndex])
        score_test[[paste0(metric, ".test")]] = metrics[[k]](Y_pred, Y_test)
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

#' Get the best contributions per team and per metric.
#' 
#' @param history   list of the contributions history per team as returned by \code{\link{compute_metrics}}
#' @param metrics   character vector. names of the metrics
#' @param test_name string. name of the test set used: \code{"quiz"} or \code{"test"}
#' 
#' @return \code{get_best} returns a named list with one member per metric. Each
#'   memebr is a \code{data.frame} where the rows are teams in decreasing order of performance
#'   and the columns are:
#'   \item{team}{name of the team}
#'   \item{n_contrib}{total number of contributions}
#'   \item{date}{the date of the best contribution}
#'   \item{file}{the file name of the best contribution}
#'   \item{<metric name>.quiz}{the score obtained on the quiz subset}
#'   \item{<metric name>.test}{the score obtained on the test set}
#'   \item{rank}{the rank of the team}
#'   \item{rank_diff}{the rank difference is set to 0 temporarily.}
get_best <- function(history, metrics=names(metrics), test_name = "quiz") {
  best = list()
  for (j in seq(along=metrics)) {
    metric = metrics[j]
    metric_column = paste(metric, test_name, sep='.')
    for (i in seq(along=history)) {
      team = names(history)[i]
      n_contrib = nrow(history[[i]])
      
      stopifnot(metric_column %in% names(history[[team]]))
      
      ind_best = which.min(history[[team]][[metric_column]])
      
      if (metric %in% names(best)) {
        n = nrow(best[[metric]])
        best[[metric]][n+1,] = data.frame(team=team, n_contrib=n_contrib, history[[team]][ind_best,], stringsAsFactors = FALSE)
      } else {
        best[[metric]] = data.frame(team=team, n_contrib=n_contrib, history[[team]][ind_best,], stringsAsFactors = FALSE)
      }
    }
    # sort teams by increasing order
    ind = order(best[[metric]][,metric_column])
    best[[metric]] = best[[metric]][ind,]
    best[[metric]]$rank = rank(best[[metric]][,metric_column], ties.method = "min")
    best[[metric]]$rank_diff = rep(0, nrow(best[[metric]]))
  }
  
  return(best)
}


#' Update the rank differences of the teams.
#' 
#' @param best_new  list of the best contributions per team and per metric as returned
#'   by \code{\link{get_best}}.
#' @param best_old  old list of the best contributions per team and per metric.
#' 
#' @return \code{update_rank_diff} returns the input list \code{best_new} with an
#'   updated column \code{rank_diff} for each metric.
update_rank_diff <- function(best_new, best_old) {
  for (i in seq(along=best_new)) {
    metric = names(best_new)[i]
    if (metric %in% names(best_old)) {
      # new ranks
      rank_new = best_new[[i]]$rank
      
      # get old ranks with teams in the same order as new
      default_rank_old = length(rank_new)+1 # for teams not present in old
      rank_old = rep(default_rank_old, length(rank_new)) # same length as new
      ind_old = match(best_old[[metric]]$team, best_new[[i]]$team)
      rank_old[ind_old] = best_old[[metric]]$rank
      
      best_new[[i]]$rank_diff = rank_new-rank_old
      
      # keep old values if no change
      if all(best_new[[i]]$rank_diff==0) {
        rank_diff_old = rep(0, length(rank_new))
        rank_diff_old[ind_old] = best_old[[metric]]$rank_diff
        best_new[[i]]$rank_diff = rank_diff_old
      }
    }
  }
  return(best_new)
}


# # symbols_dec <- c(8594, 8599, 8600) # simple arrows
# symbols_dec <- c(8658, 8663, 8664) # double arrows
# # symbols_dec <- c(10137, 10138, 10136) # black arrows
# names(symbols_dec) <- c("const", "up", "down")
# symbols <- sapply(symbols_dec, intToUtf8)
symbols <- list()
symbols$const <- '<img src="figures/glyphicons_211_right_arrow.png" style="width: 10px;"/>'
symbols$up <- '<img src="figures/glyphicons_213_up_arrow.png" style="width: 10px;"/>'
symbols$down <- '<img src="figures/glyphicons_212_down_arrow.png" style="width: 10px;"/>'

#' String displayed for the rank.
#' 
#' Concatenates the rank number with symbols indicating the progress since the last change.
#' 
#' @param r     integer. rank
#' @param r_d   integer. rank difference
#' @param symb  named list of characters. symbols used for the progress in ranking:
#'   no change (\code{const}), ascent (\code{up}) and descent (\code{down})
str_rank <- function(r, r_d, symb = symbols) {
  paste0(r, '. ', ifelse(r_d==0,
                         symb["const"], 
                         ifelse(r_d<0,
                                paste(rep(symb["up"], -r_d), collapse=""), 
                                paste(rep(symb["down"], r_d), collapse=""))))
}


#' Format the table of the ranked performances in Markdown.
#' 
#' @param best    list of the best contributions per team and per metric as returned
#'   by \code{\link{get_best}}.
#' @param metric  string. name of the metric considered
#' @param test_name string. name of the test set used: \code{"quiz"} or \code{"test"}
#' 
#' @return \code{print_best_table} returns a character vector of the table source code
#'   to be used in a Markdown document.
#'   
#' @note Chunk option \code{results='asis'} has to be used
#' 
#' @seealso \code{\link[knitr]{kable}}
print_best_table <- function(best, metric, test_name = "quiz") {
  metric_column = paste(metric, test_name, sep=".")
  best_print = data.frame(Rang = mapply(FUN = str_rank, best[[metric]]$rank, best[[metric]]$rank_diff),
                          Equipe = best[[metric]]$team,
                          Contributions = paste(best[[metric]]$n_contrib),
                          Date = format(best[[metric]]$date, format="%d/%m/%y %H:%M"),
                          Score = format(best[[metric]][[metric_column]], digits=3))
  knitr::kable(best_print)
}

#' Plot the history of the scores of each team over time.
#' 
#' The best scrore of each team has a bold symbol.
#' 
#' @param history   list of the contributions history per team as returned by \code{\link{compute_metrics}}
#' @param metric    string. name of the metric considered
#' @param test_name string. name of the test set used: \code{"quiz"} or \code{"test"}
#' @param baseline  string. name of the team considered as the baseline. Its best score
#'   will be plotted as a constant and will not appear in the legend.
#' @param col       colors of the teams
#' @param pch       symbols of the teams
#' @param lty       line types of the teams
#' @param by        real. interval width of grid lines
#' 
#' @return \code{NULL}
#' 
#' @seealso \code{\link[knitr]{kable}}
plot_history <- function(history, metric, test_name="quiz", baseline="baseline", 
                         col=rep(1:6, 100), pch=rep(0:18, 100), by = .05) {
  metric_column = paste(metric, test_name, sep=".")
  # get baseline score
  ind_base = which(names(history)==baseline)
  if (length(ind_base)>0) {
    base_score = min(history[[ind_base]][[metric_column]])
    history = history[-ind_base]
  }
  else
    base_score = NULL
  
  # compute axis limits
  if (length(history)==0)
    xlim = c(Sys.time()-1, Sys.time())
  else 
    xlim = range(history[[1]]$date)
  ylim = c(base_score-by, base_score+by)
  for (i in seq(along=history)) {
    xlim = range(xlim, history[[i]]$date)
    ylim = range(ylim, history[[i]][[metric_column]])
  }
  
  # empty figure
  plot(NA, type='n', xlab="Date", ylab = "Score", bty='l',
       xlim=xlim, ylim=ylim, xaxt = 'n')
  axis.POSIXct(1, xlim, format="%d %b")
  
  # grid
  aty = range(axTicks(2))
  abline(h=seq(aty[1]-by, aty[2]+by, by=by), col="lightgray", lty="dotted")
  
  # baseline
  abline(h=base_score, lty=2, lwd=2)
  
  # history for each team
  for (i in seq(along=history)) {
    lines(history[[i]]$date, history[[i]][[metric_column]], 
          col=col[i], lty="dotted")
    points(history[[i]]$date, history[[i]][[metric_column]], 
           col=col[i], pch=pch[i], lwd=2)
    # best contribution in bold
    ind = which.min(history[[i]][[metric_column]])
    points(history[[i]]$date[ind], history[[i]][[metric_column]][ind], 
           col=col[i], pch=pch[i], lwd=5)
  }
  
  # legend
  leg = c(baseline, names(history))
  if (length(leg)>0)
    legend('topright', leg = leg, col=c(1,col), pch=c(NA,pch), lwd=c(2,rep(2,length(history))), 
           lty=c(2,rep(NA,length(history))), bty='n', xpd = NA, inset = c(-0.22, 0))
  
  invisible(NULL)
}