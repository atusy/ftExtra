#' Convert markdown to Pandoc's JSON AST
#' @param x A character vector
#' @param .from Markdown format
#' @noRd
md2ast <- function(x, .from = "markdown", .pandoc_args = NULL) {
  tf <- tempfile()
  writeLines(x, tf)
  jsonlite::fromJSON(
    system(
      paste(
        shQuote(rmarkdown::pandoc_exec()),
        tf,
        "--from", .from,
        "--to json",
        paste(.pandoc_args, collapse = " ")
      ),
      intern = TRUE
    ),
    simplifyVector = FALSE
  )
}
