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

test_that("non-Quarto calls retain R Markdown metadata", {
  withr::local_envvar(QUARTO_EXECUTE_INFO = NA_character_)
  expect_identical(render_metadata(), rmarkdown::metadata)
})

test_with_pandoc("explicit metadata bypasses Quarto execution information", {
  withr::local_envvar(QUARTO_EXECUTE_INFO = "missing-execution-info.json")
  for (metadata in list(NULL, list())) {
    ft <- colformat_md(
      flextable::flextable(data.frame(Citation = "@example")),
      metadata = metadata
    )
    expect_identical(paragraph2txt(ft$body$content$data[[1L]]), "@example")
  }
})

test_that("citation resource URLs and absolute paths are preserved", {
  info <- tempfile(fileext = ".json")
  on.exit(unlink(info))
  metadata <- list(
    bibliography = list("https://example.org/refs.bib", normalizePath(tempdir())),
    csl = "style.csl",
    `citation-abbreviations` = "abbreviations.json",
    references = list(list(id = "inline", title = "Inline reference"))
  )
  directory <- withr::local_tempdir()
  file.create(file.path(directory, c("style.csl", "abbreviations.json")))
  document <- file.path(directory, "chapter.qmd")
  jsonlite::write_json(list(
    `document-path` = document,
    format = list(metadata = metadata)
  ), info, auto_unbox = TRUE)
  withr::local_envvar(QUARTO_EXECUTE_INFO = info)
  result <- render_metadata()
  expect_identical(result$bibliography, metadata$bibliography)
  expect_identical(result$csl, file.path(dirname(document), "style.csl"))
  expect_identical(result$`citation-abbreviations`,
    file.path(dirname(document), "abbreviations.json")
  )
  expect_identical(result$references, metadata$references)
})

test_with_pandoc("explicit metadata bypasses Quarto without Div extensions", {
  withr::local_envvar(QUARTO_EXECUTE_INFO = "missing-execution-info.json")
  paragraph <- as_paragraph_md(
    "plain", metadata = list(), .from = "markdown-fenced_divs-native_divs"
  )[[1L]]
  expect_identical(paragraph2txt(paragraph), "plain")
})

test_with_pandoc("Quarto Pandoc settings supply citation abbreviations", {
  project <- withr::local_tempdir()
  writeLines(
    "@article{example, title={Article}, journal={Journal of Testing}, year={2024}}",
    file.path(project, "refs.bib")
  )
  writeLines(paste0(
    '<style xmlns="http://purl.org/net/xbiblio/csl" version="1.0" class="in-text">',
    '<info><title>Test</title><id>https://example.org/test</id>',
    '<updated>2024-01-01T00:00:00+00:00</updated></info>',
    '<citation><layout><text variable="container-title" form="short"/>',
    '</layout></citation></style>'
  ), file.path(project, "style.csl"))
  jsonlite::write_json(list(default = list(
    `container-title` = list(`Journal of Testing` = "J. Test.")
  )), file.path(project, "abbreviations.json"), auto_unbox = TRUE)
  info <- file.path(project, "context.json")
  jsonlite::write_json(list(
    `document-path` = file.path(project, "test.qmd"),
    format = list(
      metadata = list(bibliography = "refs.bib", csl = "style.csl"),
      pandoc = list(`citation-abbreviations` = "abbreviations.json")
    )
  ), info, auto_unbox = TRUE)
  withr::local_envvar(QUARTO_EXECUTE_INFO = info)
  expect_identical(paragraph2txt(as_paragraph_md("@example")[[1L]]), "J. Test.")
})

test_with_pandoc("Quarto bibliography retains Pandoc resource-path lookup", {
  project <- withr::local_tempdir()
  dir.create(file.path(project, "refs"))
  writeLines(
    "@book{example, author={Jane Doe}, title={Example Book}, year={2024}}",
    file.path(project, "refs", "references.bib")
  )
  info <- file.path(project, "context.json")
  jsonlite::write_json(list(
    `document-path` = file.path(project, "test.qmd"),
    format = list(metadata = list(bibliography = "references.bib"))
  ), info, auto_unbox = TRUE)
  withr::local_envvar(QUARTO_EXECUTE_INFO = info)
  withr::local_dir(project)
  paragraph <- as_paragraph_md("@example", pandoc_args = "--resource-path=refs")
  expect_identical(paragraph2txt(paragraph[[1L]]), "Doe (2024)")
})
