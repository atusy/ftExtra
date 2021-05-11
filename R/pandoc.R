meta <- function(key, val) {
  sprintf("--metadata=%s:%s", key, val)
}

lua <- function(...) {
  c("--lua-filter", system.file("lua", ..., package = "ftExtra"))
}

lua_filters <- function(.sep = "\n\n") {
  if (!rmarkdown::pandoc_available("2")) return(NULL)

  c(
    lua("smart.lua"),
    lua("inline-code.lua"),
    if (rmarkdown::pandoc_available("2.7.3")) {
      c(
        lua("math.lua"),
        meta("pandoc_path", rmarkdown::pandoc_exec()),
        if (!rmarkdown::pandoc_available("2.10")) {
          meta("temporary-directory", tempdir())
        }
      )
    },
    if (rmarkdown::pandoc_available("2.2.3")) {
      c(lua("blocks-to-inlines.lua"), meta("sep_blocks", .sep))
    }
  )
}

temp_bib <- function(n) {
  temp_file <- tempfile(fileext = ".bib")
  xfun::write_utf8(
    paste0("@book{ftExtra-dummy-entry-",
           seq(n),
           ", author = {ftExtra}, title = {ftExtra}, publisher = {ftExtra}}"),
    temp_file
  )
  return(temp_file)
}

temp_yaml_cite <- function(n) {
  temp_file <- tempfile(fileext = ".yml")
  xfun::write_utf8(
    sprintf('ftExtra-dummy-cite: "%s"',
            paste(paste0("@ftExtra-dummy-entry-", seq(n)), collapse = " ")),
    temp_file
  )
  return(temp_file)
}

pandoc_args_citation_number <- function(n = 1L) {
  if (n <= 1L) return(character(0))

  n <- n - 1L

  return(c(paste0("--bibliography=", temp_bib(n)),
           paste0("--metadata-file=", temp_yaml_cite(n))))
}
