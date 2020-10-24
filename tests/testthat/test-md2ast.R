test_with_pandoc <- function(...) {
  if (rmarkdown::pandoc_available("2.7.2")) {
    test_that(...)
  }
}

test_with_pandoc("citation", {
  temp_file <- tempfile(fileext = ".bib")
  suppressWarnings(knitr::write_bib("ftExtra", temp_file))
  expect_identical(
    md2ast("@R-ftExtra",
           pandoc_args = paste0("--bibliography=", temp_file))$blocks,
    md2ast("@R-ftExtra",
           yaml = list(bibliography = temp_file))$blocks
  )
})
