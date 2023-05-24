#' Explore and manipulate the embedded data.
#'
#' Automatically remove unused variables from the "default" data object embedded
#' in a \code{gg} or \code{ggplot} object with \code{drop_vars()}. Explore data
#' variables and their use with \code{mapped_vars()}, \code{data_vars()} and
#' \code{data_attributes()}.
#'
#' @param p ggplot Plot object with embedded data.
#' @param keep.vars character Names of unused variables to be kept.
#' @param guess.vars logical Flag indicating whether to find used variables
#'   automatically.
#'
#' @export
#'
#' @note These functions are under development and not yet thoroughly tested!
#'   They are a demonstration of how one can manipulate the internals of
#'   \code{ggplot} objects creayed with 'ggplot2' versions 3.1.0 and later.
#'   These functions may stop working after some future update to the 'ggplot2'
#'   package. Although I will maintain this package for use in some of my other
#'   packages, there is no guarantee that I will be able to achieve this
#'   transparently.
#'
#'   Obviously, rather than using function \code{drop_vars()} after creating the
#'   \code{ggplot} object it is usually more efficient to select the variables
#'   of interest and pass a data frame containing only these to the
#'   \code{ggplot()} constructor.
#'
#' @section Warning!: The current implementation drops variables only from the
#'   default data object. Data objects within layers are not modified.
#'
#' @return A \code{"ggplot"} object that is a copy of \code{p} but containing
#'   only a subset of the variables in its default \code{data}.
#'
#' @examples
#' library(ggplot2)
#'
#' p <- ggplot(mpg, aes(factor(year), (cty + hwy) / 2)) +
#'   geom_boxplot() +
#'   facet_grid(. ~ class)
#'
#' mapped_vars(p) # those in use
#' mapped_vars(p, invert = TRUE) # those not used
#'
#' p.dp <- drop_vars(p) # we drop unused vars
#'
#' # number of columns in the data member
#' ncol(p$data)
#' ncol(p.dp$data)
#'
#' # which vars are in the data member
#' data_vars(p)
#' data_vars(p.dp)
#'
#' # which variables in data are used in the plot
#' mapped_vars(p)
#' mapped_vars(p.dp)
#'
#' # the plots identical
#' p
#' p.dp
#'
#' # structure and size of p
#' str(p, max.level = 0)
#' str(p.dp, max.level = 0) # smaller in size
#'
#' # structure and size of p["data"]
#' str(p, components = "data")
#' str(p.dp, components = "data") # smaller in size
#'
#' # shape data
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'
#'   p.sf <- ggplot(data = nc) +
#'           geom_sf()
#'   p.sf
#'   mapped_vars(p.sf)
#'   drop_vars(p.sf)
#' }
#'
drop_vars <- function(p, keep.vars = character(), guess.vars = TRUE) {
  stopifnot(ggplot2::is.ggplot(p))
  if (inherits(p$data, "sf")) {
    message("'drop_vars()' does not yet support shape file 'sf' data.")
    return(p)
  }
  if (guess.vars) {
    mapped.vars <- mapped_vars(p)
  } else {
    mapped.vars <- character()
  }
  data.vars <- names(p$data)
  unused.vars <- setdiff(data.vars, union(mapped.vars, keep.vars))
  keep.idxs <- which(!data.vars %in% unused.vars)
  p$data <- p$data[ , keep.idxs, drop = FALSE]
  p
}

#' @rdname drop_vars
#'
#' @param invert logical If TRUE return indices for elements of \code{data} that
#'    are not mapped to any aesthetic or facet.
#'
#' @return character vector with names of mapped variables in the default
#'    data object.
#'
#' @export
#'
mapped_vars <- function(p, invert = FALSE) {
  stopifnot(ggplot2::is.ggplot(p))
  # find all mappings
  mappings <- as.character(p$mapping)
  for (l in p$layers) {
    mappings <- c(mappings, as.character(l$mapping))
  }
  mappings <- c(mappings,
                names(p$facet$params$facets), # facet wrap
                names(p$facet$params$rows),   # facet grid
                names(p$facet$params$cols))   # facet grid
  mapped.vars <-
    gsub("[~*\\%^]", " ", mappings) %>%
    stringr::str_split(pattern = stringr::boundary("word")) %>%
    unlist()
  if (invert) {
    setdiff(names(p$data), mapped.vars)
  } else {
    intersect(names(p$data), mapped.vars)
  }
}

#' @rdname drop_vars
#'
#' @return character vector with names of all variables in the default
#'    data object.
#'
#' @export
#'
data_vars <- function(p) {
  stopifnot(ggplot2::is.ggplot(p))
  colnames(p$data)
}

#' @rdname drop_vars
#'
#' @return list containing all attributes of the default data object.
#'
#' @export
#'
data_attributes <- function(p) {
  stopifnot(ggplot2::is.ggplot(p))
  attributes(p$data)
}
