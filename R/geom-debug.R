# Null geom ---------------------------------------------------------------

#' A null geom or 'no-op' geom.
#'
#' The null geom can be used to silence graphic output from a stat, such as
#' \code{stat_debug_group()} and \code{stat_debug_panel()} defined in this same
#' package. No visible graphical output is returned. An invisible
#' \code{grid::grid_null()} grob is returned instead.
#'
#' @param mapping Set of aesthetic mappings created by
#'   \code{\link[ggplot2]{aes}}. If specified and \code{inherit.aes = TRUE} (the
#'   default), are combined with the default mapping at the top level of the
#'   plot. You only need to supply \code{mapping} if there isn't a mapping
#'   defined for the plot.
#' @param data A data frame. If specified, overrides the default data frame
#'   defined at the top level of the plot.
#' @param position Position adjustment, either as a string, or the result of a
#'   call to a position adjustment function.
#' @param stat The statistical transformation to use on the data for this layer,
#'   as a string.
#' @param na.rm If \code{FALSE} (the default), removes missing values with a
#'   warning.  If \code{TRUE} silently removes missing values.
#' @param show.legend logical. Should this layer be included in the legends?
#'   \code{NA}, the default, includes if any aesthetics are mapped. \code{FALSE}
#'   never includes, and \code{TRUE} always includes.
#' @param inherit.aes If \code{FALSE}, overrides the default aesthetics, rather
#'   than combining with them. This is most useful for helper functions that
#'   define both data and aesthetics and shouldn't inherit behaviour from the
#'   default plot specification, e.g. \code{\link[ggplot2]{borders}}.
#' @param ... other arguments passed on to \code{\link[ggplot2]{layer}}. There
#'   are three types of arguments you can use here:
#'
#'   \itemize{ \item Aesthetics: to set an aesthetic to a fixed value, like
#'   \code{color = "red"} or \code{size = 3}. \item Other arguments to the
#'   layer, for example you override the default \code{stat} associated with the
#'   layer. \item Other arguments passed on to the stat.}
#'
#' @note This geom is very unusual in that it does not produce visible graphic
#'   output. It only returns a \code{\link[grid]{grid.null}} grob (graphical
#'   object). However, it accepts for consistency all the same parameters as
#'   normal geoms, which have no effect on the graphical output, except for
#'   \code{show.legend}.
#'
#' @return A plot layer instance. Mainly used for the side-effect of printing
#'   to the console the \code{data} object.
#'
#' @export
#'
#' @examples
#' ggplot(mtcars) +
#'   geom_null()
#'
#' ggplot(mtcars, aes(cyl, mpg)) +
#'   geom_null()
#'
#' # shape data
#'
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'
#'   ggplot(data = nc) +
#'     geom_null()
#' }
#'
geom_null <- function(mapping = NULL, data = NULL, stat = "identity",
                      position = "identity", na.rm = FALSE,
                      show.legend = FALSE,
                      inherit.aes = TRUE, ...) {
  ggplot2::layer(
    geom = GeomNull, mapping = mapping,  data = data, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm,
                  ...)
  )
}

#' @title 'ggproto' objects
#'
#' @description Internal use only definitions of 'ggproto' objects needed for
#'   geoms and stats.
#'
#' @rdname gginnards-ggproto
#' @format NULL
#' @usage NULL
#' @keywords internal
#'
#' @export
#'
GeomNull <-
  ggplot2::ggproto("GeomNull", ggplot2::Geom,
                   optional_aes = c("x", "y", "npcx", "npcy", "xend", "yend", "ymax", "ymin",
                                    "label", "colour", "fill",
                                    "shape", "size", "stroke",
                                    "linetype", "lineend", "linejoin",
                                    "angle", "family", "fontface", "hjust", "vjust"),
                   default_aes = ggplot2::aes(),
                   draw_key = function(...) {
                     grid::nullGrob()
                   },
                   draw_panel = function(data, panel_scales, coord,
                                         summary.fun,
                                         summary.fun.args) {
                     grid::nullGrob()
                   }
  )

# Debug geom --------------------------------------------------------------

