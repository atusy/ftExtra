x <- data.frame(a = 1, b = 2)

test_that("insert_blank", {
  expect_identical(insert_blank('a', NULL, x), c('a', '..after1', 'b'))
  expect_identical(
    insert_blank(tidyselect::everything(), NULL, x),
    c('a', '..after1', 'b', '..after2')
  )
  expect_identical(
    insert_blank(NULL, 'a', x),
    c('..before1', 'a', 'b')
  )
  expect_identical(
    insert_blank(NULL, c('a', 'b'), x),
    c('..before1', 'a', '..before2', 'b')
  )
  expect_identical(
    insert_blank('a', 'b', x),
    c('a', '..after1', '..before1', 'b')
  )
})

test_that("with_blank is tested via test-as-flextable.R", {})
