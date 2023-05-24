testthat::test_that("generating numbered footnote refs with default settings", {
  testthat::expect_snapshot(footnote_options()$ref(1L))
  testthat::expect_snapshot(footnote_options()$ref(c(1L, 3L)))
})

testthat::test_that("generating footnote refs with common settings", {
  testthat::expect_snapshot(footnote_options(ref = "1")$ref(c(1L, 2L)))
  testthat::expect_snapshot(footnote_options(ref = "a")$ref(c(1L, 2L)))
  testthat::expect_snapshot(footnote_options(ref = "A")$ref(c(1L, 2L)))
  testthat::expect_snapshot(footnote_options(ref = "i")$ref(c(1L, 2L)))
  testthat::expect_snapshot(footnote_options(ref = "I")$ref(c(1L, 2L)))
  testthat::expect_snapshot(footnote_options(ref = "*")$ref(c(1L, 2L)))
})

testthat::test_that("generating footnote refs with prefix and suffix", {
  opt <- footnote_options(prefix = "(", suffix = ")")
  testthat::expect_snapshot(opt$ref(1L, "header", TRUE))
  testthat::expect_snapshot(opt$ref(1L, "header", FALSE))
  testthat::expect_snapshot(opt$ref(1L, "body", TRUE))
  testthat::expect_snapshot(opt$ref(1L, "body", FALSE))
})

testthat::test_that("generating footnote refs with callbacks", {
  ref <- function(n, part, footer) {
    mark <- if (part == "header") {
      as.character(n)
    } else {
      letters[n]
    }
    if (footer) {
      return(paste0(mark, ": :"))
    }
    return(paste0("^", mark, "^"))
  }

  opt <- footnote_options(ref = ref)
  testthat::expect_snapshot(opt$ref(c(1L, 2L), "header", TRUE))
  testthat::expect_snapshot(opt$ref(c(1L, 2L), "header", FALSE))
  testthat::expect_snapshot(opt$ref(c(1L, 2L), "body", TRUE))
  testthat::expect_snapshot(opt$ref(c(1L, 2L), "body", FALSE))
})
