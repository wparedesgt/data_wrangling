#Grupos y cuantificadores
library(dslabs)
library(tidyverse)
library(rvest)

data("reported_heights")


not_inches_or_cm <- function(x, smallest = 50, tallest = 84) {
  inches <- suppressWarnings(as.numeric(x))
  ind <- !is.na(inches) & 
    ((inches >= smallest & inches <= tallest) |
       (inches/2.54 >= smallest & inches/2.54 <= tallest))
  !ind
}


problems <- reported_heights %>%
  filter(not_inches_or_cm(height)) %>%
  .$height

length(problems)


converted <- problems %>% 
  str_replace("feet|ft|foot", "'") %>%
  str_replace("inches|in|''|\"" , "") %>% 
  str_replace("^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$", "\\1'\\2")

pattern <- "^[4-7]\\s*'\\s*\\d{1,2}$"

index <- str_detect(converted, pattern)

mean(index)

converted[!index]


#Cuatro patrones claros de entradas han surgido junto con algunos otros problemas menores:
  
#1. Muchos estudiantes que miden exactamente 5 o 6 pies no ingresaron ninguna pulgada. Por ejemplo, 6 '- nuestro patrón requiere que se incluyan pulgadas.

#2. Algunos estudiantes que miden exactamente 5 o 6 pies ingresaron solo ese número.

#3. Algunas de las pulgadas se ingresaron con puntos decimales. Por ejemplo 5'7.5 ''. Nuestro patrón solo busca dos dígitos.

#4. Algunas entradas tienen espacios al final, por ejemplo 5 '9.

#5. Algunas entradas están en metros y algunas de ellas usan decimales europeos: 1.6, 1.7.

#6. Dos estudiantes agregaron cm.

#7. Un estudiante explicó los números: cinco pies y ocho pulgadas.


#No es necesariamente claro que vale la pena escribir código para manejar todos estos casos, ya que pueden ser lo suficientemente raros. Sin embargo, algunos nos dan la oportunidad de aprender algunas técnicas más de expresiones regulares para que construyamos una solución.

#Caso 1

#Para el caso 1, si agregamos un '0 a, por ejemplo, convertimos todos los 6 a 6'0, entonces nuestro patrón coincidirá. Esto se puede hacer usando grupos usando el siguiente código:



yes <- c("5", "6", "5")
no <- c("5'", "5''", "5'4")
s <- c(yes, no)
str_replace(s, "^([4-7])$", "\\1'0")

#El patrón dice que tiene que comenzar (^), seguido por un dígito entre 4 y 7, y luego terminar allí ($). El paréntesis define el grupo que pasamos como \\ 1 a la regex de reemplazo.


#Casos 2 y 4

#Podemos adaptar este código ligeramente para manejar el caso 2 también, que cubre la entrada 5 '. Tenga en cuenta que el 5 'no se ve afectado por el código anterior. Esto se debe a que el extra 'hace que el patrón no coincida ya que tenemos que terminar con un 5 o 6. Para manejar el caso 2, queremos permitir que el 5 o el 6 sean seguidos por un símbolo o ninguno para los pies. Entonces, simplemente podemos agregar '{0,1} después de' para hacer esto. ¿También podemos usar ninguno o un carácter especial? Como vimos anteriormente, esto es diferente de * que es ninguno o más. Ahora vemos que este código también maneja el cuarto caso:


str_replace(s, "^([56])'?$", "\\1'0")

#Tenga en cuenta que aquí solo permitimos 5 y 6, pero no 4 y 7. Esto se debe a que las alturas de exactamente 5 y exactamente 6 pies son bastante comunes, por lo que suponemos que las que escribieron 5 o 6 realmente significaron 60 o 72 pulgadas. Sin embargo, las alturas de exactamente 4 o exactamente 7 pies de altura son tan raras que, aunque aceptamos 84 como una entrada válida, suponemos que se ingresó un 7 por error.


#Caso 3

#Podemos usar cuantificadores para tratar el caso 3. Estas entradas no coinciden porque las pulgadas incluyen decimales y nuestro patrón no lo permite. Necesitamos permitir que el segundo grupo incluya decimales y no solo dígitos. Esto significa que debemos permitir cero o un período. seguido de cero o más dígitos. Entonces, ¿usaremos ambos? y *. También recuerde que para este caso particular, el período necesita ser escapado ya que es un carácter especial (significa cualquier carácter excepto un salto de línea).

