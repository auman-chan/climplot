#' @rdname climate_data_extraction
#' @title Obtain climate data for climatic diagram drawing online
#' @usage clim_extract(file, path = tempdir())
#' @description \code{clim_extract} acquires crucial climate data from online
#' datasets for drawing Walter & Lieth climatic diagrams
#' based on the provided location coordinates.
#'
#' @details This function extracts precipitation and temperature from
#' Worldclim Historical monthly weather
#' data in 2010-2019
#' (Version of 2.5 minutes,https://worldclim.org/data/monthlywth.html),
#' containing annual average precipitation, annual average
#' temperature,annual average minimum
#' temperature and annual average max temperature of 12 months. It downloads the
#' climate data, extracts and arranges them to a data frame for drawing
#' the climatic diagram.
#'
#' @param file
#'     A data.frame(see details in dataset \code{locdata})
#'     with the following 5 columns:
#'     \itemize{
#'     \item \code{No}: Serial number of the locations
#'     \item \code{location}: Abbreviation of the locations
#'     \item \code{lon}: Longitude of the locations in decimal digit
#' (West longitude are represented by negative numbers)
#'     \item \code{lat}: Latitude of the locations in decimal digit
#' (South latitude are represented by negative numbers)
#'     \item \code{altitude}: Altitude of the locations
#'     }
#'     Other columns with information is allowed behind the columns above
#'     but would be discarded in following process.
#'
#' @param path character.A Path for storing the downloaded data,
#' avoids downloading the same data many times over and
#' guards against service interruptions. Deafault is
#'  tempdir().
#'
#' @return A data.frame with annual average precipitation, annual average
#' temperature, annual average minimum temperature and
#' annual average max temperature of 12 months, as well as
#' other essential information of every location.
#' Note that some locations don't have data of annual average temperature,
#' so they would be replace by values averaged by
#' annual average minimum temperature and annual average maximum temperature.
#'
#'
#' \itemize{
#'    \item \code{No,location,lon,lat}: Information of the locations,
#'    the the same as which in parameter \code{file}.
#'     \item \code{type}: The labels of climate data,
#'     encompassing annual average precipitation,
#'     annual average minimum temperature,annual average temperature and
#'     annual average maximum temperature.
#'     \item \code{1-12}: The column names of the particular climate data type
#'     correspond to monthly values ranging from January to December.
#' }
#' See more details in dataset \code{plotdata}.
#'
#' @examples{
#' #import data of locations
#' x <- data.frame(No = "1", location = "test",
#' lon = 0, lat = -30, altitude = 20)
#' #Code below will download data automatically
#' \dontrun{
#' y <- clim_extract(x)
#' }
#' }
#'
#' @importFrom sf st_as_sf
#' @importFrom dplyr mutate arrange select
#' @importFrom terra extract rast crs
#' @importFrom dplyr as_tibble
#' @importFrom magrittr %>%
#' @importFrom geodata worldclim_tile
#' @importFrom plyr ddply
#'
#' @export

clim_extract <- function(file, path = tempdir()) {
  if (!is.numeric(file$lon)) {
    stop("The longitude should be numeric")
  }
  if (!is.numeric(file$lat)) {
    stop("The latitude should be numeric")
  }
  if (!dir.exists(path)) {
    stop("The path doesn't exist")
  }

  extract_one_location <- function(sub) {
    No <- sub$No
    lon <- sub$lon
    lat <- sub$lat

    mintemp <- worldclim_tile(
      var = "tmin",
      lon = lon, lat = lat, path = path
    )
    maxtemp <- worldclim_tile(
      var = "tmax",
      lon = lon, lat = lat, path = path
    )
    avtemp <- worldclim_tile(
      var = "tavg",
      lon = lon, lat = lat, path = path
    )
    avprec <- worldclim_tile(
      var = "prec",
      lon = lon, lat = lat, path = path
    )

    if (is.null(mintemp) || is.null(maxtemp) || is.null(avprec)) {
      stop(paste("Can not find data for location", No))
    }


    point <- st_as_sf(sub, coords = c("lon", "lat"), crs = 4326)

    prec <- extract(avprec, point) %>%
      as_tibble() %>%
      select(-ID)

    colnames(prec) <- as.character(c(1:12))

    avtemp1 <- extract(mintemp, point) %>%
      as_tibble() %>%
      select(-ID)

    colnames(avtemp1) <- as.character(c(1:12))

    avtemp2 <- extract(maxtemp, point) %>%
      as_tibble() %>%
      select(-ID)

    colnames(avtemp2) <- as.character(c(1:12))

    if (!is.null(avtemp)) {
      avtemp3 <- extract(maxtemp, point) %>%
        as_tibble() %>%
        select(-ID)

      colnames(avtemp3) <- as.character(c(1:12))
    } else {
      avtemp3 <- apply(rbind(avtemp1, avtemp2), 2, mean) %>%
        t() %>%
        as_tibble()
    }

    avtemp1 <- avtemp1 %>% mutate(
      No = sub$No,
      Altitude = sub$altitude,
      Location = sub$location,
      Lon = sub$lon,
      Lat = sub$lat,
      Type = "min_temp", .before = 1
    )

    avtemp2 <- avtemp2 %>% mutate(
      No = sub$No,
      Altitude = sub$altitude,
      Location = sub$location,
      Lon = sub$lon,
      Lat = sub$lat,
      Type = "max_temp", .before = 1
    )

    avtemp3 <- avtemp3 %>% mutate(
      No = sub$No,
      Altitude = sub$altitude,
      Location = sub$location,
      Lon = sub$lon,
      Lat = sub$lat,
      Type = "mean_temp", .before = 1
    )

    prec <- prec %>% mutate(
      No = sub$No,
      Altitude = sub$altitude,
      Location = sub$location,
      Lon = sub$lon,
      Lat = sub$lat,
      Type = "prec", .before = 1
    )

    clidata <- rbind(prec, avtemp3, avtemp1, avtemp2) %>% arrange(No)

    return(clidata)
  }



  all_clidata <- ddply(file, ~No, extract_one_location)

  return(all_clidata)
}
