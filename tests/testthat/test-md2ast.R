test_with_pandoc("citation", {
  temp_file <- tempfile(fileext = ".bib")
  temp_dir <- dirname(temp_file)
  current_dir <- getwd()
  suppressWarnings(knitr::write_bib("ftExtra", temp_file))

  res_current_dir <- try(md2ast(
    "@R-ftExtra",
    pandoc_args = c("--bibliography", temp_file)
  )$blocks)

  # NOTE: Avoid strange errors from some environments
  # (e.g., Fedora Linux, R-devel, GCC on R-hub)
  # > pandoc-citeproc: Error in $: Incompatible API versions:
  # > encoded with [1,20] but attempted to decode with [1,17,0,4].
  if (class(res_current_dir) != "try-error") {
    res_temp_dir <- local({
      on.exit(setwd(current_dir))
      setwd(temp_dir)
      md2ast(
        "@R-ftExtra",
        metadata = list(bibliography = basename(temp_file))
      )$blocks
    })

    expect_identical(res_current_dir, res_temp_dir)
  }
})
