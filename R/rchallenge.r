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
#'  \item Publish the html page in \code{Dropbox/Public}:
#'    \code{\link{publish}()}
#'    Prior to this, make sure you \href{https://www.dropbox.com/enable_public_folder}{enabled your Public Dropbox folder}.
#' 
#'  \item Give the \href{https://www.dropbox.com/en/help/274}{public link} to your \code{Dropbox/Public/challenge.html} file to the participants.
#'  
#'  \item Automate the updates of the webpage.
#' }
#' 
#' For the step 4, on \strong{Unix} systems, you can setup the following 
#' line to your \href{https://en.wikipedia.org/wiki/Cron}{crontab} using \code{crontab -e} (mind the quotes):
#' 
#' \code{0 * * * * Rscript -e 'rchallenge::publish("~/Dropbox/mychallenge/challenge.rmd")'}
#' 
#' This will publish a html webpage in your \code{Dropbox/Public} folder every hour.
#' 
#' On \strong{Windows} systems, you can use the \href{http://windows.microsoft.com/en-us/windows/schedule-task}{Task Scheduler} to create a new task with a \emph{Start a program} action with the settings (mind the quotes):
#'   
#' \itemize{ 
#'  \item \emph{Program/script}: \code{Rscript.exe}
#'  \item \emph{options}: \code{-e rchallenge::publish('~/Dropbox/mychallenge/challenge.rmd')}
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
#' @section Examples:
#' \itemize{ 
#'  \item \href{https://dl.dropboxusercontent.com/u/25867212/challenge_mimse2014.html}{My own challenge} (in french) given to Master students at the University of Bordeaux.
#'  \item \href{https://dl.dropboxusercontent.com/u/50849929/challenge_fr.html}{A classification and variable selection problem} (in french) given by Robin Genuer (Bordeaux).
#' }
#' 
#' Please \href{https://sites.google.com/site/adrientodeschini/}{contact me} to add yours.
"_PACKAGE"
