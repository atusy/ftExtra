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
        "--to json",
        "--lua-filter", system.file("lua/smart.lua", package = "ftExtra"),
        "--lua-filter", system.file("lua/inline-code.lua", package = "ftExtra"),
        ""
      ),
      intern = TRUE
    ),
    simplifyVector = FALSE
  )
}
