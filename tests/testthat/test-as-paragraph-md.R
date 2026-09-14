test_that("vertical_align", {
  expect_identical(vertical_align(NULL, NULL), NA_character_)

  expect_identical(vertical_align(TRUE, NULL), "superscript")
  expect_identical(vertical_align(TRUE, NA), "superscript")
  expect_identical(vertical_align(TRUE, FALSE), "superscript")

  expect_identical(vertical_align(NULL, TRUE), "subscript")
  expect_identical(vertical_align(NA, TRUE), "subscript")
  expect_identical(vertical_align(FALSE, TRUE), "subscript")

  expect_identical(vertical_align(TRUE, TRUE), "subscript")

  expect_identical(
    vertical_align(c(TRUE, NA, NA), c(NA, TRUE, NA)),
    c("superscript", "subscript", NA_character_)
  )
})

test_with_pandoc("as_paragraph_md renders math", {
  math <- as_paragraph_md("$\\alpha$")[[1L]]$txt
  expect_length(math, 1L)
  expect_identical(nchar(math), 1L)
  expect_identical(math, "\u03b1")
})

test_with_pandoc("markdown images have intrinsic dimensions", {
  skip_if_not_installed("magick")
  src <- normalizePath(file.path(R.home("doc"), "html", "logo.jpg"),
    winslash = "/"
  )
  size <- magick::image_info(magick::image_read(src))
  chunk <- as_paragraph_md(sprintf("![](%s)", src))[[1L]]
  expect_equal(chunk$width, size$width / 72)
  expect_equal(chunk$height, size$height / 72)
})
