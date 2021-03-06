% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pairwise.R
\name{means_and_counts}
\alias{means_and_counts}
\title{Get the means and counts for each categorical term in the model}
\usage{
means_and_counts(fit, term)
}
\arguments{
\item{fit}{A model fit by \code{\link[=lm]{lm()}} or \code{\link[=aov]{aov()}} (or similar).}

\item{term}{If \code{NULL}, use each categorical term in the model. Otherwise, only use the given
term.}
}
\value{
A list of the means and counts for each level of each term.
}
\description{
Get the means and counts for each categorical term in the model
}
\keyword{internal}
