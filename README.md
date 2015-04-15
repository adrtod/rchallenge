rchallenge
==========
[![GitHub sources](https://img.shields.io/badge/View_on-GitHub-yellow.svg)](https://github.com/adrtod/rchallenge/)
[![GitHub release](https://img.shields.io/github/release/adrtod/rchallenge.svg)](https://github.com/adrtod/rchallenge/releases/latest)
[![Travis-CI Build Status](https://img.shields.io/travis/adrtod/rchallenge.svg)](https://travis-ci.org/adrtod/rchallenge)
[![GPLv2 License](http://img.shields.io/badge/license-GPLv2-blue.svg)](http://www.gnu.org/licenses/gpl-2.0.html)

The **rchallenge** R package provides a simple datascience competition system using [R Markdown](http://rmarkdown.rstudio.com/) 
and [Dropbox](https://www.dropbox.com/) with the following features:

- No network configuration required.
- Does not depend on external platforms like e.g. Kaggle.
- Can be easily installed on a personal computer.
- Provides a customizable template in english and french.

Further documentation is available in the [Reference manual](http://adrtod.github.io/rchallenge).

Please report bugs, troubles or discussions on the [Issues](https://github.com/adrtod/rchallenge/issues) tracker. Any contribution to improve the package is welcome.

### Installation
Install the latest version of the R package from [GitHub](https://github.com/adrtod/rchallenge)
```r
# install.packages("devtools")
devtools::install_github("adrtod/rchallenge")
```

### Getting started
Install a new challenge in `Dropbox/mychallenge`
```r
setwd("~/Dropbox/mychallenge")
library(rchallenge)
?new_challenge
new_challenge()
```

or for a french version
```r
new_challenge(template="challenge_fr.rmd")
```

You will obtain a ready-to-use challenge in the folder `Dropbox/mychallenge` containing:

Name | Description
------------- | -------------
`challenge.rmd` | Template R Markdown script for the webpage.
`data` | Directory of the data containing `data_train` and `data_test` datasets.
`submissions` | Directory of the submissions. It will contain one subdirectory per team where they can submit their submissions. The subdirectories are shared with Dropbox.
`history` | Directory where the submissions history is stored.


The default challenge provided is a binary classification problem on the [German Credit Card](https://archive.ics.uci.edu/ml/datasets/Statlog+(German+Credit+Data)) dataset.

You can easily customize the challenge in two ways:

- *During the creation of the challenge*: by using the options of the `new_challenge` function.
- *After the creation of the challenge*: by manually replacing the data files in the `data` subdirectory and the baseline predictions in `submissions/baseline` and by customizing the template `challenge.rmd` as needed.


### Next steps
To complete the installation:

1. Create and [share](https://www.dropbox.com/en/help/19) subdirectories in `submissions` for each team:
    ```r
    ?new_team
    new_team("team_foo", "team_bar")
    ```
    
2. Publish the html page in `Dropbox/Public`:
    ```r
    ?publish
    publish("challenge.rmd")
    ```
    Prior to this, make sure you [enabled your Public Dropbox folder](http://www.dropbox.com/enable_public_folder).

3. Give the [public link](https://www.dropbox.com/en/help/274) to your `Dropbox/Public/challenge.html` file to the participants.
    
4. Automate the updates of the webpage.

For the step 4, on **Unix** systems, you can setup the following 
line to your [crontab](http://en.wikipedia.org/wiki/Cron) using `crontab -e` (mind the quotes):
```
0 * * * * Rscript -e 'rchallenge::publish("~/Dropbox/mychallenge/challenge.rmd")'
```
This will publish a html webpage in your `Dropbox/Public` folder every hour.

On **Windows** systems, you can use the [Task Scheduler](http://windows.microsoft.com/en-us/windows/schedule-task) to create a new task with a *Start a program* action with the settings (mind the quotes):

- *Program/script*: `Rscript.exe`
- *options*: `-e rchallenge::publish('~/Dropbox/mychallenge/challenge.rmd')`
    
From now on, a fully autonomous challenge system is set up requiring no further 
administration. With each update, the program automatically performs the following
tasks using the functions available in our package:

Name | Description
------------- | -------------
`store_new_submissions()` | Reads submitted files and save new files in the history.
`print_readerr()` | Displays any read errors.
`compute_metrics()` | Calculates the scores for each submission in the history.
`get_best()` | Gets the highest score per team.
`print_leaderboard()` | Displays the leaderboard.
`plot_history()` | Plots a chart of score evolution per team.
`plot_activity()` | Plots a chart of activity per team.

### Examples
- My own challenge given to Master students at the University of Bordeaux: see [this page](https://dl.dropboxusercontent.com/u/25867212/challenge_mimse2014.html) (in french).

- A classification and variable selection problem given by Robin Genuer (Bordeaux): see [this page](https://dl.dropboxusercontent.com/u/50849929/challenge_fr.html) (in french).

Please [contact me](https://sites.google.com/site/adrientodeschini) to add yours.

### Copyright
Copyright (C) 2014-2015 [Adrien Todeschini](https://sites.google.com/site/adrientodeschini).

Contributions from [Robin Genuer](http://robin.genuer.fr/).

Design inspired by [Datascience.net](https://www.datascience.net/), a french platform
for datascience challenges.

The **rchallenge** package is licensed under the GPLv2 (http://www.gnu.org/licenses/gpl-2.0.html).

### To do list
- [ ] common leaderboard for several metrics
- [ ] do not take baseline into account in ranking
- [ ] examples, tests, vignettes
- [ ] test windows
- [ ] submit to CRAN
- [ ] interactive webpage using [Shiny](http://shiny.rstudio.com/)

## Release notes
### Version 1.0 (15-04-2015)
- new name
- changes in readme
- `new_team` can create several teams
- instructions for windows

### Version 0.2 (05-03-2015)
- exported `new_team` function
- suppressed dependency to caret package
- fixed change of directory in `publish`
- improved messages

### Version 0.1 (21-01-2015)
- initial package release
- easy installation
- roxygen documentation
- english and french templates
