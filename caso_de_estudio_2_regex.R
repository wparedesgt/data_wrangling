#Expresiones Regulares (regex)

library(dslabs)
library(tidyverse)
library(rvest)

#Hemos visto tres patrones eso define muchas entradas problemáticas en el caso_de_estudio_2. 
#Convertiremos entradas que se ajusten a los dos primeros patrones en uno estandarizado.

#A continuación, aprovecharemos esta estandarización para extraer los pies y las p pulgadas, y convertirlos finalmente a pulgadas.

#Luego definiremos un procedimiento para identificar entradas que están en centímetros, y convertirlas a pulgadas.

#Después de aplicar estos pasos, luego volveremos a verificar para ver qué entradas no se corrigieron, y ver si podemos ajustar nuestro enfoque para ser más completo.

#Esto es muy común en la ciencia de datos. 

#Hay muchos enfoques interactivos que se aplican.

#Para lograr nuestro objetivo, utilizaremos una técnica que nos permite detectar patrones y extraer estas partes que queremos expresiones regulares o regex.

#Una expresión regular,es una forma de describir patrones específicos de un personaje de texto que se puede usar para determinar si una cadena dada coincide con el patrón.

#Se ha definido un conjunto de reglas para hacer esto de manera eficiente y precisa.

#Técnicamente, cualquier cadena es una expresión regular.

#Quizás el ejemplo más simple es un solo personaje.

#Entonces, la coma que utilizamos aquí es que el código es un simple ejemplo de búsqueda con una expresión regular.


url <- "https://en.wikipedia.org/wiki/Gun_violence_in_the_United_States_by_state"

murders_raw <- read_html(url) %>% html_nodes("table") %>% html_table()

murders_raw <- murders_raw[[2]]

murders_raw <- murders_raw %>% setNames(c("state","population","total","murders","gun_murders","gun_ownership","total_rate","murder_rate","gun_murder_rate"))


#Agregamos la coma para buscar el patron

pattern <- ","

#tambien se puede establecer el patron directamente si es  corto.

str_detect(murders_raw$total, pattern = ",")


#Es un simple ejemplo de búsqueda con una expresión regular.

#Podemos mostrar todas las entradas que usan "cm" de esta manera.

#Usamos la función str_subset.

data("reported_heights")

str_subset(reported_heights$height, "cm")


#Ahora consideremos un ejemplo un poco más complicado.

#Preguntémonos cuál de las siguientes cadenas satisface su patrón.

#Vamos a definir "sí" como los que sí lo hacen, y "no" como los que no, y luego crea un vector de cadenas, llamado s, que incluye ambas.


yes <- c("180 cm", "70 inches")

no <- c("180", "70 ''")

s <- c(yes, no)

#Entonces, nos preguntamos cuál de las cadenas incluye el patrón "cm" o el patrón "pulgadas."

#Podríamos llamar a str_detect dos veces, así.

str_detect(s, "cm") | str_detect(s, "inches")

#Sin embargo, no necesitamos hacer esto.

#La característica principal que distingue el lenguaje regex de cadenas simples es que podemos usar caracteres especiales.

#Estos son personajes que tienen un significado.

#Comenzamos presentando este personaje "|", que significa "o".

#Entonces, si desea saber si aparece "cm" o "pulgadas" en la cadena,

#podemos usar las pulgadas de la barra de expresiones regulares, así, y obtener la respuesta correcta.

str_detect(s, "cm|inches")

#Otro personaje especial que será útil para identificar pies y pulgadas values es la barra invertida \d, que significa cualquier dígito, 0, 1, 2, 3, hasta 9.

#La barra diagonal inversa se usa para distinguirla del carácter "d".

#En R, tenemos que escapar de la barra invertida, por lo que en realidad tiene que usar dos barras diagonales inversas, y luego una d para representar los dígitos.

#\\d

#Ejemplo


#Vamos a definir varias cadenas, algunas que satisfacen un patrón, otros que no.
#Y ahora vamos a buscar un patrón que tenga un dígito.


yes <- c("5", "6", "5'10", "5 feet", "4'11")
no <- c("", ".", "Five", "six")
s <- c(yes,no)
pattern <- "\\d"
str_detect(s, pattern)


#Aprovechamos esta oportunidad para presentar la muy útil función str_view.

#Esta es una función útil para solucionar problemas, ya que nos muestra el primer partido para cada cadena.

#Entonces, si escribimos str_view (s, y luego el patrón, nos muestra la primera vez que se encontró un dígito.

str_view(s, pattern)

#El str_view_all nos muestra todas las coincidencias.

#Entonces, si lo usamos aquí, podemos ver que todos los dígitos están resaltados.
str_view_all(s, pattern)

#Hay muchos, muchos otros personajes especiales en expresiones regulares.

#Ejercicios

s <- c("70","5 ft","4'11", "",".","Six feet")

pattern <- "\\d|ft" #este es el que solicitan
 
str_view_all(s, pattern)

#pattern <- "\d|ft"

pattern <- "\\d\\d|ft"

str_view_all(s, pattern)

pattern <- "\\d|feet"

str_view_all(s, pattern)
