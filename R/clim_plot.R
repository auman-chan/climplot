#' @rdname climatic_diagram
#' @title  Walter & Lieth climatic diagram construction
#' @usage clim_plot(data,mlab="",pcol="blue",tcol="red",wcol="green",dcol="orange",
#'pfcol="#79e6e8",sfcol="#09a0d1",ylabel=FALSE,ylab1=NA,ylab2=NA,xlab="Month",
#'ShowFrost=FALSE,shem=FALSE,p3line=FALSE,p50line=FALSE,extremeT=FALSE,
#'margen=c(4,4,5,4),per=NA)
#'
#' @description \code{clim_plot} plots the Walter & Lieth climatic diagram
#' with the climate data of different locations. It is based on the method of function
#' \code{diagwl()}from package \code{climatol},
#' but offers additional parameters for color selection, axis labeling,
#' and location information display to meet diverse research and publishing needs.
#'
#'
#' @param data A data.frame(see details in the dataset \code{plotdata})
#' with the following 18 columns:
#'     \itemize{
#'    \item \code{No}: Serial number of the locations.
#'     \item \code{location}: Abbreviation of the locations.
#'     \item \code{lon}: Longitude of the locations in decimal digit
#'     (negative numbers indicating west longitude).
#'     \item \code{lat}: Latitude of the locations in decimal digit
#'     (negative numbers indicating south latitude).
#'     \item \code{altitude}: Altitude of the locations.
#'     \item \code{type}: The labels of climate data, encompassing annual average precipitation,
#'     annual average minimum temperature and annual average maximum temperature.
#'     In the event that Frost=True, it will also incorporate annual extreme minimum temperature.
#'     \item \code{1-12}: The column names of the particular climate data type
#'     correspond to monthly values ranging from January to December.
#'}
#'     Other columns containing information may be placed after the aforementioned columns,
#'     but will be disregarded in subsequent processes.
#'
#' @param mlab A vector of 12 monthly labels for the X axis.Deafult is numeric.
#' Alternatively, set as 'en' or 'es' can be specified to display
#' the month names in English or Spanish respectively.
#' (original parameter of the referenced function \code{diagwl()}).
#'
#' @param pcol Color of the precipitation curve. Default is "blue".
#'
#' @param tcol Color of the temperature curve. Default is "red".
#'
#' @param wcol Color of the humid season polygon. Default is "green".
#'
#' @param dcol Color of the arid season polygon. Default is "orange".
#'
#' @param ShowFrost A logical value for whether marking forst months. Default is FALSE.
#'
#' @param pfcol Color of the potential frosty months. Default is "#79e6e8". No use when
#' ShowFrost= FALSE.
#'
#' @param sfcol Color of the accurate frosty months. Default is "#09a0d1".
#' No use when ShowFrost= FALSE.
#'
#' @param ylabel A logical value for whether using customized label of y axis. Default is FALSE.
#'
#' @param ylab1 A character value for label of y axis of temperature. Default is NA.
#'
#' @param ylab2 A character value for label of y axis of precipitation. Default is NA.
#'
#' @param xlab A character value for label of x axis. Default is "Month".
#'
#' @param shem A logical value for whether keeping the summer period in
#' the central zone of the graphic
#' (the diagram will begin the plot with the July data). Default is FALSE. Useful when the
#' location is in southern hemisphere
#' (original parameter of the referenced function \code{diagwl()}).
#'
#' @param p3line A logical value for whether displaying
#' a supplementary precipitation line referenced to three times the temperature.
#' Default is FALSE
#' (original parameter of the referenced function \code{diagwl()}).
#'
#' @param p50line A logical value for whether displaying a supplementary
#' precipitation line in 50°C-100mm. Default is FALSE.

