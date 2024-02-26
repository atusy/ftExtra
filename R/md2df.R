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
  child <- stats::setNames(
    list(structure(
      if (isTRUE(x$t %in% c("Image", "Link"))) x$c[[3]][[1]] else TRUE,
      pandoc_attr = if ("Cite" %in% x$t || !has_attr(x$c)) {
        NULL
      } else {
        flatten_attr(x$c[[1]])
      }
    )),
    x$t
  )

  x$t <- c(child, if (is.list(t)) t else stats::setNames(list(TRUE), t))

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
  if (identical(x$t, "Div")) {
    return(resolve_type(add_type(x, list())))
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
  n <- purrr::pluck_depth(x) / 2 - 1.5 # == (pluck_depth(x) - 1) / 2 - 1
  purrr::compose(!!!rep(list(flatten_branch), n))(x)
}

#' Convert a branch of Pandoc's AST to list
#' @noRd
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

#' Drop Para from AST to avoid `.name_repair`
#'
#' @param x A named list
#'
#' @examples
#' x <- lapply(flatten_ast(md2ast("foo^[bar]")$blocks), branch2list)
#' dplyr::bind_rows(x)
#' dplyr::bind_rows(lapply(x, drop_Para))
#'
#' @noRd
drop_para <- function(x) {
  x[names(x) != "Para"]
}

format_by_attr <- function(x) {
  a <- x %>%
    lapply(attr, "pandoc_attr") %>%
    drop_null() %>%
    lapply(drop_null) %>%
    dplyr::bind_rows() %>%
    lapply(drop_na)

  if (length(a) == 0L) {
    return(x)
  }

  x$Underline <- any(x$Underline, a$class == "underline")
  x$color <- last(a$color) %||% NA_character_
  x$shading.color <- last(a$shading.color) %||% NA_character_
  x$font.family <- last(a$font.family) %||% NA_character_

  x
}

#' Convert Pandoc's AST to data frame
#'
#' @param x A value returned by `md2ast`
#'
#' @noRd
ast2df <- function(x) {
  x$blocks %>%
    flatten_ast() %>%
    lapply(branch2list) %>%
    # Div is not for users, but for processing multiple cells at once
    lapply(purrr::map_at, c("Div", "Image"), list) %>%
    lapply(format_by_attr) %>%
    lapply(drop_para) %>%
    dplyr::bind_rows() %>%
    tibble::as_tibble() %>%
    dplyr::mutate_if(is.logical, dplyr::coalesce, FALSE)
}

#' Convert Pandoc's Markdown to data frame
#' @noRd
md2df <- function(x,
                  pandoc_args = NULL,
                  metadata = rmarkdown::metadata,
                  .from = "markdown") {
  ast <- md2ast(
    x,
    pandoc_args = pandoc_args, metadata = metadata, .from = .from
  )

  ast$blocks <- ast$blocks[
    !vapply(
      ast$blocks,
      function(x) identical(c(x$t, x$c[[1L]][[1L]]), c("Div", "refs")),
      NA
    )
  ]

  ast2df(ast)
}
