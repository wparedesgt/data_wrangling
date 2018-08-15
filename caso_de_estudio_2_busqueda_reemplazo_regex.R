#Busqueda y reemplazo expresiones regulares

library(dslabs)
library(tidyverse)
library(rvest)

#En un el caso de estudio 2, definimos los problemas del objeto que contiene las cadenas que no parecen estar en pulgadas.

data("reported_heights")

not_inches <- function(x, smallest = 50, tallest = 84) {
  inches <- suppressWarnings(as.numeric(x))
  ind <- is.na(inches) | inches < smallest | inches > tallest
  ind
}

problems <- reported_heights %>% 
  filter(not_inches(height)) %>% 
  .$height

pattern <- "^[4-7]'\\d{1,2}\"$"

#Podemos ver que solo estos coinciden con el patrón que definimos.

sum(str_detect(problems,pattern))



#Para ver por qué esto es así, mostramos ejemplos que exponen por qué no tenemos más validos.

#Aquí hay unos ejemplos.

problems[c(2,10,11,12,15)] %>% str_view(pattern)

#Vemos que solo dos de ellos coinciden.

#¿Porqué es eso?
  
#Un primer problema que vemos de inmediato es que algunos estudiantes escribieronlas palabras pies y pulgadas.

#Podemos ver las entradas que hicieron esto con la función subconjunto estricto

str_subset(problems, "inches")


#Vemos varios ejemplos.

#También vemos que algunas entradas usan las comillas simples dos veces para representar pulgadas en lugar de las comillas dobles.

#Podemos ver algunos ejemplos utilizando la opción subconjunto de cadenas.

str_subset(problems, "''")

#Lo primero que podemos hacer para resolver este problema es reemplazar las diferentes formas de representar pulgadas y pies con un símbolo uniforme.

#Utilizaremos una comilla simple para pies, y para pulgadas, lo haremos simplemente no use nada.

#Entonces 5, comillas simples, y significará 5 pies y pulgadas.

#5'y

#Ahora, si ya no usamos el símbolo de pulgadas al final, podemos cambiar nuestro patrón en consecuencia quitándolo del patrón.

#Entonces nuestro patrón será este entonces.

pattern <- "^[4-7]'\\d{1,2}$"

#Si hacemos este reemplazo antes de la coincidencia, obtenemos muchas más coincidencias.

#Así que vamos a usar la función de reemplazo de cadena para reemplazar los pies, con el símbolo de los pies.

#Y vamos a reemplazar pulgadas en dos comillas simples y comillas dobles sin nada.

problems %>% 
  str_replace("feet|ft|foot", "'") %>%
  str_replace("inches|in|''|\"" , "") %>% 
  str_detect(pattern) %>%
  sum


#Ejecutamos esto y ahora vemos que obtenemos muchas más coincidencias.

#Sin embargo, todavía tenemos muchos casos por recorrer.

#Tenga en cuenta que en el código que acabamos de mostrar, aprovechamos la cadena  [? y?] consistencia y usar el [? parte. ?] 

#Otro problema que tenemos son espacios.

#Por ejemplo, el patrón 5, comillas simples, espacio, 4, y luego las comillas dobles no coinciden porque hay es un espacio entre la cita simple y el 4, que nuestro patrón no permite Los espacios son caracteres y R no los ignora.

#5' 4

#Aquí.

# Puedes escribir esta función para ver que no hay que estas dos cadenas no son lo mismo.

identical("Hi", "Hi ")

#Hay un espacio en uno y no el otro.

#En expresiones regulares, podemos representar espacios, espacios en blanco, como con barras invertidas + s.

#\s

#Entonces, para encontrar patrones como 5, comillas simples, espacio y luego otro dígito, podemos cambiar nuestro patrón a lo siguiente.

pattern_2 <- "^[4-7]'\\s\\d{1,2}$"

#Estamos agregando barra invertida, barra invertida, s después de la comilla simple.

str_subset(problems, pattern_2)

#Y ahora, podemos ver que encontramos algunos ejemplos.