#' @param extremeT A logical value for whether displaying the extreme temperature.
#' Default is FALSE.
#'
#' @param margen A vector to control the range of plot. Default is "c(4,4,5,4)"
#'
#' @param per a parameter from the referenced function \code{diagwl()}. No use temporarily.
#'
#'#'@details The function extracts precipitation and temperature from arranged
#'Worldclim Historical monthly weather data(https://worldclim.org/data/monthlywth.html)
#'and arranges them to a data.frame for constructing the climatic diagram.
#'
#' @return A Walter & Lieth climatic diagram of the provided locations, including annual variation
#' of temperature and precipitation , as well as the time of humid and arid season.
#'
#' @references {Guijarro J A (2023). climatol: Climate Tools
#' (Series Homogenization and Derived Products), 4.0.0.,
#' https://CRAN.R-project.org/package=climatol.
#'
#' Walter H & Lieth H (1960): Klimadiagramm Weltatlas. G. Fischer, Jena.}
#'
#' @examples {
#' data("plotdata")
#' test <- subset(plotdata,No==10)
#'clim_plot(data=test,ylabel = TRUE,
#'         ylab1="Temperature(\U{00B0}C)",
#'         ylab2="Precipitation(mm)",
#'         p50line = TRUE)
#'
#'#use loop to plot multiple diagrams simultaneously
#'list <- unique(plotdata$No)
#'par(mfrow=c(1,1))
#'for (i in 1:5){
#'  k <- list[i]
#' sub <- subset(plotdata,No==k)
#' clim_plot(data=sub,ylabel = TRUE,
#'           ylab1="Temperature(\U{00B0}C)",
#'           ylab2="Precipitation(mm)",
#'            p50line = TRUE)
#'}
#'
#' }
#'
#' @import graphics
#' @import stats
#' @export

