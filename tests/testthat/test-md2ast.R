test_with_pandoc("citation", {
  temp_file <- tempfile(fileext = ".bib")
  temp_dir <- dirname(temp_file)
  current_dir <- getwd()
  suppressWarnings(knitr::write_bib("ftExtra", temp_file))

  setwd(temp_dir)
  expect_identical(
    md2ast(
      "@R-ftExtra",
      pandoc_args = c(
        "--bibliography", temp_file
      )
    )$blocks,
    md2ast(
      "@R-ftExtra",
      yaml = list(bibliography = basename(temp_file))
    )$blocks
  )
  setwd(current_dir)
})
