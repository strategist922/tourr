% Generated by roxygen2 (4.0.0): do not edit by hand
\name{frozen_tour}
\alias{frozen_tour}
\title{A frozen tour path.}
\usage{
frozen_tour(d = 2, frozen)
}
\arguments{
\item{d}{target dimensionality}

\item{frozen}{matrix of frozen variables, as described in
\code{\link{freeze}}}
}
\description{
A frozen tour fixes some of the values of the orthonormal projection
matrix and allows the others to vary freely according to any of the
other tour methods.  This frozen tour is a frozen grand tour.  See
\code{\link{frozen_guided_tour}} for a frozen guided tour.
}
\details{
Usually, you will not call this function directly, but will pass it to
a method that works with tour paths like \code{\link{animate}},
\code{\link{save_history}} or \code{\link{render}}.
}
\examples{
frozen <- matrix(NA, nrow = 4, ncol = 2)
frozen[3, ] <- .5
animate_xy(flea[, 1:4], frozen_tour(2, frozen))

\dontrun{
  # Doesn't work - a bug?
  frozen <- matrix(NA, nrow = 4, ncol = 2)
  frozen[1, 1] <- 0.5
  animate_xy(flea[, 1:4], frozen_tour(2, frozen))

  # Doesn't work - a bug?
  frozen <- matrix(NA, nrow = 4, ncol = 2)
  frozen[, 1] <- 1/2
  animate_xy(flea[, 1:4], frozen_tour(2, frozen))

  # Doesn't work - a bug?
  frozen[3, ] <- c(0, 1)
  animate_xy(flea[, 1:4], frozen_tour(2, frozen))

  # Doesn't move, which is correct - no free variables
  frozen[4, ] <- .2
  animate_xy(flea[, 1:4], frozen_tour(2, frozen))

  # Doesn't work - a bug?
  frozen <- matrix(NA, nrow = 4, ncol = 2)
  frozen[, 1] <- 1/2
  animate_xy(flea[, 1:4], frozen_tour(2, frozen))
}
# Two frozen variables in five 5.
frozen <- matrix(NA, nrow = 5, ncol = 2)
frozen[3, ] <- .5
frozen[4, ] <- c(-.2, .2)
animate_xy(flea[, 1:5], frozen_tour(2, frozen))
}

