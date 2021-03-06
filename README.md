rchallenge
==========  
<!-- badges: start -->
[![R-CMD-check](https://github.com/adrtod/rchallenge/workflows/R-CMD-check/badge.svg)](https://github.com/adrtod/rchallenge/actions)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/rchallenge)](https://cran.r-project.org/package=rchallenge)
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/rchallenge)](https://www.r-pkg.org/pkg/rchallenge)
[![GPLv2 License](https://img.shields.io/badge/license-GPLv2-blue.svg)](https://www.gnu.org/licenses/gpl-2.0.html)
<!-- badges: end -->

The **rchallenge** R package provides a simple data science competition system using [R Markdown](https://rmarkdown.rstudio.com/) 
and [Dropbox](https://www.dropbox.com/) with the following features:

- No network configuration required.
- Does not depend on external platforms like e.g. [Kaggle](https://www.kaggle.com/).
- Can be easily installed on a personal computer.
- Provides a customizable template in english and french.

Further documentation is available in the [Reference manual](https://adrien.tspace.fr/rchallenge/reference/index.html).

Please report bugs, troubles or discussions on the [Issues](https://github.com/adrtod/rchallenge/issues) tracker. Any contribution to improve the package is welcome.

## Installation
Install the R package from [CRAN](https://cran.r-project.org/package=rchallenge) repositories
``` r
install.packages("rchallenge")
```
or install the latest development version from [GitHub](https://github.com/adrtod/rchallenge)
``` r
# install.packages("devtools")
devtools::install_github("adrtod/rchallenge")
```

A recent version of [pandoc](https://pandoc.org/) (>= 1.12.3) is also required. See the [pandoc installation instructions](https://pandoc.org/installing.html) for details on installing pandoc for your platform.

## Getting started
Install a new challenge in `Dropbox/mychallenge`:
``` r
setwd("~/Dropbox/mychallenge")
library(rchallenge)
new_challenge()
```

or for a french version:
``` r
new_challenge(template = "fr")
```

You will obtain a ready-to-use challenge in the folder `Dropbox/mychallenge` containing:

- `challenge.rmd`: template R Markdown script for the webpage.
- `data`: directory of the data containing `data_train` and `data_test` datasets.
- `submissions`: directory of the submissions. It will contain one subdirectory per team where they can submit their submissions. The subdirectories are shared with Dropbox.
- `history`: directory where the submissions history is stored.


The default challenge provided is a binary classification problem on the [South German Credit](https://archive.ics.uci.edu/ml/datasets/South+German+Credit) data set.

You can easily customize the challenge in two ways:

- *During the creation of the challenge*: by using the options of the `new_challenge()` function.
- *After the creation of the challenge*: by manually replacing the data files in the `data` subdirectory and the baseline predictions in `submissions/baseline` and by customizing the template `challenge.rmd` as needed.

## Next steps
To complete the installation:

1. Create and [share](https://help.dropbox.com/fr-fr/files-folders/share/share-with-others) subdirectories in `submissions` for each team:

    ``` r
    new_team("team_foo", "team_bar")
    ```

2. Render the HTML page:

    ``` r
    publish()
    ```
    Use the `output_dir` argument to change the output directory.
    Make sure the output HTML file is rendered, e.g. using [GitHub Pages](https://pages.github.com/).

3. Give the URL to your HTML file to the participants.
    
4. Refresh the webpage by repeating step 2 on a regular basis. See below for automating this step.

From now on, a fully autonomous challenge system is set up requiring no further 
administration. With each update, the program automatically performs the following
tasks using the functions available in our package:

- `store_new_submissions()` reads submitted files and save new files in the history.
- `print_readerr()` displays any read errors.
- `compute_metrics()` calculates the scores for each submission in the history.
- `get_best()` gets the highest score per team.
- `print_leaderboard()` displays the leaderboard.
- `plot_history()` plots a chart of score evolution per team.
- `plot_activity()` plots a chart of activity per team.

## Automating the updates

### Unix/OSX

You can setup the following line to your [crontab](https://en.wikipedia.org/wiki/Cron) using `crontab -e` (mind the quotes):
```
0 * * * * Rscript -e 'rchallenge::publish("~/Dropbox/mychallenge/challenge.rmd")'
```
This will render a HTML webpage every hour.
Use the `output_dir` argument to change the output directory.

If your challenge is hosted on a Github repository you can automate the push:
```
0 * * * * cd ~/Dropbox/mychallenge && Rscript -e 'rchallenge::publish()' && git commit -m "update html" index.html && git push
```

You might have to add the path to Rscript and pandoc at the beginning of your crontab:
```
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
```

Depending on your system or pandoc version you might also have to explicitly add the encoding option to the command:
```
0 * * * * Rscript -e 'rchallenge::publish("~/Dropbox/mychallenge/challenge.rmd", encoding = "utf8")'
```


### Windows

You can use the [Task Scheduler](https://www.windowscentral.com/how-create-automated-task-using-task-scheduler-windows-10) to create a new task with a *Start a program* action with the settings (mind the quotes):

- *Program/script*: `Rscript.exe`
- *options*: `-e rchallenge::publish('~/Dropbox/mychallenge/challenge.rmd')`

## Issues

- The rendering of HTML content provided by Dropbox will be discontinued from the 3rd October 2016 for Basic users and the 1st September 2017 for Pro and Business users. See <https://help.dropbox.com/fr-fr/files-folders/share/public-folder>. Alternatively, [GitHub Pages](https://pages.github.com/) provide an easy HTML publishing solution via a simple GitHub repository.
- version 1.16 of pandoc fails to fetch font awesome css, see <https://github.com/jgm/pandoc/issues/2737>.

## Examples
- [Credit approval](https://adrien.tspace.fr/challenge-mimse2014/) (in french) by Adrien Todeschini (Bordeaux).

- [Spam filter](https://chavent.github.io/challenge-mmas/) (in french) by Marie Chavent (Bordeaux).

Please [contact me](https://adrien.tspace.fr/) to add yours.

## Copyright
Copyright (C) 2014-2015 [Adrien Todeschini](https://adrien.tspace.fr/).

Contributions from [Robin Genuer](http://robin.genuer.fr/).

The **rchallenge** package is licensed under the GPLv2 (https://www.gnu.org/licenses/gpl-2.0.html).

## To do list
- [ ] do not take baseline into account in ranking
- [ ] examples, tests, vignettes
- [ ] interactive plots with `ggvis`
- [ ] check arguments
- [ ] interactive webpage using [Shiny](https://shiny.rstudio.com/)
