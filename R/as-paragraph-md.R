header <- flextable::as_paragraph("")[[1L]][-1L, ]

vertical_align <- function(sup, sub) {
  .f <- rep(FALSE, max(1, length(sup), length(sub)))
  sup <- sup %||% .f
  sub <- sub %||% .f
  dplyr::if_else(
    is.na(sub) | !sub,
    dplyr::if_else(sup, "superscript", NA_character_),
    "subscript"
  )
}

pandoc_attr <- function(x, y) {
  a <- attr(x, "pandoc_attr", exact = TRUE)
  if (is.null(a) || is.null(a[[y]])) {
    return(NA)
  }
  a[[y]]
}

pandoc_attrs <- function(x, y) {
  lapply(x, pandoc_attr, y)
}

image_size <- function(x, y = "width") {
  if (is.null(x)) {
    return(NA_real_)
  }
  as.numeric(pandoc_attrs(x, y))
}

parse_md <- function(x, .from = "markdown", auto_color_link = "blue") {
  if (!is.character(auto_color_link) || length(auto_color_link) != 1) {
    stop("`auto_color_link` must be a string")
  }

  ast <- md2ast(x, .from = .from)

  if ((ast$blocks[[1]]$t != "Para") || (length(ast$blocks) > 1)) {
    stop("Markdown text must be a single paragraph")
  }

  y <- ast %>%
    ast2df() %>%
    as.list()


  dplyr::bind_rows(
    header,
    data.frame(
      txt = y$txt,
      italic = y$Emph %||% NA,
      bold = y$Strong %||% NA,
      url = y$Link %||% NA_character_,
      width = image_size(y$Image, "width"),
      height = image_size(y$Image, "height"),
      vertical.align = vertical_align(y$Superscript, y$Subscript),
      stringsAsFactors = FALSE
    )
  ) %>%
    dplyr::mutate(
      color = dplyr::if_else(is.na(url), NA_character_, auto_color_link),
      img_data = y$Image %||% list(NULL)
    )
}

#' Convert a character vector into markdown paragraph(s)
#'
#' Parse markdown cells and returns the "paragraph" object.
#'
#' @param x A character vector.
#' @param auto_color_link A color of the link texts.
#' @param .from
#'   Pandoc's `--from` argument (default: `'markdown+autolink_bare_uris'`).
#'
#' @examples
#' library(flextable)
#' ft <- flextable(
#'   data.frame(
#'     x = c("**foo** bar", "***baz***", "*qux*"),
#'     stringsAsFactors = FALSE
#'   )
#' )
#' ft <- compose(ft, j = "x", i = 1:2, value = as_paragraph_md(x))
#' autofit(ft)
#' @export
as_paragraph_md <- function(x,
                            auto_color_link = "blue",
                            .from = "markdown+autolink_bare_uris") {
  structure(
    lapply(x, parse_md, .from = .from, auto_color_link = auto_color_link),
    class = "paragraph"
  )
}
