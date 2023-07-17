library(devtools)
library(testthat)

document()
load_all()
?clim_plot()
?clim_extract()
?plotdata
tools::R_user_dir("climplot",which = "data")

use_package("climplot")

use_testthat()
use_test("climplot")
use_readme_rmd()
rmarkdown::render("README.Rmd")

data("locdata")
data("plotdata")
a <- "D:/climplot/mean_mintemp"
b <- "D:/climplot/mean_maxtemp"
c <- "D:/climplot/mean_prec"
lc <- clim_extract(locdata,a,b,c)
plotdata <- lc

data("plotdata")
test <- subset(lc,No==10)
clim_plot(data=test,ylabel = T,
          ylab1="Temperature(\U{00B0}C)",
          ylab2="Precipitation(mm)",
          p50line = T)
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
