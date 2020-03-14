#' Returns names of grouping columns
#' @param x A data frame.
#' @noRd
group_of <- function(x) {
  setdiff(names(attr(x, 'groups', exact = TRUE)), '.rows')
}

`%||%` <- function(e1, e2) {
  if (is.null(e1)) return(e2)
  e1
}
