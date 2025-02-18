#' @rdname climatic_diagram_with_ggplot
#' @title  Walter & Lieth climatic diagram drawing with ggplot
#' @usage clim_ggplot(data, mlab = "", pcol = "blue", tcol = "red",
#' wcol = "green", dcol = "orange",fcol = "#09a0d1",
#' ylabel = FALSE, ylab1 = NA, ylab2 = NA, xlab = "Month",
#' showfrost = FALSE, shem = FALSE, line_p3 = FALSE,
#' temp_extreme = FALSE,per = NA)
#'
#' @description \code{clim_plot} plots the Walter & Lieth climatic diagram
#' with the climate data of different locations.
#' It is based on the method of function
#' \code{ggclimat_walter_lieth()}from the package \code{climaemet},
#' but offers additional parameters for color selection, axis labeling,
#' and location information display
#' to meet diverse research and publishing needs.
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
#'     \item \code{type}: The labels of climate data, encompassing
#'     annual average precipitation,
#'     annual average minimum temperature and
#'     annual average maximum temperature.
#'     In the event that Frost=True, it will also incorporate
#'     annual extreme minimum temperature.
#'     \item \code{1-12}: The column names of the particular climate data type
#'     correspond to monthly values ranging from January to December.
#' }
#'     Other columns containing information may be placed
#'     after the aforementioned columns, but will be disregarded
#'     in subsequent processes.
#'
#' @param mlab A vector of 12 monthly labels for the X axis.Deafult is numeric.
#' Alternatively, set as 'en' or 'es' can be specified to display
#' the month names in English or Spanish respectively.
#' (original parameter of the referenced function
#' \code{ggclimat_walter_lieth()}).
#'
#' @param pcol Color of the precipitation curve. Default is "blue".
#'
#' @param tcol Color of the temperature curve. Default is "red".
#'
#' @param wcol Color of the humid season polygon. Default is "green".
#'
#' @param dcol Color of the arid season polygon. Default is "orange".
#'
#' @param showfrost A logical value for whether marking forst months.
#' Default is FALSE.
#'
#' @param fcol Color of the confirmed frosty months. Default is "#09a0d1".
#' No use when showfrost= FALSE.
#'
#' @param ylabel A logical value for whether using customized label of y axis.
#' Default is FALSE.
#'
#' @param ylab1 A character value for label of y axis of temperature.
#' Default is NA.
#'
#' @param ylab2 A character value for label of y axis of precipitation.
#' Default is NA.
#'
#' @param xlab A character value for label of x axis. Default is "Month".
#'
#' @param shem A logical value for whether keeping the summer period in
#' the central zone of the graphic
#' (the diagram will begin the plot with the July data). Default is FALSE.
#' Useful when the location is in southern hemisphere
#' (original parameter of the referenced function \code{diagwl()}).
#'
#' @param line_p3 A logical value for whether displaying
#' a supplementary precipitation line referenced to three times the temperature.
#' Default is FALSE
#' (original parameter of the referenced function \code{diagwl()}).
#'
#' @param temp_extreme A logical value for whether displaying
#' the extreme temperature. Default is FALSE.
#'
#' @param per a parameter from the referenced function \code{diagwl()}.
#' No use temporarily.
#'
#' @details The function extracts precipitation and temperature from arranged
#' Worldclim Historical monthly weather data
#' (https://worldclim.org/data/monthlywth.html)
#' and arranges them to a data.frame for drawing the climatic diagram in
#' ggplot format.
#'
#' @return A ggplot variable of Walter & Lieth climatic diagram of the
#' provided locations,
#' including annual variation
#' of temperature and precipitation ,
#' as well as the time of humid and arid season.
#'
#' @examples {
#'   data("plotdata")
#'   test <- subset(plotdata, No == 10)
#'   clim_ggplot(
#'     data = test, ylabel = TRUE,
#'     ylab1 = "Temperature(\U{00B0}C)",
#'     ylab2 = "Precipitation(mm)"
#'   )
#'
#'   # use loop to plot multiple diagrams simultaneously
#'   list <- unique(plotdata$No)
#'   par(mfrow = c(1, 1))
#'   for (i in 1:5) {
#'     k <- list[i]
#'     sub <- subset(plotdata, No == k)
#'     clim_ggplot(
#'       data = sub, ylabel = TRUE,
#'       ylab1 = "Temperature(\U{00B0}C)",
#'       ylab2 = "Precipitation(mm)"
#'     )
#'   }
#' }
#'
#' @import graphics
#' @import stats
#' @import ggplot2
#' @importFrom tibble tibble
#' @importFrom tibble as_tibble
#' @importFrom dplyr bind_cols bind_rows
#'
#' @export
#'


