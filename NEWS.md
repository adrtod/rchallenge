# rchallenge 1.3.4.9000

# rchallenge 1.3.4 (08-03-2021)
- Skip test for pandoc availability on CRAN.
- Added condition on publish() example.

# rchallenge 1.3.3 (05-03-2021)
- Use South German Credit data from [UCI ML Repository](https://archive.ics.uci.edu/ml/datasets/South+German+Credit)

# rchallenge 1.3.2 (13-01-2019)
- Re-added `pandoc` to `SystemRequirements` and added a test for `pandoc` availability.

# rchallenge 1.3.1 (18-12-2019)
- removed `pandoc` from `SystemRequirements`, because implied by dependence on `rmarkdown` and `knitr` packages.
- corrected `german` data set after Groemping, U. (2019).

# rchallenge 1.3.0 (23-10-2016)
- `output_dir` argument of `publish` function now defaults to `"index.html"`. Useful for hosting the challenge on a GitHub repository with Github pages.
- `glyphicon` is defunct. use `icon` instead of glyphicon.
- `print_readerr` displays a table.
- `get_best` returns a single data.frame instead of a list with one data.frame per metric. the ranking can be based on several metrics in a specific order to break ties.
- `update_rank_diff` and `print_leaderboard` take a single data.frame as input

# rchallenge 1.2.0 (05-10-2016)
- `output_dir` argument of `publish` function now defaults to the `input` directory instead of `"~/Dropbox/Public"` because Dropbox rendering of HTML content is discontinued.

# rchallenge 1.1.1 (25-11-2015)
- fixed bug for "submitted after the deadline"
- added some comments in template rmd files
- added overall package documentation

# rchallenge 1.1 (16-05-2015)
- added `out_rmdfile` argument to `new_challenge`
- changed `template` argument to `c("en", "fr")`
- fixed bugs
- added examples to doc
- available on CRAN

# rchallenge 1.0 (15-04-2015)
- new name
- changes in `README.md`
- `new_team` can create several teams
- instructions for windows

# rchallenge 0.2 (05-03-2015)
- exported `new_team` function
- suppressed dependency to caret package
- fixed change of directory in `publish`
- improved messages

# rchallenge 0.1 (21-01-2015)
- initial package release
- easy installation
- roxygen documentation
- english and french templates
