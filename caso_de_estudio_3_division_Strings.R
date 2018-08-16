#Division de Strings
library(dslabs)
library(tidyverse)
library(rvest)
library(purrr)

#Otra operación de disputa de datos muy común
#es una división de strings.
#Para ilustrar cómo surge esto, comenzamos con un ejemplo ilustrativo.
#Supongamos que no tenemos la función leer subrayado CSV disponible para su uso.
#Supongamos que tenemos que leer un archivo CSV usando la base R
#función leer líneas como esta.

filename <- system.file("extdata/murders.csv", package = "dslabs")

lines <- readLines(filename)


#Esta función lee los datos línea por línea para crear un vector de cadenas.

lines %>% head()

#En este caso, una cadena por cada fila en la hoja de cálculo.
#Las primeras seis líneas son las siguientes.
#Queremos extraer los valores que están separados por comas
#para cada cadena en el vector.
#El comando string split hace exactamente esto.
#Aquí hay un ejemplo.

x <- str_split(lines, pattern = ",")


#Tenga en cuenta que la primera entrada tiene un nombre de columna.

col_names <- x[[1]]

#Entonces podemos separar eso, así.

x <- x[-1]


#Para convertir nuestra lista en un marco de datos,
#puede usar un atajo proporcionado por la funcion map() en el paquete purrr.


#La función de mapa aplica la misma función a cada elemento en una lista.
#Entonces, si queremos extraer la primera entrada de cada elemento en x,
#podemos escribir el siguiente código usando la función map().

map(x, function(y) y[1]) %>% head()



#Sin embargo, debido a que esta es una tarea tan común, purrr proporciona un atajo.
#Si el segundo argumento, en lugar de una función, recibe un número entero,
#asume que queremos esa entrada.
#Entonces el código es realmente mucho más simple.
#De hecho, podemos escribir esto.

map(x,1) %>% head()

#Para obligar al mapa a devolver un vector de caracteres en lugar de una lista,
#podemos usar map underscore chr.
#Del mismo modo, map underscore int returns enteros.
#Entonces, para crear nuestro marco de datos, podemos usar el siguiente código.

dat <- data.frame(map_chr(x,1),
                  map_chr(x,2),
                  map_chr(x,3),
                  map_chr(x,4),
                  map_chr(x,5)) %>%
  mutate_all(parse_guess) %>% 
  setNames(col_names)
 
dat %>% head()

#Tenga en cuenta que, usando otras funciones incluidas en el paquete purrr,
#podemos lograr lo que acabamos de hacer con un código mucho más eficiente.

dat <- x %>% 
  transpose() %>% 
  map(~ parse_guess(unlist(.))) %>% 
  setNames(col_names) %>%
  as.data.frame()


#Esto es lo que parece.
#Resulta que podríamos evitar todo esto porque, en la cadena de funciones
#dividir, hay un argumento llamado simplificar es igual a verdad
#que obliga a la función a devolver una matriz en lugar de una lista.
#Entonces podríamos haber escrito esto.


#Ejemplo


schedule <- data.frame(day = c("Monday", "Tuesday"), staff = c("Mandy, Chris and Laura", "Steve, Ruth and Frank"))


tidy <- schedule %>% 
  mutate(staff = str_split(staff, ", | and ")) %>% 
  unnest()

tidy
