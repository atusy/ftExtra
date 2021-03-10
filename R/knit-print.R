knit_print.ftExtra <- function(x, options, ...) {
  citations <- attr(x, "citations", exact = TRUE)
  if (citations != "") {
    if (options$results == "asis") {
      cat(sprintf(
        '\n\n---\nftExtra-ref-%s: "%s"\n---\n\n',
        options$label,
        citations
      ))
    } else {
      message(
        "Set the chunk option, `results='asis'`, ",
        "in order to automatically add citations to reference ",
        "with `ftExtra::colformat_md`."
      )
    }
  }
  NextMethod("knit_print", x, options, ...)
}
