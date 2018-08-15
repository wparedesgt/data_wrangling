#Case Study 1
library(tidyverse)
library(rvest)


url <- "https://en.wikipedia.org/wiki/Gun_violence_in_the_United_States_by_state"

murders_raw <- read_html(url) %>% html_nodes("table") %>% html_table()

murders_raw <- murders_raw[[2]]

murders_raw <- murders_raw %>% setNames(c("state","population","total","murders","gun_murders","gun_ownership","total_rate","murder_rate","gun_murder_rate"))

class(murders_raw$population)


#Notamos que las columnas necesitaban ser analizadas de caracteres a números,pero esas comas lo estaban haciendo difícil.

#Podemos usar la función str_detect () para ver que las columnas tengan comas usando este código

commas <- function(x) any(str_detect(x, ","))

murders_raw %>% summarize_all(funs(commas))


#Entonces podemos usar la función str_replace_all para eliminarlos usando este código.

test_1 <- str_replace_all(murders_raw$population, "," , "")

test_1 <- as.numeric(test_1)


#Entonces podemos usar mutate_all para aplicar esta operación a cada columna,ya que no afectará las columnas sin comas.
#Resulta que esta operación es tan comúneliminando comas [? ¿readr?] incluye la función parse_number () específicamente diseñado para eliminar caracteres no numéricos antes de [? coaccionando. ?] Así que nosotros podría haber escrito todo de esta manera.

test_2 <- parse_number(murders_raw$population)

identical(test_1,test_2)

#Entonces podemos obtener nuestra tabla deseada usando el siguiente código.

murders_new <- murders_raw %>% mutate_at(2:3, parse_number)

head(murders_new)

#Aquí vamos a usar parse_number ().
#Observe lo que sucede Este caso es relativamente simple en comparación con los desafíos de procesamiento de cadenas que normalmente enfrentamos en la ciencia de datos.

#Ejercicios


dat <- bind_cols(Month = c("January", "February",  "March", "April", "May" ) , Sales = c("$128,568", "$109,523","$115,468",	"$122,274",	"$117,921"), Profit = c("$16,234","$12,876","$17,920","$15,825","$15,437"))


head(dat)

dat %>% mutate_at(2:3, parse_number)

#dat %>% mutate_at(2:3, as.numeric) #error

dat %>% mutate_all(parse_number)

dat %>% mutate_at(2:3, funs(str_replace_all(., c("\\$|,"), ""))) %>% 
  mutate_at(2:3, as.numeric)
