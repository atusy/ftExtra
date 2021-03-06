% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/as-flextable.R
\name{as_flextable_methods}
\alias{as_flextable_methods}
\alias{as_flextable.grouped_df}
\alias{as_flextable.data.frame}
\title{method to convert object to flextable}
\usage{
\method{as_flextable}{grouped_df}(
  x,
  groups_to = c("titles", "merged", "asis"),
  groups_pos = c("left", "asis"),
  ...
)

\method{as_flextable}{data.frame}(x, col_keys = names(x), ...)
}
\arguments{
\item{x}{object to be transformed as flextable}

\item{groups_to}{One of \code{titles}, \code{merged}, or \code{asis}. See examples for the result.}

\item{groups_pos}{When \code{groups_to = "merged"}, grouping columns are reordered according to
\code{group_pos}. Choices are \code{left} (default) or \code{asis}.}

\item{...}{arguments for custom methods}

\item{col_keys}{columns names/keys to display. If some column names are not in
the dataset, they will be added as blank columns by default.}
}
\description{
This is a convenient function
to let users create flextable bindings
from any objects.
}
\examples{

# For grouped_df
grouped_df <- iris \%>\%
  dplyr::group_by(Species) \%>\%
  dplyr::slice(1, 2)

as_flextable(grouped_df, groups_to = "titles")
as_flextable(grouped_df, groups_to = "titles", hide_grouplabel = TRUE)
as_flextable(grouped_df, groups_to = "merged")
as_flextable(grouped_df, groups_to = "asis")
# For data.frame
iris \%>\%
  head() \%>\%
  as_flextable()
}
\seealso{
Other as_flextable methods: 
\code{\link[flextable]{as_flextable.gam}()},
\code{\link[flextable]{as_flextable.glm}()},
\code{\link[flextable]{as_flextable.grouped_data}()},
\code{\link[flextable]{as_flextable.htest}()},
\code{\link[flextable]{as_flextable.lm}()},
\code{\link[flextable]{as_flextable.xtable}()}
}
