test_with_pandoc <- function(...) {
  if (rmarkdown::pandoc_available("2.7.2")) {
    test_that(...)
  }
}
