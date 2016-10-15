
#' Countdown before deadline.
#' @param deadline     POSIXct. deadline
#' @param complete_str string. displayed when deadline is passed
#' @export
countdown = function(deadline, complete_str = intToUtf8(10004)) {
  days_left = difftime(deadline, Sys.time(), units="days")
  if (days_left>1)
    return(paste("J -", floor(days_left)))
  else if (days_left>0)
    return(paste("H -", floor(days_left*24)))
  else
    return(complete_str)
}

#' Formatted last update date before deadline.
#' @param deadline POSIXct. deadline
#' @param format   string. see \code{\link{format.POSIXct}}
#' @export
last_update <- function(deadline, format = "%d %b %Y %H:%M") {
  last = Sys.time()
  if (last>deadline+1)
    last = deadline+1
  return(format(last, format))
}

#' Format read errors in Markdown.
#' @param read_err list of read errors returned by \code{\link{store_new_submissions}}
#' @param ... further parameters to pass to \code{\link[knitr]{kable}}
#' @export
#' @return \code{print_readerr} returns a character vector of the table source code
#'   to be used in a Markdown document.
print_readerr <- function(read_err = list(), ...) {
  df = data.frame(Team=character(0), File=character(0), Message=character(0))
  for (i in seq(along=read_err)) {
    for (j in seq(along=read_err[[i]])) {
      df = rbind(df, data.frame(Team=names(read_err)[i],
                                File = paste0("`", basename(names(read_err[[i]])[j]),"`"),
                                Message = paste0("`", read_err[[i]][[j]]$message, "`"),
                                stringsAsFactors = FALSE))
    }
  }
  knitr::kable(df, ...)
}

#' String displayed for the rank.
#' 
#' Concatenates the rank number with symbols indicating the progress since the last change.
#' 
#' @param r     integer. rank
#' @param r_d   integer. rank difference
#' @param symb  named list of characters. symbols used for the progress in ranking:
#'   no change (\code{const}), ascent (\code{up}) and descent (\code{down})
#' @keywords internal
str_rank <- function(r, r_d, symb = list(const = fa("arrow-right"),
                                         up = fa("arrow-up"),
                                         down = fa("arrow-down"))) {
  paste0(r, '. ', ifelse(r_d==0,
                         symb$const, 
                         ifelse(r_d<0,
                                paste(rep(symb$up, -r_d), collapse=""), 
                                paste(rep(symb$down, r_d), collapse=""))))
}


#' Format the leaderboard in Markdown.
#' 
#' @param best    list of the best submissions per team and per metric as returned
#'   by \code{\link{get_best}}.
#' @param metrics  character vector. names of the metrics to be displayed
#' @param test_name string. name of the test set used: \code{"quiz"} or \code{"test"}
#' @param digits integer. how many significant digits are to be used for metrics.
#' @param ... further parameters to pass to \code{\link[knitr]{kable}}
#' 
#' @return \code{print_leaderboard} returns a character vector of the table source code
#'   to be used in a Markdown document.
#'   
#' @note Chunk option \code{results='asis'} has to be used
#' 
#' @export
#' @seealso \code{\link[knitr]{kable}}
#' @importFrom knitr kable
print_leaderboard <- function(best, metrics=names(metrics), test_name = "quiz", digits = 3, ...) {
  metric_cols = paste(metrics, test_name, sep=".")
  df = data.frame(Rank = mapply(FUN = str_rank, best$rank, best$rank_diff),
                  Team = best$team,
                  Submissions = paste(best$n_submissions),
                  Date = format(best$date, format="%d/%m/%y %H:%M"),
                  lapply(best[metric_cols], format, digits = digits))
  knitr::kable(df, ...)
}

#' HTML code for a Font Awesome icon.
#' 
#' @note Requires the Font Awesome HTML code:
#'   \code{<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">}
#' @param name string. name of the icon.
#' @return string containing the HTML code.
#' @export
#' @seealso \url{http://fontawesome.io/}
fa <- function(name) {
  return(paste0('<i class="fa fa-', name, '"></i>'))
}

#' Path to glyphicon image file.
#' @param name string. name of the glyphicon.
#' @param path string. folder of search.
#' @return the path to the file.
#' @export
glyphicon <- function(name, path = system.file('glyphicons', package = 'rchallenge')) {
  .Deprecated("fa")
  file <- list.files(path, pattern = paste("glyphicons_[0-9]+_", name, ".png", sep=""))
  if (length(file)==0)
    file <- list.files(path, pattern = paste("glyphicons_social_[0-9]+_", name, ".png", sep=""))
  if (length(file)==0)
    stop("glyphicon ", name, " not found")
  return(file.path(path, file))
}

#' HTML code for an image.
#' @param file string. image file.
#' @param width string. width of display.
#' @export
html_img <- function(file, width = "10px") {
  .Deprecated()
  paste('<img src="', file, '" style="width: ', width, ';"/>', sep="")
}
