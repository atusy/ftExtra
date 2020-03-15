insert_blanks <- function(after = NULL, before = NULL, data) {
  .after <- tidyselect::eval_select(after, data) + 0.1
  .before <- tidyselect::eval_select(before, data) - 0.1

  c(
    names(data),
    sprintf('..after%s', seq_along(.after)),
    sprintf('..before%s', seq_along(.before))
  )[order(c(seq(length(data)), .after, .before))]
}

#' Specify blank columns easily via `col_keys`
#'
#' @param after,before
#'   Blank columns are added after/before the selected columns.
#'   Selections can be done by the semantics of `dplyr::select`.
#'
#' @examples
#' iris %>%
#'   as_flextable(col_keys = with_blanks(dplyr::ends_with('Width')))
#'
#' @export
with_blanks <- function(after = NULL, before = NULL) {
  after = rlang::enquo(after)
  before = rlang::enquo(before)
  function(data) insert_blanks(after = after, before = before, data = data)
}
