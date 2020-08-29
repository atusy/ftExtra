#' Flattens attribute
#'
#' Implemented but not used yet
#'
#' @param a A set of attributes. Typically `x$c[[1]]`
#'
#' @noRd
flatten_attr <- function(a) {
  c(
    list(id = a[[1]], class = unlist(a[[2]])),
    stats::setNames(purrr::map_chr(a[[3]], 2), purrr::map_chr(a[[3]], 1))
  )
}

is_branch <- function(x) {
  nm <- names(x)
  identical(nm, c("t", "c")) || identical(nm, "t")
}

has_attr <- function(x) {
  !(is.atomic(x) || is_branch(x) || all(vapply(x, is_branch, NA)))
}

add_type <- function(x, t) {
  parents <- if (is.list(t)) t else stats::setNames(list(TRUE), t)
  child <- stats::setNames(
    list(structure(
      if (isTRUE(x$t %in% c("Image", "Link"))) x$c[[3]][[1]] else TRUE,
      pandoc_attr = if (has_attr(x$c)) {
        flatten_attr(x$c[[1]])
      } else {
        NULL
      }
    )),
    x$t
  )

  x$t <- c(child, parents)

  if (has_attr(x$c)) x$c <- x$c[[2]]

  x
}

resolve_type <- function(x) {
  if (is.atomic(x$c)) {
    return(x)
  }
  if (identical(x$c, list())) {
    x$c <- ""
    return(x)
  }
  if (identical(names(x$c), c("t", "c"))) {
    return(add_type(x$c, x$t))
  }
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
  tags <- names(x$t)
  c(
    txt = if ("Space" %in% tags) {
      " "
    } else if ("LineBreak" %in% tags) {
      "\n"
    } else if ("SoftBreak" %in% tags) {
      " "
    } else {
      x$c
    },
    x$t
  )
}

ast2df <- function(x) {
  x$blocks %>%
    flatten_ast() %>%
    lapply(branch2list) %>%
    lapply(purrr::map_at, "Image", list) %>%
    dplyr::bind_rows() %>%
    tibble::as_tibble() %>%
    dplyr::mutate_if(is.logical, dplyr::coalesce, FALSE)
}
