#' @importFrom flextable as_flextable
#' @export
flextable::as_flextable


#' @name as_flextable_methods
#' @inherit flextable::as_flextable
#' @param groups_to
#'   One of `titles`, `merged`, or `asis`. See examples for the result.
#' @param groups_pos
#'   When `groups_to = "merged"`, grouping columns are reordered according to
#'   `group_pos`. Choices are `left` (default) or `asis`.
#'
#' @examples
#'
#' # For grouped_df
#' grouped_df <- iris %>%
#'   dplyr::group_by(Species) %>%
#'   dplyr::slice(1, 2)
#'
#' as_flextable(grouped_df, groups_to = "titles")
#' as_flextable(grouped_df, groups_to = "titles", hide_grouplabel = TRUE)
#' as_flextable(grouped_df, groups_to = "merged")
#' as_flextable(grouped_df, groups_to = "asis")
#' @export
as_flextable.grouped_df <- function(
                                    x,
                                    groups_to = c("titles", "merged", "asis"),
                                    groups_pos = c("left", "asis"),
                                    ...) {
  groups_to <- match.arg(groups_to)
  groups_pos <- match.arg(groups_pos)

  if (groups_to == "asis") {
    return(as_flextable.data.frame(dplyr::ungroup(x), ...))
  }

  g <- group_of(x)

  if (groups_to == "titles") {
    return(
      x %>%
        dplyr::ungroup() %>%
        flextable::as_grouped_data(g) %>%
        as_flextable(...)
    )
  }

  if (groups_to == "merged") {
    return(
      x %>%
        dplyr::ungroup() %>%
        dplyr::select(if (groups_pos == "left") g, tidyselect::everything()) %>%
        as_flextable.data.frame(...) %>%
        flextable::merge_v(g[1L], g) %>%
        flextable::theme_vanilla() %>%
        flextable::fix_border_issues()
    )
  }
}

#' @rdname as_flextable_methods
#'
#' @inheritParams flextable::flextable
#'
#' @examples
#' # For data.frame
#' iris %>%
#'   head() %>%
#'   as_flextable()
#' @export
as_flextable.data.frame <- function(x, col_keys = names(x), ...) {
  if (is.function(col_keys)) col_keys <- col_keys(x)
  flextable::flextable(x, col_keys = col_keys, ...)
}
