.onLoad <- function(libname, pkgname) {
  registerS3method("knit_print", "ftExtra", knit_print.ftExtra, asNamespace("knitr"))
}
