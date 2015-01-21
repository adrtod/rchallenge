#' String displayed for the rank.
#' 
#' Concatenates the rank number with symbols indicating the progress since the last change.
#' 
#' @param r     integer. rank
#' @param r_d   integer. rank difference
#' @param symb  named list of characters. symbols used for the progress in ranking:
#'   no change (\code{const}), ascent (\code{up}) and descent (\code{down})
str_rank <- function(r, r_d, symb = list(const = html_img(glyphicon("right_arrow"), "10px"),
                                         up = html_img(glyphicon("up_arrow"), "10px"),
                                         down = html_img(glyphicon("down_arrow"), "10px"))) {
  paste0(r, '. ', ifelse(r_d==0,
                         symb["const"], 
                         ifelse(r_d<0,
                                paste(rep(symb["up"], -r_d), collapse=""), 
                                paste(rep(symb["down"], r_d), collapse=""))))
}


#' Format the leaderboard in Markdown.
#' 
#' @param best    list of the best submissions per team and per metric as returned
#'   by \code{\link{get_best}}.
#' @param metric  string. name of the metric considered
#' @param test_name string. name of the test set used: \code{"quiz"} or \code{"test"}
#' @param ... further parameters to pass to \code{\link[knitr]{kable}}er
#' 
#' @return \code{print_leaderboard} returns a character vector of the table source code
#'   to be used in a Markdown document.
#'   
#' @note Chunk option \code{results='asis'} has to be used
#' 
#' @export
#' @seealso \code{\link[knitr]{kable}}
#' @importFrom knitr kable
print_leaderboard <- function(best, metric, test_name = "quiz", ...) {
  metric_column = paste(metric, test_name, sep=".")
  leaderboard = data.frame(Rank = mapply(FUN = str_rank, best[[metric]]$rank, best[[metric]]$rank_diff),
                          Team = best[[metric]]$team,
                          Submissions = paste(best[[metric]]$n_submissions),
                          Date = format(best[[metric]]$date, format="%d/%m/%y %H:%M"),
                          Score = format(best[[metric]][[metric_column]], digits=3))
  knitr::kable(leaderboard, ...)
}