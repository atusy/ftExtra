fill_header <- function(x, fill = TRUE) {
  if (!fill) return(x)
  x  %>%
    tidyr::pivot_longer(
      tidyselect::starts_with('level'),
      names_to = 'var',
      names_prefix = 'level',
      names_ptypes = integer(),
      values_to = 'val'
    ) %>%
    tidyr::fill('val') %>%
    tidyr::pivot_wider(
      'original', names_from = 'var', values_from = 'val', names_prefix = 'level'
    )
}

merge_header <- function(x, merge = TRUE) {
  if (!merge) return(x)
  x %>%
    flextable::merge_h(part = 'header') %>%
    flextable::merge_v(part = 'header')
}

transform_header <- function(
  x, sep = '[_\\.]', theme_fun = flextable::theme_booktabs,
  .fill = FALSE, .merge = FALSE, ...
) {
  header <- names(x$header$dataset)

  mapping <- data.frame(original = header, stringsAsFactors = FALSE) %>%
    tidyr::separate(
      'original',
      paste0('level', seq(max(stringr::str_count(header, sep) + 1))),
      sep = sep, fill = 'right', remove = FALSE
    ) %>%
    fill_header(.fill)

  x %>%
    flextable::set_header_df(mapping, key = 'original') %>%
    merge_header(.merge) %>%
    theme_fun(...) %>%
    flextable::fix_border_issues()
}

#' Separate the header based on delimiters
#'
#' @param x A `flextable` object`
#' @inheritParams tidyr::separate
#' @inheritParams flextable::flextable
#' @param ... Passed to `theme_fun`
#'
#' @examples
#' iris %>% as_flextable %>% separate_header
#'
#' @export
separate_header <- function(
  x, sep = '[_\\.]', theme_fun = flextable::theme_booktabs, ...
) {
  transform_header(
    x, sep = sep, theme_fun = theme_fun, .fill = FALSE, .merge = FALSE, ...
  )
}
#' Span the header based on delimiters
#'
#' @inherit separate_header
#' @inheritParams tidyr::separate
#' @inheritParams flextable::flextable
#'
#' @examples
#' iris %>% as_flextable %>% span_header
#'
#' @export
span_header <- function(
  x, sep = '[_\\.]', theme_fun = flextable::theme_booktabs, ...
) {
  transform_header(
    x, sep = sep, theme_fun = theme_fun,
    .fill = TRUE, .merge = TRUE,
    ...
  )
}
