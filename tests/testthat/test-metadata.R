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

test_with_pandoc("Quarto bibliography paths follow the document directory", {
  project <- withr::local_tempdir()
  dir.create(file.path(project, "chapters"))
  writeLines(
    "@book{example, author={Jane Doe}, title={Example Book}, year={2024}}",
    file.path(project, "references.bib")
  )
  info <- file.path(project, "context.json")
  jsonlite::write_json(list(
    `document-path` = file.path(project, "chapters", "test.qmd"),
    format = list(metadata = list(bibliography = list("../references.bib")))
  ), info, auto_unbox = TRUE)
  withr::local_envvar(QUARTO_EXECUTE_INFO = info)
  withr::local_dir(project)
  ft <- colformat_md(flextable::flextable(data.frame(Citation = "@example")))
  expect_identical(paragraph2txt(ft$body$content$data[[1L]]), "Doe (2024)")
})
