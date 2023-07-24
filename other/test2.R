library(sp)
library(raster)
library(dplyr)
library(sf)
library(tibble)
path <- "C:/Users/czhxu/.ssh"
list.files(path)
creds <- git2r::cred_ssh_key("C:/Users/czhxu/.ssh/id_rsa.pub", "C:/Users/czhxu/.ssh/id_rsa")

remotes::install_git("https://gitee.com/auman-chan/climplot.git",credentials = creds)
remotes::install_github("auman-chan/climplot",auth_token = "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")

library(climplot)
library(sp)
data("locdata")
data("plotdata_Frost")

data("plotdata")
y <- readxl::read_xlsx("other/datatest.xlsx")
k <- subset(plotdata_Frost,No==3)

avmintemp <- list.files(a,full.names = T) %>% stack()

m <- data.frame(No="1",location="test",lon=113.27,lat=23.13,altitude=20)
file <- m
point <- st_as_sf(file, coords = c("lon","lat"))
st_crs(point) <- crs(avmintemp)

avtemp1 <- extract(avmintemp,point) %>% as_tibble()
p <- as_tibble(m)
loc <- as.data.frame(locdata)
a <- "G:/climplot/climdata/tmin"
b <- "G:/climplot/climdata/tmax"
c <- "G:/climplot/climdata/prec"
d <- "G:/climplot/climdata/tmin"
x <- clim_extract(locdata,a,b,c)
clim_plot(k,ShowFrost = T)

for (i in 1:3){

 sub <- subset(x,No==i)
 clim_plot(data=sub,ylabel = TRUE,
        ylab1="Temperature(\U{00B0}C)",
            ylab2="Precipitation(mm)",
            p50line = TRUE)
}
