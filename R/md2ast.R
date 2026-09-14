#' Convert markdown to Pandoc's JSON AST
#' @param x A character vector
#' @param .from Markdown format
#' @noRd
md2ast <- function(x,
                   pandoc_args = NULL,
                   metadata = render_metadata(),
                   .from = "markdown") {
  tf <- tempfile()

  front_matter <- if ((length(metadata) > 0) && support_yaml(.from)) {
    yaml::write_yaml(metadata, tf)
    c("---", xfun::read_utf8(tf), "---", "", "")
  }

  xfun::write_utf8(c(front_matter, x), tf)

  rmarkdown::pandoc_convert(
    input = tf,
    to = "json",
    from = .from,
    output = tf,
    citeproc = !is.null(metadata[["bibliography"]]) ||
      length(metadata[["references"]]) > 0L ||
      any(grepl("^--bibliography", pandoc_args)),
    options = pandoc_args,
    wd = getwd()
  )

  jsonlite::read_json(tf, simplifyVector = FALSE)
}
