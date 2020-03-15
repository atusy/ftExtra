x <- data.frame(a = 1, b = 2)

test_that("insert_blank", {
  expect_identical(insert_blanks('a', NULL, x), c('a', '..after1', 'b'))
  expect_identical(
    insert_blanks(tidyselect::everything(), NULL, x),
    c('a', '..after1', 'b', '..after2')
  )
  expect_identical(
    insert_blanks(NULL, 'a', x),
    c('..before1', 'a', 'b')
  )
  expect_identical(
    insert_blanks(NULL, c('a', 'b'), x),
    c('..before1', 'a', '..before2', 'b')
  )
  expect_identical(
    insert_blanks('a', 'b', x),
    c('a', '..after1', '..before1', 'b')
  )
})

test_that("with_blanks is tested via test-as-flextable.R", {})
