### Funciones para leer excel 

## read_excel lee xls y xlsx
## read_xls unicamente lee xls 
## read_xlsx unicamente lee xlsx
## excel_sheets nombra las paginas de una hoja de excel y este nombre se puede
## pasar a las tres funciones anteriores.
## read_lines funcion para leer lineas

library(tidyverse)
library(readxl)


read_lines("data/murders.csv", n_max = 3)

dat <- read_csv("data/murders.csv")

head(dat)
tail(dat)
str(dat)

getwd()

#times2016 <- read_excel("data/times.xlsx", sheet = 2)
##  error times2016 <- read_xlsx("data/times.xlsx", sheet = "2")
#times2016 <- read_xlsx("data/times.xlsx", sheet = 2)

times2016 <- read_excel("data/times.xlsx", sheet = "2016")
