##Importando usando funciones en R

library(readr)

race_time <- read.csv("data/times.csv", stringsAsFactors = F)


##Usando la funcion download.file
##download.file(url, destfile, method, quiet = FALSE, mode = "w",
##              cacheOK = TRUE,
##              extra = getOption("download.file.extra"), ...)

#url <- "loquesea la direccion"

#download.file(url, "murders.csv" )

#tempdir() tempfile() funcion  
#Description tempfile returns a vector of character strings which can be used as names for temporary files.

#Usage

#tempfile(pattern = "file", tmpdir = tempdir(), fileext = "")
#tempdir(check = FALSE)


#Ejemplo 

url <- "https://github.com/wparedesgt/murders/blob/master/data/murders.csv"

tmp_filename <- tempfile()
download.file(url, tmp_filename)
dat <- read.csv(tmp_filename)
file.remove(tmp_filename)

#ejercicio

url <- "https://github.com/wparedesgt/murders/blob/master/data/murders.csv"

dat <- read_csv(url)
download.file(url, "murders.csv")