#Entonces, ¿necesitamos más de un patrón de expresión regular?  uno para el espacio y otro sin el espacio?
  
#No, nosotros no.

#Podemos usar cuantificadores para esto también.

#Entonces, queremos que un patrón permita espacios pero no los exija.

#Incluso si hay varios espacios como este, aún queremos que coincida.

#Hay un cuantificador exactamente para este propósito.

#En expresiones regulares, el carácter de asterisco significa cero o más instancias del caracter anterior.

#Entonces, hagamos un ejemplo rápido.

#Definimos algunas cadenas, y luego probamos para ver qué cadenas encontramos al usar el asterisco después del 1.

yes <- c("AB", "A1B", "A11B", "A111B", "A1111B")
no <- c("A2B", "A21B")

str_detect(yes, "A1*B")
str_detect(no, "A1*B" )

#Vemos que encuentra todos estos y ninguno de estos.

#Tenga en cuenta que coincide con la primera cadena que tiene cero 1s y todas las cadenas que tienen uno o más 1s.

#Para que podamos mejorar nuestro patrón agregando el asterisco después del carácter de espacio barra invertida, s.

#DE ACUERDO.

#Ahora hay otros dos cuantificadores similares.

#Para ninguno o una vez, podemos usar el signo de interrogación.

#Y para uno o más, podemos usar el signo más.

#Puede ver cómo difieren al probarlo con este código.

data.frame(string = c("AB", "A1B", "A11B", "A111B", "A1111B"), 
           none_or_more = str_detect(yes, "A1*B"), 
           none_or_once = str_detect(yes, "A1?B"), 
           once_or_more = str_detect(yes, "A1+B"))

#Realmente usaremos los tres en nuestro informe como ejemplos como verás más adelante.

# Pero en este momento, para mejorar nuestro patrón, puede agregar los asteriscos después de la barra invertida, s en frente y después del símbolo de los pies para permitir el espacio entre los pies símbolo y los números.

pattern <- "^[4-7]\\s*'\\s*\\d{1,2}$"


#Ahora igualamos y obtenemos algunas entradas más.

#Aquí está el ejemplo.

problems %>% 
  str_replace("feet|ft|foot", "'") %>%
  str_replace("inches|in|''|\"" , "") %>% 
  str_detect(pattern) %>%
  sum

#Podríamos tener la tentación de evitar hacer esto eliminando todos los espacios con la cadena de funciones lo reemplazan todo.

#Sin embargo, cuando se realiza una operación de este tipo, necesita asegurarse de que no tenga un efecto no deseado.

#En nuestro ejemplo de altura reportado, esto será un problema porque algunas entradas son de la forma x espacio y con espacio separando los pies de las pulgadas.

# X  Y

#Si eliminamos todos los espacios, incorrectamente volveremos x espacio y en xy,

#XY 

#Lo que implica que una persona de 6 '1 "se convertiría en 61 pulgadas persona en lugar de una persona de 73 pulgadas.

#Ejercicio

animals <- c("moose", "monkey", "meerkat", "mountain lion")

pattern <- "mo*"

str_detect(animals, pattern)

pattern <- "mo?"

str_detect(animals, pattern)

pattern <- "mo+"

str_detect(animals, pattern)

pattern <- "moo*"

str_detect(animals, pattern)

#No2

schools <- c("U. Kentucky","Univ New Hampshire","Univ. of Massachusetts","University Georgia","U California","California State University")

schools



schools %>% 
  str_replace("Univ\\.?|U\\.?", "University ") %>% 
  str_replace("^University of |^University ", "University of ")


schools %>% 
  str_replace("^Univ\\.?\\s|^U\\.?\\s", "University ") %>% 
  str_replace("^University of |^University ", "University of ")

schools %>% 
  str_replace("^Univ\\.\\s|^U\\.\\s", "University") %>% 
  str_replace("^University of |^University ", "University of ")

schools %>% 
  str_replace("^Univ\\.?\\s|^U\\.?\\s", "University") %>% 
  str_replace("University ", "University of ")
