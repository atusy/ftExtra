# Implemented but not used yet
flatten_attr <- function(a) {
  c(
    list(id = a[[1]], class = unlist(a[[2]])),
    stats::setNames(map_chr(a[[3]], 2), map_chr(a[[3]], 1))
  )
}

add_type <- function(x, t) {
  has_link = x$t %in% c('Image', 'Link')

  x$t <- c(
    structure(list(if (has_link) x$c[[3]][[1]] else TRUE), .Names = x$t),
    if (is.list(t)) t else structure(list(TRUE), .Names = t)
  )

  if (has_link) {
    x$c <- x$c[[2]]
  }

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
  c(txt = if ('Space' %in% names(x$t)) ' ' else x$c, x$t)
}

ast2df <- function(x) {
  x$blocks %>%
    flatten_ast() %>%
    lapply(branch2list) %>%
    dplyr::bind_rows() %>%
    dplyr::mutate_if(is.logical, dplyr::coalesce, FALSE)
}
