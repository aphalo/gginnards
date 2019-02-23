#' Show the structure of a ggplot object.
#'
#' A \code{str()} method tailored to objects of class \code{"ggplot"}. It adds
#' to the output the size of the object, and the ability to subset
#' individual components.
#'
#' @param object ggplot Plot object with embedded data.
#' @param components Vector of components to print, as indexes into
#'   \code{object}.
#' @param max.level integer Maximum depth of recursion (of lists within lists
#'   ...) to be printed.
#' @param vec.len integer Approximate maximum length allowed when showing the
#'   first few values of a vector.
#' @param list.len integer Maximum number of components to show of any list that
#'   will be described.
#' @param give.attr logical Flag, determining whether a description of
#'   attributes will be shown.
#' @param nest.lev numeric current nesting level in the recursive calls to
#'   \code{str()}.
#' @param indent.str character String used for each level of indentation.
#' @param comp.str character String to be used for separating list components.
#' @param size logical Flag, should the size of the object in bytes be printed?
#' @param ... accept additional parameter arguments
#'
#' @return A NULL is returned invisibly. While a description of the
#'   structure of \code{p} or its components will be printed in outline form as
#'   a "side-effect", with indentation for each level of recursion, showing the
#'   internal storage mode, class(es) if any, attributes, and first few
#'   elements of each data vector. By default each level of list recursion is
#'   indicated and attributes enclosed in angle brackets.
#'
#' @seealso A \code{summary()} method for class \code{ggplot} is defined by
#'   package 'ggplot2'. Method \code{summary()} provides a more compact
#'   description of \code{"ggplot"} objects than method \code{str()}. Here we
#'   provide a wrapper on R's \code{str()} with different default arguments. A
#'   summary does not directly describe how the different components of an R
#'   object are stored, while the structure does.
#'
#' @importFrom utils str
#'
#' @export
#'
#' @name str
#'
#' @examples
#' library(ggplot2)
#'
#' p <- ggplot(mpg, aes(factor(year), (cty + hwy) / 2)) +
#'   geom_boxplot() +
#'   geom_point(color = "red") +
#'   facet_grid(. ~ class) +
#'   ggtitle("Example plot")
#'
#' p
#'
#' # str(p) vs. summary(p)
#' str(p, max.level = 1, size = FALSE)
#' summary(p)
#'
#' # structure of p at 2 levels of nesting
#' str(p, max.level = 2)
#'
#' # top level structure and size of p
#' str(p, max.level = 0)
#'
#' # structure and size of p["data"]
#' str(p, components = "data")
#'
str.ggplot <- function(object, ...,
                       max.level = 1, components = TRUE,
                       vec.len = 2, list.len = 99,
                       give.attr = FALSE,
                       comp.str = "$ ",
                       nest.lev = 0,
                       indent.str = paste(rep.int(" ", max(0, nest.lev + 1)),
                                                           collapse = ".."),
                       size = TRUE) {
  object <- object[components]

  if (size) {
    cat("Object size: ", format(utils::object.size(object),
               units = "auto", standard = "SI"),
        "\n", sep = "")
  }
  str(object = object,
      max.level = max.level,
      vec.len = vec.len,
      list.len = list.len,
      give.attr = give.attr,
      comp.str = comp.str,
      indent.str = indent.str
      )
  invisible()
}

