#Agrupando Expresiones Regulares

library(tidyverse)
library(dslabs)
library(rvest)

#El segundo un gran grupo de entradas problemáticas eran de la forma x.y o x, y, y x y.

#x.y  x,y x y

#Queremos cambiar todo esto a nuestro formato común, x'y.

#Pero no podemos hacer la búsqueda y el reemplazo, porque cambiaríamos el valor como 70.5 a 70'5.

#Nuestra estrategia será, por lo tanto, buscar un patrón muy específico que asegure nosotros los pies y las pulgadas están siendo provistos.

#Luego, para aquellos que coincidan, reemplácelos apropiadamente.

#Los grupos son un aspecto poderoso de regex que permite la extracción de valores.

#Los grupos se definen usando paréntesis.

#No afectan el emparejamiento de patrones per se.

#En cambio, permite que las herramientas identifiquen partes específicas del patrón para que podamos extraerlos Entonces, por ejemplo, queremos cambiar la altura como 5,6 a cinco pies, seis pulgadas.

#5'6

#Para evitar cambiar patrones como 70.2, lo haremos requiere que el primer dígito esté entre cuatro y siete podemos hacer eso usando la operación range y que el segundo sea ninguno o más dígitos.

#Podemos hacer eso usando barra invertida, barra invertida d asterisco.

#\\d*

#Comencemos definiendo un patrón simple que coincida con esto.

#Podemos hacerlo así.

patterns_without_groups <-  "^[4-7],\\d*$"

#Queremos extraer los dígitos para que podamos formar la nueva versión usando una sola cotización.

#Estos son dos grupos, por lo que los encapsulamos con paréntesis como este.

patterns_with_groups <- "^([4-7]),(\\d*)$"

#Tenga en cuenta que encapsulamos la parte del patrón que coincide con las partes que queremos para mantener, las partes que queremos extraer.

#Antes de continuar, observe que agregar grupos no afecta las detecciones ya que solo señala que queremos guardar lo que capturan los grupos.

#Podemos ver eso al escribir este código.

yes <- c("5,9", "5,11", "6,", "6,1")
no <- c("5'9", ",", "2,8", "6.1.1")
s <- c(yes, no)

str_detect(s, patterns_without_groups)

str_detect(s, patterns_with_groups)

#Tenga en cuenta que los paréntesis no cambian el procedimiento de coincidencia.

#Una vez que definimos grupos, podemos usar una función str_match para extraer los valores que estos grupos definen, como este.

#Mira lo que sucede si escribimos este código.

str_match(s, patterns_with_groups)


#Tenga en cuenta que la segunda y tercera columnas contienen pies y pulgadas respectivamente.

#El primero es el patrón original que se combinó.

#Si no se produjo ninguna coincidencia, vemos una N / A.

#Ahora podemos entender la diferencia entre la función str_extract y str_match.

#str_extract extrae solo cadenas que coinciden con un patrón, no los valores definidos por los grupos. 

#Esto es lo que sucede con el straing_stract.

str_extract(s, patterns_with_groups)


#Otro aspecto poderoso de los grupos es que puede hacer referencia al valor extraído en expresiones regulares al buscar y reemplazar.

#El carácter especial de expresiones regulares para el grupo i-ésimo es barra invertida, barra invertida, i.

#\\i

#Entonces backslash, backslash, 1 es el valor extraído del primer grupo, y barra invertida, barra invertida, 2 es el valor del segundo grupo, y así sucesivamente

##\\1  \\2


#Como ejemplo simple, tenga en cuenta que el siguiente código reemplazará una coma por un período, pero solo si está entre dos dígitos.

#Aquí está el código.

patterns_with_groups <- "^([4-7]),(\\d*)$"

yes <- c("5,9", "5,11", "6,", "6,1")
no <- c("5'9", ",", "2,8", "6.1.1")
s <- c(yes, no)

str_replace(s, patterns_with_groups, "\\1'\\2")


#Podemos usar es convertir casos en nuestras alturas informadas.

#Ahora estamos listos para definir un patrón que nos ayude a convertir todos los x.y, x, y, y x y a nuestro formato preferido.

#Necesitamos adaptar el guión bajo del patrón con los grupos para ser un poco más flexibles y captura todos estos casos.

#El patrón ahora se ve así.

patterns_with_groups <- "^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$"


#Vamos a romper esto.

#Es bastante complicado.

#El cursor significa inicio de la cuerda.

#Entonces cuatro a siete significa un dígito entre cuatro y siete cuatro, cinco, seis o siete.

#Entonces la barra invertida, barra invertida, s, estrella significa ninguno o más espacios en blanco.

#El siguiente patrón significa que el quinto símbolo es coma, o punto, o al menos un espacio.

#Entonces tenemos ninguno o más espacios en blanco de nuevo.

#Entonces tenemos ninguno o más dígitos, y luego el final de la cadena.

#Podemos ver que parece estar funcionando.

#Probemos estos ejemplos.


data("reported_heights")

not_inches <- function(x, smallest = 50, tallest = 84) {
  inches <- suppressWarnings(as.numeric(x))
  ind <- is.na(inches) | inches < smallest | inches > tallest
  ind
}

problems <- reported_heights %>% 
  filter(not_inches(height)) %>% 
  .$height


str_subset(problems, patterns_with_groups) %>% head()

#Y podremos realizar la búsqueda y el reemplazo.

str_subset(problems, patterns_with_groups) %>% 
  str_replace(patterns_with_groups, "\\1'\\2") %>% head()


#Aquí vamos.

#Casi tiene el resultado deseado.

#Hay un pequeño problema, y es que tenemos un caso con 25 pulgadas.

#Nos ocuparemos de este problema más adelante.

#Ejercicios

problems <- c("5.3", "5,5", "6 1", "5 .11", "5, 12")
pattern_with_groups <- "^([4-7])[,\\.](\\d*)$"
str_replace(problems, pattern_with_groups, "\\1'\\2")


#No2

problems <- c("5.3", "5,5", "6 1", "5 .11", "5, 12")
pattern_with_groups <- "^([4-7])[,\\.\\s](\\d*)$"
str_replace(problems, pattern_with_groups, "\\1'\\2")
