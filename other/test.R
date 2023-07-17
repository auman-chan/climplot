library(devtools)
library(testthat)
document()
load_all()
?clim_plot()
tools::R_user_dir("climplot",which = "data")

use_package("climplot")

use_testthat()
use_test("climplot")
use_readme_rmd()
rmarkdown::render("README.Rmd")

data("locdata")
a <- "D:/climplot/mean_mintemp"
b <- "D:/climplot/mean_maxtemp"
c <- "D:/climplot/mean_prec"
lc <- clim_extract(locdata,a,b,c)
plotdata <- lc
test <- subset(lc,No==10)
clim_plot(data=test,ylabel = T,
          ylab1="Temperature(\U{00B0}C)",
          ylab2="Precipitation(mm)",
          p50line = T)
rm(clim_plot)
