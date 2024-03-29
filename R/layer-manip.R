#' Layer manipulation.
#'
#' Delete, move or append one or more layers in a ggplot object.
#'
#' @param x an object of class \code{gg} to be operated upon.
#' @param match_type The name of the ggproto object class for the geom(s),
#'   position(s) or stat(s) matching that of the layers to be operated upon.
#' @param idx integer vector Index into the list of layers used to select the
#'   layers to be operated upon.
#'
#' @return An edited copy of \code{x} for \code{delete_layers},
#'   \code{append_layers} and \code{move_layers}. An integer vector of indexes
#'   giving the positions of the matching layers in the list of layers contained
#'   in \code{x} in the case of \code{which_layers}.
#'
#' @references
#' \url{https://stackoverflow.com/questions/13407236/remove-a-layer-from-a-ggplot2-chart}
#'
#' @details These functions must be used with care as they select all layers
#'   matching the provided geom, position or stat ggproto object class. Layers
#'   added with a stat do use a geom, and vice versa.
#'
#'   One and only one of \code{match_type} and \code{idx} must be passed a
#'   non-null argument.
#'
#'   In plots with several layers, it is possible that more than one layer
#'   matches the class name passed to \code{match_type}. It is also possible to
#'   pass a numeric vector with multiple indexes through parameter \code{idx}.
#'   In both cases multiple layers will be operated upon, but their relative
#'   positions will remain unchanged.
#'
#'   If a numeric vector with multiple position indexes is supplied as argument
#'   for \code{position}, the topmost position will be used. As indexing in R
#'   starts at 1, passing 0 or \code{"bottom"} as argument for \code{position}
#'   puts the moved or appended layer(s) behind all other layers (prepends the
#'   layer).
#'
#' @note The functions described here are not expected to be useful in everyday
#'   plotting as one can more easily change the order in which layers are added
#'   to a ggplot. However, if one uses high level methods or functions that
#'   automatically produce a full plot using 'ggplot2' internally, one may need
#'   to add, move or delete layers so as to profit from such canned methods and
#'   retain enough flexibility.
#'
#' @examples
#' df <- data.frame(
#'   gp = factor(rep(letters[1:3], each = 10)),
#'   y = rnorm(30)
#' )
#' p <- ggplot(df, aes(gp, y)) +
#'        geom_point() +
#'        stat_summary(fun.data = "mean_se", colour = "red")
#' p
#' delete_layers(p, "GeomPoint")
#' delete_layers(p, "StatSummary")
#' move_layers(p, "GeomPoint", position = "top")
#' move_layers(p, "GeomPointrange", position = "bottom")
#' move_layers(p, "StatSummary", position = "bottom")
#' move_layers(p, "GeomPointrange", position = 1L)
#' append_layers(p, geom_line(colour = "orange"), position = "bottom")
#' append_layers(p, geom_line(colour = "orange"), position = 1L)
#' extract_layers(p, "GeomPoint")
#' ggplot(df, aes(gp, y)) + extract_layers(p, "GeomPoint")
#' which_layers(p, "GeomPoint")
#' num_layers(p)
#' top_layer(p)
#' bottom_layer(p)
#' num_layers(ggplot())
#' top_layer(ggplot())
#' bottom_layer(ggplot())
#'
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   nc_3857 <- sf::st_transform(nc, 3857)
#'
#'   p.sf1 <- ggplot() +
#'            geom_sf(data = nc)
#'   p.sf1
#'   num_layers(p.sf1)
#'   top_layer(p.sf1)
#'
#'   append_layers(p.sf1,
#'                 geom_sf(data = nc_3857, colour = "red", fill = NA),
#'                 position = "top")
#'
#'   p.sf2 <- ggplot() +
#'            geom_sf(data = nc) +
#'            geom_sf(data = nc_3857, colour = "red", fill = NA)
#'   p.sf2
#'   num_layers(p.sf2)
#'   top_layer(p.sf2)
#'   delete_layers(p.sf2, idx = 2L)
#'
#'   extract_layers(p.sf2, "GeomSf")
#'   extract_layers(p.sf2, "StatSf")
#'   extract_layers(p.sf2, idx = 1L)
#'   p.sf1 + extract_layers(p.sf2, idx = 2L)
#'
#'   # beware that Coords are not extracted!
#'   ggplot() + extract_layers(p.sf2, idx = 2L) + coord_sf()
#' }
#'
#' @export
#'
delete_layers <- function(x, match_type = NULL, idx = NULL) {
  edit_layers(x = x,
              match_type = match_type,
              idx = idx,
              action = "delete")
}

#' @rdname delete_layers
#'
#' @param object a ggplot layer created by a \code{geom_} or \code{stat_}
#'   function or a list of such layers or an empty list.
#'
#' @export
#'
append_layers <- function(x, object, position = "top") {
  is_list_of_layers <- function(list) {
    n <- length(list)
    if (n == 0) return(TRUE)
    are.layers <- sapply(object, methods::is, class2 = "Layer")
    if (all(are.layers)) return(TRUE)
    are.sf.layers <- sapply(object, methods::is, class2 = "LayerSF")
    are.sf.coords <- sapply(object, methods::is, class2 = "CoordSf")
    all(are.layers | are.sf.layers | are.sf.coords)
  }
  stopifnot(ggplot2::is.ggplot(x))
  stopifnot(methods::is(object, "Layer") ||
              is.list(object) && is_list_of_layers(object))
  z <- x + object
  if (length(z$layers) > length(x$layers) && position != "top") {
    z <- edit_layers(x = z,
                     match_type = NULL,
                     position = position,
                     idx = (length(x$layers) + 1):length(z$layers),
                     action = "move")
  }
  z
}

