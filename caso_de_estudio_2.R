#Casos de estudio N.2 

library(tidyverse)
library(dslabs)
library(rvest)
library(httr)


data("reported_heights")

#Recopilamos más de 1,000 presentaciones, pero desafortunadamente el vector columna con las alturas reportadas tenía varias entradas no numéricas, y como resultado se convirtió en un vector de caracteres.

#Podemos verlo aquí.

class(reported_heights$height)

#Si tratamos de analizarlo en un número, obtenemos una advertencia.

x <- as.numeric(reported_heights$height)

#Hay muchas NA.

#Aunque la mayoría de los valores parecen ser de altura en pulgadas según lo solicitado aquí están los primeros cinco  terminamos con muchas NA. Puedes ver cuántos usan este código.

sum(is.na(x))

#Podemos ver algunas de las entradas que no son exitosas convertido mediante el uso de la función de filtro para mantener solo las entradas que resultó en NA.

reported_heights %>% mutate(new_height = as.numeric(height)) %>% 
  filter(is.na(new_height)) %>% head(n=10)


#Ahora, mira las entradas que no son numéricas. Inmediatamente vemos lo que está sucediendo. Algunos de los estudiantes no informaron sus alturas en pulgadas según lo solicitado.

#Podríamos descartar estos y continuar, sin embargo, muchas de las entradas siguen patrones que, en principio, podemos convertir fácilmente a pulgadas.

#Por ejemplo, en la salida que acabamos de ver, ver varios casos que usan el siguiente formato, con "X" representando pies y "Y" que representa pulgadas.

# X'Y"

#Cada uno de estos casos puede ser leído y convertido a pulgadas por un humano.

#Por ejemplo, si escribe 5'4 "como este, esto es 5 veces 12 más 4, que es 64 pulgadas.

#5 X 12 + 4 = 64

#Sin embargo, los humanos son propensos a cometer errores.

#Además, debido a que planeamos continuar recopilando datos en el futuro,será conveniente escribir un código que automáticamente haga esto.

#Un primer paso en este tipo de tarea es estudiar las entradas problemáticas e intente definir patrones específicos seguidos por un gran grupo de entradas.

#Cuanto más grandes sean estos grupos, más entradas podemos arreglarlo con un solo enfoque programático.

#Queremos encontrar patrones que puedan describirse con precisión con una regla, como un dígito seguido de un símbolo de pie seguido de uno o dos dígitos seguidos por un símbolo de pulgadas.

#Para buscar tales patrones, ayuda a eliminar las entradas que son consistentes con ser pulgadas, y ver solo las entradas problemáticas.

#Escribimos una función para hacer esto automáticamente.

#Solo guardamos entradas que resultan en NA cuando se aplican como numéricaso están fuera de un rango de alturas plausibles.

#Permitimos un rango que cubre aproximadamente el 99.99999% de la población adulta.

#También utilizamos suppressWarnings en todo el código para evitar los mensajes de advertencia que sabemos que nos dará as.numeric.

#suppressWarnings()

not_inches <- function(x, smallest = 50, tallest = 84) {
  inches <- suppressWarnings(as.numeric(x))
  ind <- is.na(inches) | inches < smallest | inches > tallest
  ind
}


#Aplicamos esta función, y encontramos que hay muchas entradas que son problemáticos

problems <- reported_heights %>% 
  filter(not_inches(height)) %>% 
  .$height

#vemos cuantos son problematicos

length(problems)

#Pero después de examinarlos cuidadosamente, notamos tres patrones que son seguidos por tres grandes grupos de entradas.

#Un patrón de la forma "X" pies y o "X" pies espacio y pulgadas o "X" pies y barras invertidas pulgadas, y con "X Y" que representan pies y pulgadas respectivamente, es un patrón común.

# X' Y  o  "X' Y" o X' Y\"

pattern <- "^\\d\\s*'\\s*\\d{1,2}\\.*\\d*'*\"*$"

#Aquí hay 10 ejemplos.

str_subset(problems, pattern) %>% head(n=10) %>% cat()

#Un patrón de la forma x punto y o x coma x, con x pies y y pulgadas, también son comunes.

#X.Y o X,Y

pattern <- "^[4-6]\\s*[\\.|,]\\s*([0-9]|10|11)$"
str_subset(problems, pattern) %>% head(n=10) %>% cat()


#Las entradas que se informaron en centímetros en lugar de pulgadas es otro ejemplo.

ind <- which(between(suppressWarnings(as.numeric(problems)) / 2.54, 54, 81))
ind <- ind[!is.na(ind)]
problems[ind] %>% head(n=10) %>% cat()


#Una vez que se ve que estos grupos grandes siguen patrones específicos,podemos desarrollar un plan de ataque.

#Tenga en cuenta que rara vez hay una sola forma de realizar estas tareas.

#Aquí, seleccionamos uno que nos ayuda a enseñar varias técnicas útiles.

#Ejercicios
not_inches(c(175))
#not_inches(c(“5’8\””))
not_inches(c(70))
#not_inches(c(85) (the height of Shaquille O'Neal in inches))
