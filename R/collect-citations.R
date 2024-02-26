collect_citations <- function(x, .from = "markdown") {
  tf <- tempfile()
  xfun::write_utf8(x, tf)
  rmarkdown::pandoc_convert(
    input = tf,
    to = "markdown",
    from = .from,
    output = tf,
    citeproc = FALSE,
    options = lua("cite.lua"),
    wd = getwd()
  )
  paste(readLines(tf), collapse = "")
}
