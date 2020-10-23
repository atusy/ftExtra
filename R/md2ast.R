#' Convert markdown to Pandoc's JSON AST
#' @param x A character vector
#' @param .from Markdown format
#' @noRd
md2ast <- function(x, pandoc_args = NULL, .from = "markdown") {
  tf <- tempfile()

  yaml <- rmarkdown::metadata

  front_matter <- if (length(yaml) > 0) {
    yaml::write_yaml(yaml, tf)
    c("---", readLines(tf), "---", "", "")
  }

  citeproc <- if(!is.null(yaml$bibliography)) rmarkdown::pandoc_citeproc_args()

  writeLines(c(front_matter, x), tf)
  jsonlite::fromJSON(
    system(
      paste(
        shQuote(rmarkdown::pandoc_exec()),
        tf,
        "--from", .from,
        "--to json",
        paste(pandoc_args, collapse = " ")
      ),
      intern = TRUE
    ),
    simplifyVector = FALSE
  )
}
