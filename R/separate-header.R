#' Span flextable's header
#'
#' @param x A `flextable` object`
#' @inheritParams tidyr::separate
#' @inheritParams flextable::flextable
#' @param ... Passed to `theme_fun`
#'
#' @export
separate_header <- function(
  x, sep = '[_\\.]', fill = FALSE, theme_fun = flextable::theme_booktabs, ...
) {
  header <- names(x$header$dataset)

  mapping <- data.frame(original = header, stringsAsFactors = FALSE) %>%
    tidyr::separate(
      'original',
      paste0('level', seq(max(stringr::str_count(header, sep) + 1))),
      sep = sep, fill = 'right', remove = FALSE
    )


  x %>%
    flextable::set_header_df(
      if (fill) fill_span(mapping) else mapping, key = 'original'
    ) %>%
    flextable::merge_h(part = 'header') %>%
    flextable::merge_v(part = 'header') %>%
    theme_fun(...) %>%
    flextable::fix_border_issues()
}

fill_span <- function(x) {
  x %>%
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
