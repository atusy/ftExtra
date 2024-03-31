# ftExtra 0.6.3

* Require **flextable**>=0.9.5 to fix broken `colformat_md` (#101)

# ftExtra 0.6.2

* Avoid error from using horizontal rule (#98)

# ftExtra 0.6.1

* Deprecated functions masking the corresponding ones from the **flextable** package (#95)

* Renamed `separate_header` to `split_header` (#95)

* Fixed a wrong escape regex in the  `sep` parameter of `split_header`, `span_header`, and `separate_header` (#95)

# ftExtra 0.6.0

* Fix `footnote_options` not controlling reference symbols correctly. Formerly, only symbols in the cells used the `prefix` and the `suffix` arguments. Now, footnote texts also respects them (#88).

* Support fine controls on footnote symbols in two ways. See `?footnote_options` for the details (#90).
    * `prefix` and `suffix` labels by passing the corresponding arguments to `footnote_options`
    * finest controls by passing a function to `footnote_options(ref = ...)`. 

# ftExtra 0.5.0

* Fix `as_flextable.grouped_df` which broke second and subsequent group variables. Also, this function gains `groups_arrange` argument. The default value is `NULL` which implies `FALSE` for the backward-compatibility. In the next version, `NULL` remains the default but becomes deprecated. Then, `TRUE` becomes the default in the subsequent release (thanks, @eitsupi, #76).

* `as_paragraph_md` and `colformat_md` gains the `metadata` argument with the default value `rmarkdown::metadata` (#78).

* `as_flextable.grouped_df` uses `dplyr::group_vars` to get names of grouping variables, and remove an internal synonym (#79).

* `as_paragraph_md` and `colformat_md` disables two Pandoc extentions, `raw_html` and `raw_attribute`. Previously, these synstaxes raised errors on formatting (#80).

* mention **ftExtra** respects `csl` field in the YAML front matter (#83).

* Fix a performance issue on `colformat_md` when using footnotes (#85).

* `separate_header` and `span_header` now refers to `flextable::get_flextable_defaults()` to find default value for `theme_fun` (#86).

# ftExtra 0.4.0

* `as_paragraph_md` supports empty string, `""`, as an input (#68).
* `colformat_md` applies on actual content of flextable rather than input dataset (#72).
* Improved support for the underline syntax in Pandoc's Markdown (#73).

# ftExtra 0.3.0

## New features

* `colformat_md` and `as_paragraph_md` gains `replace_na = ""` as a new default parameter. Previously, `NA` are printed as `"NA"` (#63).

## Internal changes

* Support tidyr 1.2.0 (thanks, @DavisVaughan, #66)

# ftExtra 0.2.0

## Breaking changes

* Drop supports for Pandoc versions < 2.0.6 in order to reduce maintenance costs. (#59).

## New features

* `colformat_md` supports multiple paragraphs by collapsing them with a separator given to the `.sep` argument (default: `"\n\n") (#43).
* `colformat_md` can now automatically add citations to reference on R Markdown (#48).
* `colformat_md` can now contain cells with multiple footnotes. In addition, footnote keys are placed exactly the same place of source. The previous implementation moved the keys to the end of corresponding cells (#51).
* `as_paragraph_md` supports variety of input formats by checking enabled extensions (#54).

## Bug fixes

* Fix `colformat_md(pandoc_args = c("--bibliography", "example.bib"))` should work even if bibliography field is missing from the YAML front matter (#41).

## Internal changes

* Drop **jpeg** package from suggests, which is formerly used in a vignette (#42).
* `colformat_md` converts cells to Pandoc's AST by a single call of Pandoc. Previously it called pandoc for each cell. This change improves performance around 15X faster (#46). Note that #46 broken support for some input formats (e.g., commonmark) and old Pandoc (< 2.0.6), but the regression is already fixed (#53, #57).
* `as_paragraph_md()` internally uses `flextable::chunk_dataframe()` in order to avoid potential problems if the **flextable** package changes the chunk structure in the future (#56, thanks @davidgohel).

# ftExtra 0.1.1
* Fix math not rendered on Windows with Pandoc < 2.10 (#33)
* `math.lua` requires Pandoc >= 2.7.3 (#35)
* Fix Pandoc < 2.7.3 raising error message "option --lua-filter requires an argument SCRIPTPATH". This is a regression from #35 (#37)
* Fix CRAN warning, "file 'https://www.r-project.org/logo/Rlogo.png' can not be found." (#38)

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
