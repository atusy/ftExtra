branch <- list(
  t = 'Emph',
  c = list(
    list(
      t = 'Str',
      c = 'text'
    )
  )
)

res_branch <- list(t = c('Str', 'Emph'), c = 'text')

tree <- list(list(
  t = 'Para',
  c = list(branch, branch)
))

res_tree <- list(
  list(t = c('Str', 'Emph', 'Para'), c = 'text'),
  list(t = c('Str', 'Emph', 'Para'), c = 'text')
)

test_that('add_type', {
  expect_identical(add_type(branch$c[[1]], branch$t), res_branch)
})

test_that('resolve_type', {
  expect_identical(resolve_type(branch$c[[1]]), branch$c[[1]])
  expect_identical(resolve_type(branch), list(res_branch))
})

test_that('flatten_branch', {
  expect_identical(flatten_branch(flatten_branch(tree)), res_tree)
})

test_that('flatten_ast', {
  expect_identical(flatten_ast(tree), res_tree)
})

test_that('branch2list', {
  expect_identical(
    branch2list(res_branch),
    list(txt = 'text', Str = TRUE, Emph = TRUE)
  )
  expect_identical(
    branch2list(list(t = 'Space')), list(txt = ' ', Space = TRUE)
  )
})

test_that('ast2df', {
  expect_identical(
    ast2df(list(blocks = tree)),
    tibble::tibble(
      txt = c('text', 'text'),
      Str = c(TRUE, TRUE),
      Emph = c(TRUE, TRUE),
      Para = c(TRUE, TRUE)
    )
  )
})
