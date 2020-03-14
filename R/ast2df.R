add_type <- function(x, t) {
  x$t <- c(x$t, t)
  x
}

resolve_type <- function(x) {
  if (is.atomic(x$c)) return(x)
  if (identical(names(x$c), c('t', 'c'))) return(add_type(x$c, x$t))
  return(lapply(x$c, add_type, x$t))
}

flatten_branch <- function(x) {
  x %>%
    lapply(resolve_type) %>%
    purrr::map_if(function(x) is.character(names(x)), list) %>%
    unlist(recursive = FALSE)
}

flatten_ast <- function(x) {
  n <- purrr::vec_depth(x) / 2 - 1.5 # (vec_depth(x) - 1) / 2 - 1
  purrr::compose(!!!rep(list(flatten_branch), n))(x)
}

branch2list <- function(x) {
  c(
    txt = if ('Space' %in% x$t) ' ' else x$c,
    as.list(stats::setNames(rep(TRUE, length(x$t)), x$t))
  )
}

ast2df <- function(x) {
  x$blocks %>%
    flatten_ast() %>%
    lapply(branch2list) %>%
    dplyr::bind_rows() %>%
    dplyr::mutate_if(is.logical, dplyr::coalesce, FALSE)
}
