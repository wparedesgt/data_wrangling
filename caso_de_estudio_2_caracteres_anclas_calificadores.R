#Caso de estudio 2 Clases de caracteres, anclas y calificadores

#Verás que creamos cadenas para probar nuestra expresión regular.
#Para hacer esto, definimos patrones que conocemosdebe coincidir con el patrón que estamos probando, y algunos que sabemos no debería.

#Los llamaremos "sí" y "no", respectivamente.

#Esto nos permite verificar los dos tipos de errores, no coincidiendo y haciendo coincidir incorrectamente.

library(tidyverse)
library(dslabs)
library(rvest)


#Las clases de caracteres se utilizan para definir una serie de caracteres eso puede ser igualado.

#Definimos clases de caracteres con los corchetes [].

#Entonces, por ejemplo, si queremos que el padre coincida solo si tenemos un 5 o un 6, podemos usar la expresión regular, corchetes, 5, 6.

yes <- c("5", "6", "5'10", "5 feet", "4'11")
no <- c("", ".", "Five", "six")
s <- c(yes,no)

str_view(s, "[56]")


#Entonces lo probamos, puedes ver que solo detectamos los 5 y 6.

#Puedes verlo con una string_view.

#Supongamos que queremos hacer coincidir los valores entre 4 y 7.

#Una forma común de definir una clase de caracteres es con rangos.

#Entonces, por ejemplo, si usamos los corchetes y luego de 0 a 9, esto es equivalente a usar la reacción d.

#Son todos los dígitos.

#Entonces, los corchetes del patrón 4 a 7 coincidirán con los números 4, 5, 6 y 7.
#Podemos verlo en este ejemplo.

yes <- as.character(4:7)
no <- as.character(1:3)
s <- c(yes,no)

str_detect(s, "[4-7]")


#Sin embargo, es importante saber que en expresiones regulares, todo es un caracter.
#No hay números, entonces 4 es el caracter 4, no el número 4.

#Tenga en cuenta, por ejemplo, que si escribimos de 1 a 20, esto no significa 1, 2, 3, 4, 5, hasta 20. Significa que los caracteres 1 a 2 y luego el caracter 0.

#Así que las expresiones regulares 1 a 20 entre corchetes simplemente significa la clase de caracteres compuesta de 0, 1 y 2.


#Tenga en cuenta que los caracteres tienen un orden y los dígitos sigue el orden numérico.

#Entonces 0 viene antes de 1, que viene antes de 2, y así sucesivamente.

#Por la misma razón, podemos definir letras como rangos.

#Así que de la a la z son todas las letras minúsculas así [a-z] y las mayúsculas de la A a la Z [A-Z] son todas las letras mayúsculas.

#Si quieres todas las letras, entonces lo escribiríamos así. 

#[a-zA-Z]


#¿Qué pasa si queremos que el patrón coincida cuando tenemos exactamente un dígito?
#Esto será útil en nuestros estudios de casos ya que los pies nunca son más de un dígito.

#Entonces una restricción nos ayudará.

#Una forma de hacer esto con expresiones regulares es mediante el uso de anclajes que nos permiten definir patrones que debe comenzar o terminar en lugares específicos.

#Los dos anclajes más comunes son el signo de intercalación y el signo de dólar   (^ $),que representan el comienzo y el final de una cadena, respectivamente.

#Entonces, el patrón de intercalación, barra diagonal inversa, diagonal inversa, d, signo de dólar se lee como inicio de la cadena seguido de un dígito seguido al final de la cadena.

#^\\d$

#Observe cómo este patrón ahora solo detecta las cadenas con exactamente un dígito.

#Podemos verlo en este ejemplo.

pattern <- "^\\d$"

yes <- c("1", "5", "9")
no <- c("12", "123", " 1", "a4", "b")
s <- c(yes,no)
str_view(s, pattern)

#Tenga en cuenta que el 1 en el ejemplo que acabamos de mostrar no coincide porque hay un espacio al frente, por lo que no es solo un dígito.

#Para la parte de pulgadas, podemos tener uno o dos dígitos.

#Esto se puede especificar en regex con cuantificadores.
#Esto se hace siguiendo el patrón con llaves con la cantidad de veces que se repite la entrada anterior.

#Entonces el patrón para uno o dos dígitos es como esto barra invertida, barra inclinada invertida, d, y luego llaves, 1 coma 2.

#\\d{1,2}

#Entonces este código hará lo que queremos.
pattern <- "^\\d{1,2}$"

yes <- c("1", "5", "9")
no <- c("12", "123", " 1", "a4", "b")
s <- c(yes,no)
str_view(s, pattern)

#Encontrará todos los números que son dos dígitos o un dígito.

#En este caso, 1, 2, 3 no coincide pero 1, 2 lo hace.

#Entonces, para buscar un patrón de pies y pulgadas, podemos agregar el símbolo para los pies y el símbolo para pulgadas después de los dígitos.

#Con lo que hemos aprendido, ahora podemos construir un ejemplo para el patrón x pies y y pulgadas, con la "x" representando pies y la "y" pulgadas.

#Se verá así.

pattern <- "^[4-7]'\\d{1,2}\"$"


#Vamos a decir que comienza esta cadena, luego cualquier número entre 4 y 7, los otros pies, luego el símbolo para los pies, luego uno o dos dígitos, y luego el final de la cadena.

#Este patrón ahora se está volviendo complejo, pero podemos míralo con cuidado y desglosa.

#El cursor significa inicio de la cuerda. 
#Corchetes, 4, 7.
#Un dígito ya sea 4, 5, 6 o 7.
#El símbolo de los pies: barra diagonal inversa, barra invertida d, llaves, 1, 2 significa uno o dos dígitos
#Y luego, las comillas invertidas son el símbolo de pulgadas, luego terminamos con el signo de dólar, lo que significa el final de la cadena.

#Probémoslo.

#Hagamos algunas strings donde son pies y pulgadas, otras donde no deberíamos obtener una coincidencia.

yes <- c("5'7\"", "6'2\"", "5'12\"")
no <- c("6,2\"", "6.2\"", "I am 5'11\"", "3'2\"", "64")

#Lo probamos con string detect y vemos que funciona como se espera.

str_detect(yes, pattern)
str_detect(no, pattern)


#Por ahora, estamos permitiendo que las pulgadas sean 12 o más grandes.
#Añadiremos una restricción más adelante como expresión regular.

#Ejerccicio

animals <- c("cat", "puppy", "Moose", "MONKEY")
pattern <- "[a-z]"
str_detect(animals, pattern)

#NO2

animals <- c("cat", "puppy", "Moose", "MONKEY")
pattern <- "[A-Z]$"
str_detect(animals, pattern)

#No3

animals <- c("cat", "puppy", "Moose", "MONKEY")
pattern <- "[a-z]{4,5}"
str_detect(animals, pattern)
