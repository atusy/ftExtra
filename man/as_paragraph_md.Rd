% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/as-paragraph-md.R
\name{as_paragraph_md}
\alias{as_paragraph_md}
\title{Convert a character vector into markdown paragraph(s)}
\usage{
as_paragraph_md(
  x,
  auto_color_link = "blue",
  md_extensions = NULL,
  pandoc_args = NULL,
  metadata = rmarkdown::metadata,
  replace_na = "",
  .from = "markdown+autolink_bare_uris-raw_html-raw_attribute",
  .footnote_options = NULL,
  ...
)
}
\arguments{
\item{x}{A character vector.}

\item{auto_color_link}{A color of the link texts.}

\item{md_extensions}{Pandoc's extensions. Although it is prefixed with "md", extensions for any
formats specified to \code{.from} can be used. See
\url{https://www.pandoc.org/MANUAL.html#extensions} for details.}

\item{pandoc_args}{Additional command line options to pass to pandoc}

\item{metadata}{A list of metadata, typically the parsed result of the YAML front matter
(default: \code{rmarkdown::metadata}). This value is used iff the \code{.from}
argument specifies the input format that supports the YAML metadata blocks.}

\item{replace_na}{A value to replace \code{NA} (default = \code{""}).}

\item{.from}{Pandoc's \code{--from} argument (default: \code{'markdown+autolink_bare_uris'}).}

\item{.footnote_options}{Options for footnotes generated by \code{footnote_options()}.}

\item{...}{Arguments passed to internal functions.}
}
\description{
Parse markdown cells and returns the "paragraph" object.
}
\examples{
if (rmarkdown::pandoc_available("2.0.6")) {
  library(flextable)
  ft <- flextable(
    data.frame(
      x = c("**foo** bar", "***baz***", "*qux*"),
      stringsAsFactors = FALSE
    )
  )
  ft <- compose(ft, j = "x", i = 1:2, value = as_paragraph_md(x))
  autofit(ft)
}
}
