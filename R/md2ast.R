#' Convert markdown to Pandoc's JSON AST
#' @param x A character vector
#' @param .from Markdown format
#' @noRd
md2ast <- function(x,
                   pandoc_args = NULL,
                   metadata = rmarkdown::metadata,
                   .from = "markdown") {
  tf <- tempfile()

  front_matter <- if ((length(metadata) > 0) && support_yaml(.from)) {
    yaml::write_yaml(metadata, tf)
    c("---", warn_chunk(xfun::read_utf8(tf)), "---", "", "")
  }

  xfun::write_utf8(c(front_matter, x), tf)

  rmarkdown::pandoc_convert(
    input = tf,
    to = "json",
    from = .from,
    output = tf,
    citeproc = !is.null(metadata[["bibliography"]]) || any(grepl("^--bibliography", pandoc_args)),
    options = pandoc_args,
    wd = getwd()
  )

  jsonlite::read_json(tf, simplifyVector = FALSE)
}


warn_chunk <- function(text) {
  purl <- withr::with_options(list(knitr.purl.inline = TRUE),
                              knitr::purl(text = text, quiet = TRUE))

  if (purl != "") {
    warning(
      "The metadata argument of colformat_md or as_paragraph_md should not ",
      "contain chunks or inline chunks because of potential errors on Pandoc.",
      "Consider replacing them with evaluated values."
    )
  }

  return(text)
}
