render_metadata <- function() {
  info <- Sys.getenv("QUARTO_EXECUTE_INFO", "")
  if (!nzchar(info)) {
    return(rmarkdown::metadata)
  }
  jsonlite::read_json(info)$format$metadata
}
