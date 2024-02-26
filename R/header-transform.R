fill_header <- function(x, fill = TRUE) {
  if (!fill) {
    return(x)
  }
  x %>%
    tidyr::pivot_longer(
      tidyselect::starts_with("level"),
      names_to = "var",
      names_prefix = "level",
      values_to = "val"
    ) %>%
    tidyr::fill("val") %>%
    tidyr::pivot_wider(
      id_cols = "original",
      names_from = "var", values_from = "val", names_prefix = "level"
    )
}

merge_header <- function(x, merge = TRUE) {
  if (!merge) {
    return(x)
  }
  x %>%
    flextable::merge_h(part = "header") %>%
    flextable::merge_v(part = "header")
}

transform_header <- function(
    x,
    sep = "[_\\.]",
    theme_fun = NULL,
    .fill = FALSE,
    .merge = FALSE,
    ...) {
  header <- names(x$header$dataset)

  mapping <- data.frame(original = header, stringsAsFactors = FALSE) %>%
    tidyr::separate(
      "original",
      paste0("level", seq(max(stringr::str_count(header, sep) + 1))),
      sep = sep, fill = "right", remove = FALSE
    ) %>%
    fill_header(.fill)

  if (is.null(theme_fun)) {
    default_theme <- flextable::get_flextable_defaults()$theme_fun
    theme_fun <- if (is.function(default_theme)) {
      default_theme
    } else {
      getNamespace("flextable")[[default_theme]]
    }
  }

  x %>%
    flextable::set_header_df(mapping, key = "original") %>%
    merge_header(.merge) %>%
    theme_fun(...) %>%
    flextable::fix_border_issues()
}

#' Split the header based on delimiters
#'
#' @note
#' `split_header` is a rename of `separate_header` and the latter will be removed in the future release.
#'
#' @param x A `flextable` object`
#' @inheritParams tidyr::separate
#' @inheritParams flextable::flextable
#' @param
#'   theme_fun A flextable theme function.
#'   When `NULL` (default), the value is resolved by
#'   `flextable::get_flextable_defaults()`.
#' @param ... Passed to `theme_fun`
#'
#' @examples
#' iris %>%
#'   flextable() %>%
#'   separate_header()
#' @export
split_header <- function(
    x,
    sep = "[_.]",
    theme_fun = NULL,
    ...) {
  transform_header(
    x,
    sep = sep, theme_fun = theme_fun, .fill = FALSE, .merge = FALSE, ...
  )
}

#' @rdname split_header
#' @export
separate_header <- function(
    x,
    sep = "[_.]",
    theme_fun = NULL,
    ...) {
  .Deprecated(
    "split_header",
    msg = paste(
      "ftExtra::separate_header will be removed in the future release",
      "to avoid masking `flextable::separate_header`.",
      "Instead, use ftExtra::split_header which is a copy of",
      "ftExtra::separate_header."
    )
  )
  split_header(x, sep, theme_fun, ...)
}

#' Span the header based on delimiters
#'
#' @inherit separate_header
#' @inheritParams tidyr::separate
#' @inheritParams flextable::flextable
#'
#' @examples
#' iris %>%
#'   flextable() %>%
#'   span_header()
#' @export
span_header <- function(
    x,
    sep = "[_.]",
    theme_fun = NULL,
    ...) {
  transform_header(
    x,
    sep = sep, theme_fun = theme_fun,
    .fill = TRUE, .merge = TRUE,
    ...
  )
}
