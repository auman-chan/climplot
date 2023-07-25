#' @docType data
#' @name plotdata_Frost
#'
#' @title An example data.frame export from "clim_extract"
#' with extreme temperature
#'
#' @description  A dataset exported from function \code{clim_extract}
#' for plotting the climatic diagrams with frosty months display.
#' It contains the abbreviation, coordinates and altitude
#' of different locations, as well as the values of 4 types of climate data.
#'
#' @details 18 columns of this dataset: "No", "Location", "Lon", "Lat",
#' "Altitude" are information of locations,
#' "Type" are the labels of climate data, and the rest of columns with colnames
#' "1-12" are the climate data values across 1-12 months.
#'
#'
#' @format A data frame with 30 rows and 18 variables:
#' \describe{
#'     \item{No}{Serial number of the locations.}
#'     \item{Location}{Abbreviation of the locations.}
#'     \item{Lon}{Longitude of the locations in decimal digit.}
#'     \item{Lat}{Latitude of the locations in decimal digit.}
#'     \item{Altitude}{Altitude of the locations.}
#'     \item{Type}{Labels of the climate data, including annual average
#'     precipitation,annual average minimum temperature,annual average
#'     maximum temperature, and annual extreme minimum temperature.}
#'     \item{1}{Values of specific type of climate data,the names of columns
#'     represent monthly values from January to December.}
#'     \item{2}{Values of specific type of climate data,the names of columns
#'     represent monthly values from January to December.}
#'     \item{3}{Values of specific type of climate data,the names of columns
#'     represent monthly values from January to December.}
#'     \item{4}{Values of specific type of climate data,the names of columns
#'     represent monthly values from January to December.}
#'     \item{5}{Values of specific type of climate data,the names of columns
#'     represent monthly values from January to December.}
#'    \item{6}{Values of specific type of climate data,the names of columns
#'    represent monthly values from January to December.}
#'    \item{7}{Values of specific type of climate data,the names of columns
#'    represent monthly values from January to December.}
#'    \item{8}{Values of specific type of climate data,the names of columns
#'     represent monthly values from January to December.}
#'    \item{9}{Values of specific type of climate data,the names of columns
#'     represent monthly values from January to December.}
#'    \item{10}{Values of specific type of climate data,the names of columns
#'    represent monthly values from January to December.}
#'    \item{11}{Values of specific type of climate data,the names of columns
#'    represent monthly values from January to December.}
#'    \item{12}{Values of specific type of climate data,the names of columns
#'    represent monthly values from January to December.}
#'     ...
#'     }
#' @keywords internal
#' @source \url{NULL}
NULL
