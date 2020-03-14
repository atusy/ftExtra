d <- data.frame(a_1 = 1, a_2 = 1, b = 1, c_c = 1)
h <- data.frame(
  original = names(d),
  level1 = c('a', 'a', 'b', 'c'),
  level2 = c('1', '2', NA_character_, 'c'),
  stringsAsFactors = FALSE
)
ft <- flextable::flextable(d) %>%
  flextable::set_header_df(h, key = 'original')

test_that("fill_header", {
  x <- data.frame(original = 'foo', level1 = 'foo', level2 = NA_character_)
  expect_identical(
    fill_header(x), x %>% dplyr::mutate(level2 = level1) %>% tibble::as_tibble()
  )
  expect_identical(
    fill_header(x, FALSE), x
  )
})

test_that("merge_header", {
  expect_identical(
    merge_header(ft),
    ft %>%
      flextable::merge_h(part = 'header') %>%
      flextable::merge_v(part = 'header')
  )
  expect_identical(merge_header(ft, FALSE), ft)
})

test_that("separate-header", {
  expect_identical(
    d %>% as_flextable() %>% separate_header(),
    ft %>% flextable::theme_booktabs() %>% flextable::fix_border_issues()
  )
})

test_that("span-header", {
  expect_identical(
    d %>% as_flextable() %>% span_header(),
    flextable::flextable(d) %>%
      flextable::set_header_df(h %>% fill_header(), key = 'original') %>%
      merge_header() %>%
      flextable::theme_booktabs() %>%
      flextable::fix_border_issues()
  )
})
