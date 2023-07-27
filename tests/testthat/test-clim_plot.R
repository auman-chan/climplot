test_that("plot", {
  data("plotdata")
  x <- subset(plotdata, No == 2)
  Cairo::CairoPNG( filename = "plot.png",
                   width = 629,height = 548)
  climplot::clim_plot(x)
  dev.off()
announce_snapshot_file(path = "plot.png")
announce_snapshot_file(path ="name.png")
  compare_file_binary("plot.png","name.png")
})
