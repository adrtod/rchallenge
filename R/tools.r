
#' Countdown before deadline
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

#' Formatted last date before deadline
#' @param deadline POSIXct. deadline
#' @param format   string. see \code{\link{format.POSIXct}}
#' @export
last_update <- function(deadline, format = "%d %b %Y %H:%M") {
  last = Sys.time()
  if (last>deadline+1)
    last = deadline+1
  return(format(last, format))
}

#' Path to glyphicon image file
#' @param name string. name of the glyphicon.
#' @param path string. folder of search.
#' @return the path to the file.
#' @export
glyphicon <- function(name, path = system.file('glyphicons', package = 'challenge')) {
  file <- list.files(path, pattern = paste("glyphicons_[0-9]+_", name, ".png", sep=""))
  if (length(file)==0)
    file <- list.files(path, pattern = paste("glyphicons_social_[0-9]+_", name, ".png", sep=""))
  if (length(file)==0)
    stop("glyphicon", name, "not found")
  return(file.path(path, file))
}

#' html code for an image
#' @param file string. image file.
#' @param width string. width of display.
#' @export
html_img <- function(file, width = "10px") {
  paste('<img src="', file, '" style="width: ', width, ';"/>', sep="")
}

#' Print read errors
#' @param read_err list of read errors returned by \code{\link{store_new_submissions}}
#' @export
#' @return \code{NULL}
print_readerr <- function(read_err = list()) {
  if (length(read_err)==0)
    cat("No read error.\n")
  for (i in seq(along=read_err)) {
    cat("Team", names(read_err)[i], ":\n")
    for (j in seq(along=read_err[[i]])) {
      cat("   ", paste(basename(names(read_err[[i]])[j]), ": "))
      cat(read_err[[i]][[j]]$message, "\n")
    }
  }
  invisible(NULL)
}

