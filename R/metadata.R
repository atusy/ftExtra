render_metadata <- function() {
  info <- Sys.getenv("QUARTO_EXECUTE_INFO", "")
  if (!nzchar(info)) {
    return(rmarkdown::metadata)
  }
  context <- jsonlite::read_json(info)
  metadata <- context$format$metadata
  # Quarto classifies this citation setting as a Pandoc option.
  abbreviations <- context$format$pandoc[["citation-abbreviations"]]
  if (!is.null(abbreviations)) {
    metadata[["citation-abbreviations"]] <- abbreviations
  }
  document <- context[["document-path"]]
  if (!is.null(document)) {
    # Quarto resolves resource paths relative to the source document, not getwd().
    resolve_path <- function(path) {
      if (xfun::is_abs_path(path) || grepl("^[[:alpha:]][[:alnum:]+.-]*:", path)) {
        return(path)
      }
      candidate <- file.path(dirname(document), path)
      # Keep names available to Pandoc's resource-path and built-in CSL lookup.
      if (file.exists(candidate)) candidate else path
    }
    for (key in c("bibliography", "csl", "citation-abbreviations")) {
      if (is.character(metadata[[key]])) {
        metadata[[key]] <- vapply(metadata[[key]], resolve_path, "", USE.NAMES = FALSE)
      } else if (is.list(metadata[[key]])) {
        metadata[[key]] <- lapply(metadata[[key]], resolve_path)
      }
    }
  }
  metadata
}
