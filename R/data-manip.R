#' Drop unused variables from data
#'
#' Automatically remove unused variables from the data object embedded in a
#' \code{gg} or \code{ggplot} object.
#'
#' @param p ggplot Plot object with embedded data.
#' @param keep.vars character Names of unused variables to be kept.
#' @param guess.vars logical Flag indicating whether to find used variables
#'    automatically.
#'
#' @export
#'
#' @note This function is under development and not yet thoroughly tested! It is
#'   a demonstration of how one can manipulate the internals of \code{ggplot}
#'   objects. This function may stop working after some future update to the
#'   'ggplot2' package.
#'
#'   Rather than using this function after creating the \code{ggplot} object it
#'   may be more efficient to extract the variables of interest and pass a data
#'   frame containing only these to the \code{ggplot()} constructor.
#'
#' @section Warning!: The current implementation drops variables only from the
#'   default data object. Data objects within layers are not modified.
#'
#' @examples
#' library(ggplot2)
#'
#' p <- ggplot(mpg, aes(factor(year), (cty + hwy) / 2)) +
#'   geom_boxplot() +
#'   facet_grid(. ~ class)
#' p
#'
#' p.dp <- drop_vars(p)
#' p.dp
#'
#' object.size(p)
#' object.size(p.dp)
#'
#' names(p$data)
#' names(p.dp$data)
#'
drop_vars <- function(p, keep.vars = character(), guess.vars = TRUE) {
  if (guess.vars) {
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
  } else {
    mapped.vars <- character()
  }
  data.vars <- names(p$data)
  unused.vars <- setdiff(data.vars, union(mapped.vars, keep.vars))
  keep.idxs <- which(!data.vars %in% unused.vars)
  p$data <- dplyr::select(p$data, keep.idxs)
  p
}
