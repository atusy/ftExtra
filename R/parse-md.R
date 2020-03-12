header <- flextable::as_paragraph('')[[1L]][-1L, ]

`%||%` <- function(e1, e2) {
  if (is.null(e1)) return(e2)
  e1
}

vertical_align <- function(sup, sub) {
  .f <- rep(FALSE, max(1, length(sup), length(sub)))
  sup <- sup %||% .f
  sub <- sub %||% .f
  dplyr::if_else(
    sub, 'subscript', dplyr::if_else(sup, 'superscript', NA_character_)
  )
}

parse_md_ <- function(x) {
  y <- x %>% md2ast %>% ast2df %>% as.list

  dplyr::bind_rows(
    header,
    data.frame(
      txt = y$txt,
      italic = y$Emph %||% NA,
      bold = y$Strong %||% NA,
      vertical.align = vertical_align(y$Superscript, y$Subscript)
    )
  )
}

parse_md <- function(x) structure(lapply(x, parse_md_), class = 'paragraph')