#' Geom which prints input data to console.
#'
#' The debug geom is used to print to the console a summary of the data being
#' received by geoms as input \code{data} data frame.
#'
#' It can be useful when debugging the code of statistics or to learn how the
#' stats and geoms work in 'ggplot2' (>= 2.0.0).
#'
#' @param mapping Set of aesthetic mappings created by
#'   \code{\link[ggplot2]{aes}} or \code{\link{aes_}}. If specified and
#'   \code{inherit.aes = TRUE} (the default), is combined with the default
#'   mapping at the top level of the plot. You only need to supply
#'   \code{mapping} if there isn't a mapping defined for the plot.
#' @param data A data frame. If specified, overrides the default data frame
#'   defined at the top level of the plot.
#' @param summary.fun A function used to print the \code{data}
#'   object received as input.
#' @param summary.fun.args A list of additional arguments
#'   to be passed to \code{summary.fun}.
#' @param position Position adjustment, either as a string, or the result of a
#'   call to a position adjustment function.
#' @param stat The statistical transformation to use on the data for this layer,
#'   as a string.
#' @param na.rm If \code{FALSE} (the default), removes missing values with a
#'   warning.  If \code{TRUE} silently removes missing values.
#' @param show.legend logical. Should this layer be included in the legends?
#'   \code{NA}, the default, includes if any aesthetics are mapped. \code{FALSE}
#'   never includes, and \code{TRUE} always includes.
#' @param inherit.aes If \code{FALSE}, overrides the default aesthetics, rather
#'   than combining with them. This is most useful for helper functions that
#'   define both data and aesthetics and shouldn't inherit behaviour from the
#'   default plot specification, e.g. \code{\link[ggplot2]{borders}}.
#' @param parse Ignored. Helps avoid warnings.
#' @param ... other arguments passed on to \code{\link[ggplot2]{layer}}. There
#'   are three types of arguments you can use here:
#'
#'   \itemize{ \item Aesthetics: to set an aesthetic to a fixed value, like
#'   \code{color = "red"} or \code{size = 3}. \item Other arguments to the
#'   layer, for example you override the default \code{stat} associated with the
#'   layer. \item Other arguments passed on to the stat. }
#' @return This _geom_ is very unusual in that it does not produce visible graphic
#'   output. It only returns a \code{grid.null()} grob (graphical object). It
#'   passes its input as argument to the first parameter of the function
#'   passed as argument to `geom.summary.function`. This by default is the
#'   argument passed to `summary.fun`.
#'
#' @importFrom utils head
#' @export
#'
#' @examples
#' # echo to the R console \code{data} as received by geoms
#' ggplot(mtcars, aes(cyl, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   geom_debug()
#'
#' ggplot(mtcars, aes(cyl, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   geom_debug(summary.fun = head, summary.fun.args = list(n = 3))
#'
#' ggplot(mtcars, aes(cyl, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   geom_debug(summary.fun = nrow)
#'
#' ggplot(mtcars, aes(cyl, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   geom_debug(summary.fun = attributes)
#'
#' # echo to the R console \code{data} as received by geoms
#' ggplot(mtcars, aes(cyl, mpg, colour = factor(cyl))) +
#'   stat_summary(fun.data = "mean_se") +
#'   stat_summary(fun.data = "mean_se", geom = "debug")
#'
#' # shape data is not passed to geometries or statistics
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'
#'   ggplot(data = nc) +
#'     geom_sf(color = "darkblue", fill = "white") +
#'     geom_debug()
#' }
#'
geom_debug <- function(mapping = NULL,
                       data = NULL,
                       stat = "identity",
                       summary.fun = head,
                       summary.fun.args = list(),
                       parse = NULL,
                       position = "identity", na.rm = FALSE,
                       show.legend = FALSE,
                       inherit.aes = TRUE,
                       ...) {
  ggplot2::layer(
    geom = GeomDebug,
    mapping = mapping,
    data = data,
    stat = stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm,
                  summary.fun = summary.fun,
                  summary.fun.args = summary.fun.args)
  )
}

#' @rdname geom_debug
#' @export
geom_debug_npc <- geom_debug

#' @rdname gginnards-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomDebug <-
  ggplot2::ggproto("GeomDebug", ggplot2::Geom,
                   optional_aes = c("x", "y", "npcx", "npcy", "xend", "yend", "ymax", "ymin",
                                    "label", "colour", "fill",
                                    "shape", "size", "stroke",
                                    "linetype", "lineend", "linejoin",
                                    "angle", "family", "fontface", "hjust", "vjust"),
                   default_aes = ggplot2::aes(),
                   draw_panel = function(data, panel_scales, coord,
                                         summary.fun = head,
                                         summary.fun.args = list()) {
                     if (!is.null(summary.fun)) {
                       z <-  do.call(summary.fun, c(quote(data), summary.fun.args))
                     } else {
                       z <- data
                     }
                     cat("Input 'data' to 'draw_panel()':\n")
                     print(z)
                     if (is.data.frame(z) && nrow(data) > nrow(z)) {
                       cat("...\n")
                     }
                     cat("\n")
                     grid::nullGrob()
                   },
                   draw_key = function(...) {
                     grid::nullGrob()
                   }
  )
