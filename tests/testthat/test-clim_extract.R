test_that("normal extract", {
  data("locdata")
  data("plotdata")
  tmin <- "G:/climplot/climdata/tmin"
  tmax <- "G:/climplot/climdata/tmax"
  prec <- "G:/climplot/climdata/prec"
  m <- climplot::clim_extract(locdata,tmin,tmax,prec)
  expect_equal(m,plotdata)
})

test_that("extract with forst",{
  data("locdata")
  data("plotdata_Frost")
  tmin <- "G:/climplot/climdata/tmin"
  tmax <- "G:/climplot/climdata/tmax"
  prec <- "G:/climplot/climdata/prec"
  extmin <- "G:/climplot/climdata/extmin"
  mq <- climplot::clim_extract(locdata,tmin,tmax,prec,Frost = T,extmin)
  expect_equal(mq,plotdata_Frost)
})

test_that("data_frame import",{
  m <- data.frame(No="1",location="test",lon=113.27,lat=23.13,altitude=20)
  tmin <- "G:/climplot/climdata/tmin"
  tmax <- "G:/climplot/climdata/tmax"
  prec <- "G:/climplot/climdata/prec"
  extmin <- "G:/climplot/climdata/extmin"
  mq <- climplot::clim_extract(m,tmin,tmax,prec,Frost = T,extmin)
  expect_true(nrow(mq)==4,ncol(mq)==18)
})

test_that("excel import",{
  m <- readxl::read_xlsx("datatest.xlsx")
  tmin <- "G:/climplot/climdata/tmin"
  tmax <- "G:/climplot/climdata/tmax"
  prec <- "G:/climplot/climdata/prec"
  extmin <- "G:/climplot/climdata/extmin"
  mq <- climplot::clim_extract(m,tmin,tmax,prec,Frost = T,extmin)
  expect_true(nrow(mq)==12,ncol(mq)==18)
})
