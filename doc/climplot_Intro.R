params <-
list(EVAL = FALSE)

## ---- echo=FALSE, out.width="30%",fig.align = 'center'------------------------
knitr::include_graphics("imgfile.png")

## ----intasll, eval=FALSE------------------------------------------------------
#  install.packages('remotes')
#  install.packages('git2r')
#  remotes::install_git("https://gitee.com/auman-chan/climplot.git")

## ----load package,include=FALSE-----------------------------------------------
#load package
library(climplot)

## ----echo=FALSE---------------------------------------------------------------
read.csv("climdata.csv")

## ----global options, echo=FALSE, message=FALSE, warning=FALSE-----------------
data("locdata")
locdata

## ----extraction,eval=FALSE----------------------------------------------------
#  #Modify the path of yours
#  a <- "G:/climplot/climdata/tmin"
#  b <- "G:/climplot/climdata/tmax"
#  c <- "G:/climplot/climdata/prec"
#  
#  #extraction of climate data
#  
#  plotdata <- clim_extract(locdata,a,b,c)
#  }

## ----plotdata,echo=FALSE------------------------------------------------------
data("plotdata")
plotdata

## ----extraction with Frost,eval=FALSE-----------------------------------------
#  #Modify the path of yours
#  a <- "G:/climplot/climdata/tmin"
#  b <- "G:/climplot/climdata/tmax"
#  c <- "G:/climplot/climdata/prec"
#  d <- "G:/climplot/climdata/extmin"
#  #extraction of climate data
#  
#  plotdata <- clim_extract(locdata,a,b,c,Frost = TRUE,d)
#  }

## ----plotdata_F,echo=FALSE----------------------------------------------------
data("plotdata_Frost")
plotdata_Frost

## ----plot1--------------------------------------------------------------------
data("plotdata")
loc <- subset(plotdata,No==2)
clim_plot(loc)


## ----plot mutli, eval=FALSE---------------------------------------------------
#  data("plotdata")
#  list <- unique(plotdata$No)
#  par(mfrow=c(1,1))
#  for (i in 1:5){
#   k <- list[i]
#  sub <- subset(plotdata,No==k)
#  clim_plot(data=sub,ylabel = TRUE,
#            ylab1="Temperature(\U{00B0}C)",
#            ylab2="Precipitation(mm)",
#             p50line = TRUE)
#  }

## ----plot frost, echo=TRUE----------------------------------------------------

data("plotdata_Frost")
loc <- subset(plotdata_Frost,No==3)
clim_plot(data=loc,ShowForst = T)

## ----color picker, echo=TRUE--------------------------------------------------
loc <- subset(plotdata_Frost,No==1)
clim_plot(loc,pcol = "#8DB6CD",tcol = "#FF6A6A",wcol="#4EEE94",dcol = "#EEB422",pfcol="#00BFFF",sfcol="#8A2BE2",ShowForst = TRUE)


## ----label, echo=TRUE---------------------------------------------------------
loc <- subset(plotdata_Frost,No==1)
clim_plot(loc,xlab="月份",mlab = "en",ylabel = TRUE,ylab1 ="Temperature(\U{00B0}C)",ylab2 ="Precipitation(mm)",ShowForst = TRUE)

## ----auxiliary line-----------------------------------------------------------
loc <- subset(plotdata_Frost,No==1)
clim_plot(loc,p3line = TRUE,p50line = TRUE,extremeT = TRUE,ShowForst = TRUE)

