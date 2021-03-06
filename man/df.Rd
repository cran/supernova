% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/supernova.R
\name{df_term}
\alias{df_term}
\alias{df_variable}
\title{Get the degrees of freedom a variable or term uses}
\usage{
df_term(term, data)

df_variable(variable, data)
}
\arguments{
\item{term, variable}{The term or variable to get the degrees of freedom for. It should match one
of the column names in \code{data}, or, if it is an interactive term (e.g. "weight:height"), all
components must be column names in \code{data}.}

\item{data}{The data the term is from.}
}
\value{
The degrees of freedom used by the term or variable in the model (as an integer).
}
\description{
A term here is a predictor from a linear model (e.g. "weight" or "weight:height") whereas a
variable is a column in a data frame (e.g. "weight" or "height").
}
\keyword{internal}
