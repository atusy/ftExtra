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

pandoc_attr <- function(x, y) {
  a = attr(x, 'pandoc_attr', exact = TRUE)
  if (is.null(a)) return(NULL)
  a[[y]]
}

parse_md <- function(x, .from = 'markdown', auto_color_link = 'blue') {
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
      width = as.numeric(pandoc_attr(y$Image, 'width') %||% NA_real_),
      height = as.numeric(pandoc_attr(y$Image, 'height') %||% NA_real_),
      vertical.align = vertical_align(y$Superscript, y$Subscript),
      stringsAsFactors = FALSE
    )
  ) %>%
    dplyr::mutate(
      color = dplyr::if_else(is.na(url), NA_character_, auto_color_link),
      img_data = y$Image %||% list(list())
    )
}

#' Convert a character vector into markdown paragraph(s)
#'
#' Parse markdown cells and returns the "paragraph" object.
#'
#' @param x A character vector.
#' @inheritParams colformat_md
#'
#' @examples
#' library(flextable)
#' ft <- flextable(
#'   data.frame(
#'     x = c('**foo** bar', '***baz***', '*qux*'),
#'     stringsAsFactors = FALSE
#'   )
#' )
#' ft <- compose(ft, j = "x", i = 1:2, value = as_paragraph_md(x))
#' autofit(ft)
#'
#' @export
as_paragraph_md <- function(x, auto_color_link = 'blue', .from = 'markdown') {
  structure(
    lapply(x, parse_md, .from = .from, auto_color_link = auto_color_link),
    class = 'paragraph'
  )
}
