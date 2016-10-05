#' @section Installation:
#' Install the R package from \href{https://cran.r-project.org/package=rchallenge}{CRAN} repositories
#' 
#' \code{install.packages("rchallenge")}
#' 
#' or install the latest development version from \href{https://github.com/adrtod/rchallenge}{GitHub}
#' 
#' \code{# install.packages("devtools")}
#' 
#' \code{devtools::install_github("adrtod/rchallenge")}
#' 
#' A recent version of \href{http://johnmacfarlane.net/pandoc/}{pandoc} (>= 1.12.3) is also required. 
#' See the \href{https://github.com/rstudio/rmarkdown/blob/master/PANDOC.md}{pandoc installation instructions} 
#' for details on installing pandoc for your platform.
#' 
#' @section Getting started:
#' Install a new challenge in \code{Dropbox/mychallenge}:
#' 
#' \code{setwd("~/Dropbox/mychallenge")}
#' 
#' \code{library(rchallenge)}
#' 
#' \code{\link{new_challenge}()}
#' 
#' or for a french version:
#' 
#' \code{\link{new_challenge}(template = "fr")}
#' 
#' You will obtain a ready-to-use challenge in the folder \code{Dropbox/mychallenge} containing:
#' \itemize{ 
#'  \item \code{challenge.rmd}: Template R Markdown script for the webpage.
#'  \item \code{data}: Directory of the data containing \code{data_train} and \code{data_test} datasets.
#'  \item \code{submissions}: Directory of the submissions. It will contain one subdirectory per team where they can submit their submissions. The subdirectories are shared with Dropbox.
#'  \item \code{history}: Directory where the submissions history is stored.
#' }
#' The default challenge provided is a binary classification problem on the \href{https://goo.gl/ndMhNw}{German Credit Card} dataset.
#' 
#' You can easily customize the challenge in two ways:
#'   
#' \itemize{ 
#'  \item \emph{During the creation of the challenge}: by using the options of the \code{\link{new_challenge}} function.
#'  \item \emph{After the creation of the challenge}: by manually replacing the data files in the \code{data} subdirectory and the baseline predictions in \code{submissions/baseline} and by customizing the template \code{challenge.rmd} as needed.
#' }
#' 
#' @section Next steps:
#' To complete the installation:
#' \enumerate{
#'  \item Create and \href{https://www.dropbox.com/en/help/19}{share} subdirectories in \code{submissions} for each team:
#'  
#'    \code{\link{new_team}("team_foo", "team_bar")}
#' 
#'  \item Render the html page:
#'    \code{\link{publish}()}
#'    Use the \code{output_dir} argument to change the output directory.
#'    Make sure the output HTML file is rendered, e.g. using \href{https://pages.github.com/}{GitHub Pages}.
#' 
#'  \item Give the URL to your \code{challenge.html} file to the participants.
#'  
#'  \item Refresh the webpage by repeating step 2 on a regular basis. See below for automating this step.
#' }
#' 
#' From now on, a fully autonomous challenge system is set up requiring no further 
#' administration. With each update, the program automatically performs the following
#' tasks using the functions available in our package:
#'   
#' \itemize{ 
#'  \item \code{\link{store_new_submissions}}: Reads submitted files and save new files in the history.
#'  \item \code{\link{print_readerr}}: Displays any read errors.
#'  \item \code{\link{compute_metrics}}: Calculates the scores for each submission in the history.
#'  \item \code{\link{get_best}}: Gets the highest score per team.
#'  \item \code{\link{print_leaderboard}}: Displays the leaderboard.
#'  \item \code{\link{plot_history}}: Plots a chart of score evolution per team.
#'  \item \code{\link{plot_activity}}: Plots a chart of activity per team.
#' }
#' 
#' @section Automating the updates on \strong{Unix/OSX}:
#' 
#' For the step 4, you can setup the following line to your \href{https://en.wikipedia.org/wiki/Cron}{crontab} 
#' using \code{crontab -e} (mind the quotes):
#' 
#' \code{0 * * * * Rscript -e 'rchallenge::publish("~/Dropbox/mychallenge/challenge.rmd")'}
#' 
#' This will render a HTML webpage every hour.
#' Use the \code{output_dir} argument to change the output directory.
#' 
#' You might have to add the path to Rscript and pandoc at the beginning of your crontab:
#'  
#' \code{PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin}
#'
#' Depending on your system or pandoc version you might also have to explicitly add the encoding option to the command:
#' 
#' \code{0 * * * * Rscript -e 'rchallenge::publish("~/Dropbox/mychallenge/challenge.rmd", encoding = "utf8")'}
#' 
#' @section Automating the updates on \strong{Windows}:
#' 
#' You can use the \href{https://technet.microsoft.com/en-us/library/cc748993(v=ws.11).aspx}{Task Scheduler} 
#' to create a new task with a \emph{Start a program} action with the settings (mind the quotes):
#'   
#' \itemize{ 
#'  \item \emph{Program/script}: \code{Rscript.exe}
#'  \item \emph{options}: \code{-e rchallenge::publish('~/Dropbox/mychallenge/challenge.rmd')}
#' }
#' 
#' @note The rendering of HTML content provided by Dropbox will be discontinued from the 
#' 3rd October 2016 for Basic users and the 1st September 2017 for Pro and Business users. 
#' See \url{https://www.dropbox.com/help/16}. Alternatively, \href{https://pages.github.com/}{GitHub Pages}
#' provide an easy HTML publishing solution via a simple GitHub repository.
#' 
#' @section Examples:
#' \itemize{ 
#'  \item \href{https://adrtod.github.io/challenge_mimse2014.html}{My own challenge} (in french) given to Master students at the University of Bordeaux.
#'  \item \href{https://dl.dropboxusercontent.com/u/50849929/challenge_fr.html}{A classification and variable selection problem} (in french) given by Robin Genuer (Bordeaux).
#' }
#' 
#' Please \href{https://adrtod.github.io}{contact me} to add yours.
"_PACKAGE"
