#Raspado WEB
#Pagina en donde salio la información de asesinatos en USA por estado
#https://en.wikipedia.org/wiki/Gun_violence_in_the_United_States_by_state

#También podemos aprovechar un lenguaje ampliamente utilizado
#para hacer que las páginas web se vean bien llamadas hojas de estilo en cascada, o CSS.

#El paquete que vamos a aprender a hacer web scraping es parte del tidyverse,
#y se llama rvest

library(tidyverse)
library(dslabs)
library(rvest)

#El primer paso con este paquete es importar la página web en R.

url <- "https://en.wikipedia.org/wiki/Gun_violence_in_the_United_States_by_state"
h <- read_html(url)

class(h)

#La clase de este objeto es en realidad documento XML.
#El paquete de cosecha es en realidad más general.
#Maneja documentos XML, no solo documentos HTML.
#XML es un lenguaje de marcado general, eso es lo que significa XML.
#Este lenguaje se puede usar para representar cualquier tipo de información.
#HTML es un tipo específico de XML, específicamente desarrollado
#para representar páginas web.

#Aquí sabemos que la información se almacena en una tabla HTML.
#Puede ver esto en una línea de código del documento HTML que mostramos anteriormente.
#La línea específica es esta.
#<table class="wikitable sortable">

#Las diferentes partes de los documentos HTML a menudo
#definir mensajes entre los dos símbolos menores que y mayores que.
#Estos se conocen como nodos. 

#<>

#El paquete rvest incluye funciones para extraer nodos de documentos HTML.
#La función html_nodes, plural, extrae todos los nodos de ese tipo.

#La función html_nodes, plural, extrae todos los nodos de ese tipo.
#Y html_node extrae solo el primer nodo de ese tipo.

tab <- h %>% html_nodes("table")

#Lugo miramos la tabla que contiene solo los datos que queremos.

tab <- tab[[2]]

#Y podemos verlo imprimiendo [? afuera ?] [? lengüeta. ?] Todavía no estamos allí
#sin embargo, porque esto claramente no es un conjunto de datos ordenado.
#Ni siquiera es un marco de datos.
#En el código que acabamos de mostrar, definitivamente puedes ver un patrón,
#y escribir código para extraer solo los datos es muy factible.
#De hecho, rvest incluye una función precisamente para esto--
# para convertir tablas HTML en marcos de datos.
#Aquí está el código que usarías.

tab <- tab %>% html_table

class(tab)


tab <- tab %>% setNames(c("state","population","total","murders","gun_murders","gun_ownership","total_rate","murder_rate","gun_murder_rate"))

head(tab)
