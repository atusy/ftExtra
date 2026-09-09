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

test_with_pandoc("lists inside block quotes keep item boundaries", {
  paragraph <- as_paragraph_md(
    "> - first\n> - second"
  )[[1L]]
  expect_identical(paragraph2txt(paragraph), "\u2022 first\n\n\u2022 second")
})

test_with_pandoc("nested Divs retain the enclosing list indentation", {
  paragraph <- as_paragraph_md(
    "- parent\n\n  ::: {.foo}\n  - child\n  :::\n- sibling"
  )[[1L]]
  expect_identical(
    paragraph2txt(paragraph),
    "\u2022 parent\n\n  \u2022 child\n\n\u2022 sibling"
  )
})

test_with_pandoc("empty parent list items stay separate from their children", {
  paragraphs <- as_paragraph_md(
    c(
      "-\n  - child\n- sibling",
      "- ::: {.foo}\n  - child\n  :::\n- sibling",
      "- > - child\n- sibling"
    ),
    .sep = " | "
  )
  expect_identical(
    vapply(paragraphs, paragraph2txt, ""),
    rep("\u2022  |   \u2022 child | \u2022 sibling", 3L)
  )
})

test_with_pandoc("Div paragraphs inside footnotes retain their separator", {
  options <- footnote_options()
  as_paragraph_md(
    "text[^n]\n\n[^n]:\n    ::: {.foo}\n    first\n\n    second\n    :::",
    .footnote_options = options
  )
  expect_identical(paragraph2txt(options$value[[1L]]), "1first\n\nsecond")
})

test_with_pandoc("Div paragraphs inside definitions retain their separator", {
  paragraph <- as_paragraph_md(
    "term\n:   ::: {.foo}\n    first\n\n    second\n    :::",
    .sep = " | "
  )[[1L]]
  expect_match(paragraph2txt(paragraph), "first | second", fixed = TRUE)
})

test_with_pandoc("Div paragraphs inside tables retain their separator", {
  paragraph <- as_paragraph_md(
    "<table><tr><td><div><p>first</p><p>second</p></div></td></tr></table>",
    .from = "html",
    .sep = " | "
  )[[1L]]
  expect_match(paragraph2txt(paragraph), "first | second", fixed = TRUE)
})

test_with_pandoc("Div paragraphs inside figures retain their separator", {
  paragraph <- as_paragraph_md(
    "<figure><div><p>first</p><p>second</p></div></figure>",
    .from = "html",
    .sep = " | "
  )[[1L]]
  expect_match(paragraph2txt(paragraph), "first | second", fixed = TRUE)
})
