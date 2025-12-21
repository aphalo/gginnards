# used only in the file
# defined to avoid duplicating this list
#
optional.aes <-
  c(# ggplot2 at 3.5.1
    "group", "subgroup", "order",
    "x", "y", "z",
    "xintercept", "yintercept",
    "slope", "intercept",
    "sample",
    "xend", "yend",
    "ymax", "ymin",
    "xmax", "xmin",
    "middle", "xmiddle",
    "lower", "xlower",
    "upper", "xupper",
    "width", "height",
    "label",
    "hjust", "vjust",
    "colour", "color", "alpha", "fill",
    "shape", "size", "linewidth", "stroke",
    "linetype", "lineend", "linejoin",
    "angle", "radius",
    "family", "fontface", "lineheight",
    "map_id", "weight",
    "geometry",
    # ggpp at 0.6.0
    "vp.width", "vp.height",
    "npcx", "npcy",
    # ggrepel at 0.9.6
    "point.size", "segment.angle",
    "segment.curvature", "segment.ncp",
    "segment.shape", "segment.square",
    "segment.squareShape", "segment.inflect",
    "segment.debug",
    "segment.linetype",
    "segment.colour", "segment.color",
    "segment.size", "segment.alpha",
    # ggtext at 0.1.2
    "label.colour", "label.size",
    "text.colour",
    "box.colour", "box.size",
    "halign", "valign",
    "orientation",
    # marquee at 1.2.1
    "style"
  )

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
geom_null <- function(mapping = NULL,
                      data = NULL,
                      stat = "identity",
                      position = "identity",
                      na.rm = FALSE,
                      show.legend = FALSE,
                      inherit.aes = TRUE, ...) {
  ggplot2::layer(
    geom = GeomNull, mapping = mapping,  data = data, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = rlang::list2(na.rm = na.rm,
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
                   # needed to avoid warnings
                   optional_aes = optional.aes,
                   default_aes = ggplot2::aes(),
                   draw_key = function(...) {
                     grid::nullGrob()
                   },
                   draw_panel = function(data,
                                         panel_params,
                                         coord) {
                     grid::nullGrob()
                   }
  )

# Debug geom --------------------------------------------------------------

#' Geoms that print input data to console.
#'
#' The debug geoms are used to print to the console a summary of the object being
#' received by geoms' draw functions as input \code{data} and \code{parameters}
#' objects.
#'
#' It can be useful when debugging the code of statistics or to learn how the
#' stats and geoms work in 'ggplot2' (>= 3.0.0).
#'
#' @param mapping Set of aesthetic mappings created by
#'   \code{\link[ggplot2]{aes}} or \code{\link[ggplot2]{aes_}}. If specified and
#'   \code{inherit.aes = TRUE} (the default), is combined with the default
#'   mapping at the top level of the plot. You only need to supply
#'   \code{mapping} if there isn't a mapping defined for the plot.
#' @param data A data frame. If specified, overrides the default data frame
#'   defined at the top level of the plot.
#' @param dbgfun.data,dbgfun.params,summary.fun The functions as character
#'   strings giving their names or as named or anonymous function objects, to be
#'   used to summarize the \code{data} and the \code{params} objects received as
#'   input by the geometry.
#' @param dbgfun.data.args,dbgfun.params.args,summary.fun.args A named list of
#'   additional arguments to be passed to \code{dbgfun.data} and
#'   \code{dbgfun.params}.
#' @param dbgfun.print A function used to print the \code{data} object received
#'   as input.
#' @param dbgfun.print.args A named list. Currently ignored!
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
#' @param parse,orientation Ignored. Helps avoid warnings.
#' @param nudge_x,nudge_y Horizontal and vertical adjustments to nudge the
#'   starting position. The units for \code{nudge_x} and \code{nudge_y} are the
#'   same as for the data units on the x-axis and y-axis.
#' @param ... other arguments passed on to \code{\link[ggplot2]{layer}}. There
#'   are three types of arguments you can use here:
#'
#'   \itemize{ \item Aesthetics: to set an aesthetic to a fixed value, like
#'   \code{color = "red"} or \code{size = 3}. \item Other arguments to the
#'   layer, for example you override the default \code{stat} associated with the
#'   layer. \item Other arguments passed on to the stat. }
#'
#' @return The panel function of this geometry always returns a
#'   \code{\link[grid]{nullGrob}}, the legend is is also set to
#'   \code{\link[grid]{nullGrob}}. This geometry used for its text printing side
#'   effect.
#'
#' @details The intended use of \code{geom_debug_panel()} and
#'   \code{geom_debug_group()} is to explore the data as
#'   they are used in a plot layer to produce graphical output. Geometries
#'   can be defined using draw functions that receive as input data corresponding
#'   to a single group at a time, or draw functions that receive as input all
#'   data to be drawn in a panel at a time, possibly including multiple
#'   groups. Function \code{geom_debug()} is identical to
#'   \code{geom_debug_panel()}, and included for backwards compatibility.
#'
#'   These \emph{debug} geoms are very unusual in that they do not produce
#'   visible graphic output. They "draw" a \code{grid.null()} grob (graphical
#'   object) when the plot is rendered. Also, differently to normal geometries,
#'   they print the \code{data} and \code{params} objects or a summary of them
#'   to the R console. The summary is obtained using the functions passed as
#'   arguments to their formal parameter \code{dbgfun.data} and
#'   \code{dbgfun.params}. The \code{data} and \code{params} objects are passed
#'   as the first positional argument to these functions and the values they
#'   return are printed.
#'
#'   If \code{dbgfun.data = "I"} is passed, the \code{data} object is printed as
#'   is. In contrast, if \code{dbgfun.data = NULL} is passed, the \code{data}
#'   object summary and its printing are not skipped. The mechanism is identical
#'   for \code{dbgfun.params} and \code{params}.
#'
#'   Nudging with \code{nudge_x} and \code{nudge_y} behave as in
#'   \code{\link[ggplot2]{geom_text}}. Arguments passed to \code{position} are
#'   obeyed. So the effects of positions are reflected in the \code{data} object
#'   printed or summarized to the R console. The arguments passed to
#'   \code{parse} and \code{orientation} are currently ignored.
#'
#'   Many aesthetics are defined as optional so that they are accepted silently
#'   by \code{geom_debug()} and handled by 'ggplot2' as usual. Given the number
#'   available extensions to 'ggplot2', it is likely that some are missing.
#'
#'   The names of \code{dbgfun.data()} and \code{dbgfun.params()} are included
#'   in the section headers of the printout, together with panels and groups.
#'
#'   In most cases, the definitions of the debug and print functions must be
#'   available when the \code{"gg"} object is printed and the plot rendered.
#'
#' @note \code{geom_debug()} is a synonym of \code{geom_debug_panel()}, for
#'   backwards compatibility. Not to be used in new code.
#'
#' @seealso To access data, scales and grobs in a built ggplot, see
#'   \code{\link[ggplot2]{ggplot_build}}.
#'
#' @importFrom utils head
#' @export
#'
#' @examples
#' # echo to the R console \code{data} as received by geoms
#' ggplot(mtcars, aes(cyl, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   geom_debug_panel()
#'
#' ggplot(mtcars, aes(cyl, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   geom_debug_group()
#'
#' ggplot(mtcars, aes(cyl, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   geom_debug_panel(dbgfun.params = NULL)
#'
#' ggplot(mtcars, aes(cyl, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   geom_debug_panel(dbgfun.data = NULL)
#'
#' ggplot(mtcars, aes(cyl, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   geom_debug_panel(dbgfun.data = "head", dbgfun.data.args = list(n = 3))
#'
#' ggplot(mtcars, aes(cyl, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   geom_debug_panel(dbgfun.data = "nrow", dbgfun.params = "length")
#'
#' ggplot(mtcars, aes(cyl, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   geom_debug_panel(dbgfun.data = "attributes", dbgfun.params = "attributes")
#'
#' ggplot(mtcars, aes(cyl, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   geom_debug_panel(dbgfun.data = "I", dbgfun.params = NULL)
#'
#' # echo to the R console \code{data} as received by geoms
#' ggplot(mtcars, aes(cyl, mpg, colour = factor(cyl))) +
#'   stat_summary(fun.data = "mean_se") +
#'   stat_summary(geom = "debug_panel", fun.data = "mean_se")
#'
#' ggplot(mtcars, aes(cyl, mpg, colour = factor(cyl))) +
#'   stat_summary(fun.data = "mean_se") +
#'   stat_summary(geom = "debug_panel", fun.data = "mean_se", dbgfun.params = NULL)
#'
#' # shape data is not passed to geometries or statistics
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <-
#'     sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'
#'   ggplot(data = nc) +
#'     geom_sf(color = "darkblue", fill = "white") +
#'     geom_debug_panel()
#' }
#'
#' # backwards compatibility
#' ggplot(mtcars, aes(cyl, mpg, color = factor(cyl))) +
#'   geom_point() +
#'   geom_debug()
#'
#' ggplot(mtcars, aes(cyl, mpg, colour = factor(cyl))) +
#'   stat_summary(fun.data = "mean_se") +
#'   stat_summary(geom = "debug", fun.data = "mean_se")
#'
geom_debug_panel <- function(mapping = NULL,
                             data = NULL,
                             stat = "identity",
                             dbgfun.data = "head",
                             dbgfun.data.args = list(),
                             dbgfun.params = "summary",
                             dbgfun.params.args = list(),
                             dbgfun.print = "print",
                             dbgfun.print.args = list(),
                             parse = NULL,
                             orientation = NULL,
                             nudge_x = 0,
                             nudge_y = 0,
                             position = "identity",
                             na.rm = FALSE,
                             show.legend = FALSE,
                             inherit.aes = TRUE,
                             ...) {
  if (!missing(nudge_x) || !missing(nudge_y)) {
    if (!missing(position) && position != "identity") {
      rlang::abort("You must specify either `position` or `nudge_x`/`nudge_y`.")
    }
    # by default we keep the original positions
    position <- ggplot2::position_nudge(nudge_x, nudge_y)
  }

  ggplot2::layer(
    geom = GeomDebugPanel,
    mapping = mapping,
    data = data,
    stat = stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = rlang::list2(na.rm = na.rm,
                          ...,
                          dbgfun.data = dbgfun.data,
                          dbgfun.data.args = dbgfun.data.args,
                          dbgfun.params = dbgfun.params,
                          dbgfun.params.args = dbgfun.params.args,
                          dbgfun.print = dbgfun.print,
                          dbgfun.print.args = dbgfun.print.args,
                          draw.label = "draw_panel()")
  )
}

#' @rdname geom_debug_panel
#'
#' @export
#'
geom_debug_group <- function(mapping = NULL,
                             data = NULL,
                             stat = "identity",
                             dbgfun.data = "head",
                             dbgfun.data.args = list(),
                             dbgfun.params = "summary",
                             dbgfun.params.args = list(),
                             dbgfun.print = "print",
                             dbgfun.print.args = list(),
                             parse = NULL,
                             orientation = NULL,
                             nudge_x = 0,
                             nudge_y = 0,
                             position = "identity",
                             na.rm = FALSE,
                             show.legend = FALSE,
                             inherit.aes = TRUE,
                             ...) {
  if (!missing(nudge_x) || !missing(nudge_y)) {
    if (!missing(position) && position != "identity") {
      rlang::abort("You must specify either `position` or `nudge_x`/`nudge_y`.")
    }
    # by default we keep the original positions
    position <- ggplot2::position_nudge(nudge_x, nudge_y)
  }

  ggplot2::layer(
    geom = GeomDebugGroup,
    mapping = mapping,
    data = data,
    stat = stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = rlang::list2(na.rm = na.rm,
                          ...,
                          dbgfun.data = dbgfun.data,
                          dbgfun.data.args = dbgfun.data.args,
                          dbgfun.params = dbgfun.params,
                          dbgfun.params.args = dbgfun.params.args,
                          dbgfun.print = dbgfun.print,
                          dbgfun.print.args = dbgfun.print.args,
                          draw.label = "draw_group()")
  )
}

# For backwards compatibility we fake the old function name
#
#' @rdname geom_debug_panel
#'
#' @section Defunct: \code{geom_debug()} has been replaced by
#'  \code{geom_debug_group()}.
#'
#' @export
#'
geom_debug <- function(...) {
  warning("'geom_debug()' has been replaced by 'geom_debug_group()'.")
  geom_debug_group(...)
}

#' @rdname gginnards-ggproto
#' @format NULL
#' @usage NULL
#' @export
debug_draw_function <- function(data,
                                panel_params,
                                coord,
                                dbgfun.data = "head",
                                dbgfun.data.args = list(),
                                dbgfun.params = NULL,
                                dbgfun.params.args = list(),
                                dbgfun.print = "print",
                                dbgfun.print.args = list(),
                                draw.label = "draw_function()") {

  if (is.character(dbgfun.print)) {
    dbgfun.print <- match.fun(dbgfun.print)
  } else if (!is.function(dbgfun.print)) {
    dbgfun.print <- print
  }

  if (!is.null(dbgfun.data)) {
    if (is.character(dbgfun.data)) {
      dbgfun.data.name <- dbgfun.data
      dbgfun.data <- match.fun(dbgfun.data)
    } else if (!is.null(dbgfun.data)) {
      dbgfun.data.name <- deparse(substitute(dbgfun.data))
      if (length(dbgfun.data.name) > 1) {
        dbgfun.data.name <- "anonymous function"
      }
    }
    data.header <- sprintf("PANEL %i; group(s) %s; '%s' input 'data' (%s):",
                           unclass(data$PANEL[1]),
                           paste(format(sort(unique(data$group))), collapse = ", "),
                           draw.label,
                           dbgfun.data.name)
    zz <-  do.call(dbgfun.data, c(quote(data), dbgfun.data.args))
    dbgfun.print(data.header)
    dbgfun.print(zz)
  }

  if (!is.null(dbgfun.params)) {
    if (is.character(dbgfun.params)) {
      dbgfun.params.name <- dbgfun.params
      dbgfun.params <- match.fun(dbgfun.params)
    } else if (!is.null(dbgfun.params)) {
      dbgfun.params.name <- deparse(substitute(dbgfun.params))
    }
    params.header <- sprintf("PANEL %i; group(s) %s; '%s' input 'params' (%s):",
                             unclass(data$PANEL[1]),
                             paste(format(sort(unique(data$group))), collapse = ", "),
                             draw.label,
                             dbgfun.params.name)
    zz <-  do.call(dbgfun.params, c(quote(panel_params), dbgfun.params.args))
    dbgfun.print(params.header)
    dbgfun.print(zz)
  }

  grid::nullGrob()
}

#' @rdname gginnards-ggproto
#' @format NULL
#' @usage NULL
#'
#' @export
GeomDebugPanel <-
  ggplot2::ggproto("GeomDebugPanel", ggplot2::Geom,
                   # needed to avoid warnings
                   optional_aes = optional.aes,
                   default_aes = ggplot2::aes(),
                   draw_panel = debug_draw_function,
                   draw_key = function(...) {
                     grid::nullGrob()
                   }
  )

#' @rdname gginnards-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomDebugGroup <-
  ggplot2::ggproto("GeomDebugGroup", ggplot2::Geom,
                   # needed to avoid warnings
                   optional_aes = optional.aes,
                   default_aes = ggplot2::aes(),
                   draw_group = debug_draw_function,
                   draw_key = function(...) {
                     grid::nullGrob()
                   }
  )
