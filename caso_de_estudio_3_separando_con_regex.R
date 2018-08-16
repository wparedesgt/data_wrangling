#Separando con expresiones regulares

library(dslabs)
library(tidyverse)



#La construccion de expresiones regulares que nos permite identificar qué elementos 
#de un vector de caracteres podemos hacer coincidir el patrón de pies y pulgadas.
#Sin embargo, queríamos hacer más.
#Queríamos extraer y guardar los pies y el valor numérico para que podamos convertirlos a pulgadas cuando sea apropiado.

#Vamos a construir un caso más simple.

#Así que vamos a hacerlo así.

s <- c("5'10", "6'1")
tab <- data.frame(x = s)

#Ya hemos aprendido a usar las funciones por separado.

#Entonces podemos usar este código para separar la parte de los pies y la parte de las pulgadas.

tab %>% separate(x, c("feet", "inches"), sep = "'")

#La función extracto del paquete tidyr que dice usar grupos de expresiones regulares para extraer los valores deseados.

#Aquí está el código de la columna que usa extraer al código usando por separado.

tab %>%  extract(x, c("feet", "inches"), regex = "(\\d)'(\\d{1,2})")

#Entonces, ¿por qué necesitamos el nuevo extracto de función?

#La razón es que los grupos en expresiones regulares nos dan mucha más flexibilidad.

#Por ejemplo, si definimos un ejemplo como este y solo queremos los números, por separado falla

s <- c("5'10", "6'1\"", "5'8inches")

tab <- data.frame(x = s)


#Mira lo que sucede.

#Pero podemos usar extract.

tab %>% extract(x, c("feet", "inches"), regex = "(\\d)'(\\d{1,2})")


#La expresión regular aquí es un poco más complicada,ya que tenemos que permitir la comilla simple con espacios en pies.

#Pero también queremos las comillas dobles incluidas en el valor, entonces no incluimos eso en el grupo.

#Entonces podemos usar extraer para obtener los números que queremos usando este código.

#Podemos usar separado y extraer en nuestro caso de estudio y en el material de la clase.

#Tenemos el código que termina con los problemas y extrae la altura en pulgadas para la gran mayoría de los estudiantes.

#Te dejaremos estudiar eso por tu cuenta.