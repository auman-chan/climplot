#The code for climatic data calculation.
#Because of the calculation required a lot of memory usage and time,lack of generality.
#So we haven't import them into package as a function

#imp_path: path of import Worldclim Worldclim Historical monthly weather data,
#every kind of dataset(mintemp,maxtemp,prec)should be saparated in different folders

#exp_path: path of export arranged data in format of .tif

#name: the name of tif file to differentiate the data

#method: the method for calculating the raster,default is "mean" to calculate
#annual average climatic values
#Set as "min" to calculate annual minimum climatic values for forst month display.

clim_cal <- function(imp_path,
                     exp_path,
                     name=NA,
                     method="mean",
                     ...){
tifname <- list.files(imp_path,full.names = T)

rastermean <- function(num){
  tif <- tifname[tifname %>% str_detect(pattern = paste0("-",num,".tif"))]
  val <- lapply(tif,raster) %>% raster::brick() %>% calc(mean)
  return(val)
}

rastermin <- function(num){
  tif <- tifname[tifname %>% str_detect(pattern = paste0("-",num,".tif"))]
  val <- lapply(tif,raster) %>% brick() %>% calc(min)
  return(val)
}

plan(multisession,workers= parallel)
month <- c(1:12) %>% str_pad(2,side = "left","0")

if(method=="mean"){
  raster <- future_lapply(month,function(x) rastermean(x))
}else if(method=="min"){
  raster <- future_lapply(month,function(x) rastermin(x))
}

rasterstack <- raster %>% stack()
path <- exp_path
for(i in 1:12){
  ras <- raster(rasterstack,layer=i)
  #export the RasterLayer
  writeRaster(ras,file.path(path,paste0(name,month[i],".tif")))
}

}
