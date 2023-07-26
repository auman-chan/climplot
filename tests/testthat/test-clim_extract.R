test_that("normal extract", {
  data("locdata")
  data("plotdata")
  x <- subset(locdata,No > 7)
  y <- subset(plotdata,No > 7)
  row.names(y) <- 1:nrow(y)
  m <- clim_extract(x)
  expect_equal(m, y)
})

test_that("data_frame import", {
  x <- data.frame(No = "1", location = "test", lon = 113.27, lat = 23.13,
                  altitude = 20)
  mq <- clim_extract(x)

  expect_true(nrow(mq) == 4, ncol(mq) == 18)
})

test_that("excel import", {
  m <- readxl::read_xlsx("datatest.xlsx")
  mq <- clim_extract(m)

  expect_true(nrow(mq) == 8, ncol(mq) == 18)
})