#' @rdname delete_layers
#'
#' @param position character or interger, the position of the layer immediately
#'    above of which to move or append the moved or appended layers.
#'
#' @export
#'
move_layers <- function(x, match_type = NULL, position = "top", idx = NULL) {
  edit_layers(x = x,
              match_type = match_type,
              position = position,
              idx = idx,
              action = "move")
}

#' @rdname delete_layers
#'
#' @param shift integer.
#'
#' @export
#'
shift_layers <- function(x, match_type = NULL, idx = NULL, shift = 1L) {
  if (is.double(idx)) {
    idx <- as.integer(idx)
  }
  if (is.double(shift)) {
    shift <- as.integer(shift)
  }
  if (shift == 0L) {
    # nothing to do
    return(x)
  }
  from <- which_layers(x = x,
                       match_type = match_type,
                       idx = idx)
  # We substract 1L as move_layers inserts layer above position
  move_layers(x = x,
              match_type = match_type,
              position = from + shift - 1L,
              idx = idx)
}

#' @rdname delete_layers
#'
#' @export
#'
which_layers <- function(x, match_type = NULL, idx = NULL) {
  edit_layers(x = x,
              match_type = match_type,
              idx = idx,
              action = "which")
}

#' @rdname delete_layers
#'
#' @export
#'
extract_layers <- function(x, match_type = NULL, idx = NULL) {
  which.idxs <-   edit_layers(x = x,
                              match_type = match_type,
                              idx = idx,
                              action = "which")
  x$layers[which.idxs]
}

#' @rdname delete_layers
#'
#' @export
#'
top_layer <- function(x) {
  stopifnot(ggplot2::is.ggplot(x))
  ifelse(length(x$layers) > 0L, length(x$layers), NA_integer_)
}

#' @rdname delete_layers
#'
#' @export
#'
bottom_layer <- function(x) {
  stopifnot(ggplot2::is.ggplot(x))
  ifelse(length(x$layers) > 0L, 1L, NA_integer_)
}

#' @rdname delete_layers
#'
#' @export
#'
num_layers <- function(x) {
  stopifnot(ggplot2::is.ggplot(x))
  length(x$layers)
}

#' Edit plot layer
#'
#' Delete or move one or more layers in a ggplot object.
#'
#' @param x an object of class \code{gg} to be operated upon.
#' @param match_type The name of the ggproto object class for the geom(s),
#'   position(s) or stat(s) matching that of the layers to be operated upon.
#' @param idx integer vector Index(es) into the list of layers, used to select
#'   the layers to be operated upon.
#' @param action character One of "delete", "move", or "which".
#'
#' @keywords internal
#'
edit_layers <- function(x,
                        match_type = NULL,
                        position = 0L,
                        idx = NULL,
                        action) {
  stopifnot(ggplot2::is.ggplot(x))
  stopifnot(xor(is.null(match_type), is.null(idx)))
  if (length(position) > 1) {
    warning("'position' is not vectorized, using 'position[1]'")
    position <- position[1]
  }
  if (is.numeric(idx)) {
    # Convert into logical vector---equivalent to the inverse of which()
    idx <- seq_len(length(x$layers)) %in% as.integer(idx)
  }
  if (is.null(idx)) {
    # Check what to search for
    known_fields <- c("geom", "stat", "position")
    matched_field <-
      known_fields[sapply(known_fields, grepl, x = tolower(match_type))]
    if (length(matched_field) == 0L) {
      stop("Argument '", match_type,
           "' not in supported fields: ", known_fields, ".")
    }
    # Find layers that match the requested type.
    idx <- sapply(x$layers,
                  function(y) {
                    class(y[[matched_field]])[1] == match_type
                  })
  }
  if (any(is.na(idx))) {
    idx <- logical()
  }
  if (action == "delete") {
    if (sum(idx) > 0L) {
      # Delete the layers.
      x$layers[idx] <- NULL
    }
  } else if ((action == "move")) {
    if (sum(idx) > 0L) {
      # Move the layers.
      if (position == "top") {
        x$layers <- c(x$layers[!idx], x$layers[idx])
      } else if (position == "bottom") {
        x$layers <- c(x$layers[idx], x$layers[!idx])
      } else if (is.integer(position) && !is.na(position)) {
        # We avoid position overflow and underflow
        # We use only the topmost position
        position <- max(0L, position)
        position <- min(position, length(x$layers))
        x$layers <- append(x$layers[!idx], x$layers[idx],
                           ifelse(position > length(x$layers[!idx]),
                                  length(x$layers[!idx]),
                                  position))
      } else {
        stop("Position must be one of 'top' or 'bottom' or a positive integer.")
      }
    }
  } else if (action == "which") {
      x <- which(idx)
  }
  x
}
