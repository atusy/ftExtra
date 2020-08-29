#' Format character columns as markdown text
#'
#' @param x A `flextable` object
#' @param j Columns to be treated as markdown texts.
#'   Selection can be done by the semantics of `dplyr::select()`.
#' @inheritParams as_paragraph_md
#'
#' @examples
#' if (rmarkdown::pandoc_available()) {
#'   d <- data.frame(
#'     x = c("**bold**", "*italic*"),
#'     y = c("^superscript^", "~subscript~"),
#'     z = c("***^ft^~Extra~** is*", "*Cool*")
#'   )
#'   colformat_md(flextable::flextable(d))
#' }
#' @export
colformat_md <- function(
                         x, j = where(is.character),
                         auto_color_link = "blue", .from = "markdown+autolink_bare_uris") {
  body <- x$body$dataset
  .j <- rlang::enexpr(j)
  col <- names(tidyselect::eval_select(rlang::expr(c(!!.j)), body))

  if (length(col) == 0) {
    return(x)
  }

  flextable::compose(
    x,
    i = seq(nrow(body)),
    j = col,
    value = as_paragraph_md(
      unlist(body[col], use.names = FALSE),
      auto_color_link = auto_color_link,
      .from = .from
    ),
    part = "body"
  )
}

where <- function(...) {
  tidyselect::vars_select_helpers$where(...)
}
