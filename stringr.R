#stringr Package

#En general, el procesamiento de cadena implica una cadena y un patrón.
#En R, generalmente almacenamos cadenas en un vector de caracteres.

library(tidyverse)
library(rvest)


url <- "https://en.wikipedia.org/wiki/Gun_violence_in_the_United_States_by_state"

murders_raw <- read_html(url) %>% html_nodes("table") %>% html_table()

murders_raw <- murders_raw[[2]]

murders_raw <- murders_raw %>% setNames(c("state","population","total","murders","gun_murders","gun_ownership","total_rate","murder_rate","gun_murder_rate"))

class(murders_raw$population)


#La columna de población tiene un vector de caracteres.
#Las primeras tres cadenas en este vector definidas por la variable de población
#se puede ver aquí.

murders_raw$population[1:3]

#Tenga en cuenta que la coerción habitual para convertir números no funciona aquí. Mira lo que sucede.

as.numeric(murders_raw$population[1:3])

#Esto es por las comas.

#El procesamiento de cadenas que queremos hacer aquí es eliminar la coma de patrones de la cadena de murders_raw$population y luego coaccionar los números.

#En general, las tareas de procesamiento de cadenas pueden ser
#dividido en detección, localización, extracción, o reemplazando patrones en cadenas.

#En nuestro ejemplo, necesitamos ubicar la coma y reemplazarlos con un personaje vacío.
#La base R incluye la función para realizar todas estas tareas.
#Sin embargo, no siguen una convención unificadora, lo cual hace que sea un poco difícil de memorizar y usar.

#El paquete stringr básicamente reempaca esta funcionalidad, pero usando un enfoque más consistente para nombrar funciones y ordenando sus argumentos

#Por ejemplo, en stringr, todas las funciones de procesamiento de cadenas comienzan con str_, lo que significa que si escribes esto y luego presionas Tab,
#R se autocompletará y le mostrará todas las funciones disponibles, lo que significa que no necesariamente tenemos que memorizar todos los nombres de las funciones.

#Otra ventaja es que la cadena siempre está el primer argumento, lo que significa que podemos movernos más fácilmente usando la tubería.

