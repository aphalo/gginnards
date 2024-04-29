#' @title Print to console data received by the compute group function.
#'
#' @description \code{stat_debug_group} does not modify \code{data} but can
#'   echo to the R console its \code{data} input or a summary of it.
#'
#' @param mapping The aesthetic mapping, usually constructed with
#'   \code{\link[ggplot2]{aes}} or \code{\link[ggplot2]{aes_}}. Only needs
#'   to be set at the layer level if you are overriding the plot defaults.
#' @param data A layer specific dataset - only needed if you want to override
#'   the plot defaults.
#' @param geom The geometric object to use display the data
#' @param fun.data A function taking a data frame as its first argument and
#'   returning a data frame. This function does the computations generating
#'   the value passed from the statistic to the downstream geometry.
#' @param fun.data.args A named list of additional arguments to be passed to
#'   \code{fun.data}.
#' @param dbgfun.data,geom.dbgfun.data,geom.dbgfun.params A
#'   functions used to summarise the \code{data} and \code{parameters} object
#'   received as input by the statistic and geome.
#' @param dbgfun.data.args,geom.dbgfun.data.args,geom.dbgfun.params.args
#'   A named list.
#' @param dbgfun.data,geom.dbgfun.data,geom.dbgfun.params,dbgfun.print A
#'   function used to print the \code{data} object received as input.
#' @param dbgfun.data.args,geom.dbgfun.data.args,geom.dbgfun.params.args,dbgfun.print.args
#'   A named list.
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
#' @section Computed variables: \describe{ \item{x}{x at centre of range}
#'   \item{y}{y at centre of range} \item{nrow}{\code{nrow()} of \code{data}
#'   object} \item{ncol}{\code{ncol()} of \code{data} object}
#'   \item{colnames}{\code{colnames()} of \code{data} object}
#'   \item{colclasses}{\code{class()} of \code{x} and \code{y} columns in
#'   \code{data} object} \item{group}{all distinct values in group as passed in
#'   \code{data} object} \item{PANEL}{all distinct values in PANEL as passed in
#'   \code{data} object} }
#'
#' @return A copy of its \code{data} input, which is an object of class
#'    \code{"data.frame"} or inheriting from \code{"data.frame"}.
#'
#' @details This stat is meant to be used for the side-effect of printing to the
#'   console the \code{data} object received as input by the
#'   \code{compute_group()} function, or a summary of it. This is the same as
#'   for any other statistics passed the same arguments (including defaults that
#'   may need to be overridden if they differ).
#'
#'   In principle any geom can be passed as argument to override \code{geom = "null"},
#'   but \code{geom = "debug"} is treated as a special case and functions
#'   \code{geom.dbgfun.data} and \code{geom.dbgfun.params}, and lists
#'   \code{geom.dbgfun.data.args} and \code{geom.dbgfun.params.args} renamed and
#'   passed to the geometry. Arguments passed to these four formal parameters
#'   are not passed to other geometries.
#'
#'   Keep in mind that this stat sets default mappings only for the \emph{x} and/or
#'   \emph{y} aesthetics, additional mappings can be set using \code{aes()},
#'   possibly together with \code{after_stat()}.
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
#'   stat_debug_group()
#'
#' # geom_debug prints the data returned by the stat
#' ggplot(my.df, aes(x,y)) +
#'   geom_point() +
#'   stat_debug_group(geom = "debug")
#'
#' # geom_debug prints the data returned by the stat
#' ggplot(my.df, aes(x,y)) +
#'   geom_point() +
#'   stat_debug_group(geom = "debug",
#'                    geom.dbgfun.params = "summary")
#'
#' # to print only the the data returned by the stat
#' # we pass as summary function a function that always returns NULL
#' ggplot(my.df, aes(x,y)) +
#'   geom_point() +
#'   stat_debug_group(geom = "debug",
#'                    dbgfun.data = function(x) {NULL})
#'
#' ggplot(my.df, aes(x,y)) +
#'   geom_point() +
#'   stat_debug_group(aes(label = paste("group:", group)),
#'                    geom = "text")
#'
#' # here we show all the data object
#' ggplot(my.df, aes(x,y)) +
#'   geom_point() +
#'   stat_debug_group(dbgfun.data = "I")
#'
#' # with grouping
#' ggplot(my.df, aes(x,y, colour = group)) +
#'   geom_point() +
#'   stat_debug_group()
#'
#' ggplot(my.df, aes(x, y, colour = group)) +
#'   geom_point() +
#'   stat_debug_group(dbgfun.data = "nrow")
#'
#' ggplot(my.df, aes(x, y)) +
#'   geom_point() +
#'   facet_wrap(~group) +
#'   stat_debug_group()
#'
#' # by default head() is used to show the top rows of data object
#' ggplot(my.df, aes(group,y)) +
#'   geom_point() +
#'   stat_debug_group()
#'
#' @export
#' @family diagnosis functions
#'
stat_debug_group <-
  function(mapping = NULL,
           data = NULL,
           geom = "null",
           fun.data = "I",
           fun.data.args = list(),
           dbgfun.data = "head",
           dbgfun.data.args = list(),
           geom.dbgfun.data = "head",
           geom.dbgfun.data.args = list(),
           geom.dbgfun.params = NULL,
           geom.dbgfun.params.args = list(),
           dbgfun.print = "print",
           dbgfun.print.args = list(),
           position = "identity",
           na.rm = FALSE,
           show.legend = FALSE,
           inherit.aes = TRUE,
           ...) {
    if (geom == "debug") {
      params <- rlang::list2(na.rm = na.rm,
                             ...,
                             fun.data = fun.data,
                             fun.data.args = fun.data.args,
                             stat.dbgfun.data = dbgfun.data,
                             stat.dbgfun.data.args = dbgfun.data.args,
                             dbgfun.data = geom.dbgfun.data,
                             dbgfun.data.args = geom.dbgfun.data.args,
                             dbgfun.params = geom.dbgfun.params,
                             dbgfun.params.args = geom.dbgfun.params.args,
                             dbgfun.print = dbgfun.print,
                             dbgfun.print.args = dbgfun.print.args)
    } else {
      # avoid warning when other geoms are used
      params <- rlang::list2(na.rm = na.rm,
                             ...,
                             fun.data = fun.data,
                             fun.data.args = fun.data.args,
                             stat.dbgfun.data = dbgfun.data,
                             stat.dbgfun.data.args = dbgfun.data.args,
                             dbgfun.print = dbgfun.print,
                             dbgfun.print.args = dbgfun.print.args)
    }

    ggplot2::layer(
      stat = StatDebugGroup,
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
StatDebugGroup <-
  ggplot2::ggproto(
    "StatDebugGroup",
    ggplot2::Stat,
    compute_group = function(data,
                             scales,
                             fun.data,
                             fun.data.args,
                             stat.dbgfun.data,
                             stat.dbgfun.data.args,
                             dbgfun.print,
                             dbgfun.print.args) {


      if (is.character(dbgfun.print)) {
        dbgfun.print <- match.fun(dbgfun.print)
      } else if (!is.function(dbgfun.print)) {
        dbgfun.print <- print
      }
      if (!is.null(stat.dbgfun.data)) {
        if (is.character(stat.dbgfun.data)) {
          stat.dbgfun.data.name <- stat.dbgfun.data
          stat.dbgfun.data <- match.fun(stat.dbgfun.data)
        } else if (!is.null(stat.dbgfun.data) ) {
          stat.dbgfun.data.name <- deparse(substitute(stat.dbgfun.data))
          if (length(stat.dbgfun.data.name) > 1) {
            stat.dbgfun.data.name <- "anonymous function"
          }
        }
        data.header <- sprintf("PANEL %i; group %i; 'compute_group()' input 'data' (%s):",
                               unclass(data$PANEL[1]), data$group[1], stat.dbgfun.data.name)
        zz <-  do.call(stat.dbgfun.data, c(quote(data), stat.dbgfun.data.args))
        dbgfun.print(data.header)
        dbgfun.print(zz)
      }

      # the computations on data
      if (is.null(fun.data)) {
        data[NULL, ]
      } else {
        do.call(fun.data, c(quote(data), fun.data.args))
      }

    },
    required_aes = c("x|y")
  )