clim_plot <- function(data,     #dataset
                       mlab="", #月份显示方式，默认数字，en为英文首字母，es为西文
                       pcol="blue", #降雨线颜色
                       tcol="red",
                      wcol="green", #
                      dcol="orange",
                      pfcol="#79e6e8",
                      sfcol="#09a0d1",
                       ylabel=FALSE,
                       ylab1=NA,
                       ylab2=NA,
                       xlab="Month",
                       ShowFrost=FALSE, #whether display the frosty months
                       shem=FALSE,
                       p3line=FALSE, #auxiliary line of temperature
                       p50line=FALSE,#auxiliary line of 50-100mm precipitation
                       extremeT=FALSE,
                      margen=c(4,4,5,4),
                      per=NA #观测年份
                       ) {

  est <- data$Location[1]
  alt <- data$Altitude[1]
  lon <- round(data$Lon[1],digits = 2)
  lat <- round(data$Lat[1],digits = 2)
  if(lon<0){
    lonmark <- "W"
  }else{
    lonmark <- "E"
  }
  if(lat<0){
    latmark <- "S"
  }else{
    latmark <- "N"
  }

  loc <- paste0(lon,"\U{00B0}",lonmark," ",lat,"\U{00B0}",latmark)
  dat <- data[,(7:18)] #extract the information of plotting

  old.par <- par(no.readonly = TRUE)
  on.exit(par(old.par))
  par(mar=margen, pty="m", las=0, new=FALSE)
  nr <- nrow(dat)
  if(nrow(dat) < 3) stop("Three rows of monthly data should be provided.\n")
  #etiquetas de los meses
  if(mlab=="es") mlab=c("E","F","M","A","M","J","J","A","S","O","N","D")
  else if(mlab=="en") mlab=c("J","F","M","A","M","J","J","A","S","O","N","D")
  else mlab=c(1:12)
  dat <- as.matrix(dat)
  if(shem) {
    m1 <- dat[,1:6]
    m2 <- dat[,7:12]
    dat <- cbind(m2,m1)
    mlab <- c(mlab[7:12],mlab[1:6])
  }
  p <- dat[1,] #get precipitation data
  if(nr==2) tm <- dat[2,]
  else tm <- apply(dat[2:3,],2,mean)  #calculate mean temperature
  pmax <- max(p) #get max precipitation
  ymax <- 60  #set max value of temperature
  if(pmax > 300) ymax <- 50 + 10*floor((pmax+100)/200)
  ymin <- min(-1.5,min(tm))
  #ejes:生成坐标轴，如果有零下温度还会生成零下部分
  if(ymin < -1.5) {
    ymin=floor(ymin/10)*10 #keep tens
    labT <- paste(ymin)
    labP <- ""
    if(ymin < -10) {
      for(i in (ymin/10+1):-1) {
        labT <- c(labT,i*10) #minimum temperature value
        labP <- c(labP,"")
      }
    }
    labT <- c(labT,"0","10","20","30","40","50","")
    labP <- c(labP,"0","20","40","60","80","100","300")
  }
  else {
    labT <- c("0","10","20","30","40","50","")
    labP <- c("0","20","40","60","80","100","300")
  }
  if(ymax > 60) {
    for(i in 6:(ymax/10-1)) {
      labT <- c(labT,"")
      labP <- c(labP,100*(2*i-7))
    }
  }
  plot(0:13-0.5,c(tm[12],tm[1:12],tm[1]),xlim=c(0,12),
       ylim=c(ymin,ymax),type="n",xaxs="i",yaxs="i",
       xaxp=c(0,12,12),xlab="",ylab="",xaxt="n",yaxt="n",bty="n")

  lmin <- ymin #create the label according to minimum
  if(lmin==-1.5) lmin=0


  axis(2,((lmin/10):(ymax/10))*10,labels=labT,col.axis=tcol)#side=2,left axis
  axis(4,((lmin/10):(ymax/10))*10,labels=labP,col.axis=pcol)#side=2,right axis

  #display mode of ylab
  if(ylabel){
    mtext(ylab1,cex = 1.2,side=2,line=2.5,adj=0.5)
    mtext(ylab2,cex = 1.2,side=4,line=2.5,adj=0.5)
  }
  else{
    mtext("\U{00B0}C",2,col=tcol,las=1,line=3.5,adj=0,at=60)
    mtext("mm",4,col=pcol,las=1,line=3.5,adj=1,at=60)
  }
  mtext(xlab,cex = 1.2,side=1,line=2.5,adj=0.5)

  abline(0,0)
  if(p50line){abline(50,0)}
  #information above the plot
  if(is.na(alt))
  {mtext(est,line=2,adj=0,cex=1.2)
  }
  if(is.na(per)) {
    mtext(paste(est," (",alt," m)",sep=""),line=2,adj=0,cex=1.2)
    mtext(loc, line=1,adj=0,cex=1.2)
  }
  else {
    mtext(paste(est," (",alt," m)",sep=""),line=3,adj=0,cex=1.2)
    mtext(loc, line=2,adj=0,cex=1.2)
    mtext(per,line=1,adj=0,cex=1.2)
  }
  mtext(paste(round(mean(tm*10))/10,"\U{00B0}C"),line=2,adj=1,cex=1.2)
  mtext(paste(round(sum(p))," mm",sep=""),line=1,adj=1,cex=1.2)


  x <- 0:13-0.5  #value of x axis
  p2 <- c(p[12],p[1:12],p[1])
  #14 points for a smooth line of precipitation

  if(p3line) { #auxiliary line of precipitation
    yl3 <- c(p[12],p[1:12],p[1])/3
    yl3[yl3>50] <- 50
  }

  #precipitation divide by 2 when its maximum is less than 100mm
  if(pmax<=100) {
    xl <- x
    yl <- c(p[12],p[1:12],p[1])/2
    n2 <- 14
  }
  else {
    #precipitation axis transform when its maximum is more than 100mm
    #生成为0的空数据框
    #xp
    #xp and yp对应丰水期的数据绘制，设置有30个坐标点（不与月份一一对应）
    #xl和yl对应降水的曲线绘制，设置有25个坐标点（不与月份一一对应）
    xp <- numeric(30)
    yp <- numeric(30)
    xl <- numeric(25)
    yl <- numeric(25)
    n <- 0 #number of points of wet season polygon
    n2 <- 0 # #number of points of humid season polygon
    gr <- FALSE
    #When prec of two adjacent months are across the 100mm line
    #the unit of prec would change(2mm and 20mm)
    #the scale of curve would change as well
    if(p2[1]>100) {
      #prec of first month is more than 100mm
      n <- n+1
      xp[n] <- x[1]
      yp[n] <- 50
      n <- n+1
      xp[n] <- x[1]
      yp[n] <- 50 + (p2[1]-100)/20
      n <- n+1
      n2 <- n2+1
      xl[n2] <- x[1]
      yl[n2] <- 50
      gr <- TRUE
    }
    else {
      #prec of first month is less than 100mm
      n2 <- n2+1
      xl[n2] <- x[1]
      yl[n2] <- p2[1]/2
    }
    for(i in 2:14) {
      if(gr) {

        n <- n+1
        if(p2[i]>100) {
          #1. two adjacent months with prec more than 100mm
          xp[n] <- x[i]
          yp[n] <- 50 + (p2[i]-100)/20

        }
        else {
          #2. the month with prec less than 100mm but the last month more than 100mm
          xp[n] <- x[i-1] + (100-p2[i-1])/(p2[i]-p2[i-1])
          #x coordinate of turning point of wet season polygon would have scale-change
          yp[n] <- 50 #y coordinate of turning point of wet season polygon,set as position 50(C)
          n2 <- n2+1 #new turning point of prec curve
          xl[n2] <- xp[n]
          yl[n2] <- 50
          n <- n+1 # a NA point to mark the potential end of polygon
          xp[n] <- NA
          yp[n] <- NA
          n2 <- n2+1 # a
          xl[n2] <- x[i]
          yl[n2] <- p2[i]/2
          gr <- FALSE
        }
      }
      else {

        if(p2[i]>100) {
          #2. the month with prec less than 100mm but the last month more than 100mm
          n <- n+1
          xp[n] <- x[i-1] + (100-p2[i-1])/(p2[i]-p2[i-1])
          yp[n] <- 50
          #check whether the normal points of last month has been created
          if(xl[n2]!=x[i-1]) {
            n2 <- n2+1 #create one
            xl[n2] <- x[i-1]
            yl[n2] <- p2[i-1]/2
          }

          n2 <- n2+1
          xl[n2] <- xp[n]
          yl[n2] <- 50

          n <- n+1
          xp[n] <- x[i]
          yp[n] <- 50 + (p2[i]-100)/20
          gr <- TRUE
        }
        else {
          #4.two adjacent months with prec less than 100mm
          n2 <- n2+1
          xl[n2] <- x[i]
          yl[n2] <- p2[i]/2
        }
      }
    }
    if(!is.na(yp[n])) {
      # add a point behind NA point to close the polygon
      n <- n+1
      xp[n] <- xp[n-1]
      yp[n] <- 50
      n2 <- n2+1
      xl[n2] <- 12.5
      yl[n2] <- 50
    }
    #plot the polygon
    polygon(xp[1:n],yp[1:n],col=pcol,border=pcol)
  }
  #plot the polygon of humid and arid season
  pi <- approx(xl[1:n2],yl[1:n2],n=66)$y
  ti <- approx(x,c(tm[12],tm[1:12],tm[1]),n=66)$y
  ti[ti<0] <- 0
  d <- pi - ti
  xi <- (1:66)/5-0.7
  xw <- subset(xi,d>0) #humid months
  y1 <- subset(pi,d>0)
  y2 <- subset(ti,d>0)
  if(length(xw)>0) segments(xw,y1,xw,y2,col=wcol,lty=1,lwd=1)
  xw <- subset(xi,d<0) #arid months
  y1 <- subset(pi,d<0)
  y2 <- subset(ti,d<0)
  if(length(xw)>0) segments(xw,y1,xw,y2,col=dcol,lty=3,lwd=2)
  if(ShowFrost& nrow(dat)==4){
    #Forsty months display
    #accurate frosty months
    for(i in 1:12) if(dat[3,i]<=0) rect(i-1,-1.5,i,0,col=sfcol)
    #potential frosty months
    for(i in 1:12) if(dat[4,i]<=0 && dat[3,i]>0) rect(i-1,-1.5,i,0,col=pfcol)
  }

  lines(xl[1:n2],yl[1:n2],col=pcol,lwd=2)#prec curve
  if(p3line) lines(x,yl3)
  lines(x,c(tm[12],tm[1:12],tm[1]),col=tcol,lwd=2)# temp curve

  if(extremeT){#extreme value

    mtext(formatC(max(as.matrix(dat[3,])),digits=1,format="f"),2,las=1,
          line=2,at=45)

    mtext(formatC(min(as.matrix(dat[2,])),digits=1,format="f"),2,las=1,
          line=2,at=5)
  }
  #marker of months
  for(i in 0:13) segments(i,0,i,-1.5)
  mtext(mlab,1,las=1,line=0.5,adj=0.5,at=x[2:13])
  invisible()
  #end of function
}
