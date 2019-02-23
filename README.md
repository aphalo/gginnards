# gginnards #

[![cran version](http://www.r-pkg.org/badges/version/gginnards)](https://cran.r-project.org/package=gginnards) 
[![cran checks](https://cranchecks.info/badges/worst/gginnards)](https://cran.r-project.org/web/checks/check_results_gginnards.html)

Package '**gginnards**' (Explore the innards of 'ggplot2') is a set of
extensions to R package 'ggplot2' (>= 3.1.0) and tools useful when learning how to
write extensions and when debugging newly defined stats and geoms.  

Statistics and geometries that echo their data input to the R console and/or 
plot aim at easing debugging during development of new geoms and statistics 
(or learning how ggplot layers work).

A set of functions facilitates the manipulation of layers in ggplot objects,
allowing deletion of any existing layer, insertion of new layers at any
position, and reordering of the existing layers.

A function to drop unused variables from the data object embedded in `gg` and
`ggplot` objects serves as an additional example of a manipulation that may
be useful when dealing with very large datasets. Companion functions are
defined to explore the embedded data.

This package was born when several functions were removed from package 
'ggpmisc'. These functions are meant mainly to be used for debugging and
learning how ggplot internals works while the balance of 'ggpmisc' are 
functions for everyday plotting.

Please, see the web site [r4photobiology](https://www.r4photobiology.info) for
details and update notices, and [the docs
site](https://docs.r4photobiology.info/gginnards).

The current release of '__gginnards__' is available through
[CRAN](https://cran.r-project.org/package=gginnards) for R (>= 3.4.0).

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
