# ftExtra 0.1.0

* Support markdown footnote with `colformat_md`. Currently, one footnote per a cell is allowed, and it must be located at the end of the cell content (#22).
* Add `footnote_options()` to configure options for footnotes (#23).
* Support formatting markdown texts on header with `colformat_md(part = "header")` (#23).
* Support single- and double-quotes by a lua filter (dfc82e0).
* Support attributes with Span, Link, and Code. Useful attributes include the `.underline` class and the `color`, `shading.color`, and `font.family` attributes (#24).
* Support inline code (#25).
* Add the `md_extensions` and `pandoc_args` arguments to `colformat_md()` and `as_paragraph_md()` (#26, #29).
* Support citation. Bibliography can be inherited from YAML front matter of an Rmd file (#27, #29).
* Support math on macOS and Linux (#30), and on Windows (#31).
* Fix character corruptions on Windows by forcing UTF8 (#31).
* Use pandoc citeproc when YAML frontmatter contains the bibliography field (#31).

# ftExtra 0.0.3

* Patched to pass "CRAN Package Check Results for Package" where `r-patched-solaris-x86` fails because of missing pandoc.

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
