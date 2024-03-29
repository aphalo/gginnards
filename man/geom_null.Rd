% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom-debug.R
\name{geom_null}
\alias{geom_null}
\title{A null geom or 'no-op' geom.}
\usage{
geom_null(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  na.rm = FALSE,
  show.legend = FALSE,
  inherit.aes = TRUE,
  ...
)
}
\arguments{
\item{mapping}{Set of aesthetic mappings created by
\code{\link[ggplot2]{aes}}. If specified and \code{inherit.aes = TRUE} (the
default), are combined with the default mapping at the top level of the
plot. You only need to supply \code{mapping} if there isn't a mapping
defined for the plot.}

\item{data}{A data frame. If specified, overrides the default data frame
defined at the top level of the plot.}

\item{stat}{The statistical transformation to use on the data for this layer,
as a string.}

\item{position}{Position adjustment, either as a string, or the result of a
call to a position adjustment function.}

\item{na.rm}{If \code{FALSE} (the default), removes missing values with a
warning.  If \code{TRUE} silently removes missing values.}

\item{show.legend}{logical. Should this layer be included in the legends?
\code{NA}, the default, includes if any aesthetics are mapped. \code{FALSE}
never includes, and \code{TRUE} always includes.}

\item{inherit.aes}{If \code{FALSE}, overrides the default aesthetics, rather
than combining with them. This is most useful for helper functions that
define both data and aesthetics and shouldn't inherit behaviour from the
default plot specification, e.g. \code{\link[ggplot2]{borders}}.}

\item{...}{other arguments passed on to \code{\link[ggplot2]{layer}}. There
  are three types of arguments you can use here:

  \itemize{ \item Aesthetics: to set an aesthetic to a fixed value, like
  \code{color = "red"} or \code{size = 3}. \item Other arguments to the
  layer, for example you override the default \code{stat} associated with the
  layer. \item Other arguments passed on to the stat.}}
}
\value{
A plot layer instance. Mainly used for the side-effect of printing
  to the console the \code{data} object.
}
\description{
The null geom can be used to silence graphic output from a stat, such as
\code{stat_debug_group()} and \code{stat_debug_panel()} defined in this same
package. No visible graphical output is returned. An invisible
\code{grid::grid_null()} grob is returned instead.
}
\note{
This geom is very unusual in that it does not produce visible graphic
  output. It only returns a \code{\link[grid]{grid.null}} grob (graphical
  object). However, it accepts for consistency all the same parameters as
  normal geoms, which have no effect on the graphical output, except for
  \code{show.legend}.
}
\examples{
ggplot(mtcars) +
  geom_null()

ggplot(mtcars, aes(cyl, mpg)) +
  geom_null()

# shape data

if (requireNamespace("sf", quietly = TRUE)) {
  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

  ggplot(data = nc) +
    geom_null()
}

}
