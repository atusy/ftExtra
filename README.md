
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ftExtra

<!-- badges: start -->

<!-- badges: end -->

The ftExtra package provides helper functions for the flextable package:

  - `colformat_md` parses markdown texts in columns
  - `span_header` makes multi-level headers

## Installation

``` r
remotes::install_github("atusy/ftExtra")
```

## Example

``` r
library(flextable)
library(ftExtra)
```

### Parse markdown texts

``` r
data.frame(
  x = c("**bold**", "*italic*"),
  y = c("^superscript^", "~subscript~"),
  z = c("***~ft~^Extra^** is*", "*Cool*"),
  stringsAsFactors = FALSE
) %>%
  flextable::flextable() %>%
  ftExtra::colformat_md()
```

<img src="inst/image/ft_colformat_md.png" width="100%" />

### Span headers

``` r
iris %>%
  head %>%
  flextable::flextable() %>%
  ftExtra::span_header()
```

<img src="inst/image/ft_span_headers.png" width="100%" />
