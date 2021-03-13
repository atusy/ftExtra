reshape_extensions <- function(extensions) {
  setNames(grepl("\\+", extensions), gsub("[+-]", "", extensions))
}

pandoc_default_extensions <- function(format, pandoc = rmarkdown::pandoc_exec()) {
  pandoc %>%
    system2(paste0("--list-extensions=", format), stdout = TRUE) %>%
    reshape_extensions()
}


pandoc_specified_extensions <- function(format) {
  if(!grepl("[+-]", format)) {
    return(character(0))
  }

  gsub("([+-])", ",\\1", format) %>%
    strsplit(",") %>%
    (function(x) x[[1L]][-1L])() %>%
    reshape_extensions() %>%
    rev() %>%
    (function(x) {
      x[!duplicated(names(x))]
    })()
}

pandoc_enabled_extensions <- function(format, pandoc = rmarkdown::pandoc_exec()) {
  default <- pandoc_default_extensions(gsub("[+-].*", "", format), pandoc = pandoc)
  specified <- pandoc_specified_extensions(format)
  keys <- intersect(names(default), names(specified))
  if (length(specified) > 0L) {
    default[keys] <- specified[keys]
  }
  return(names(default)[default])
}

supported_divs <- function(format, ...) {
  extensions <- pandoc_enabled_extensions(format, ...)
  divs <- c("fenced_divs", "native_divs")
  divs[divs %in% extensions]
}

support_extensions <- function(format, extensions, ...) {
  enabled <- pandoc_enabled_extensions(format, ...)
  setNames(extensions %in% enabled, extensions)
}

support_yaml <- function(format, ...) {
  support_extensions(format, "yaml_metadata_block", ...)
}
