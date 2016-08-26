#' @keywords internal
update_gh_pages <- function(message) {
  system("git checkout gh-pages")
  system("git checkout master -- docs")
  setwd("docs")
  system("git mv -fkv * ..")
  setwd("..")
  system(paste('git commit -am "', message,'"'))
  system("git push")
  system("git checkout master")
}