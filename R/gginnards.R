#' @details The new facilities for cleanly defining new stats and geoms added to
#'   package 'ggplot2' in version 2.0.0 gave origin to this package. I needed
#'   tools to help me learn how layers work and to debug the extenssions to
#'   'ggplot2' that I was developing. I share them through this package in the
#'   hope that they will help other users of 'ggplot2' understand how this
#'   this vry popular graphics package works internally.
#'
#' Extensions provided:
#' \itemize{
#' \item "Debug" stats and a "debug" geom that print to the console a summary
#' of their \code{data} input.
#' \item Functions for inspecting and manipulating the list of layers of a
#' ggplot object.
#' \item Function that drops unused variables from the data embedded in
#' ggplot objects.
#' }
#'
#' @references
#' Package 'ggplot2' web site at \url{http://ggplot2.org/}\cr
#' Package 'ggplot2' documentation at \url{http://docs.ggplot2.org/}\cr
#' Package 'ggplot2' source code at \url{https://github.com/hadley/ggplot2}
#'
#' @import ggplot2
#' @importFrom ggplot2 ggplot
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
"_PACKAGE"
