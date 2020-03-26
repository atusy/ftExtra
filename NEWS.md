# ftExtra 0.0.2

* Support link and image syntax with `colformat_md()`. Color of the links can be controled by for example `colformat_md(auto_color_link = 'red')`.
* Add `.from` option to `colformat_md()` so to specify Pandoc's `--from` argument (e.g., `'markdown+emoji'`, `'html'`, and so on).

# ftExtra 0.0.1

* Add `colformat_md()` which parses markdown text in the body of the flextable object.
* Add `separate_header()` which separates header into multiple rows based on regular expression.
* Add `span_header()` which separates header into multiple rows based on regular expression, and spans them if the adjacent values share the same value.
* Add `with_blanks()` which inserts blank columns based on the semantics of `dplyr::select`.
* Add `as_flextable.data.frame` to convert data frames to flextable.
* Add `as_flextable.grouped_df` to convert grouped data frames to flextable.
