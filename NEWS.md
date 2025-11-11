---
editor_options:
  markdown:
    wrap: 72
---

# gginnards 0.2.0-2

* Use `lobstr::obj_addr()` instead of `pryr::address()` in User Guide 2 
examples. ('pryr' will be soon archived.)
* A few code examples were added and/or edited in functions' documentation.
* Minor edits to vignette and README, updating documentation for 'ggplot2' 
(>= 4.0.0).

# gginnards 0.2.0-1

* Fix CRAN checks NOTE.

# gginnards 0.2.0

**This is a code breaking update in relation to functions
`stat_debug_group()` and `stat_debug_panel()`. Both the function signature,
returned values and default arguments have changed.** The new and updated
functions are more polished and flexible than they were in earlier versions of
the package but can still be made to produce similar, but not identical, output
to functions of the same names from earlier versions.

-   Function `geom_debug()` maintained for backwards compatibility.

-   Functions `geom_debug_panel()` and `geom_debug_group()` print summaries of
both `data` and `params` objects.

-   In functions `geom_debug_panel()`, `geom_debug_group()`,
`stat_debug_panel()` and `stat_debug_group()` the function used to print the
summaries is an argument to a new formal parameter `dbgfun.print`.

-   Update `stat_debug_group()` and `stat_debug_panel()` so
that the function used to compute the value returned as `data` is an argument to
a new formal parameter `fun.data`.

-   Rename formal parameter `summary.fun` into `dbgfun.data` in
`geom_debug_panel()`, `geom_debug_group()`, `stat_debug_group()` and
`stat_debug_panel()`.

-   Update the `optional_aes` in `geom_debug_panel()`, `geom_debug_group()` and
`geom_null()` to track changes in `ggplot2` and `ggpp`.

# gginnards 0.1.2

-   Fix bug in `drop_vars()` (report and fix by struckma in issue [#1](https://github.com/aphalo/gginnards/issues/1)).

# gginnards 0.1.1

-   Update `geom_debug()` to avoid several spurious warnings triggered by
    unrecognized parameters and aesthetics. Aesthetics silently accepted
    include all those used by geoms from packages 'ggplot2', 'ggpp', and
    'ggrepel'.
    
-   Improve the printed output from `geom_debug()`, `stat_debug_group()`
    and `stat_debug_panel()`.
    
-   Change the default geom of `stat_debug_group()` and `stat_debug_panel()`
    from `"debug"` to `"null"`.    

-   Tested working with 'ggplot2' 3.3.6 and upcoming 'ggplot2' 3.4.0 (v3.4.0-rc).

# gginnards 0.1.0-1

-   Minor update to *User Guide 2* and four code examples in functions'
    documentation to address non-compliance with CRAN requirements.

-   Minor update to *User Guide 2* figures to enhance clarity.

# gginnards 0.1.0

-   Add `geom_debug_npc()` as a synonym for `geom_debug()` to allow
    debugging of *geoms* supporting npc coordinates as defined in
    package 'ggpp'.

-   Revise `stat_debug_group()` and `stat_debug_panel()` simplifying the
    output to the console. In particular avoid setting default
    aesthetics, change default for `geom` to `"debug"` and used `head()`
    as default for summaries .

-   Revise `geom_debug()` setting `head()` as default for `summary.fun`.

-   Revise part 1 of the User Guide.

    *Some of these changes to default arguments and function parameters
    are code-breaking but of little consequence as these debugging
    functions are meant to be used interactively.*

# gginnards 0.0.4

-   Track updates to 'ggplot2', adding support and examples for
    `geom_sf()` plot layers.
-   Revise documentation.
-   **Move git repository from Bitbucket to Github.**
-   Set up Github action for CRAN-checks on Windows, OS X and Ubuntu.

# gginnards 0.0.3

-   Revise User Guide.
-   Revise documentation adding examples and correcting minor errors.
-   Rewrite README in R markdown adding examples.

# gginnards 0.0.2

-   Implement str() method for class "ggplot" as a wrapper with tweaked
    default arguments.
-   Add functions mapped_vars() and data_vars() to list variables in the
    default data member of objects of class "gg".
-   Add function data_attributes() to list the attributes of the default
    data member of objects of class "gg".

# gginnards 0.0.1

Methods and functions originally part of 'ggpmisc' but removed in the
update to 'ggpmisc' 0.3.0 are included in this new package.

-   Add new function drop_vars() to automatically drop from the data
    object embedded in "gg" "ggplot" objects the variables neither
    mapped to aesthetics nor used for faceting.

# ggpmisc 0.2.17

Last release before split. Please, see [documentation for
'ggpmisc'](https://docs.r4photobiology.info/ggpmisc/news/index.html#ggpmisc-0-2-7-2016-03-22 "changelog")
for earlier history.
