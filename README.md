
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](http://bcdevexchange.org/badge/2.svg)](https://github.com/BCDevExchange/docs/blob/master/discussion/projectstates.md) [![Travis-CI Build Status](https://travis-ci.org/bcgov/cccharts.svg?branch=master)](https://travis-ci.org/bcgov/cccharts)

cccharts
========

Introduction
------------

`cccharts` is an R package to plot climate change indicator data for British Columbia. It is essentially a wrapper on top of `ggplot2` code.

### Three Plot Types

It produces three types of plots:

-   Color-coded point (or bar chart) estimates with upper and lower confidence intervals (if available) (`plot_estimates`).
-   Color-coded maps of BC with the estimates for Ecoprovinces or Stations (`map_estimates`).
-   Raw data with estimated trend lines (`plot_fit`).

Examples of the three types of plots are presented below.

To get more information on the arguments that a function takes type for example `?plot_estimates`.

### PNG Files and `ggplot` Objects

The three base functions return `ggplot` objects which can be modified prior to plotting. The higher level wrappers `plot_estimates_pngs`, `map_estimates_pngs` etc automatically save the plots to png files in a subdirectory of the folder `cccharts` in the working directory. They also return a list of the `ggplot` objects in case the users wishes to manipulate them further.

### Color Scheme

The default color scheme is a *diverging* BrBG Brewer [palette](http://colorbrewer2.org/#type=diverging&scheme=BrBG&n=11). The user can override the color scheme for the `plot_estimates` or `map_estimates` functions by setting the `low`, `mid`, and `high` arguments. To switch to a *sequential* color scheme simply set `mid = NULL`. To make all points the same color (and suppress a color legend) simply set `low` and `high` at the same value.

### Data

`cccharts` also provides actual datasets. Type `data()` to see the available datasets or for example type `?snow` for more information on the snow data.

Utilisation
-----------

``` r
library(cccharts)
#> Loading required package: ggplot2
plot_estimates(data = cccharts::sea_surface_temperature_station, x = "Season", facet = "Station")
#> Warning: 1 data points have inconsistent significance and confidence limits
```

![](README-unnamed-chunk-2-1.png)

``` r
map_estimates(data = cccharts::sea_level_station, station = TRUE, bounds = c(0.1,0.7,0,0.55))
```

![](README-unnamed-chunk-3-1.png)

``` r
plot_fit(data = dplyr::filter(cccharts::flow_station_discharge, Term == "Medium", Statistic == "Mean", Season == "Annual"), observed = cccharts::flow_station_discharge_observed, free_y = TRUE, facet = "Station")
```

![](README-unnamed-chunk-4-1.png)

To generate the plot files (creates a folder in the working directory called `cccharts`).

    library(cccharts)
    demo("cccharts", ask = FALSE)

Installation
------------

To install the latest version from GitHub

    # install.packages("devtools")
    devtools::install_github("bcgov/cccharts")

Contribution
------------

Please report any [issues](https://github.com/bcgov/cccharts/issues).

[Pull requests](https://github.com/bcgov/cccharts/pulls) are always welcome.

If you would like to contribute, please see our [CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

License
-------

    Copyright 2016 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at 

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

Maintenance
-----------

This repository is maintained by [Environmental Reporting BC](http://www2.gov.bc.ca/gov/content?id=FF80E0B985F245CEA62808414D78C41B). Click [here](https://github.com/bcgov/EnvReportBC-RepoList) for a complete list of our repositories on GitHub.
