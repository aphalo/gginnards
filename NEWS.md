---
editor_options:
  markdown:
    wrap: 72
---

# gginnards 0.1.0-1

-   Minor update to *User Guide 2* and four code examples in functions'
    documenttaion to address non-compliance with CRAN requirements.

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
