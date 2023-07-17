#' @rdname climate_data
#' @title Acquire climate data for climatic diagram
#' @usage clim_extract(file,mintemp_path,maxtemp_path,prec_path)
#' @description \code{clim_extract} acquires climate data which are esstential for
#'Walter & Lieth climatic diagram plotting according to the provided coordinate of
#'the location.
#'
#'@details The function extracts precipitation and temperature from a
#'series of arranged climate data in RasterLayer format,
#'and arranges them to a data frame for plotting the climatic diagram.
#'The RasterLayer are computed by Worldclim Historical monthly weather data in 2010-2019
#'(Version of 2.5 minutes,https://worldclim.org/data/monthlywth.html), containing annual average precipitation, annual average minimum
#' temperature and annual average max temperature of 12 months in 2010-2019.
#'They can output from original climate data mentioned above with running the code
#'in script \code{other/clim_cal.R}, or download directly from the supplementary material.
#'
#' @param file
#'     A data.frame(see details in dataset \code{locdata}) with the following 5 columns:
#'     \itemize{
#'     \item \code{No}: Serial number of the locations
#'     \item \code{location}: Abbreviation of the locations
#'     \item \code{lon}: Longitude of the locations in decimal digit
#'(East longitude are represented by negative numbers)
#'     \item \code{lat}: Latitude of the locations in decimal digit
#'(South latitude are represented by negative numbers)
#'     \item \code{altitude}: Altitude of the locations
#'     }
#'     Other columns with information is allowed behind the columns above
#'     but would be discarded in following process.
#'
#'    @param mintemp_path The path for the folder of annual average minimum
#'    temperature. The folder contains 12 .tif files corresponding to data of 12 months.
#'
#'    @param maxtemp_path The path for the folder of annual average maximum
#'    temperature. The folder contains 12 .tif files corresponding to data of 12 months.
#'
#'    @param prec_path The path for the folder of annual average maximum
#'    temperature. The folder contains 12 .tif files corresponding to data of 12 months.
#'
#' @return A data.frame with annual average precipitation, annual average minimum
#' temperature and annual average max temperature of 12 months, as well as
#' other essential information of every location.
#'
#' \itemize{
#'    \item \code{No,location,lon,lat}: information of the station,the the same as
#'which in parameter \code{file}.
#'     \item \code{type}: Labels of the climate data,including annual average
#'     precipitation,annual average minimum temperature and annual average
#'     maximum temperature.
#'     \item \code{1-12}: Values of specific type of climate data,the names of columns
#'represent monthly values from January to December.
#'}
#'See more details in dataset \code{plotdata}.
#'
#' @references {Guijarro J A (2023). climatol: Climate Tools
#' (Series Homogenization and Derived Products), 4.0.0.,
#' https://CRAN.R-project.org/package=climatol
#'
#' Fick, S.E. and R.J. Hijmans, (2017). WorldClim 2:
#'new 1km spatial resolution climate surfaces for global land areas.
#'International Journal of Climatology 37 (12): 4302-4315.
#'
#' Harris, I., Osborn, T.J., Jones, P.D., Lister, D.H. (2020).
#' Version 4 of the CRU TS monthly high-resolution gridded multivariate climate dataset.
#'Scientific Data 7: 109
#'
#' Walter H & Lieth H (1960): Klimadiagramm Weltatlas. G. Fischer, Jena.}
#'
#'@examples{
#' #import data of stations
#' data("locdata")
#' #Please modify the path of yours
#' a <- "D:/climplot/climdata/mean_mintemp"
#' b <- "D:/climplot/climdata/mean_maxtemp"
#' c <- "D:/climplot/climdata/mean_prec"
#' #extraction of climate data
#' \dontrun{
#' #not sure whether the folders are ready
#' cli <- clim_extract(locdata,a,b,c)
#' }
#' }
#' @importFrom sp coordinates
#' @importFrom dplyr mutate arrange desc
#' @importFrom raster extract stack
#' @importFrom dplyr as_tibble
#' @importFrom magrittr %>%
#'
#' @keywords internal
#' @export

clim_extract <- function(file,
                         mintemp_path,
                         maxtemp_path,
                         prec_path
                         ){
  if(!file.exists(mintemp_path)) {
    stop("The path of 'mintemp' data doesn't exist!")
  }

  if(!file.exists(maxtemp_path)) {
    stop("The path of 'maxtemp' data doesn't exist!")
  }

  if(!file.exists(prec_path)) {
    stop("The path of 'prep' data doesn't exist!")
  }

  avmintemp <- list.files(mintemp_path,full.names = T) %>% stack()
  avmaxtemp <- list.files(maxtemp_path,full.names = T) %>% stack()
  avprec <- list.files(prec_path,full.names = T) %>% stack()

pointdata <- file
  point <- data.frame(lon=coordinates(pointdata[,"lon"]),
                            lat=coordinates(pointdata[,"lat"]))
  avtemp1 <- extract(avmintemp,point) %>% as_tibble()
  colnames(avtemp1) <- as.character(c(1:12))
  avtemp1 <- avtemp1 %>% mutate(No=pointdata$No,
                                       Altitude=pointdata$altitude,
                                       Location=pointdata$location,
                                       Lon=pointdata$lon,
                                       Lat=pointdata$lat,
                                       Type="min.temprature",.before = 1)

  avtemp2 <- extract(avmaxtemp,point) %>% as_tibble()
  colnames(avtemp2) <- as.character(c(1:12))
  avtemp2 <- avtemp2 %>% mutate(No=pointdata$No,
                                       Altitude=pointdata$altitude,
                                       Location=pointdata$location,
                                       Lon=pointdata$lon,
                                       Lat=pointdata$lat,
                                       Type="max.temprature",.before = 1)

  prec <- extract(avprec,point) %>% as_tibble()
  colnames(prec) <- as.character(c(1:12))
  prec <- prec %>% mutate(No=pointdata$No,
                                 Altitude=pointdata$altitude,
                                 Location=pointdata$location,
                                 Lon=pointdata$lon,
                                 Lat=pointdata$lat,
                                 Type="precipitation",.before = 1)

  #arrange by the order of mean precipitation,mean min_temperature and
  #mean max_temperature
  clidata <- rbind(prec,avtemp1,avtemp2) %>% arrange(Location,desc(Type))

  return(clidata)
}
