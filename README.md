
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](http://bcdevexchange.org/badge/2.svg)](https://github.com/BCDevExchange/docs/blob/master/discussion/projectstates.md) [![Travis-CI Build Status](https://travis-ci.org/bcgov/cccharts.svg?branch=master)](https://travis-ci.org/bcgov/cccharts)

cccharts
========

Introduction
------------

`cccharts` is an R package to plot climate change indicator data for British Columbia.

Utilisation
-----------

``` r
library(cccharts)
#> Loading required package: ggplot2

plot_range(cccharts::precipitation, x = "Season") + facet_wrap(~Ecoprovince)
```

![](README-unnamed-chunk-2-1.png)

To generate all plot files (creates a folder in the working directory called `cccharts`).

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
