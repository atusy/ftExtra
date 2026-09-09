test_with_pandoc("Quarto execution metadata supplies citations by default", {
  info <- tempfile(fileext = ".json")
  on.exit(unlink(info))
  bib <- tempfile(fileext = ".bib")
  on.exit(unlink(bib), add = TRUE)
  writeLines(
    "@book{example, author={Jane Doe}, title={Example Book}, year={2024}}",
    bib
  )
  metadata <- list(bibliography = bib)
  jsonlite::write_json(list(format = list(metadata = metadata)), info,
    auto_unbox = TRUE
  )
  withr::local_envvar(QUARTO_EXECUTE_INFO = info)
  paragraph <- as_paragraph_md("@example")[[1L]]
  expect_identical(paragraph2txt(paragraph), "Doe (2024)")
})
