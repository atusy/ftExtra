x <- tibble::as_tibble(iris[c(1, 2, 51, 52), c(5, 1)])

test_that("as.flextable.grouped_df", {
  options(ftExtra.ignore.deprecation = TRUE)
  d <- dplyr::group_by(x, .data$Species)
  f <- flextable::as_grouped_data(x, "Species")

  expect_identical(as_flextable(d), as_flextable(f))

  expect_identical(
    as_flextable(d, groups_to = "merged"),
    x %>%
      flextable::flextable() %>%
      flextable::merge_v("Species") %>%
      flextable::theme_vanilla()
  )

  expect_identical(
    as_flextable(d, groups_to = "asis"),
    flextable::flextable(x)
  )
})

test_that("flextable.grouped_df multi groups", {
  x <- mtcars %>%
    tibble::as_tibble(rownames = "model") %>%
    dplyr::select(model, cyl, mpg, disp, am)
  d <- x %>%
    dplyr::group_by(am, cyl, mpg)
  f <- flextable::as_grouped_data(x, groups = c("am", "cyl", "mpg"))

  expect_identical(as_flextable(d), as_flextable(f))

  expect_identical(
    as_flextable(d, groups_to = "merged"),
    x %>%
      dplyr::relocate(am, cyl, mpg) %>%
      flextable::flextable() %>%
      flextable::merge_v(c("am", "cyl", "mpg")) %>%
      flextable::theme_vanilla()
  )

  expect_identical(
    as_flextable(d, groups_to = "merged", groups_arrange = TRUE),
    x %>%
      dplyr::relocate(am, cyl, mpg) %>%
      dplyr::arrange(am, cyl, mpg) %>%
      flextable::flextable() %>%
      flextable::merge_v(c("am", "cyl", "mpg")) %>%
      flextable::theme_vanilla()
  )

  expect_identical(
    as_flextable(d, groups_to = "merged", groups_pos = "asis"),
    x %>%
      flextable::flextable() %>%
      flextable::merge_v(c("am", "cyl", "mpg")) %>%
      flextable::theme_vanilla()
  )

  expect_identical(
    as_flextable(d, groups_to = "asis"),
    flextable::flextable(x)
  )
})
