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
                     auto_color_link = "blue",
                     pandoc_args = NULL,
                     .from = "markdown",
                     .footnote_options = NULL) {
  if (!is.character(auto_color_link) || length(auto_color_link) != 1L) {
    stop("`auto_color_link` must be a string")
  }

  filters <- if (rmarkdown::pandoc_available("2")) {
    c(
      "--lua-filter",
      system.file("lua/smart.lua", package = "ftExtra"),
      "--lua-filter",
      system.file("lua/inline-code.lua", package = "ftExtra"),
      if (rmarkdown::pandoc_available("2.7.3")) {
        c(
          "--lua-filter",
          system.file("lua/math.lua", package = "ftExtra"),
          paste0("--metadata=pandoc-path:", rmarkdown::pandoc_exec()),
          if (!rmarkdown::pandoc_available("2.10")) {
            paste0("--metadata=temporary-directory:", tempdir())
          }
        )
      }
    )
  }

  md_df <- md2df(x, pandoc_args = c(filters, pandoc_args), .from = .from)

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
#' @param md_extensions
#'   Pandoc's extensions. Although it is prefixed with "md", extensions for any
#'   formats specified to `.from` can be used. See
#'   <https://www.pandoc.org/MANUAL.html#extensions> for details.
#' @param .from
#'   Pandoc's `--from` argument (default: `'markdown+autolink_bare_uris'`).
#' @param ...
#'   Arguments passed to internal functions.
#' @inheritParams rmarkdown::html_document
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
                            md_extensions = NULL,
                            pandoc_args = NULL,
                            .from = "markdown+autolink_bare_uris",
                            ...) {
  structure(lapply(x, parse_md,
                   auto_color_link = auto_color_link,
                   pandoc_args = pandoc_args,
                   .from = paste0(.from, paste(md_extensions, collapse="")),
                   ...),
            class = "paragraph")
}
