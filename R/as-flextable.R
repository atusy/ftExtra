#' @importFrom flextable as_flextable
#' @export
flextable::as_flextable

#' @export
as_flextable.grouped_df <- function(x, ...) {
  x %>%
    dplyr::ungroup()%>%
    flextable::as_grouped_data(
      setdiff(names(attr(x, 'groups', exact = TRUE)), '.rows')
    ) %>%
    flextable::as_flextable(...)
}

#' @export
as_flextable.data.frame <- function(x, ...) {
  flextable::flextable(x, ...)
}
