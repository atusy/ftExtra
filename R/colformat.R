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
colformat_md <- function(x,
                         j = where(is.character),
                         auto_color_link = "blue",
                         .from = "markdown+autolink_bare_uris",
                         footnote_key = c("1", "a", "A", "i", "I", "*"),
                         footnote_max = 26,
                         ref_symbols = NULL,
                         inline = FALSE,
                         sep = "; "
                         ) {
  body <- x$body$dataset
  .i <- seq(nrow(body))
  .j <- rlang::enexpr(j)
  col <- names(tidyselect::eval_select(rlang::expr(c(!!.j)), body))

  if (length(col) == 0) {
    return(x)
  }

  footnote_key = match.arg(as.character(footnote_key),
                           c("1", "a", "A", "i", "I", "*"))
  if ((footnote_key %in% c("a", "A")) && (footnote_max > 26)) {
    stop('If `footnote_key` is "a" or "A", `footnote_max` must be <= 26')
  }
  footnotes <- new.env()
  footnotes$value <- list()
  footnotes$progress <- 0L
  footnotes$pos <- expand.grid(i = .i, j = col, stringsAsFactors = FALSE)
  footnotes$available <- numeric()

  ft <- flextable::compose(
    x,
    i = .i,
    j = col,
    value = as_paragraph_md(
      unlist(body[col], use.names = FALSE),
      auto_color_link = auto_color_link,
      .from = .from, .env_footnotes = footnotes
    ),
    part = "body"
  )

  if (length(footnotes$value) == 0) {
    return(ft)
  }

  pos <- footnotes$pos[footnotes$available, ]
  flextable::footnote(ft, i = pos$i, j = pos$j,
                      value = structure(footnotes$value, class = "paragraph"),
                      ref_symbols = ref_symbols,
                      part = "body",
                      inline = inline,
                      sep = sep)
}

where <- function(...) {
  tidyselect::vars_select_helpers$where(...)
}
