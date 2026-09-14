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

test_with_pandoc("a single image dimension preserves the aspect ratio", {
  skip_if_not_installed("magick")
  src <- normalizePath(file.path(R.home("doc"), "html", "logo.jpg"),
    winslash = "/"
  )
  size <- magick::image_info(magick::image_read(src))
  chunk <- as_paragraph_md(sprintf("![](%s){width=2}", src))[[1L]]
  expect_equal(chunk$width, 2)
  expect_equal(chunk$height, 2 * size$height / size$width)
  chunk <- as_paragraph_md(sprintf("![](%s){height=3}", src))[[1L]]
  expect_equal(chunk$height, 3)
  expect_equal(chunk$width, 3 * size$width / size$height)
})

test_with_pandoc("explicit image dimensions do not require reading the image", {
  chunk <- as_paragraph_md("![](not-present.png){width=2 height=3}")[[1L]]
  expect_equal(chunk$width, 2)
  expect_equal(chunk$height, 3)
})

test_with_pandoc("mixed text and markdown images can be saved as PNG", {
  skip_if_not_installed("magick")
  src <- normalizePath(file.path(R.home("doc"), "html", "logo.jpg"),
    winslash = "/"
  )
  md <- sprintf("**before** ![](%s) ![](%s){width=2} after", src, src)
  chunk <- as_paragraph_md(md)[[1L]]
  images <- !vapply(chunk$img_data, is.null, logical(1))
  expect_equal(sum(images), 2)
  expect_true(all(is.finite(chunk$width[images])))
  expect_true(all(is.finite(chunk$height[images])))
  expect_true(all(is.na(chunk$width[!images])))
  expect_true(all(is.na(chunk$height[!images])))
  expect_true(chunk$bold[chunk$txt == "before"])

  ft <- colformat_md(flextable::flextable(data.frame(image = md)))
  ft <- flextable::autofit(ft)
  path <- tempfile(fileext = ".png")
  on.exit(unlink(path))
  expect_no_error(flextable::save_as_image(ft, path = path))
  expect_true(file.exists(path))
  expect_equal(magick::image_info(magick::image_read(path))$format, "PNG")
})
