#' Theme difference
#'
#' Compare two 'ggplot2' theme definitions, field by field.
#'
#' @param theme1,theme2 'ggplot2' theme objects.
#' @param value logical If \code{TRUE} return a list with the fields with
#'   differences extracted from the themes, and if \code{FALSE}, return the
#'   names of the fields with differences.
#' @param pattern character A character string containing a regular expression
#'   to be matched by \code{\link{grep}()} against the union of the field
#'   names in to two themes being compared or in the theme being operated
#'   upon. If \code{NULL} all fields are used.
#' @param classes character A character vector containg the names of classes
#'   of the fields to operate upon. For ggplot2 elements, without "ggplot2::".
#' @param invert logical If \code{TRUE} return the fields that are equal instead
#'   of those that are different.
#'
#' @details The names of the shared fields obtained with \code{\link{setdiff}()}
#'   are used to walk through the list-like theme definitions, comparing each of
#'   these fields with \code{\link{identical}()}. Fields missing or \code{NULL}
#'   in only one of the two themes, are also considered different. If
#'   \code{pattern} is not \code{NULL}, the comparison is retricted to the
#'   field names matching the pattern. If \code{classes} is not \code{NULL},
#'   the comparison is restricted to the fields of a class listed in the
#'   vector passed as argument.
#'
#' @return The value returned by \code{theme_diff()} is a \code{character}
#'   vector of field names if \code{value = FALSE} or otherwise a named list
#'   with two members, each a subset of one of the themes, named
#'   \code{"theme1"} and  \code{"theme2"}. The value returned by
#'   \code{theme_classes()} is a named \code{character}
#'   vector of most derived class names, with field names as names.
#'   The value returned by \code{theme_extract()} is a \code{character}
#'   vector of field names if \code{value = FALSE} or otherwise a subset of
#'   the theme fields.
#'
#' @export
#'
#' @examples
#'
#' theme_diff(theme_bw())
#' theme_diff(theme_bw(), theme_grey())
#'
#' theme_diff(theme_bw(), theme_bw(base_size = 12))
#' theme_diff(theme_bw(), theme_bw(base_size = 12), pattern = "^strip")
#' theme_diff(theme_bw(), theme_bw(base_size = 12), classes = "element_text")
#' theme_diff(theme_bw(), theme_bw(base_size = 12), classes = "simpleUnit")
#'
#' theme_diff(theme_classic(), theme_bw())
#' theme_diff(theme_classic(), theme_bw(), pattern = "^axis\\.title", invert = TRUE)
#' theme_diff(theme_bw(), theme_bw(base_size = 12), pattern = "title$", value = TRUE)
#' theme_diff(theme_bw(), theme_bw(base_size = 12), classes = "element_rect", value = TRUE)
#' theme_diff(theme_bw(), theme_bw(base_size = 12), classes = "simpleUnit", value = TRUE)
#'
#' theme_classes(theme_bw(), pattern = "^text$")
#'
#' theme_diff(theme_bw(), theme_bw(base_size = 12), pattern = "^text$", value = TRUE)
#'
#' theme_extract(theme_bw(), pattern = "^text$")
#' theme_extract(theme_bw(12), pattern = "^text$")
#'
#' # fields that are not set explicitly (inherited)
#' theme_extract(theme_bw(), classes = "NULL", value = FALSE)
#'
theme_diff <- function(theme1,
                       theme2 = ggplot2::theme_grey(),
                       pattern = NULL,
                       classes = NULL,
                       value = FALSE,
                       invert = FALSE) {
  if (!length(names(theme1)) || !length(names(theme2))) {
    stop("Only objects with named fields can be compared with 'theme_diff()'!")
  }
  if (class(theme1)[1] != class(theme2)[1]) {
    warning("Comparing objects belonging to different classes is unreliable!")
  }
  fields.th1 <- names(theme1)
  fields.th2 <- names(theme2)

  if (!is.null(classes)) {
    fields.th1 <-
      fields.th1[gsub("^ggplot2::", "",
                      theme_classes(theme1 = theme1)) %in% classes]
    fields.th2 <-
      fields.th2[gsub("^ggplot2::", "",
                      theme_classes(theme1 = theme2)) %in% classes]
  }
  fields.all <- union(fields.th1, fields.th2)
  if (!is.null(pattern) && is.character(pattern)) {
    fields.all <- grep(pattern, fields.all, value = TRUE)
    fields.th1 <- intersect(fields.th1, fields.all)
    fields.th2 <- intersect(fields.th2, fields.all)
  }
  fields.missing2 <- setdiff(fields.th1, fields.th2)
  fields.missing1 <- setdiff(fields.th1, fields.th2)
  fields.shared <- intersect(fields.th1, fields.th2)

  fields.equal <- character()
  fields.different <- character()

  for (field in fields.all) {
    if (field %in% fields.shared) {
      if (isTRUE(identical(theme1[[field]], theme2[[field]]))) {
        fields.equal <- c(fields.equal, field)
      } else {
        fields.different <- c(fields.different, field)
      }
    } else {
      fields.different <- c(fields.different, field)
    }
  }
  if (invert) {
    z <- fields.equal
  } else {
    z <- fields.different
  }
  if (value) {
    list(theme1 = theme1[setdiff(z, fields.missing1)],
         theme2 = theme2[setdiff(z, fields.missing2)])
  } else {
    z
  }
}

#' Theme member classes
#'
#' Extract the class of the members of a 'ggplot2' theme.
#'
#' @export
#'
#' @rdname theme_diff
#'
#' @examples
#'
#' theme_classes(theme_bw(), pattern = "border")
#'
theme_classes <- function(theme1,
                          pattern = NULL) {
  if (!length(names(theme1))) {
    stop("Only objects with named fields can be compared with 'theme_diff()'!")
  }

  fields.th <- names(theme1)
  if (!is.null(pattern) && is.character(pattern)) {
    fields.th <- grep(pattern, fields.th, value = TRUE)
  }

  field.classes <- list()
  for (field in fields.th) {
    field.classes[[field]] <- class(theme1[[field]])[1]
  }
  unlist(field.classes)
}

#' Extract members of a 'ggplot2' theme.
#'
#' @export
#'
#' @rdname theme_diff
#'
#' @examples
#'
#' theme_extract(theme_bw(), pattern = "border")
#'
theme_extract <- function(theme1,
                          pattern = NULL,
                          classes = NULL,
                          value = TRUE) {
  if (!length(names(theme1))) {
    stop("Only objects with named fields can be compared with 'theme_diff()'!")
  }

  fields.th1 <- names(theme1)

  if (!is.null(classes)) {
    fields.th1 <-
      fields.th1[gsub("^ggplot2::", "",
                      theme_classes(theme1 = theme1)) %in% classes]
  }

  if (!is.null(pattern) && is.character(pattern)) {
    fields.th1 <- grep(pattern, fields.th1, value = TRUE)
  }

  if (value) {
    theme1[fields.th1]
  } else {
    fields.th1
  }
}