clim_ggplot <- function(data,mlab = "", pcol = "blue",
                                  tcol = "red", wcol = "green",
                                  dcol = "orange", fcol = "#09a0d1",
                                  ylabel = FALSE, ylab1 = NA,
                                  ylab2 = NA, xlab = "Month",
                                  showfrost = FALSE, shem = FALSE,
                                  line_p3 = FALSE,
                                  temp_extreme = FALSE,
                                   per = NA
                                  ) {
  ## Validate inputs----

  est <- data$Location[1]
  alt <- data$Altitude[1]
  lon <- round(data$Lon[1], digits = 2)
  lat <- round(data$Lat[1], digits = 2)
  lonmark <- ifelse(lon < 0, "W", "E")
  latmark <- ifelse(lat < 0, "S", "N")
  loc <- paste0(lon, "\U{00B0}", lonmark,"  ", lat, "\U{00B0}", latmark)

  dat <- data[, 7:18]
  if (!all(dim(dat) == c(4, 12))) {
    stop(
      "`dat` should have 4 rows and 12 colums. Your inputs has ",
      nrow(dat), " rows and ", ncol(dat), " columns."
    )
  }

  # NULL data
  data_na <- as.integer(sum(is.na(dat)))
  if (data_na > 0) {
    stop("Data with null values, unable to plot the diagram \n")
  }

  # If matrix transform to data frame
  if (is.matrix(dat)) {
    dat <- as.data.frame(dat,
                         row.names = c(
                           "p_mes_md", "tm_mean", "tm_min",
                           "ta_max"
                         ),
                         col.names = paste0("m", seq_len(12))
    )
  }

  ## Transform data----
  # Months label

  mlab = ""
  if (mlab == "es") {
    mlab <- c("E", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D")
  } else if (mlab == "en") {
    mlab <- c("J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D")
  } else {
    mlab <- 1:12
  }

    mlab2 <- c("J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D")


  # Pivot table and tidydata
  dat_long <- tibble::as_tibble(as.data.frame(t(dat)))
  # Easier to handle, normalize names
  names(dat_long) <- c("p_mes", "tm_mean", "tm_min", "tm_max")

  dat_long <- dplyr::bind_cols(label = mlab2, dat_long)

  # Southern hemisphere
  if (shem) {
    dat_long <- rbind(dat_long[7:12, ], dat_long[1:6, ])
  }

  # Mean temp
  dat_long$tm <- dat_long[[3]]

  # Reescalate p_mes
  dat_long$pm_reesc <- ifelse(dat_long$p_mes < 100,
                              dat_long$p_mes * 0.5,
                              dat_long$p_mes * 0.05 + 45
  )

  # Add p3line

  dat_long$p3line <- dat_long$p_mes / 3

  # Add first and last row for plotting properly
  dat_long <- dplyr::bind_rows(
    dat_long[nrow(dat_long), ],
    dat_long,
    dat_long[1, ]
  )

  dat_long[c(1, nrow(dat_long)), "label"] <- ""

  # Interpolate values to expand x range
  # Number rows
  dat_long <- cbind(indrow = seq(-0.5, 12.5, 1), dat_long)
  dat_long_int <- NULL

  for (j in  seq(nrow(dat_long) - 1)) {
    intres <- NULL

    for (i in seq_len(ncol(dat_long))) {
      if (is.character(dat_long[j, i])) {
        # On character don't interpolate
        val <- as.data.frame(dat_long[j, i])
      } else {
        # Interpolate
        interpol <- approx(
          x = dat_long[c(j, j + 1), 1],
          y = dat_long[c(j, j + 1), i],
          n = 50
        )
        val <-
          as.data.frame(interpol$y) # Just the interpolated value
      }
      names(val) <- names(dat_long)[i]
      intres <- dplyr::bind_cols(intres, val)
    }

    dat_long_int <- dplyr::bind_rows(dat_long_int, intres)
  }

  # Regenerate and filter values
  dat_long_int$interpolate <- TRUE
  dat_long_int$label <- ""
  dat_long$interpolate <- FALSE
  dat_long_int <-
    dat_long_int[!dat_long_int$indrow %in% dat_long$indrow, ]
  dat_long_end <- dplyr::bind_rows(dat_long, dat_long_int)
  dat_long_end <- dat_long_end[order(dat_long_end$indrow), ]
  dat_long_end <- dat_long_end[
    dat_long_end$indrow >= 0 & dat_long_end$indrow <= 12,
  ]
  dat_long_end <- tibble::as_tibble(dat_long_end)
  # Final tibble with normalized and helper values



  # Labels and axis----

  ## Horizontal axis ----
  month_breaks <- dat_long_end[dat_long_end$label != "", ]$indrow
  month_labs <- mlab

  ## Vert. Axis range - temp ----
  ymax <- max(60, 10 * floor(max(dat_long_end$pm_reesc) / 10) + 10)

  # Min range
  ymin <- min(-3, min(dat_long_end$tm)) # min Temp
  range_tm <- seq(0, ymax, 10)

  if (ymin < -3) {
    ymin <- floor(ymin / 10) * 10 # min Temp rounded
    # Labels
    range_tm <- seq(ymin, ymax, 10)
  }

  # Labels
  templabs <- paste0(range_tm)
  templabs[range_tm > 50] <- ""

  # Vert. Axis range - prec
  range_prec <- range_tm * 2
  range_prec[range_tm > 50] <- range_tm[range_tm > 50] * 20 - 900
  preclabs <- paste0(range_prec)
  preclabs[range_tm < 0] <- ""

  ## Titles and additional labels----
  title <- est

  if (!is.na(alt)) {
    title <- paste0(
      title, " (",
      prettyNum(alt, big.mark = ",", decimal.mark = "."), " m)"
    )
  }


  if (!is.na(per)) {
    title <- paste0(title, "\n",loc,"\n", per)
  }else{
    title <- paste0(title, "\n",loc)
  }

  # Subtitles
  sub <-
    paste(round(mean(dat_long_end[dat_long_end$interpolate == FALSE, ]$tm), 1),
          "\U{00B0}C", "\n",
          prettyNum(
            round(sum(
              dat_long_end[dat_long_end$interpolate == FALSE, ]$p_mes
            )),
            big.mark = ","
          ),
          " mm",
          sep = ""
    )

  # Vertical tags
  if(temp_extreme){
  maxtm <- prettyNum(round(max(dat_long_end$tm_max), 1))
  mintm <- prettyNum(round(min(dat_long_end$tm_min), 1))

  tags <- paste0(
    paste0(rep(" \n", 6), collapse = ""),
    maxtm,
    paste0(rep(" \n", 10), collapse = ""),
    mintm
  )
  }else{
    tags <- ""
  }

  # Helper for ticks

  ticks <- data.frame(
    x = seq(0, 12),
    ymin = -3,
    ymax = 0
  )

  #Tabs of the x axis

  #Tabs of the y axis
  if(is.na(ylab1)){
    ylab1 <- "\U{00B0}C"
  }

  if(is.na(ylab2)){
  ylab2 <- "mm"
  }

  # Lines and additional areas----
  getpolymax <- function(x, y, y_lim) {
    initpoly <- FALSE
    yres <- NULL
    xres <- NULL

    # Check
    for (i in seq_len(length(y))) {
      lastobs <- i == length(x)

      # If conditions to plot polygon
      if (y[i] > y_lim[i]) {
        if (isFALSE(initpoly)) {
          # Initialise polygon if not already initialise
          xres <- c(xres, x[i])
          yres <- c(yres, y_lim[i])
          initpoly <- TRUE
        }
        xres <- c(xres, x[i])
        yres <- c(yres, y[i])

        # On lastobs we need to close the polygon
        if (lastobs) {
          xres <- c(xres, x[i], NA)
          yres <- c(yres, y_lim[i], NA)
        }
      } else {
        # Close polygon
        if (initpoly) {
          xres <- c(xres, x[i - 1], NA)
          yres <- c(yres, y_lim[i - 1], NA)
          initpoly <- FALSE
        }
      }
    }
    poly <- tibble::tibble(x = xres, y = yres)
    return(poly)
  }


  getlines <- function(x, y, y_lim) {
    yres <- NULL
    xres <- NULL
    ylim_res <- NULL

    # Check
    for (i in seq_len(length(y))) {
      # If conditions to line
      if (y[i] > y_lim[i]) {
        xres <- c(xres, x[i])
        yres <- c(yres, y[i])
        ylim_res <- c(ylim_res, y_lim[i])
      }
    }
    line <- tibble::tibble(
      x = xres,
      y = yres,
      ylim_res = ylim_res
    )
    return(line)
  }

  prep_max_poly <- getpolymax(
    x = dat_long_end$indrow,
    y = pmax(dat_long_end$pm_reesc, 50),
    y_lim = rep(50, length(dat_long_end$indrow))
  )

  tm_max_line <- getlines(
    x = dat_long_end$indrow,
    y = dat_long_end$tm,
    y_lim = dat_long_end$pm_reesc
  )

  pm_max_line <- getlines(
    x = dat_long_end$indrow,
    y = pmin(dat_long_end$pm_reesc, 50),
    y_lim = dat_long_end$tm
  )

  # Prob freeze
  dat_real <-
    dat_long_end[dat_long_end$interpolate == FALSE, c("indrow", "tm_min")]
  x <- NULL
  y <- NULL
  for (i in seq_len(nrow(dat_real))) {
    if (dat_real[i, ]$tm_min < 0) {
      x <-
        c(
          x,
          NA,
          rep(dat_real[i, ]$indrow - 0.5, 2),
          rep(dat_real[i, ]$indrow + 0.5, 2),
          NA
        )
      y <- c(y, NA, -3, 0, 0, -3, NA)
    } else {
      x <- c(x, NA)
      y <- c(y, NA)
    }
  }
  probfreeze <- tibble::tibble(x = x, y = y)
  rm(dat_real)
  # Sure freeze
  dat_real <-
    dat_long_end[dat_long_end$interpolate == FALSE, c("indrow", "tm_max")]

  x <- NULL
  y <- NULL
  for (i in seq_len(nrow(dat_real))) {
    if (dat_real[i, ]$tm_max < 0) {
      x <-
        c(
          x,
          NA,
          rep(dat_real[i, ]$indrow - 0.5, 2),
          rep(dat_real[i, ]$indrow + 0.5, 2),
          NA
        )
      y <- c(y, NA, -3, 0, 0, -3, NA)
    } else {
      x <- c(x, NA)
      y <- c(y, NA)
    }
  }
  surefreeze <- tibble::tibble(x = x, y = y)

  # Start plotting----
  # Basic lines and segments
  wandlplot <- ggplot2::ggplot() +
    ggplot2::geom_line(
      data = dat_long_end,
      aes(x = .data$indrow, y = .data$pm_reesc),
      color = pcol
    ) +
    ggplot2::geom_line(
      data = dat_long_end,
      aes(x = .data$indrow, y = .data$tm),
      color = tcol
    )

  if (nrow(tm_max_line > 0)) {
    wandlplot <- wandlplot +
      ggplot2::geom_segment(
        aes(
          x = .data$x,
          y = .data$ylim_res,
          xend = .data$x,
          yend = .data$y
        ),
        data = tm_max_line,
        color = dcol,
        alpha = 0.15
      )
  }

  if (nrow(pm_max_line > 0)) {
    wandlplot <- wandlplot +
      ggplot2::geom_segment(
        aes(
          x = .data$x,
          y = .data$ylim_res,
          xend = .data$x,
          yend = .data$y
        ),
        data = pm_max_line,
        color = wcol,
        alpha = 0.15
      )
  }

  if (line_p3) {
    wandlplot <- wandlplot +
      ggplot2::geom_line(
        data = dat_long_end,
        aes(
          x = .data$indrow,
          y = .data$p3line
        ),
        color = pcol
      )
  }

  # Add polygons

  # Max precip
  if (max(dat_long_end$pm_reesc) > 50) {
    wandlplot <- wandlplot +
      ggplot2::geom_polygon(
        data = prep_max_poly,
        aes(x, y), fill = pcol
      )
  }


  # Probable freeze
  if(showfrost){
  if (min(dat_long_end$tm_min) < 0) {
    wandlplot <- wandlplot +
      ggplot2::geom_polygon(
        data = probfreeze,
        aes(x = x, y = y),
        fill = fcol,
        colour = "black"
      )
  }

  # Sure freeze

  if (min(dat_long_end$tm_max) < 0) {
    wandlplot <- wandlplot +
      geom_polygon(
        data = surefreeze,
        aes(x = x, y = y),
        fill = fcol,
        colour = "black"
      )
  }
  }

  # Add lines and scales to chart
  wandlplot <- wandlplot +
    geom_hline(yintercept = c(0, 50), linewidth = 0.5) +
    geom_segment(data = ticks, aes(
      x = x,
      xend = x,
      y = ymin,
      yend = ymax
    )) +
    scale_x_continuous(
      breaks = month_breaks,
      name = xlab,
      labels = month_labs,
      expand = c(0, 0)
    ) +
    scale_y_continuous(
      name = ylab1,
      limits = c(ymin, ymax),
      labels = templabs,
      breaks = range_tm,
      sec.axis = dup_axis(
        name = ylab2,
        labels = preclabs
      )
    )


  # Add tags and theme
  wandlplot <- wandlplot +
    ggplot2::labs(
      title = title,
      subtitle = sub,
      tag = tags
    ) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      plot.title = element_text(
        hjust = 0,
        vjust = 0,

        size = 14,


      ),
      plot.subtitle = element_text(
        hjust = 1,
        vjust = 1,
        size = 14,

      ),
      plot.tag = element_text(size = 10),
      plot.tag.position = "left",
      axis.ticks.length.x.bottom = unit(0, "pt"),
      axis.line.x.bottom = element_blank(),
      axis.title.y.left = element_text(
        angle = 90,
        vjust = 0.9,
        size = 10,
        colour = tcol,
        margin = unit(rep(10, 4), "pt")
      ),
      axis.text.x.bottom = element_text(size = 10),
      axis.text.y.left = element_text(colour = tcol, size = 10),
      axis.title.y.right = element_text(
        angle = 90,
        vjust = 0.9,
        size = 10,
        colour = pcol,
        margin = unit(rep(10, 4), "pt")
      ),
      axis.text.y.right = element_text(colour = pcol, size = 10)
    )


  return(wandlplot)
}

