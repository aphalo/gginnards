#' @title Print to console data received by the compute panel function.
#'
#' @description \code{stat_debug} reports all distinct values in \code{group}
#'   and \code{PANEL}, and \code{nrow}, \code{ncol} and the names of the columns
#'   or variables, and the class of x and y for each panel in a ggplot as passed
#'   to the \code{compute_panel} function in the \code{ggproto} object.
#'
#' @param mapping The aesthetic mapping, usually constructed with
#'   \code{\link[ggplot2]{aes}} or \code{\link[ggplot2]{aes_}}. Only needs
#'   to be set at the layer level if you are overriding the plot defaults.
#' @param data A layer specific dataset - only needed if you want to override
#'   the plot defaults.
#' @param geom The geometric object to use display the data
#' @param summary.fun,geom.summary.fun A function used to print the \code{data}
#'   object received as input.
#' @param summary.fun.args,geom.summary.fun.args A named list.
#' @param position The position adjustment to use for overlapping points on this
#'   layer
#' @param show.legend logical. Should this layer be included in the legends?
#'   \code{NA}, the default, includes if any aesthetics are mapped. \code{FALSE}
#'   never includes, and \code{TRUE} always includes.
#' @param inherit.aes If \code{FALSE}, overrides the default aesthetics, rather
#'   than combining with them. This is most useful for helper functions that
#'   define both data and aesthetics and shouldn't inherit behaviour from the
#'   default plot specification, e.g. \code{\link[ggplot2]{borders}}.
#' @param ... other arguments passed on to \code{\link[ggplot2]{layer}}. This
#'   can include aesthetics whose values you want to set, not map. See
#'   \code{\link[ggplot2]{layer}} for more details.
#' @param na.rm	a logical value indicating whether NA values should be stripped
#'   before the computation proceeds.
#'
#' @section Computed variables:
#' \describe{
#'   \item{x}{x at centre of range}
#'   \item{y}{y at centre of range}
#'   \item{nrow}{\code{nrow()} of \code{data} object}
#'   \item{ncol}{\code{ncol()} of \code{data} object}
#'   \item{colnames}{\code{colnames()} of \code{data} object}
#'   \item{colclasses}{\code{class()} of \code{x} and \code{y} columns in \code{data} object}
#'   \item{group}{all distinct values in group as passed in \code{data} object}
#'   \item{PANEL}{all distinct values in PANEL as passed in \code{data} object}
#'   }
#'
#' @return A tibble with a summary of the \code{data} received, which is not
#'    printed by default using \code{geom_null()}. Can be printed by passing
#'    \code{geom = "debug"}.
#'
#' @details This stat is meant to be used for the side-effect of printing to the
#'   console the \code{data} object received as input by the
#'   \code{compute_panel()} function, or a summary of it. This is the same as
#'   for any other statistics passed the same arguments (including defaults that
#'   may need to be overridden if they differ).
#'
#'   In principle any geom can be passed as argument to override \code{"null"}.
#'   Keep in mind that this stat sets default mappings only for the \emph{x} and
#'   \emph{y} aesthetics: \code{geom_debug()} and \code{geom_text()} are
#'   useful.
#'
#' @examples
#' my.df <- data.frame(x = rep(1:10, 2),
#'                     y = rep(c(1,2), c(10,10)) + rnorm(20),
#'                     group = rep(c("A","B"), c(10,10)))
#'
#' # by default head() is used to show the top rows of data object
#' # and geom_null() to silence the data returned by the stat
#' ggplot(my.df, aes(x,y)) +
#'   geom_point() +
#'   stat_debug_panel()
#'
#' # geom_debug prints the data returned by the stat
#' ggplot(my.df, aes(x,y)) +
#'   geom_point() +
#'   stat_debug_panel(geom = "debug")
#'
#' # to print only the the data returned by the stat
#' # we pass as summary function a function that always returns NULL
#' ggplot(my.df, aes(x,y)) +
#'   geom_point() +
#'   stat_debug_panel(geom = "debug",
#'                    summary.fun = function(x) {NULL})
#'
#' ggplot(my.df, aes(x,y)) +
#'   geom_point() +
#'   stat_debug_panel(aes(label = sprintf("nrow = %i, ncol = %i, colnames: %s",
#'                                        after_stat(nrow),
#'                                        after_stat(ncol),
#'                                        after_stat(colnames))),
#'                    geom = "text")
#'
#' # here we show all the data object
#' ggplot(my.df, aes(x,y)) +
#'   geom_point() +
#'   stat_debug_panel(summary.fun = NULL)
#'
#' ggplot(my.df, aes(x,y)) +
#'   geom_point() +
#'   stat_debug_panel(summary.fun = "nrow")
#'
#' # with grouping
#' ggplot(my.df, aes(x,y, colour = group)) +
#'   geom_point() +
#'   stat_debug_panel(summary.fun = NULL)
#'
#' ggplot(my.df, aes(x,y)) +
#'   geom_point() +
#'   facet_wrap(~group) +
#'   stat_debug_panel()
#'
#' # by default head() is used to show the top rows of data object
#' ggplot(my.df, aes(group,y)) +
#'   geom_point() +
#'   stat_debug_panel()
#'
#' @export
#' @family diagnosis functions
#'
stat_debug_panel <-
  function(mapping = NULL,
           data = NULL,
           geom = "null",
           summary.fun = "head",
           summary.fun.args = list(),
           geom.summary.fun = NULL,
           geom.summary.fun.args = list(),
           position = "identity",
           na.rm = FALSE,
           show.legend = FALSE,
           inherit.aes = TRUE,
           ...) {
    if (geom == "debug") {
      params <- rlang::list2(na.rm = na.rm,
                             stat.summary.fun = summary.fun,
                             stat.summary.fun.args = summary.fun.args,
                             summary.fun = geom.summary.fun,
                             summary.fun.args = geom.summary.fun.args,
                             ...)
    } else {
      # avoid warning when other geoms are used
      params <- rlang::list2(na.rm = na.rm,
                             stat.summary.fun = summary.fun,
                             stat.summary.fun.args = summary.fun.args,
                             ...)
    }

    ggplot2::layer(
      stat = StatDebugPanel,
      data = data,
      mapping = mapping,
      geom = geom,
      position = position,
      show.legend = show.legend,
      inherit.aes = inherit.aes,
      params = params
    )
}

#' @rdname gginnards-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatDebugPanel <-
  ggplot2::ggproto(
    "StatDebugPanel",
    ggplot2::Stat,
    compute_panel =
      function(data, scales,
               stat.summary.fun = head,
               stat.summary.fun.args = list()) {
        if (is.null(stat.summary.fun)) {
          header.text <- "Input 'data' to 'compute_panel()':"
          z <- data
        } else {
          if (is.character(stat.summary.fun)) {
            header.text <- sprintf("Summary (%s) of input 'data' to 'compute_panel()':",
                                   stat.summary.fun)
          } else {
            header.text <- "Summary of input 'data' to 'compute_panel()':"
          }
           z <-  do.call(stat.summary.fun, c(quote(data), stat.summary.fun.args))
        }
        if (!is.null(z)) {
          print(header.text)
          print(z)
        }
        tibble::tibble(x = mean(range(data$x)),
                       y = mean(range(data$y)),
                       nrow = nrow(data),
                       ncol = ncol(data),
                       colnames = list(colnames(data)),
                       class.x = class(data$x),
                       class.y = class(data$y),
                       groups = list(unique(data$group)))
      },
    required_aes = c("x", "y")
  )
