knit_print.ftExtra <- function(x, options, ...) {
  if (options$results == "asis") {
    cat(sprintf(
      '\n\n---\nftExtra-ref-%s: "%s"\n---\n\n',
      options$label,
      attr(x, "citations", exact = TRUE)
    ))
  }
  NextMethod("knit_print", x, options, ...)
}
