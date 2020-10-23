#' Convert markdown to Pandoc's JSON AST
#' @param x A character vector
#' @param .from Markdown format
#' @noRd
md2ast <- function(x, pandoc_args = NULL, .from = "markdown") {
  tf <- tempfile()

  yaml <- rmarkdown::metadata
  if (length(yaml) > 0) {
    if (!is.null(yaml$bibliography)) {
      pandoc_args <- c(pandoc_args,
                       rmarkdown::pandoc_citeproc_args())
    }
    yaml::write_yaml(yaml, tf)
    front_matter <- c("---", readLines(tf), "---")
  } else {
    front_matter <- NULL
  }

  writeLines(c(front_matter, "", "", x), tf)
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
