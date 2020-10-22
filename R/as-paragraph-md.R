header <- flextable::as_paragraph("")[[1L]][-1L, ]

vertical_align <- function(sup, sub) {
  .f <- rep(FALSE, max(1L, length(sup), length(sub)))
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
                     .footnote_options = NULL) {
  if (!is.character(auto_color_link) || length(auto_color_link) != 1L) {
    stop("`auto_color_link` must be a string")
  }

  md_df <- md2df(x, .from = .from)

  if (is.null(.footnote_options) || (all(names(md_df) != "Note"))) {
    y <- md_df
  } else {
    .footnote_options$n <- .footnote_options$n + 1L
    ref <- data.frame(txt = .footnote_options$ref[[.footnote_options$n]],
                      Superscript = TRUE,
                      stringsAsFactors = FALSE)
    .footnote_options$value <- c(
      .footnote_options$value,
      list(construct_chunk(as.list(dplyr::bind_rows(ref, md_df[md_df$Note, ])),
                           auto_color_link))
    )
    y <- dplyr::bind_rows(md_df[!md_df$Note, ], ref)
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
      underlined = x$underlined %||% NA,
      color = x$color %||% NA_character_,
      shading.color = x$shading.color %||% NA_character_,
      font.family = x$font.family %||% NA_character_,
      stringsAsFactors = FALSE
    )
  ) %>%
    dplyr::mutate(
      color = dplyr::if_else(
        is.na(.data$color) & !is.na(.data$url),
        auto_color_link,
        .data$color
      ),
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
#' @param .footnote_options Spec options for footnotes via `colformat_md`.
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
                            .footnote_options = NULL) {
  structure(lapply(x, parse_md,
                   .from = .from,
                   auto_color_link = auto_color_link,
                   .footnote_options = .footnote_options),
            class = "paragraph")
}
