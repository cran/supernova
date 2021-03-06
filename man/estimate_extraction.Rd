% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/value_extraction.R
\name{estimate_extraction}
\alias{estimate_extraction}
\alias{b0}
\alias{b1}
\alias{f}
\alias{pre}
\alias{sse}
\alias{ssm}
\alias{ssr}
\alias{fVal}
\alias{PRE}
\alias{SSE}
\alias{SSM}
\alias{SSR}
\title{Extract estimates/statistics from a model}
\usage{
b0(object, data = NULL, ...)

b1(object, data = NULL, ...)

f(object, data = NULL, ...)

pre(object, data = NULL, ...)

sse(object, data = NULL, ...)

ssm(object, data = NULL, ...)

ssr(object, data = NULL, ...)

fVal(object, data = NULL, ...)

PRE(object, data = NULL, ...)

SSE(object, data = NULL, ...)

SSM(object, data = NULL, ...)

SSR(object, data = NULL, ...)
}
\arguments{
\item{object}{A \code{\link{lm}} object, or \code{\link{formula}}.}

\item{data}{If \code{object} is a formula, the data to fit the formula to as a \code{\link{data.frame}}.}

\item{...}{Additional arguments passed through to \code{\link{lm}}.}
}
\value{
The value of the estimate as a single number.
}
\description{
This collection of functions is useful for extracting estimates and statistics from a fitted
model. They are particularly useful when estimating many models, like when bootstrapping
confidence intervals. Each function can be used with an already fitted model as an \code{\link{lm}} object,
or a formula and associated data can be passed to it. \strong{All of these assume the comparison is the
empty model.}
}
\details{
\itemize{
\item \strong{\code{b0}}: The intercept from the full model.
\item \strong{\code{b1}}: The slope b1 from the full model.
\item \strong{\code{fVal}}: The F value from the full model.
\item \strong{\code{PRE}}: The Proportional Reduction in Error for the full model.
\item \strong{\code{SSE}}: The SS Error (SS Residual) from the model.
\item \strong{\code{SSM}}: The SS Model (SS Regression) for the full model.
\item \strong{\code{SSR}}: Alias for SSM.
}
}
