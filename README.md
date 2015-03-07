challenge
=========
[![GitHub sources](https://img.shields.io/badge/View_on-GitHub-yellow.svg)](https://github.com/adrtod/challenge/)
[![GitHub release](https://img.shields.io/github/release/adrtod/challenge.svg)](https://github.com/adrtod/challenge/releases/latest)
[![Travis-CI Build Status](https://img.shields.io/travis/adrtod/challenge.svg)](https://travis-ci.org/adrtod/challenge)
[![GPLv2 License](http://img.shields.io/badge/license-GPLv2-blue.svg)](http://www.gnu.org/licenses/gpl-2.0.html)

The R package **challenge** provides a simple datascience competition system using [R Markdown](http://rmarkdown.rstudio.com/) 
and [Dropbox](https://www.dropbox.com/) with the following features:

- no network configuration required.
- does not depend on external platforms like e.g. Kaggle.
- can be easily installed on a personal computer.
- provides a customizable template in english and french.

Further documentation is available in the [Reference manual](http://adrtod.github.io/challenge).

Please report bugs, troubles or discussions on the [Issues](https://github.com/adrtod/challenge/issues) tracker. Any contribution to improve the package is welcome.

### Installation
Install the latest version of the R package from [GitHub](https://github.com/adrtod/challenge)
```r
# install.packages("devtools")
devtools::install_github("adrtod/challenge")
```

### Getting started
Install a new challenge in `Dropbox/mychallenge`
```r
setwd("~/Dropbox/mychallenge")
library(challenge)
?new_challenge
new_challenge()
```

or for a french version
```r
new_challenge(template="challenge_fr.rmd")
```

You will obtain a ready-to-use challenge in the folder `Dropbox/mychallenge` containing:

- `challenge.rmd`: template R Markdown script for the webpage.
- `data`: directory of the data containing `data_train` and `data_test` datasets.
- `submissions`: directory of the submissions. It will contain one subdirectory per team
    where they can submit their submissions. The subdirectories are shared with
    Dropbox.
- `history`: directory where the submissions history is stored.

The default challenge provided is a binary classification problem on the [German Credit Card](https://archive.ics.uci.edu/ml/datasets/Statlog+(German+Credit+Data)) dataset.

### Next steps
To complete the installation:

1. Replace the data files in the `data` subdirectory and the baseline predictions in `submissions/baseline`.
2. Customize the template `challenge.rmd` as needed.
3. Create and [share](https://www.dropbox.com/en/help/19) subdirectories in `submissions` for each team:
    ```r
    ?new_team
    new_team("my_team")
    ```
    
4. Publish the html page in `Dropbox/Public`:
    ```r
    ?publish
    publish("challenge.rmd")
    ```
    Prior to this, make sure you [enabled your Public Dropbox folder](http://www.dropbox.com/enable_public_folder).

5. Give the [public link](https://www.dropbox.com/en/help/274) to your `Dropbox/Public/challenge.html` file to the participants.
    
6. Automate the updates of the webpage. On UNIX systems, you can setup the following 
    line to your [crontab](http://en.wikipedia.org/wiki/Cron) using `crontab -e`:
    ```
    0 * * * * Rscript -e challenge::publish("~/Dropbox/mychallenge/challenge.rmd")
    ```
    
    This will publish a html webpage in your `Dropbox/Public` folder every hour.
    
From now on, a fully autonomous challenge system is set up requiring no further 
administration. With each update, the program automatically performs the following
tasks using the functions available in our package:

- `store_new_submissions()` reads submitted files and save new files in the history.
- `print_readerr()` displays any read errors.
- `compute_metrics()` calculates of scores for each submission in the history.
- `get_best()` gets the highest score per team.
- `print_leaderboard()` displays the leaderboard.
- `plot_history()` plots a chart of score evolution per team.
- `plot_activity()` plots a chart of activity per team.

### Examples
- My own challenge given to Master students at the University of Bordeaux: see [this page](http://goo.gl/KRuYn0) (in french).

- A classification and variable selection problem given by Robin Genuer (Bordeaux): see [this page](https://dl.dropboxusercontent.com/u/50849929/challenge_fr.html) (in french).

Please [contact me](https://sites.google.com/site/adrientodeschini) to add yours.

### Copyright
Copyright (C) 2014-2015 [Adrien Todeschini](https://sites.google.com/site/adrientodeschini).

Contributions from [Robin Genuer](http://robin.genuer.fr/).

Design inspired by [Datascience.net](https://datascience.net/), a french platform
for datascience challenges.

The **challenge** package is licensed under the GPLv2 (http://www.gnu.org/licenses/gpl-2.0.html).

### To do list
- [ ] do not take baseline into account in ranking
- [ ] submit to CRAN
- [ ] interactive webpage using [Shiny](http://shiny.rstudio.com/)

## Release notes
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
