challenge
=========

A simple datascience challenge system using [Rmarkdown](http://rmarkdown.rstudio.com/) 
and [Dropbox](https://www.dropbox.com/).

I am currently using it for teaching Machine learning to Master students at the 
University of Bordeaux (see [this page](http://goo.gl/KRuYn0) in french).

Install
=======
Install the latest version of the package from github

```
require(devtools)
devtools::install_github("adrtod/challenge")
```

Getting started
===============
Install a new challenge in `path/to/newchallenge` (should be somewhere in your Dropbox)

```
library(challenge)

?new_challenge
new_challenge(path="path/to/newchallenge")
```

For a french version

```
new_challenge(path="path/to/newchallenge", template="challenge_fr.rmd")
```

You will obtain a folder with the following content:

- `challenge.rmd`: template Rmarkdown script for the webpage.
- `data`: directory of the data.
- `submissions`: directory of the submissions. Must contain one subdirectory per team
    where they can submit their submissions. The subdirectories are shared with
    Dropbox.
- `history`: directory where the contributions history is stored.

Next steps to complete the installation:

1. Replace the data files in the data subdirectory
2. Edit the template `challenge.rmd` as needed
3. Create and share subdirectories in `submissions` for each team:

```
setwd("path/to/newchallenge")

?new_team
new_team("TEAM_A")

```
    
4. Setup a crontab for automatic updates:

```
0 * * * * Rscript -e challenge::publish("path/to/challenge.rmd")
```

This will publish a html webpage in your Dropbox/Public folder every hour.

Author
=======
Copyright (C) 2014-2015 [Adrien Todeschini](https://sites.google.com/site/adrientodeschini)

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

Version 0.1 18/01/2015
----------------------
- initial package release
