header <- flextable::as_paragraph('')[[1L]][-1L, ]

vertical_align <- function(sup, sub) {
  .f <- rep(FALSE, max(1, length(sup), length(sub)))
  sup <- sup %||% .f
  sub <- sub %||% .f
  dplyr::if_else(
    is.na(sub) | !sub,
    dplyr::if_else(sup, 'superscript', NA_character_),
    'subscript'
  )
}

parse_md_ <- function(x, .from = 'markdown') {
  y <- x %>% md2ast(.from = .from) %>% ast2df %>% as.list

  dplyr::bind_rows(
    header,
    data.frame(
      txt = y$txt,
      italic = y$Emph %||% NA,
      bold = y$Strong %||% NA,
      vertical.align = vertical_align(y$Superscript, y$Subscript),
      stringsAsFactors = FALSE
    )
  )
}

parse_md <- function(x, .from = 'markdown') {
  structure(lapply(x, parse_md_, .from = .from), class = 'paragraph')
}
