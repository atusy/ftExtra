md2ast = function(x) {
  tf = tempfile()
  writeLines(x, tf)
  jsonlite::fromJSON(
    system(
      paste(
        rmarkdown::pandoc_exec(),
        tf,
        '--to json'
      ),
      intern = TRUE
    ),
    simplifyVector = FALSE
  )
}




