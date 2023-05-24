#' Options for footnotes
#'
#' Configure options for footnotes.
#'
#' @param ref
#'   A string or a function that defines symbols of footnote references.
#'   If the value is string, it must be one of the "1", "a", "A", "i", "I", or
#'   "*". If a function, keep in mind this is an experimental feature. It
#'   receives 3 parameters (`n`, `part`, and `footer`) and returns character
#'   vectors which will further be processed as markdown. See examples for the
#'   details.
#' @param prefix,suffix
#'   Pre- and suf-fixes for `ref` (default: `""`). These parameters are used
#'   if and only if ref is a character.
#' @param start
#'   A starting number of footnotes.
#' @param max
#'   A max number of footnotes used only when `ref` is "a" or "A".
#' @inheritParams flextable::footnote
#'
#' @return An environment
#'
#' @examples
#' # A examole flextable with unprocessed markdown footnotes
#' ft <- as_flextable(tibble::tibble(
#'   "header1^[note a]" = c("x^[note 1]", "y"),
#'   "header2" = c("a", "b^[note 2]")
#' ))
#'
#' # Render all footnotes in the same format.
#' if (rmarkdown::pandoc_available()) {
#'   ft %>%
#'     colformat_md(
#'       part = "all",
#'       .footnote_options = footnote_options("1", start = 1L)
#'     )
#' }
#'
#' # Use a user-defined function to format footnote symbols
#' if (rmarkdown::pandoc_available()) {
#'   # a function to format symbols of footnote references
#'   ref <- function(n, part, footer) {
#'     # Change symbols by context
#'     # - header: letters (a, b, c, ...)
#'     # - body: integers (1, 2, 3, ...)
#'     s <- if (part == "header") {
#'       letters[n]
#'     } else {
#'       as.character(n)
#'     }
#'
#'     # Suffix symbols with ": " (a colon and a space) in the footer
#'     if (footer) {
#'       return(paste0(s, ":\\ "))
#'     }
#'
#'     # Use superscript in the header and the body
#'     return(paste0("^", s, "^"))
#'   }
#'
#'   # apply custom format of symbols
#'   ft %>%
#'     # process header first
#'     colformat_md(
#'       part = "header", .footnote_options = footnote_options(ref = ref)
#'     ) %>%
#'     # process body next
#'     colformat_md(
#'       part = "body", .footnote_options = footnote_options(ref = ref)
#'     ) %>%
#'     # tweak width for visibility
#'     flextable::autofit(add_w = 0.2)
#' }
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
  env$part <- "body"
  env$caller <- NA_character_
  env
}

symbol_generators <- list(
  `1` = function(n) as.character(seq(n)),
  a = function(n) letters[seq(n)],
  A = function(n) LETTERS[seq(n)],
  i = function(n) tolower(as.roman(seq(n))),
  I = function(n) as.roman(seq(n)),
  `*` = function(n) {
    vapply(
      seq(n),
      function(i) paste(rep("*", i), collapse = ""),
      NA_character_
    )
  }
)

#' @noRd
#' @return fun(n: integer, header: "body" | "header", footer: boolean): tibble[]
generate_ref <- function(ref, n, prefix, suffix) {
  if (is.function(ref)) {
    #' @noRd
    #' @param n n-th ref symbol (integer)
    #' @param part "body" (default) or "header"
    #' @param footer `TRUE` or `FALSE`
    #' @param ... Other arguments passed to md2df
    f <- function(n, part, footer, ...) lapply(ref(n, part, footer), md2df, ...)
    return(f)
  }
  ref <- match.arg(as.character(ref), names(symbol_generators))
  if ((ref %in% c("a", "A")) && (n > 26)) {
    stop('If `footnote_symbol` is "a" or "A", `footnote_max` must be <= 26')
  }
  res <- lapply(
    paste0(prefix, symbol_generators[[ref]](n), suffix),
    function(x) tibble::tibble(txt = x, Str = TRUE, Superscript = TRUE)
  )
  function(n, ...) res[n]
}

collapse_footnotes <- function(value, sep) {
  value %>%
    lapply(dplyr::add_row, data.frame(txt = sep %||% "")) %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(seq_index = dplyr::row_number()) %>%
    list()
}

add_footnotes <- function(x, .footnote_options) {
  n <- length(.footnote_options$value)

  if (n == 0L) {
    return(x)
  }

  footer_lines <- if (.footnote_options$inline) {
    collapse_footnotes(.footnote_options$value, .footnote_options$sep)
  } else {
    .footnote_options$value
  }
  class(footer_lines) <- "paragraph"

  flextable::add_footer_lines(x, values = footer_lines)
}

solve_footnote <- function(
    md_df, .footnote_options, auto_color_link,
    pandoc_args, metadata, .from) {
  is_note <- md_df[["Note"]]
  if (is.null(.footnote_options) || !any(is_note)) {
    return(md_df)
  }

  local_id <- vctrs::vec_unrep(is_note) %>%
    dplyr::mutate(id = cumsum(.data[["key"]]) * .data[["key"]]) %>%
    purrr::pmap(function(id, times, ...) rep(id, times)) %>%
    unlist(use.names = FALSE, recursive = FALSE)
  global_id <- .footnote_options$n + local_id
  note_id <- global_id[is_note]

  ref <- function(n, footer) {
    .footnote_options$ref(
      n, .footnote_options$part, footer,
      pandoc_args = pandoc_args, metadata = metadata, .from = .from
    )
  }

  .footnote_options$value <- c(
    .footnote_options$value,
    md_df[is_note, ] %>%
      split(note_id) %>%
      purrr::imap(function(group, i) {
        construct_chunk(
          as.list(dplyr::bind_rows(ref(as.integer(i), TRUE), group)),
          auto_color_link = auto_color_link
        )
      })
  )
  .footnote_options$n <- .footnote_options$n + max(local_id)

  rows <- purrr::pmap(md_df, list)
  rows[is_note] <- ref(note_id, FALSE)

  dplyr::bind_rows(rows[!is_note | !duplicated(local_id)])
}
