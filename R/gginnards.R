#' @details The new facilities for cleanly defining new stats and geoms added to
#'   package 'ggplot2' in version 2.0.0 gave origin to this package. I needed
#'   tools to help me learn how layers work and to debug the extenssions to
#'   'ggplot2' that I was developing. I share them through this package in the
#'   hope that they will help other users of 'ggplot2' understand how this
#'   this vry popular graphics package works internally. The vignettes provide
#'   examples of how to use this tools both for debugging and learning how
#'   ggplots are stored.
#'
#' Extensions provided:
#' \itemize{
#' \item "Debug" stats and a "debug" geom that print to the console a summary
#' of their \code{data} input.
#' \item Functions for inspecting and manipulating the list of layers of a
#' ggplot object.
#' \item Functions for exploring and manipulating the data embedded in
#' ggplot objects, including dropping unused variables.
#' }
#'
#' @references
#' Package 'tidyverse' web site at \url{https://www.tidyverse.org/}\cr
#' Package 'ggplot2' documentation at \url{https://ggplot2.tidyverse.org/}\cr
#' Package 'ggplot2' source code at \url{https://github.com/tidyverse/ggplot2}
#'
#' @import ggplot2
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
"_PACKAGE"
