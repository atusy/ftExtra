#' Options for footnotes
#'
#' Configure options for footnotes.
#'
#' @param ref
#'   One of "1", "a", "A", "i", "I", or "*" to as a choice for a symbol to
#'   cross-reference footnotes.
#' @param prefix,suffix
#'   Pre- and suf-fixes for `ref` (default: `""`).
#' @param start
#'   A starting number of footnotes.
#' @param max
#'   A max number of footnotes.
#' @inheritParams flextable::footnote
#'
#' @return An environment
#'
#' @examples
#' o <- footnote_options("1", start = 1L)
#'
#' @export
footnote_options <- function(ref = c("1", "a", "A", "i", "I", "*"),
                             prefix = "",
                             suffix = "",
                             start = 1L,
                             max = 26L,
                             inline = FALSE,
                             sep = "; ") {
  env <- new.env()
  env$ref <- generate_ref(ref, max, prefix, suffix)
  env$value <- list()
  env$n <- start - 1L
  env$inline <- inline
  env$sep <- sep
  env
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

generate_ref <- function(ref, n, prefix, suffix) {
  ref <- match.arg(as.character(ref), names(ref_generators))
  if ((ref %in% c("a", "A")) && (n > 26)) {
    stop('If `footnote_symbol` is "a" or "A", `footnote_max` must be <= 26')
  }
  paste0(prefix, ref_generators[[ref]](n), suffix)
}

add_footnotes <- function(x, part, .footnote_options) {
  n <- length(.footnote_options$value)

  if (n == 0L) {
    return(x)
  }

  pos <- rep(1L, n)
  flextable::footnote(x, i = pos, j = pos, part = part,
                      value = structure(.footnote_options$value,
                                        class = "paragraph"),
                      ref_symbols = rep("", n),
                      inline = .footnote_options$inline,
                      sep = .footnote_options$sep)
}
