library(dslabs)
library(tidyverse)
##Wrangling Data
#Paths and the Working Directory
#Busca el directorio de Trabajo
getwd()
#Para cambiar el directorio de trabajo se usa
setwd()
#Una vez que descargue e instale ese paquete DSLABS,
#los archivos estarán en los datos externos, extdata, directorio
#que puedes obtener escribiendo este comando.
system.file("extdata",package = "dslabs")

#Y podrá ver los archivos incluidos en este directorio usando
#la función list.files (), como esta.
path <- "G:/Wsoft/Documents/R/win-library/3.5/dslabs/extdata"

list.files(path) #En este caso es el path de esos archivos

##Funcion file.copy
#function file.path() #pone los slash correctos

filename <- "murders.csv"
fullpath <- file.path(path, filename)
fullpath

#Creando directorio de trabajo y de datos

Directorio_Trabajo <- getwd()

#Creando Directorio de Datos

Directorio_Datos <- "/data"

#Asignando el directorio de datos

Total <- paste(Directorio_Trabajo, Directorio_Datos, sep = "")

setwd(Total)

#copiando el csv a mi directorio

file.copy(fullpath, getwd())

#ver si existe el archivo

file.exists(filename)

#reasignando directorio de trabajo

setwd(Directorio_Trabajo)

#Otro Ejercicio

getwd()

filename <- "murders.csv"

path <- system.file("extdata", package = "dslabs")

file.copy()
