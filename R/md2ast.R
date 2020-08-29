#' Convert markdown to Pandoc's JSON AST
#' @param x A character vector
#' @param .from Markdown format
#' @noRd
md2ast <- function(x, .from = "markdown") {
  tf <- tempfile()
  writeLines(x, tf)
  jsonlite::fromJSON(
    system(
      paste(
        shQuote(rmarkdown::pandoc_exec()),
        tf,
        "--from", .from,
        "--to json"
      ),
      intern = TRUE
    ),
    simplifyVector = FALSE
  )
}
