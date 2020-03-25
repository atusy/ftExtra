#' Format character columns as markdown text
#'
#' @param x A `flextable` object
#' @param auto_color_link A color of the link texts.
#'
#' @examples
#' if (rmarkdown::pandoc_available()) {
#'   data.frame(
#'     x = c("**bold**", "*italic*" ),
#'     y = c("^superscript^", "~subscript~"),
#'     z = c("***^ft^~Extra~** is*", "*Cool*")
#'   )
#' }
#'
#' @export
colformat_md <- function(x, auto_color_link = 'blue') {
  body <- x$body$dataset
  j = names(body)[vapply(body, is.character, NA)]
  if (length(j) == 0) return(x)
  flextable::compose(
    x, i = seq(nrow(body)), j = j,
    value = parse_md(
      unlist(body[j], use.names = FALSE), .from =  'markdown',
      auto_color_link = auto_color_link
    ),
    part = 'body'
  )
}
