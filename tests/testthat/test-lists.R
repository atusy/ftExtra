test_with_pandoc("colformat_md keeps bullet list items separate", {
  ft <- flextable::flextable(data.frame(A = "- ABCD\n\n- EFG"))
  ft <- colformat_md(ft)
  expect_identical(
    paragraph2txt(ft$body$content$data[[1L]]),
    "\u2022 ABCD\n\n\u2022 EFG"
  )
})

test_with_pandoc("ordered list items keep their starting number", {
  paragraph <- as_paragraph_md("3. ABCD\n4. EFG")[[1L]]
  expect_identical(paragraph2txt(paragraph), "3. ABCD\n\n4. EFG")
})
