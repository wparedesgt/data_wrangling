#Definición de cadenas: comillas simples y dobles 
library(tidyverse)


s <- '10"'

s
#Para asegurarnos de que funciona, en R podemos usar la función cat.
#La función cat nos permite ver cómo se ve realmente la cadena.
#Entonces, si escribimos cat (s), veremos 10 "como quisiéramos.

cat(s)

#Ahora, ¿qué queremos usar para que la cuerda sea de 5 pies escrita así--
#5 y luego la comilla simple.

s <- "5'"

cat(s)


#Así que hemos aprendido a escribir cinco pies y 10 pulgadas por separado.
#Pero, ¿y si queremos escribirlos juntos para representar
#cinco pies y 10 pulgadas, así?
# 5'10"

#En este caso, ni la cita simple ni la doble funcionarán.
#Esto le dará un error, porque cerramos la cadena después de los cinco.
#Y esto también le dará un error, porque cierra la cadena después de 10.
#Tenga en cuenta que esto realmente no le da un error.
#Si escribimos una de las cadenas anteriores en R,
#se quedará atascado esperando a que cierre la cita abierta,
#y tendrás que esc botón.
#En estas situaciones en las que no podemos usar ninguna de las dos citas
#para escribir la cadena que queremos, necesitamos escapar de las comillas.
#Y para eso usamos la barra invertida.

#Así que podemos escapar de cualquiera de los personajes como este--
# podemos usar comillas simples y luego escapar las comillas simples que # #representan pies, o podemos usar comillas dobles y escapar de las comillas dobles que representar pulgadas, como este.

s <- '5\'10"'
cat(s)

#Ejercicio

cat(" LeBron James is 6’8\" ")
#cat(' LeBron James is 6'8" ')
#cat(" LeBron James is 6\’8" ")
cat(` LeBron James is 6'8" `)
