`%||%` <- function(e1, e2) {
  if (is.null(e1)) {
    return(e2)
  }
  e1
}

drop_null <- function(x) {
  x[!vapply(x, is.null, NA)]
}

drop_na <- function(x) {
  x[!is.na(x)]
}

last <- function(x) {
  x[[length(x)]]
}
