test_with_pandoc("math filter uses the selected Pandoc executable", {
  skip_if_not(rmarkdown::pandoc_available("2.7.3"))
  expect_contains(
    lua_filters(),
    meta("pandoc-path", rmarkdown::pandoc_exec())
  )
})
