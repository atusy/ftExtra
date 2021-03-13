#' Convert markdown to Pandoc's JSON AST
#' @param x A character vector
#' @param .from Markdown format
#' @noRd
md2ast <- function(x,
                   pandoc_args = NULL,
                   .from = "markdown",
                   yaml = rmarkdown::metadata) {
  tf <- tempfile()

  front_matter <- if ((length(yaml) > 0) && support_yaml(.from)) {
    yaml::write_yaml(yaml, tf)
    c("---", xfun::read_utf8(tf), "---", "", "")
  }

  xfun::write_utf8(c(front_matter, x), tf)

  rmarkdown::pandoc_convert(
    input = tf,
    to = "json",
    from = .from,
    output = tf,
    citeproc = !is.null(yaml$bibliography) || any(grepl("^--bibliography", pandoc_args)),
    options = pandoc_args,
    wd = getwd()
  )

  jsonlite::read_json(tf, simplifyVector = FALSE)
}
