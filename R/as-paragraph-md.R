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

lua <- function(...) {
  c("--lua-filter", system.file("lua", ..., package = "ftExtra"))
}

lua_filters <- function(.sep) {
  if (!rmarkdown::pandoc_available("2")) return(NULL)

  c(
    lua("smart.lua"),
    lua("inline-code.lua"),
    if (rmarkdown::pandoc_available("2.7.3")) {
      c(
        lua("math.lua"),
        paste0("--metadata=pandoc-path:", rmarkdown::pandoc_exec()),
        if (!rmarkdown::pandoc_available("2.10")) {
          paste0("--metadata=temporary-directory:", tempdir())
        }
      )
    },
    if (rmarkdown::pandoc_available("2.2.3")) {
      c(lua("blocks-to-inlines.lua"), paste0("--metadata=sep_blocks:", .sep))
    }
  )
}



parse_md <- function(x,
                     auto_color_link = "blue",
                     pandoc_args = NULL,
                     .from = "markdown",
                     .footnote_options = NULL,
                     .sep = "\n\n") {
  if (!is.character(auto_color_link) || length(auto_color_link) != 1L) {
    stop("`auto_color_link` must be a string")
  }

  md_df <- md2df(
    x,
    pandoc_args = c(lua_filters(.sep = .sep), pandoc_args),
    .from = .from,
    .check = TRUE
  )

  id <- pandoc_attrs(md_df$Div, "id")
  cells <- unname(split(dplyr::select(md_df, !"Div"), factor(id, levels = unique(id))))

  lapply(cells, function(cell) {
    y <- solve_footnote(cell, .footnote_options, auto_color_link)
    construct_chunk(as.list(y), auto_color_link)
  })
}

solve_footnote <- function(md_df, .footnote_options, auto_color_link) {
  if (is.null(.footnote_options) || !any(md_df[["Note"]])) {
    return(md_df)
  }

  .footnote_options$n <- .footnote_options$n + 1L
  ref <- data.frame(txt = .footnote_options$ref[[.footnote_options$n]],
                    Superscript = TRUE,
                    stringsAsFactors = FALSE)
  .footnote_options$value <- c(
    .footnote_options$value,
    list(construct_chunk(as.list(dplyr::bind_rows(ref, md_df[md_df$Note, ])),
                         auto_color_link))
  )
  dplyr::bind_rows(md_df[!md_df$Note, ], ref)
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
  x <- paste(
    purrr::map2_chr(
      x,
      paste0('cell', seq_along(x)),
      function(x, id) sprintf('<div id="%s">%s</div>', id, x)
    ),
    collapse = ''
  )

  structure(parse_md(x,
                   auto_color_link = auto_color_link,
                   pandoc_args = pandoc_args,
                   .from = paste0(.from, paste(md_extensions, collapse="")),
                   ...),
            class = "paragraph")
}
