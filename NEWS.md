# ftExtra 0.0.2

## New features

* Markdown parser
    * supports more syntax
        * Links
        * Inline images
        * Soft line breaks
        * Hard line breaks (e.g., `colformat_md(as_flextable(data.frame('a\\\nb', stringsAsFactors = FALSE)))`).
    * stops with error if there are multiple paragraphs or block elements other than the paragraph.
* `colformat_md()`
  * controls colors of links for example by `colformat_md(auto_color_link = 'red')`.
  * gains `.from` argument to specify Pandoc's `--from` argument.
  * gains `j` argument so that users can choose which columns to be treated as markdown based on `dplyr::select()`'s semantics.
* Add `as_paragraph_md` which parses markdown texts on selected cells rather than selected columns. Use this function within `flextable::compose`.

# ftExtra 0.0.1

* Add `colformat_md()` which parses markdown text in the body of the flextable object.
* Add `separate_header()` which separates header into multiple rows based on regular expression.
* Add `span_header()` which separates header into multiple rows based on regular expression, and spans them if the adjacent values share the same value.
* Add `with_blanks()` which inserts blank columns based on the semantics of `dplyr::select`.
* Add `as_flextable.data.frame` to convert data frames to flextable.
* Add `as_flextable.grouped_df` to convert grouped data frames to flextable.
