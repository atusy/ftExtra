# ftExtra 0.0.2

## New features

* `colformat_md()`
  * Supports link and image syntax. Color of the links can be controled by for example `colformat_md(auto_color_link = 'red')`.
  * gains `.from` argument to specify Pandoc's `--from` argument.
  * gains `j` argument so that users can choose which columns to be treated as markdown based on `dplyr::select()`'s semantics.

## Internal changes

* `ftExtra:::ast2df()` calls `tibble::as_tibble()` to support dplyr 1.0.1 (thanks romainfrancois, #11)

# ftExtra 0.0.1

* Add `colformat_md()` which parses markdown text in the body of the flextable object.
* Add `separate_header()` which separates header into multiple rows based on regular expression.
* Add `span_header()` which separates header into multiple rows based on regular expression, and spans them if the adjacent values share the same value.
* Add `with_blanks()` which inserts blank columns based on the semantics of `dplyr::select`.
* Add `as_flextable.data.frame` to convert data frames to flextable.
* Add `as_flextable.grouped_df` to convert grouped data frames to flextable.
