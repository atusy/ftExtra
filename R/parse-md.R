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

parse_md_ <- function(x, .from = 'markdown', auto_color_link = 'blue') {
  if (!is.character(auto_color_link) || length(auto_color_link) != 1) {
    stop('`auto_color_link` must be a string')
  }

  y <- x %>% md2ast(.from = .from) %>% ast2df %>% as.list

  dplyr::bind_rows(
    header,
    data.frame(
      txt = y$txt,
      italic = y$Emph %||% NA,
      bold = y$Strong %||% NA,
      url = y$Link %||% NA_character_,
      vertical.align = vertical_align(y$Superscript, y$Subscript),
      stringsAsFactors = FALSE
    )
  ) %>%
    dplyr::mutate(
      color = dplyr::if_else(is.na(url), NA_character_, auto_color_link)
    )
}

parse_md <- function(x, .from = 'markdown', auto_color_link = 'blue') {
  structure(
    lapply(x, parse_md_, .from = .from, auto_color_link = auto_color_link),
    class = 'paragraph'
  )
}
