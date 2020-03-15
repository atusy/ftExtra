# ftExtra 0.0.1

* Add `colformat_md()` which parses markdown text in the body of the flextable object.
* Add `separate_header()` which separates header into multiple rows based on regular expression.
* Add `span_header()` which separates header into multiple rows based on regular expression, and spans them if the adjacent values share the same value.
* Add `with_blanks()` which inserts blank columns based on the semantics of `dplyr::select`.
* Add `as_flextable.data.frame` to convert data frames to flextable.
* Add `as_flextable.grouped_df` to convert grouped data frames to flextable.
