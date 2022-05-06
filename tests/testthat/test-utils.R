test_that("%||% returns right if left is NULL", {
  expect_identical("a" %||% "b", "a")
  expect_identical(NULL %||% "b", "b")
})

test_that("drop_null", {
  expect_identical(drop_null(list(NULL, 1)), list(1))
})

test_that("drop_na", {
  expect_true(drop_na(c(TRUE, NA)))
})

test_that("last", {
  expect_true(last(list(FALSE, TRUE)))
  expect_true(last(c(FALSE, TRUE)))
})
