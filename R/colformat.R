#' Format character columns as markdown text
#'
#' @param x A `flextable` object
#' @export
colformat_md <- function(x) {
  body <- x$body$dataset
  j = names(body)[vapply(body, is.character, NA)]
  if (length(j) == 0) return(x)
  flextable::compose(
    x, i = seq(nrow(body)), j = j,
    value = parse_md(unlist(body[j], use.names = FALSE), .from =  'markdown'),
    part = 'body'
  )
}
