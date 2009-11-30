#' Save tour history.
#'
#' Save a tour path so it can later be displayed in many different ways.
#'
#' @param data matrix, or data frame containing numeric columns
#' @param tour_path tour path generator, defaults to the grand tour
#' @param max_bases maximum number of new bases to generate.  Some tour paths
#'  (like the guided tour) may generate less than the maximum.
#' @param start starting projection, if you want to specify one
#' @param rescale if true, rescale all variables to range [0,1]?
#' @param sphere if true, sphere all variables
#'
#' @examples
#' # You can use a saved history to replay tours with different visualisations
#'
#' t1 <- save_history(flea[, 1:6], max = 3)
#' animate_xy(flea[, 1:6], planned_tour(t1))
#' ##andrews_history(t1)
#' ##andrews_history(interpolate(t1))
#'
#' t1 <- save_history(flea[, 1:6], grand_tour(4), max = 3)
#' animate_pcp(flea[, 1:6], planned_tour(t1))
#' animate_scatmat(flea[, 1:6], planned_tour(t1))
#'
#' t1 <- save_history(flea[, 1:6], grand_tour(1), max = 3)
#' animate_dist(flea[, 1:6], planned_tour(t1))
#'
#' testdata <- matrix(rnorm(100*3), ncol=3)
#' testdata[1:50, 1] <- testdata[1:50, 1] + 10
#' testdata <- sphere(testdata)
#' t2 <- save_history(testdata, guided_tour(holes, max.tries = 100), 
#'   max = 5, rescale=FALSE)
#' animate_xy(testdata, planned_tour(t2))
#'
#' # Or you can use saved histories to visualise the path that the tour took.
#' plot(history_index(interpolate(t2), holes))
#' plot(history_curves(interpolate(t2)))
save_history <- function(data, tour_path = grand_tour(), max_bases = 100, start = NULL, rescale = TRUE, sphere = FALSE){
  if (rescale) data <- rescale(data)
  if (sphere) data  <- sphere(data)
  
  # A bit inefficient, but saves changes to rest of tour code
  # Basically ensures that we only ever jump from one basis to the next:
  # don't use any geodesic interpolation
  velocity <- 10
  
  if (is.null(start)) {
    start <- tour_path(NULL, data)    
  }

  projs <- array(NA, c(ncol(data), ncol(start), max_bases + 1))
  princ_dirs <- projs
  projs[, , 1] <- start
  count <- 1
  
  target <- function(target, geodesic) {
    if (is.null(target)) return()
    count <<- count+1
    projs[, , count] <<- target
    princ_dirs[, , count] <<- geodesic$Gz
  }

  tour(data, tour_path, start = start,
    velocity = velocity, total_steps = max_bases,
    target_fun = target
  )
  
  # Remove empty matrices for tours that terminated early
  # (e.g. guided tour)
  empty <- apply(projs, 3, function(x) all(is.na(x)))
  projs <- projs[, , !empty, drop = FALSE]
  
  attr(projs, "data") <- data
  structure(projs, class = "history_array")
}

#' Subset history array
#' 
#' @keywords internal
#' @method [ history_array
#' @aliases [.history_array
#' @name subset-history_array
"[.history_array" <- function(x, ...) {
  sub <- NextMethod()
  class(sub) <- class(x)
  attr(sub, "data") <- attr(x, "data")
  sub
}

#' Prints the History Array
#' Prints the History Array in a useful format  
#' 
#' @method print history_array
#' @keywords internal
print.history_array <- function(x, ...) {
  attr(x, "data") <- NULL
  NextMethod()
}

#' Make into a List from History List
#' 
#' @method as.list history_list
#' @keywords internal
as.list.history_list <- function(x, ...) x

#' Make into a List from History Array
#' 
#' @method as.list history_array
#' @keywords internal
as.list.history_array <- function(x, ...) {
  n <- dim(x)[3]
  projs <- vector("list", n)
  for (i in seq_len(n)) {
    projs[[i]] <- as.matrix(x[, , i])
  }
  structure(projs, class = "history_list", data = attr(x, "data"))
}

#' Make into an Array from History Array
#' 
#' @method as.array history_array
#' @keywords internal
as.array.history_array <- function(x, ...) x


#' Make into an Array from History List
#' 
#' @method as.array history_list
#' @keywords internal
as.array.history_list <- function(x, ...) {
  dims <- c(nrow(x[[1]]), ncol(x[[1]]), length(x))
  projs <- array(NA, dims)
  for (i in seq_along(x)) {
    projs[, , i] <- x[[i]]
  }
  structure(projs, class = "history_array", data = attr(x, "data"))
}