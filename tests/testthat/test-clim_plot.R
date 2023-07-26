test_that("plot", {
  data("plotdata")
  x <- subset(plotdata, No == 2)
  climplot::clim_plot(x)
  path <- tempdir()
  png(filename = file.path(path, "plot.png"))
  exp <- list.files(tempdir(), pattern = "plot.png",full.names = TRUE)
  expect_true(file.exists(exp))
})
