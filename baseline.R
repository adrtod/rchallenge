load("data/data_test.RData")

contrib_dir = "contrib"
team = "baseline"
out_dir = file.path(contrib_dir, team)

unlink(out_dir)
dir.create(out_dir)

#' # Predict all good
predict_all_good <- function(data_test, ...) {
  rep("Good", nrow(data_test))
}

Y_pred <- predict_all_good(data_test)
write(Y_pred, file = file.path(out_dir, 'all_good.csv'))

#' # Predict all bad
predict_all_bad <- function(data_test, ...) {
  rep("Bad", nrow(data_test))
}

Y_pred <- predict_all_bad(data_test)
write(Y_pred, file = file.path(out_dir, 'all_bad.csv'))
