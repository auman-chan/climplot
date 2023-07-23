library(devtools)
library(testthat)
library(climplot)
library(tidyverse)
library(raster)
document()
load_all()

build_vignettes()
build_readme()

usethis::use_pkgdown()
#Reinstall Cairo and ragg packages when error of purrr...
#no use to bulid vignettes again cos they read from .Rmd files
pkgdown::build_site()
#build home from readme.md,so it should update the build again
#sometimes the pic can't display,move it to docs/articles manually
#also the name of customized pics without "-" or "num"
pkgdown::build_home()
pkgdown::build_reference()
rmarkdown::render("README.zh-CN.Rmd")

?clim_plot()
?clim_extract()
?plotdata_Frost
?plotdata


tools::R_user_dir("climplot",which = "data")

use_package("climplot")


use_testthat()
use_test("climplot")
use_readme_rmd()
rmarkdown::render("README.Rmd")

data("locdata")
data("plotdata")
t <- locdata
a <- "G:/climplot/climdata/tmin"
b <- "G:/climplot/climdata/tmax"
c <- "G:/climplot/climdata/prec"
d <- "G:/climplot/climdata/extmin"
list.files(b)
avmintemp <- list.files(a,full.names = T) %>% stack()
lc <- clim_extract(locdata,a,b,c)
lk <- clim_extract(locdata,a,b,c,Frost=TRUE,d)
plotdata <- lc
plotdata_Frost <- lk
use_data(plotdata,plotdata_Frost)

data("plotdata")
test <- subset(lk,No==10)
clim_plot(data=test,ylabel = T,
          ylab1="Temperature(\U{00B0}C)",
          ylab2="Precipitation(mm)",
          p50line = T,extremeT = T,ShowForst = T)
rm(clim_plot)
list <- unique(plotdata$No)
par(mfrow=c(1,1))
for (i in 1:5){
  k <- list[i]
  sub <- subset(plotdata,No==k)
  clim_plot(data=sub,ylabel = T,
            ylab1="Temperature(\U{00B0}C)",
            ylab2="Precipitation(mm)",
            p50line = T)
}

list1 <- list.files("G:/climplot/climdata/mean_maxtemp")
list2 <- list.files("G:/climplot/climdata/mean_mintemp")
list3 <- list.files("G:/climplot/climdata/mean_prec")
m <- data.frame( "annual_average_maximum_temperature"=list1,
                "annual_average_minimum_temperature"=list2,
                "annual_average_precipitation"=list3
    )
write.csv(m,file="climdata.csv")
