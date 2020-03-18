#' Unpreserve a caption within html_preserved
#'
#' @noRd
unpreserve_caption <- function(x) {
  stringr::str_replace_all(
    x,
    '(<!--html_preserve-->.*)(<caption>.*</caption>)(.*<!--/html_preserve-->)',
    '\\1<!--/html_preserve-->\\2<!--html_preserve-->\\3'
  )
}

div_ft_caption <- '::: \\{custom-style="Table Caption"\\}'

#' Wrap caption by the html caption tag
#' @noRd
as_caption <- function(x) {
  i <- grep(div_ft_caption, x)
  y <- strsplit(x[i], '\\n')
  j <- lapply(y, function(x) grep(div_ft_caption, x) + 2)
  y <- purrr::map2(
    y, j, purrr::modify_at, function(x) paste0('<caption>', x, '</caption>')
  )

  x[i] <- purrr::map_chr(y, paste, collapse = '\n')
  x
}

#' List of love
love <- list(
  html = unpreserve_caption,
  docx = as_caption
)

#' Enable an output hook
#'
#' @export
loves_bookdown <- function() {
  fmt <- knitr::opts_knit$get("rmarkdown.pandoc.to")
  current_hook <- knitr::knit_hooks$get('document')

  if (!fmt %in% names(love)) {
    warning("ftExtra's love has not reached to ", fmt, '.')
  }

  new_hook <- love[[fmt]]
  knitr::knit_hooks$set(
    document = function(x) new_hook(current_hook(x))
  )
}
