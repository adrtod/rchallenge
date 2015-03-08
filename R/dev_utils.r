#' @keywords internal
update_gh_pages <- function(message) {
  system("git checkout gh-pages")
  system("git checkout master -- inst/web")
  system("cd inst/web")
  system("git mv -fkv * ../..")
  system("cd ../..")
  system(paste('git commit -am "', message,'"'))
  system("git push")
  system("git checkout master")
}