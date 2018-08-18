#Extrayendo tablas de PDF

library(dslabs)
library(tidyverse)
library(rvest)

#Uno de los conjuntos de datos proporcionados en dslabs muestra las tasas de financiación científica por género en los Países Bajos:

data("research_funding_rates")
research_funding_rates 

#Los datos provienen de un documento publicado en la prestigiosa revista PNAS. Sin embargo, los datos no se proporcionan en una hoja de cálculo; están en una tabla en un documento PDF. Podríamos extraer los números a mano, pero esto podría conducir a un error humano. En cambio, podemos tratar los datos usando R.

#Descargar los datos
#Comenzamos descargando el documento PDF y luego importándolo a R usando el siguiente código:

library("pdftools")
temp_file <- tempfile()
url <- "http://www.pnas.org/content/suppl/2015/09/16/1510159112.DCSupplemental/pnas.201510159SI.pdf"
download.file(url, temp_file)
txt <- pdf_text(temp_file)
file.remove(temp_file)

#Si examinamos el texto del objeto, notamos que es un vector de caracteres con una entrada para cada página. Así que guardamos la página que queremos usando el siguiente código:

raw_data_research_funding_rates <- txt[2]


#Los pasos anteriores se pueden omitir porque también incluimos los datos sin procesar en el paquete dslabs:

data("raw_data_research_funding_rates")

#Mirando la descarga

#Examinando este objeto,

raw_data_research_funding_rates %>% head

#vemos que es una cadena larga. Cada línea de la página, incluidas las filas de la tabla, está separada por el símbolo de nueva línea: \ n.

#Por lo tanto, podemos crear una lista con las líneas del texto como elementos:

tab <- str_split(raw_data_research_funding_rates, "\n")


#Debido a que comenzamos con solo un elemento en la cadena, terminamos con una lista con solo una entrada:

tab <- tab[[1]]

#Al examinar este objeto,

tab %>% head

#vemos que la información para los nombres de columna es la tercera y cuarta entradas:

the_names_1 <- tab[3]
the_names_2 <- tab[4]

the_names_1 %>% head
the_names_2 %>% head


#En la tabla, la información de la columna se distribuye en dos líneas. Queremos crear un vector con un nombre para cada columna. Podemos hacer esto usando algunas de las funciones que acabamos de aprender.


#Extrayendo los datos de la tabla
#Comencemos con la primera línea:

the_names_1


#Queremos eliminar el espacio principal y todo lo que sigue a la coma. Podemos usar expresiones regulares para este último. Entonces podemos obtener los elementos dividiéndolos usando el espacio. Queremos dividirnos solo cuando hay 2 o más espacios para evitar dividir la tasa de éxito. Entonces usamos el regex \\ s {2,} de la siguiente manera:


the_names_1 <- the_names_1 %>%
  str_trim() %>%
  str_replace_all(",\\s.", "") %>%
  str_split("\\s{2,}", simplify = TRUE)

the_names_1


#Ahora veamos la segunda línea:

the_names_2

#Aquí queremos recortar el espacio inicial y luego dividirlo por el espacio como lo hicimos en la primera línea:

the_names_2 <- the_names_2 %>%
  str_trim() %>%
  str_split("\\s+", simplify = TRUE)


the_names_2


#Ahora podemos unirnos a estos para generar un nombre para cada columna:

tmp_names <- str_c(rep(the_names_1, each = 3), the_names_2[-1], sep = "_")

tmp_names %>% head


the_names <- c(the_names_2[1], tmp_names) %>%
  str_to_lower() %>%
  str_replace_all("\\s", "_")

the_names

#Ahora estamos listos para obtener los datos reales. Al examinar el objeto pestaña, notamos que la información está en las líneas 6 a 14. Podemos usar str_split nuevamente para lograr nuestro objetivo:

new_research_funding_rates <- tab[6:14] %>%
  str_trim %>%
  str_split("\\s{2,}", simplify = TRUE) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  setNames(the_names) %>%
  mutate_at(-1, parse_number)



new_research_funding_rates %>% head()

#Podemos ver que los objetos son idénticos:

identical(research_funding_rates, new_research_funding_rates)

