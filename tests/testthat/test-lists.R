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

test_with_pandoc("list separators and cell boundaries are preserved", {
  paragraphs <- as_paragraph_md(
    c("- ABCD\n- EFG", "plain\n\nparagraph"),
    .sep = " | "
  )
  expect_identical(
    vapply(paragraphs, paragraph2txt, ""),
    c("\u2022 ABCD | \u2022 EFG", "plain | paragraph")
  )
})

test_with_pandoc("nested lists keep their indentation and numbering", {
  paragraph <- as_paragraph_md(
    "- parent\n    1. child\n    2. sibling\n- next"
  )[[1L]]
  expect_identical(
    paragraph2txt(paragraph),
    "\u2022 parent\n\n  1. child\n\n  2. sibling\n\n\u2022 next"
  )
})

test_with_pandoc("list items retain inline formatting", {
  paragraph <- as_paragraph_md("- **bold**\n- *italic*\n- [link](https://example.com)")[[1L]]
  expect_identical(
    paragraph2txt(paragraph),
    "\u2022 bold\n\n\u2022 italic\n\n\u2022 link"
  )
  expect_true(paragraph$bold[paragraph$txt == "bold"])
  expect_true(paragraph$italic[paragraph$txt == "italic"])
  expect_identical(paragraph$url[paragraph$txt == "link"], "https://example.com")
})

test_with_pandoc("paragraphs within list items retain the separator", {
  paragraph <- as_paragraph_md("- first\n\n  continued\n\n- last", .sep = " | ")[[1L]]
  expect_identical(paragraph2txt(paragraph), "\u2022 first | continued | \u2022 last")
})

test_with_pandoc("fancy ordered lists use decimal markers", {
  paragraph <- as_paragraph_md("c.  third\nd.  fourth")[[1L]]
  expect_identical(paragraph2txt(paragraph), "3. third\n\n4. fourth")
})
