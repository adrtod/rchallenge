challenge
=========

A simple datascience challenge system using [Rmarkdown](http://rmarkdown.rstudio.com/) 
and [Dropbox](https://www.dropbox.com/).

I am currently using it for teaching Machine learning to Master students at the 
University of Bordeaux (see [this page](http://goo.gl/KRuYn0)).

Contents
========
- `challenge.Rmd`: Rmarkdown script for the webpage (currently in french).
- `admin.R`: R script with utility functions used in the webpage.
- `baseline.R`: R script generating the baseline predictions.
- `refresh.R`: R script used to refresh the webpage.
- `data`: directory of the data.
- `contrib`: directory of the contributions. Must contain one subdirectory per team
    where they can submit their contributions. The subdirectories are shared with
    Dropbox.
- `history`: directory where the contributions history is stored.
- `figures`: directory of images used in the webpage.

Author
=======
[Adrien Todeschini](https://sites.google.com/site/adrientodeschini)

Design inspired by [Datascience.net](https://datascience.net/), a french platform
for datascience challenges.

Roadmap
========
- [ ] English translation
- [ ] Interactive webpage using [Shiny](http://shiny.rstudio.com/)
- [ ] CRAN package