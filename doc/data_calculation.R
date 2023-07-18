params <-
list(EVAL = FALSE)

## ----cal_code,eval=FALSE------------------------------------------------------
#  library(raster)
#  library(dplyr)
#  library(stringr)
#  library(future.apply)
#  library(parallel)
#  
#  clim_cal <- function(imp_path,
#                       exp_path,
#                       name=NA,
#                       method="mean",
#                       parallel=1,
#                       ...){
#  tifname <- list.files(imp_path,full.names = T)
#  
#  rastermean <- function(num){
#    tif <- tifname[tifname %>% str_detect(pattern = paste0("-",num,".tif"))]
#    val <- lapply(tif,raster) %>% raster::brick() %>% calc(mean)
#    return(val)
#  }
#  
#  rastermin <- function(num){
#    tif <- tifname[tifname %>% str_detect(pattern = paste0("-",num,".tif"))]
#    val <- lapply(tif,raster) %>% brick() %>% calc(min)
#    return(val)
#  }
#  
#  plan(multisession,workers= parallel)
#  month <- c(1:12) %>% str_pad(2,side = "left","0")
#  
#  if(method=="mean"){
#    raster <- future_lapply(month,function(x) rastermean(x))
#  }else if(method=="min"){
#    raster <- future_lapply(month,function(x) rastermin(x))
#  }
#  
#  rasterstack <- raster %>% stack()
#  path <- exp_path
#  for(i in 1:12){
#    ras <- raster(rasterstack,layer=i)
#    #export the RasterLayer
#    writeRaster(ras,file.path(path,paste0(name,"_",month[i],".tif")))
#  }
#  
#  }
#  

