test_with_pandoc("colformat_md keeps bullet list items separate", {
  ft <- flextable::flextable(data.frame(A = "- ABCD\n\n- EFG"))
  ft <- colformat_md(ft)
  expect_identical(
    paragraph2txt(ft$body$content$data[[1L]]),
    "\u2022 ABCD\n\n\u2022 EFG"
  )
})
