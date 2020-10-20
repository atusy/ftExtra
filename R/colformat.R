#' Format character columns as markdown text
#'
#' @param x A `flextable` object
#' @param j Columns to be treated as markdown texts.
#'   Selection can be done by the semantics of `dplyr::select()`.
#' @param footnote_ref
#'   One of "1", "a", "A", "i", "I", or "*" to as a choice for a symbol to
#'   cross-reference footnotes.
#' @param footnote_max
#'   A max number of footnotes.
#' @param footnote_inline
#'   Whether to append footnotes on the same line (default: `FALSE`).
#' @param footnote_sep
#'   A separator of footnotes when `footnote_inline = TRUE` (default: `"; "`).
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
                         footnote_ref = c("1", "a", "A", "i", "I", "*"),
                         footnote_max = 26,
                         footnote_inline = FALSE,
                         footnote_sep = "; ",
                         .from = "markdown+autolink_bare_uris"
) {
  body <- x$body$dataset
  .j <- rlang::enexpr(j)
  col <- names(tidyselect::eval_select(rlang::expr(c(!!.j)), body))

  if (length(col) == 0) {
    return(x)
  }

  footnotes <- new.env()
  footnotes$ref <- generate_ref(footnote_ref, footnote_max)
  footnotes$value <- list()
  footnotes$n <- 0L

  ft <- flextable::compose(x, i = seq(nrow(body)), j = col, part = "body",
                           value = as_paragraph_md(
                             unlist(body[col], use.names = FALSE),
                             auto_color_link = auto_color_link,
                             .from = .from, .env_footnotes = footnotes
                           ))

  if (footnotes$n == 0L) {
    return(ft)
  }

  pos <- rep(1L, footnotes$n)
  flextable::footnote(ft, i = pos, j = pos, part = "body",
                      value = structure(footnotes$value, class = "paragraph"),
                      ref_symbols = rep("", footnotes$n),
                      inline = footnote_inline,
                      sep = footnote_sep)
}

where <- function(...) {
  tidyselect::vars_select_helpers$where(...)
}

ref_generators <- list(
  `1` = function(n) as.character(seq(n)),
  a = function(n) letters[seq(n)],
  A = function(n) LETTERS[seq(n)],
  i = function(n) tolower(as.roman(seq(n))),
  I = function(n) as.roman(seq(n)),
  `*` = function(n) vapply(seq(n),
                           function(i) paste(rep("*", i), collapse = ""),
                           NA_character_)

)

generate_ref <- function(ref, n) {
  ref <- match.arg(as.character(ref), names(ref_generators))
  if ((ref %in% c("a", "A")) && (n > 26)) {
    stop('If `footnote_symbol` is "a" or "A", `footnote_max` must be <= 26')
  }
  ref_generators[[ref]](n)
}
