test_that("vertical_align", {
  expect_identical(vertical_align(NULL,  NULL),  NA_character_)

  expect_identical(vertical_align(TRUE,  NULL),  'superscript')
  expect_identical(vertical_align(TRUE,  NA),    'superscript')
  expect_identical(vertical_align(TRUE,  FALSE), 'superscript')

  expect_identical(vertical_align(NULL,  TRUE),  'suberscript')
  expect_identical(vertical_align(NA,    TRUE),  'suberscript')
  expect_identical(vertical_align(FALSE, TRUE),  'suberscript')

  expect_identical(vertical_align(TRUE,  TRUE),  'subscript')

  expect_identical(
    vertical_align(c(TRUE, NA, NA), c(NA, TRUE, NA)),
    c('superscript', 'subscript', NA_character_)
  )
})
