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

parse_md <- function(x,
                     .from = "markdown",
                     auto_color_link = "blue",
                     .env_footnotes = NULL) {
  if (!is.character(auto_color_link) || length(auto_color_link) != 1) {
    stop("`auto_color_link` must be a string")
  }

  ast <- md2ast(x, .from = .from)

  if ((ast$blocks[[1]]$t != "Para") || (length(ast$blocks) > 1)) {
    stop("Markdown text must be a single paragraph")
  }

  ast_df <- ast2df(ast)

  if (is.null(.env_footnotes)) {
    y <- ast_df
  } else if (all(names(ast_df) != "Note")) {
    .env_footnotes$progress <- .env_footnotes$progress + 1L
    y <- ast_df
  } else {
    .env_footnotes$progress <- .env_footnotes$progress + 1L
    .env_footnotes$value <- c(
      .env_footnotes$value,
      list(construct_chunk(as.list(ast_df[ast_df$Note, ], auto_color_link))))
    .env_footnotes$available <- c(.env_footnotes$available,
                                  .env_footnotes$progress)
    y <- ast_df[!ast_df$Note, ]
  }

  construct_chunk(as.list(y), auto_color_link)
}

construct_chunk <- function(x, auto_color_link = "blue") {
  dplyr::bind_rows(
    header,
    data.frame(
      txt = x$txt,
      italic = x$Emph %||% NA,
      bold = x$Strong %||% NA,
      url = x$Link %||% NA_character_,
      width = image_size(x$Image, "width"),
      height = image_size(x$Image, "height"),
      vertical.align = vertical_align(x$Superscript, x$Subscript),
      stringsAsFactors = FALSE
    )
  ) %>%
    dplyr::mutate(
      color = dplyr::if_else(is.na(url), NA_character_, auto_color_link),
      img_data = x$Image %||% list(NULL),
      seq_index = dplyr::row_number()
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
#' if (rmarkdown::pandoc_available()) {
#'   library(flextable)
#'   ft <- flextable(
#'     data.frame(
#'       x = c("**foo** bar", "***baz***", "*qux*"),
#'       stringsAsFactors = FALSE
#'     )
#'   )
#'   ft <- compose(ft, j = "x", i = 1:2, value = as_paragraph_md(x))
#'   autofit(ft)
#' }
#' @export
as_paragraph_md <- function(x,
                            auto_color_link = "blue",
                            .from = "markdown+autolink_bare_uris",
                            .env_footnotes = NULL) {
  structure(
    lapply(x, parse_md,
           .from = .from,
           auto_color_link = auto_color_link,
           .env_footnotes = .env_footnotes),
    class = "paragraph"
  )
}
