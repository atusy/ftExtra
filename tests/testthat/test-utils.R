test_that("group_of grouped_df", {
  expect_identical('Species', group_of(dplyr::group_by(iris, .data$Species)))
  expect_identical(NULL, group_of(iris))
})

test_that("%||% returns right if left is NULL", {
  expect_identical('a' %||% 'b', 'a')
  expect_identical(NULL %||% 'b', 'b')
})
