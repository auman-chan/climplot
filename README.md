
# climplot: Facilitate and tailor Walter & Lieth climatic diagram drawing

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![Project Status: Active The project has reached a stable, usable state
and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Licence](https://img.shields.io/badge/licence-gpl--3.0-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
[![minimal R
version](https://img.shields.io/badge/R-%3E=%203.5.0-6666ff.svg)](https://cran.r-project.org/)
[![packageversion](https://img.shields.io/badge/Package%20version-0.3.0-orange.svg?style=flat-square)](commits/develop)
[![Last-changedate](https://img.shields.io/badge/last%20change-2023--07--27-yellow.svg)](/commits/master)
![CRAN_Status_Badge](https://img.shields.io/badge/CRAN-Not%20ready-red.svg)
[![R-CMD-check](https://github.com/auman-chan/climplot/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/auman-chan/climplot/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/auman-chan/climplot/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/auman-chan/climplot/actions/workflows/test-coverage.yaml)
[![Codecov test
coverage](https://codecov.io/gh/auman-chan/climplot/branch/master/graph/badge.svg)](https://app.codecov.io/gh/auman-chan/climplot?branch=master)
<!-- badges: end -->

<img src="./vignettes/imgfile.png" alt="climplot logo" align="right" width="35%"/>

[climplot](https://gitee.com/auman-chan/climplot) aims to collect
crucial climate data for global locations and render the Walter & Lieth
climatic diagrams in a more user-friendly and personalized manner.

The main features of the package are:

- The automatic obtainment and arrangement of standardized and reliable
  data for drawing Walter & Lieth climatic diagrams
- The provision for more parameter to customize the plots and display
  comprehensive information

The package offers functions for:

- Download and arrange worldwide climate data to draw Walter & Lieth
  climatic diagram for global locations
- Draw the Walter & Lieth climatic diagram
- Revise the color scheme and information presentation of the diagram

## Installing and loading

To install the latest developmental version from
[github](https://github.com/) and [gitee](https://gitee.com/), you will
need the R packages
[remotes](https://cran.r-project.org/package=remotes) and
[git2r](https://cran.r-project.org/package=git2r). If you want to
install the vignettes of this package, please add
`build_vignettes = TRUE`.

``` r
install.packages("remotes")

#from github
remotes::install_github("auman-chan/climplot")
#from gitee
install.packages("git2r")
remotes::install_git("https://gitee.com/auman-chan/climplot.git")

#add vignettes
remotes::install_github("auman-chan/climplot", build_vignettes = TRUE)

remotes::install_git("https://gitee.com/auman-chan/climplot.git",
                     build_vignettes= TRUE)

#add vignettes
remotes::install_github("auman-chan/climplot", build_vignettes = TRUE)

remotes::install_git("https://gitee.com/auman-chan/climplot.git", 
                     build_vignettes = TRUE)
```

## Eaxmple

### Extraction of climate data

Information of the target locations should be ready for the extraction.
It must contain five columns in the following order:

- **No**: Serial number of the locations
- **location**: Abbreviation of the locations
- **lon**: Longitude of the locations in decimal digit (negative numbers
  indicating west longitude)
- **lat**: Latitude of the locations in decimal digit (negative numbers
  indicating south latitude)
- **altitude**: Altitude of the locations

Other extra columns with information is allowed behind the columns
above, but would be discarded in following process.

The data `locdata` in this package can be a example of the import
data.frame.

After preparing the climate dataset and location information, import the
data.frame to the function `clim_extract`:

``` r
#Example data in this package
data("locdata")

#extraction of climate data

plotdata <- clim_extract(locdata)
```

|  No | Altitude | Location   |      Lon |     Lat | Type      |    1 |    2 |    3 |    4 |     5 |     6 |     7 |     8 |     9 |   10 |   11 |   12 |
|----:|---------:|:-----------|---------:|--------:|:----------|-----:|-----:|-----:|-----:|------:|------:|------:|------:|------:|-----:|-----:|-----:|
|   1 |     2025 | Motuo      |  95.3536 | 29.3042 | prec      | 10.0 | 22.0 | 38.0 | 93.0 | 114.0 | 230.0 | 241.0 | 216.0 | 187.0 | 72.0 | 12.0 |  7.0 |
|   1 |     2025 | Motuo      |  95.3536 | 29.3042 | mean_temp | 10.9 | 11.6 | 15.1 | 18.6 |  21.9 |  24.0 |  24.4 |  24.6 |  23.1 | 20.1 | 16.0 | 12.4 |
|   1 |     2025 | Motuo      |  95.3536 | 29.3042 | min_temp  | -1.9 | -0.5 |  3.1 |  6.2 |   9.9 |  12.5 |  13.6 |  13.3 |  12.7 |  9.2 |  2.9 | -0.3 |
|   1 |     2025 | Motuo      |  95.3536 | 29.3042 | max_temp  | 10.9 | 11.6 | 15.1 | 18.6 |  21.9 |  24.0 |  24.4 |  24.6 |  23.1 | 20.1 | 16.0 | 12.4 |
|   2 |     1301 | Wulianshan | 100.5000 | 24.5000 | prec      | 12.0 | 16.0 | 20.0 | 35.0 |  75.0 | 173.0 | 204.0 | 193.0 | 126.0 | 98.0 | 47.0 | 18.0 |
|   2 |     1301 | Wulianshan | 100.5000 | 24.5000 | mean_temp | 20.8 | 23.2 | 26.5 | 29.0 |  29.5 |  28.6 |  28.3 |  28.5 |  27.3 | 25.2 | 22.2 | 19.9 |
|   2 |     1301 | Wulianshan | 100.5000 | 24.5000 | min_temp  |  5.7 |  7.4 | 10.7 | 14.4 |  17.8 |  20.4 |  20.6 |  20.1 |  18.6 | 16.0 | 11.4 |  7.1 |
|   2 |     1301 | Wulianshan | 100.5000 | 24.5000 | max_temp  | 20.8 | 23.2 | 26.5 | 29.0 |  29.5 |  28.6 |  28.3 |  28.5 |  27.3 | 25.2 | 22.2 | 19.9 |
|   3 |     2082 | Wawushan   | 102.9167 | 29.5000 | prec      | 12.0 | 13.0 | 21.0 | 53.0 | 104.0 | 168.0 | 191.0 | 180.0 | 145.0 | 73.0 | 27.0 | 14.0 |
|   3 |     2082 | Wawushan   | 102.9167 | 29.5000 | mean_temp |  4.2 |  5.9 | 10.9 | 15.6 |  18.3 |  19.8 |  22.0 |  21.8 |  17.6 | 13.7 |  9.9 |  5.9 |
|   3 |     2082 | Wawushan   | 102.9167 | 29.5000 | min_temp  | -4.1 | -2.8 |  1.0 |  5.7 |   9.1 |  11.9 |  14.7 |  14.3 |  11.0 |  7.0 |  2.0 | -2.2 |
|   3 |     2082 | Wawushan   | 102.9167 | 29.5000 | max_temp  |  4.2 |  5.9 | 10.9 | 15.6 |  18.3 |  19.8 |  22.0 |  21.8 |  17.6 | 13.7 |  9.9 |  5.9 |

The exported data.frame includes 5 kinds of information of locations(as
which in the data.frame imported), and values of 4 kinds of climate
factors across 12 months. A data.frame stores in the data `plotdata` of
this package, as an example of the function export.

### Climatic diagram drawing

Take the data `plotdata` as an example, and import them into the
function `clim_plot`:

``` r
data("plotdata")
loc <- subset(plotdata, No == 2)
clim_plot(loc)
```

<img src="vignettes/result.png" alt="plot result" align="center"/>

In the figure above:

- The red curve represents the annual variation of temperature, and blue
  one represents of precipitation variation. These two curves form two
  types of patches indicating humidity and aridity levels. The
  string-filled patches represent humid seasons while those with
  scattered points represent arid seasons. The polygon filled with the
  color same as precipitation curve indicates months with precipitation
  over 100mm, displaying the wet season.

- The information on the left top includes the name, the altitude and
  the coordinates of the locations. The right top are the values of
  annual mean temperature and mean precipitation.

## More inforamtion

More examples and information, please view the help pages and [the
online vigenettes of this
package](https://auman-chan.github.io/climplot/).

## Citations

Please cite climplot as follows:

Chan A (2023). climplot: climplot: Facilitate and tailor Walter & Lieth
climatic diagram drawing. R package version 0.2.1,
<https://github.com/auman-chan/climplot>.

NOTE: please also cite the
[‘climatol’](https://CRAN.R-project.org/package=climatol) package and
[Worldclim](https://worldclim.org/data/monthlywth.html) data.
