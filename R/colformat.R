#' Format character columns as markdown text
#'
#' @param x A `flextable` object
#' @param j Columns to be treated as markdown texts.
#'   Selection can be done by the semantics of `dplyr::select()`.
#' @param part
#'   One of "body", "header", and "all". If "all", formatting proceeds in the
#'   order of "header" and "body".
#' @param .sep
#'   A separator of paragraphs (default: `"\n\n"`)
#' @inheritParams as_paragraph_md
#'
#' @examples
#' if (rmarkdown::pandoc_available("2.0.6")) {
#'   d <- data.frame(
#'     x = c("**bold**", "*italic*"),
#'     y = c("^superscript^", "~subscript~"),
#'     z = c("***^ft^~Extra~** is*", "*Cool*")
#'   )
#'   colformat_md(flextable::flextable(d))
#' }
#' @export
colformat_md <- function(x,
                         j = where(is.character),
                         part = c("body", "header", "all"),
                         auto_color_link = "blue",
                         md_extensions = NULL,
                         pandoc_args = NULL,
                         metadata = rmarkdown::metadata,
                         replace_na = "",
                         .from = "markdown+autolink_bare_uris-raw_html-raw_attribute",
                         .footnote_options = footnote_options(),
                         .sep = "\n\n"
) {
  .j <- rlang::enexpr(j)
  part <- match.arg(part)
  .footnote_options$caller <- "colformat_md"

  if (part == "all") {
    for (part in c("header", "body")) {
      x <- colformat_md(x, j = !!.j, part = part,
                        auto_color_link = auto_color_link,
                        pandoc_args = pandoc_args, metadata = metadata,
                        replace_na = replace_na, .from = .from,
                        .footnote_options = .footnote_options, .sep = .sep)
      .footnote_options$value <- list()
    }
    return(x)
  }

  dataset <- x[[part]]$dataset
  content <- x[[part]][["content"]][["content"]][["data"]]
  nm <- colnames(content)
  col <- tidyselect::eval_select(rlang::expr(c(!!.j)), dataset[nm])

  if (length(col) == 0) {
    return(x)
  }

  texts <- purrr::map_chr(content[, col], paragraph2txt)

  # Must evaluate outside add_footnotes due to lazy evaluation of arguments
  ft <- flextable::compose(x,
                           i = seq(nrow(dataset)), j = col, part = part,
                           value = as_paragraph_md(
                             texts,
                             auto_color_link = auto_color_link,
                             .from = .from,
                             md_extensions = md_extensions,
                             pandoc_args = pandoc_args,
                             metadata = metadata,
                             replace_na = replace_na,
                             .footnote_options = .footnote_options,
                             .sep = .sep
                           ))

  structure(
    add_footnotes(ft, .footnote_options),
    class = c("ftExtra", class(ft)),
    citations = collect_citations(paste(texts, collapse = "\n\n"))
  )
}

where <- function(...) {
  tidyselect::vars_select_helpers$where(...)
}

paragraph2txt <- function(x) {
  if (all(is.na(x$txt))) return(NA_character_)

  txt <- x[["txt"]]
  img <- x[["img_data"]]
  has_img <- !purrr::map_lgl(img, is.null) & !is.na(img)
  txt[has_img] <- sprintf("![](%s)", img[has_img])

  paste(txt[!is.na(txt)], collapse = "")
}
