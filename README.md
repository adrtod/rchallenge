challenge
=========
[![Travis-CI Build Status](https://travis-ci.org/adrtod/challenge.png?branch=master)](https://travis-ci.org/adrtod/challenge)

A simple datascience challenge system using [R Markdown](http://rmarkdown.rstudio.com/) 
and [Dropbox](https://www.dropbox.com/). It requires no network configuration, 
does not depend on external platforms like e.g. Kaggle and can be easily installed 
on a personal computer.

I am currently using it for teaching Machine learning to Master students at the 
University of Bordeaux (see [this page](http://goo.gl/KRuYn0) in french).

Install
=======
Install the latest version of the R package from github
```r
# install.packages("devtools")
devtools::install_github("adrtod/challenge")
```

Getting started
===============
Install a new challenge in `~/Dropbox/mychallenge`
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

You will obtain a ready-to-use challenge in the folder `~/Dropbox/mychallenge` containing:

- `challenge.rmd`: template R Markdown script for the webpage.
- `data`: directory of the data containing `data_train` and data_test` datasets.
- `submissions`: directory of the submissions. It will contain one subdirectory per team
    where they can submit their submissions. The subdirectories are shared with
    Dropbox.
- `history`: directory where the submissions history is stored.

The default challenge provided is a binary classification problem on the [German Credit Card](https://archive.ics.uci.edu/ml/datasets/Statlog+(German+Credit+Data)) dataset.

Next steps to complete the installation:

1. Replace the data files in the data subdirectory
2. Customize the template `challenge.rmd` as needed
3. Create and share subdirectories in `submissions` for each team:
    ```r
    ?new_team
    new_team("team_A")
    ```
    
4. Publish the html page in your folder `~/Dropbox/Public` and share the public link:
    ```r
    ?publish
    publish("challenge.rmd")
    ```
    
5. Automate the updates of the webpage. On UNIX systems, you can setup the following 
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

Author
=======
Copyright (C) 2014-2015 [Adrien Todeschini](https://sites.google.com/site/adrientodeschini)

Contributions from [Robin Genuer](http://robin.genuer.fr/)

Design inspired by [Datascience.net](https://datascience.net/), a french platform
for datascience challenges.

License: GPL-2

Roadmap
========
- [x] English translation
- [x] R package
- [ ] CRAN
- [ ] Interactive webpage using [Shiny](http://shiny.rstudio.com/)

Release notes
=============
Development version (ongoing)
--------------------------
- export `new_team` function
- suppress dependency to caret package

Version 0.1 (21-01-2015)
------------------------
- initial package release
- easy installation
- roxygen documentation
- english and french templates

Todo
==========
- [ ] do not take baseline into account in ranking