#Entonces podemos adaptar nuestro patrón, actualmente ^ [4-7] \\ s * '\\ s * \\ d {1,2} $ para permitir un decimal al final:


pattern <- "^[4-7]\\s*'\\s*(\\d+\\.?\\d*)$"


#Caso 5

#Caso 5, metros que usan comas, podemos aproximarnos de manera similar a como convertimos x.y a x'y. La diferencia es que requerimos que el primer dígito sea 1 o 2:

yes <- c("1,7", "1, 8", "2, " )
no <- c("5,8", "5,3,2", "1.7")
s <- c(yes, no)
str_replace(s, "^([12])\\s*,\\s*(\\d*)$", "\\1\\.\\2")

#Más adelante verificaremos si las entradas son metros usando sus valores numéricos.

#Trimming

#En general, los espacios al principio o al final de la cadena son poco informativos. Estos pueden ser particularmente engañosos porque a veces pueden ser difíciles de ver:


s <- "Hi "
cat(s)
identical(s, "Hi")

#Este es un problema bastante general que hay una función dedicada a eliminarlos: str_trim.

str_trim("5 ' 9 ")


#Para mayúsculas y minúsculas

#Una de las entradas escribe los números como palabras: cinco pies y ocho pulgadas. Aunque no es eficiente, podríamos agregar 12 str_replace adicionales para convertir cero a 0, uno a 1, y así sucesivamente. Para evitar tener que escribir dos operaciones separadas para Cero y cero, Uno y uno, etc., podemos usar la función str_to_lower para hacer primero todas las palabras minúsculas:

s <- c("Five feet eight inches")
str_to_lower(s)


#Poniéndolo en una función

#Ahora estamos listos para definir un procedimiento que maneje la conversión de todos los casos problemáticos.

#Ahora podemos unir todo esto en una función que toma un vector de cadena e intenta convertir tantas cadenas como sea posible a un solo formato. A continuación se muestra una función que reúne los reemplazos de código anteriores:


convert_format <- function(s){
  s %>%
    str_replace("feet|foot|ft", "'") %>% #convert feet symbols to '
    str_replace_all("inches|in|''|\"|cm|and", "") %>%  #remove inches and other symbols
    str_replace("^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$", "\\1'\\2") %>% #change x.y, x,y x y
    str_replace("^([56])'?$", "\\1'0") %>% #add 0 when to 5 or 6
    str_replace("^([12])\\s*,\\s*(\\d*)$", "\\1\\.\\2") %>% #change european decimal
    str_trim() #remove extra space
}



#También podemos escribir una función que convierta palabras en números:

words_to_numbers <- function(s){
  str_to_lower(s) %>%  
    str_replace_all("zero", "0") %>%
    str_replace_all("one", "1") %>%
    str_replace_all("two", "2") %>%
    str_replace_all("three", "3") %>%
    str_replace_all("four", "4") %>%
    str_replace_all("five", "5") %>%
    str_replace_all("six", "6") %>%
    str_replace_all("seven", "7") %>%
    str_replace_all("eight", "8") %>%
    str_replace_all("nine", "9") %>%
    str_replace_all("ten", "10") %>%
    str_replace_all("eleven", "11")
}


#Ahora podemos ver qué entradas problemáticas permanecen:



converted <- problems %>% words_to_numbers %>% convert_format
remaining_problems <- converted[not_inches_or_cm(converted)]
pattern <- "^[4-7]\\s*'\\s*\\d+\\.?\\d*$"
index <- str_detect(remaining_problems, pattern)
remaining_problems[!index]


#Ejercicios

s <- c("5'10", "6'1\"", "5'8inches", "5'7.5")
tab <- data.frame(x = s)

#Si usa el código de extracción de nuestro video, el punto decimal se descarta. ¿Qué modificación del código le permitiría poner los decimales en una tercera columna llamada "decimal"?

#extract(data = tab, col = x, into = c("feet", "inches", "decimal"), 
#        regex = "(\\d)'(\\d{1,2})(\\.)?"

  
#extract(data = tab, col = x, into = c("feet", "inches", "decimal"), 
#                regex = "(\\d)'(\\d{1,2})(\\.\\d+)" 
        
#extract(data = tab, col = x, into = c("feet", "inches", "decimal"), 
#                regex = "(\\d)'(\\d{1,2})\\.\\d+?"
        
        
extract(data = tab, col = x, into = c("feet", "inches", "decimal"), 
                regex = "(\\d)'(\\d{1,2})(\\.\\d+)?")      
                