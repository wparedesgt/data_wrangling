#Prueba y Mejora
library(dslabs)
library(tidyverse)
library(rvest)

data("reported_heights")

#Hemos desarrollado un poderoso procesamiento de strings técnica que puede ayudarnos a atrapar muchas de las entradas problemáticas.

#Ahora es el momento de probar nuestro enfoque, buscar más problemas, y modificar nuestro enfoque para posibles mejoras.

#Vamos a escribir una función que capture todas las entradas que no se puede convertir en números, recordando que algunos están en centímetros.

#Nos ocuparemos de ellos más tarde.

#Aquí está la función.

not_inches_or_cm <- function(x, smallest = 50, tallest = 84) {
  inches <- suppressWarnings(as.numeric(x))
  ind <- !is.na(inches) & 
    ((inches >= smallest & inches <= tallest) |
        (inches/2.54 >= smallest & inches/2.54 <= tallest))
  !ind
}


#Veamos cuántos de estos podemos ajustar nuestro patrón después de los varios pasos de procesamiento que hemos desarrollado.

problems <- reported_heights %>%
  filter(not_inches_or_cm(height)) %>%
  .$height

length(problems)

#Aquí, aprovechamos el pipe una de las ventajas de usar un larguero.

#Usamos pipe para concatenar los diferentes reemplazos que acabamos de realizar.

#Luego definimos el patrón y luego, vamos y tratamos de ver cuántos coinciden.

converted <- problems %>% 
  str_replace("feet|ft|foot", "'") %>%
  str_replace("inches|in|''|\"" , "") %>% 
  str_replace("^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$", "\\1'\\2")

pattern <- "^[4-7]\\s*'\\s*\\d{1,2}$"

index <- str_detect(converted, pattern)

mean(index)

#Estamos igualando más de la mitad ahora.

#Examinemos los casos restantes.

#Aquí están.

converted[!index]


#Entonces cuales son los problemas?


#Muchos estudiantes que miden exactamente 5 o 6 pies no ingresaron ninguna pulgada.

#Por ejemplo, 6 'y nuestro patrón requiere que se incluyan pulgadas.

#Algunos estudiantes que miden exactamente 5 o 6 pies ingresaron solo ese número.

#Algunas de las pulgadas se ingresaron con puntos decimales.

#Por ejemplo, 5 pies y 7.5 pulgadas.

#Nuestro patrón solo busca dos dígitos.

#Algunas entradas tienen espacios al final.

#Por ejemplo, 5 '9.

#Algunas entradas están en metros y algunas de ellas son decimales europeos.

#Entonces es 1, 7 es 1.7 metro.

#Dos estudiantes agregaron CM y un estudiante deletreado los números, 5 pies, 8 pulgadas.

#No es necesariamente claro que valga la pena escribir código para manejar todos estos casos ya que pueden ser lo suficientemente raros.

#Sin embargo, algunos nos dan la oportunidad de aprender un poco más [? rechazar?] técnicas.

#Entonces le mostraremos el código que necesita para arreglarlos en el material del curso.


#Ejercicio No.1

converted <- problems %>% 
  str_replace("feet|foot|ft", "'") %>% 
  str_replace("inches|in|''|\"", "") %>% 
  str_replace("^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$", "\\1'\\2")

pattern <- "^[4-7]\\s*'\\s*\\d{1,2}$"
index <- str_detect(converted, pattern)
converted[!index]

#Which answer best describes the differences between the regex string we use as an argument in str_replace("^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$", "\\1'\\2")

#And the regex string in pattern <- "^[4-7]\\s*'\\s*\\d{1,2}$"?

#La expresión regular utilizada en str_replace busca una coma, punto o espacio entre los pies y las pulgadas de los dígitos, mientras que la expresión regular del patrón solo busca un apóstrofo; la expresión regular en str_replace permite que ninguno o más dígitos se ingresen como pulgadas, mientras que la expresión regular del patrón solo permite uno o dos dígitos. #ultima respuesta

#Ejercicio No. 2

#Observa algunas entradas que no se convierten correctamente utilizando su código str_replace y str_detect

yes <- c("5 feet 7inches", "5 7")
no <- c("5ft 9 inches", "5 ft 9 inches")
s <- c(yes, no)

converted <- s %>% 
  str_replace("feet|foot|ft", "'") %>% 
  str_replace("inches|in|''|\"", "") %>% 
  str_replace("^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$", "\\1'\\2")

pattern <- "^[4-7]\\s*'\\s*\\d{1,2}$"
str_detect(converted, pattern)


#Parece que el problema puede deberse a espacios alrededor de las palabras pies | pie | pies y pulgadas | pulgadas ¿De qué otra manera puedes solucionar este problema?


converted <- s %>% 
  str_replace("\\s*(feet|foot|ft)\\s*", "'") %>% 
  str_replace("\\s*(inches|in|''|\")\\s*", "") %>% 
  str_replace("^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$", "\\1'\\2")

pattern <- "^[4-7]\\s*'\\s*\\d{1,2}$"
str_detect(converted, pattern)


converted <- s %>% 
  str_replace("\\s+feet|foot|ft\\s+", "'") %>% 
  str_replace("\\s+inches|in|''|\"\\s+", "") %>% 
  str_replace("^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$", "\\1'\\2")


pattern <- "^[4-7]\\s*'\\s*\\d{1,2}$"
str_detect(converted, pattern)

converted <- s %>% 
  str_replace("\\s*|feet|foot|ft", "'") %>% 
  str_replace("\\s*|inches|in|''|\"", "") %>% 
  str_replace("^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$", "\\1'\\2") 

pattern <- "^[4-7]\\s*'\\s*\\d{1,2}$"
str_detect(converted, pattern)

converted <- s %>% 
  str_replace_all("\\s", "") %>% 
  str_replace("\\s|feet|foot|ft", "'") %>% 
  str_replace("\\s|inches|in|''|\"", "") %>% 
  str_replace("^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$", "\\1'\\2")



pattern <- "^[4-7]\\s*'\\s*\\d{1,2}$"
str_detect(converted, pattern)


