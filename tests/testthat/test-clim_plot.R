test_that("plot", {
  data("plotdata")
  x <- subset(plotdata, No == 2)
  png(
    filename = "plot.png",
    width = 629, height = 548
  )
  climplot::clim_plot(x)
  dev.off()
  announce_snapshot_file(path = "plot.png")
  announce_snapshot_file(path = "name.png")
  compare_file_binary("plot.png", "name.png")
})

test_that("plot of frost", {
  data("plotdata")
  x <- subset(plotdata, No == 1)
  png(
    filename = "plot.png",
    width = 629, height = 548
  )
  climplot::clim_plot(x, showfrost = TRUE)
  dev.off()
  announce_snapshot_file(path = "plot.png")
  announce_snapshot_file(path = "name2.png")
  compare_file_binary("plot.png", "name2.png")
})


test_that("plot of labels", {
  data("plotdata")
  x <- subset(plotdata, No == 1)
  png(
    filename = "plot.png",
    width = 629, height = 548
  )
  climplot::clim_plot(x, ylabel = TRUE, xlab = "M", ylab1 = "T", ylab2 = "P")
  dev.off()
  announce_snapshot_file(path = "plot.png")
  announce_snapshot_file(path = "name3.png")
  compare_file_binary("plot.png", "name3.png")
})
