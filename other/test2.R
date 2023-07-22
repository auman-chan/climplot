library(sp)
library(raster)
library(dplyr)
path <- "C:/Users/czhxu/.ssh"
list.files(path)
creds <- git2r::cred_ssh_key("C:/Users/czhxu/.ssh/id_rsa.pub", "C:/Users/czhxu/.ssh/id_rsa")

remotes::install_git("https://gitee.com/auman-chan/climplot.git",credentials = creds)
remotes::install_github("auman-chan/climplot",auth_token = "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")

library(climplot)
library(sp)
data("locdata")
data("plotdata_Frost")


m <- data.frame(No="1",location="test",lon=113.27,lat=23.13,altitude=20)
p <- as_tibble(m)
loc <- as.data.frame(locdata)
a <- "D:/climplot/tmin"
b <- "D:/climplot/tmax"
c <- "D:/climplot/prec"
d <- "D:/climplot/extmin"
x <- clim_extract(locdata,a,b,c,Frost = T,d)
loc <- as_tibble(locdata)
file <- m
avmintemp <- list.files(a,full.names = T)
x <- raster::stack(avmintemp)
