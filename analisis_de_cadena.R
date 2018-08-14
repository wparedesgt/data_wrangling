#Análisis de cadena

library(dslabs)
library(tidyverse)
library(rvest)

url <- "https://en.wikipedia.org/wiki/Gun_violence_in_the_United_States_by_state"

murders_raw <- read_html(url) %>% html_nodes("table") %>% html_table()

murders_raw <- murders_raw[[2]]

murders_raw <- murders_raw %>% setNames(c("state","population","total","murders","gun_murders","gun_ownership","total_rate","murder_rate","gun_murder_rate"))

#Nos damos cuenta de que dos de las columnas que esperábamos contienen números en realidad contienen caracteres

class(murders_raw$population)
class(murders_raw$total)

#Debido a que esta es una tarea tan común, ya hay una función,
#parse_number (), que hace esta conversión fácilmente.

murders_raw$population <- parse_number(murders_raw$population)
murders_raw$total <- parse_number(murders_raw$total)

#Sin embargo, muchos de los procesos de cuerdas desafían a un científico de datos
#las caras son únicas y a menudo inesperadas.
#Por lo tanto, es bastante ambicioso tener
#un curso completo sobre estos temas.
#Aquí, usamos estudios de casos que nos ayudan a demostrar
#cómo el procesamiento de cadenas es una poderosa herramienta necesaria para muchos datos disputas desafíos.
#Específicamente, mostramos los datos brutos originales
#utilizado para crear los marcos de datos que hemos estado estudiando en este curso
#y describe el procesamiento de cadena que se necesitaba.
#Al repasar estos estudios de caso, cubriremos
#algunas de las tareas más comunes en el procesamiento de cadenas,
#incluyendo la eliminación de caracteres no deseados del texto,
#extrayendo valores numéricos de textos, encontrando y reemplazando caracteres,
#extraer partes específicas de cadenas, convirtiendo
#texto de formato libre a formatos más uniformes y cadenas de división
#en valores múltiples