context("Validate")

mockDownload <- function(url, file){
  if (url != "https://s3.amazonaws.com/echo.api/fakecert"){
    stop("Refusing to fake unrecognized URL download: ", url)
  }

  # Otherwise copy our hardcoded cert to that location
  file.copy("./certs/amazon.crt", file)
}

test_that("Invalid cert protocol fails", {
  req <- new.env()
  req$HTTP_SIGNATURECERTCHAINURL <- "http://something"

  expect_error(doValidate(req), "protocol is not HTTPS")
})

test_that("Invalid host fails", {
  req <- new.env()
  req$HTTP_SIGNATURECERTCHAINURL <- "https://something.com"

  expect_error(doValidate(req), "host name is not s3.amazonaws.com")
})

test_that("Invalid path fails", {
  req <- new.env()
  req$HTTP_SIGNATURECERTCHAINURL <- "https://s3.amazonaws.com/wrong"

  expect_error(doValidate(req), "path does not begin with")
})

test_that("Invalid port fails", {
  req <- new.env()
  req$HTTP_SIGNATURECERTCHAINURL <- "https://s3.amazonaws.com:123/echo.api/something"

  expect_error(doValidate(req), "port was not")
})

test_that("Validity date checking behaves", {
  req <- readRDS("./certs/request.Rds") # A valid request from AWS
  req$HTTP_SIGNATURECERTCHAINURL <- "https://s3.amazonaws.com/echo.api/fakecert"

  # Valid date works
  date <- as.POSIXct(1492739184, origin="1970-01-01", tz="GMT")
  doValidate(req, date, mockDownload)

  # Slightly invalid date throws on timestamp
  date <- as.POSIXct(1492739484, origin="1970-01-01", tz="GMT")
  expect_error(doValidate(req, date, mockDownload), "Timestamp on request differs")

  # Predating cert validity fails
  date <- as.POSIXct("2016-10-06", tz="GMT")
  expect_error(doValidate(req, date, mockDownload), "Certificate validity set to start in the future")

  # Postdating cert validity fails
  date <- as.POSIXct("2017-11-01", tz="GMT")
  expect_error(doValidate(req, date, mockDownload), "Certificate has expired")
})
