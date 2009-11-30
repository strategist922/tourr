#' Rescale a matrix or data frame
#'
#' Standardise each column to have range [0, 1]
#' 
#' @param df data frame or matrix
#' @keywords manip
rescale <- function(df) {
  apply(df, 2, function(x) (x - min(x)) / diff(range(x)))
}

#' Sphere a matrix (or data frame) by transforming variables to
#' principal components.
#'
#' Sphering is often useful in conjunction with the guided tour, as it 
#' removes simpler patterns that may conceal more interesting findings.
#'
#' @param df   data frame or matrix
#' @keywords manip
sphere <- function(df) {
  apply(predict(prcomp(df)), 2, scale)
}


#' A null function
#'
#' This function does nothing, and is a useful default callback function
#' 
#' @param ... all arguments to \code{...} are ignore
#' @keywords internal
nul <- function(...) {}


#' Set up a blank plot to display data projections
#' @keywords internal
blank_plot <- function(...) {
  plot(
    x = NA, y = NA, xlab = "", ylab = "",
    axes = FALSE, frame = TRUE, xaxs = "i", yaxs = "i",
    ...
  )  
}


#' Find the platform
#' Find the platform being used by the user
#' 
#' @keywords internal
find_platform <- function() {
  os <- R.Version()$os
  gui <- .Platform$GUI
  
  if (length(grep("linux", os)) == 1) {
    osType <- "lin"
  } else if (length(grep("darwin", os)) == 1) {
    osType <- "mac"
  } else {
    osType <- "win"    
  }
    
  if (osType %in% c("lin", "mac") && gui != "X11") {
    type <- "gui"
  } else if (osType == "win" && gui == "Rgui"){
    type <- "gui"
  } else {
    type <- "cli"    
  }

  list(os = osType, iface = type)
}

#' Prints information on how to stop the output
#'
#' This function prints the corresponding information on how to stop the plotting.
#' 
#' @keywords internal
to_stop <- function() {
  plat <- find_platform()
  if(plat$os == "win") {
    key <- "Ctrl + Break"
  } else if (plat$os == "mac" && plat$iface == "gui") {
    key <- "Esc"
  } else {
    key <- "Ctrl + C"
  }
  message("Press ", key, " to stop tour running")
}