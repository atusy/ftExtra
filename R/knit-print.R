#' knit_print for extended flextable object
#'
#' Adds a YAML meta data block to cite materials found by `colformat_md()` in
#' the `flextable` object.
#'
#' @inheritParams knitr::knit_print
#' @param label
#'  A key to be set in the YAML meta data block to cite materials.
#'  This must be unique in the document.
#'  Default value is the chunk label prepended by "ftExtra-cite-".
#'
#' @return The `knit_asis` class object.
#' @noRd
knit_print.ftExtra <- function(x,
                               options,
                               ...,
                               key = paste0("ftExtra-cite-", options$label)) {
  ft <- NextMethod("knit_print", x, options, ...)

  cite <- attr(x, "citations", exact = TRUE)

  if (cite == "") {
    return(ft)
  }

  res <- sprintf('---\n%s: "%s"\n---\n\n%s', key, cite, ft)
  attributes(res) <- attributes(ft)
  res
}
