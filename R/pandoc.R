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
