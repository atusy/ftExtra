#' Convert markdown to Pandoc's JSON AST
#' @param x A character vector
#' @param .from Markdown format
#' @noRd
md2ast <- function(x, pandoc_args = NULL, .from = "markdown") {
  tf <- tempfile()

  yaml <- rmarkdown::metadata

  front_matter <- if (length(yaml) > 0) {
    yaml::write_yaml(yaml, tf)
    c("---", xfun::read_utf8(tf), "---", "", "")
  }

  citeproc <- if(!is.null(yaml$bibliography)) rmarkdown::pandoc_citeproc_args()

  xfun::write_utf8(c(front_matter, x), tf)

  system(paste(
    shQuote(rmarkdown::pandoc_exec()),
    tf,
    "--from", .from,
    "--to json",
    "--output", tf,
    paste(pandoc_args, collapse = " ")
  ))

  jsonlite::read_json(tf, simplifyVector = FALSE)
}
