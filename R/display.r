
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
str_rank <- function(r, r_d, symb = list(const = icon("fa-arrow-right"),
                                         up = icon("fa-arrow-up"),
                                         down = icon("fa-arrow-down"))) {
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

#' HTML code for icons.
#' 
#' Currently only supports Font Awesome icons. 
#' 
#' @note Requires the Font Awesome HTML code:
#'   \code{<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">}
#' @param name string. name of the icon. You can see a full list of options at
#'   \url{https://fontawesome.com/icons/}.
#' @return string containing the HTML code.
#' @export
#' @examples 
#' rmd <- '
#' ```{r}
#' library(rchallenge)
#' ```
#' <link rel="stylesheet" 
#'  href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
#' `r icon("fa-user")`
#' `r icon("fa-user fa-lg")`
#' `r icon("fa-user fa-2x")`
#' `r icon("fa-user fa-3x")`
#' `r icon("fa-user fa-3x fa-border")`
#' '
#' file <- tempfile()
#' cat(rmd, file=file)
#' writeLines(readLines(file))
#' if (rmarkdown::pandoc_available('1.12.3')) {
#'   rmarkdown::render(file)
#' }
icon <- function(name) {
  return(paste0('<i class="fa ', name, '"></i>'))
}

#' HTML code for an image.
#' @param file string. image file.
#' @param width string. width of display.
#' @export
html_img <- function(file, width = "10px") {
  .Deprecated()
  paste('<img src="', file, '" style="width: ', width, ';"/>', sep="")
}
