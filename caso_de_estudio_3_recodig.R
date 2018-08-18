#Recoding

library(dslabs)
library(tidyverse)
library(rvest)


# Otra operación común que involucra strings es recodificar los nombres de variables categóricas.

#Por ejemplo, si tiene un nombre realmente largo para sus niveles, y los mostrarás en plots, es posible que desee utilizar versiones más cortas de los nombres.

#Por ejemplo, en un vector de caracteres con nombres de países, es posible que desee cambiar a los Estados Unidos de América a USA y el Reino Unido al UK, y así sucesivamente.

#Podemos hacer esto usando case_when().

#Pero el tidyverse ofrece opciones que están específicamente diseñadas para esta tarea, la función recode().

#Aquí hay un ejemplo que muestra cómo cambiar el nombre de países con nombres largos.

#Vamos a usar el conjunto de datos de Gapminer.

data("gapminder")

#Supongamos que queremos mostrar la serie de tiempo de esperanza de vida para los países del Caribe.

#Así que aquí hay un código que hará ese plot.

gapminder %>% 
  filter(region == "Caribbean") %>% 
  ggplot(aes(year, life_expectancy,color = country)) +
  geom_line()




#Esta es la trama que queremos, pero gran parte del espacio se desperdicia para acomodar algunos de los nombres de países largos.

#Aquí están algunos de los más largos.

gapminder %>% 
  filter(region == "Caribbean") %>% 
  filter(str_length(country) >= 12) %>%
  distinct(country)


#Por ejemplo, San Vicente y las Granadinas.

#Tenemos cuatro países con nombres de más de 12 caracteres.

#Estos nombres aparecen una vez por año en el conjunto de datos de Gapminer.

#Y una vez que elegimos apodos, tenemos que cambiarlos todos consistentemente.

#Las funciones de recodificación se pueden usar para hacer esto.

#Aquí hay un ejemplo de cómo lo hacemos.

gapminder %>%
  filter(region == "Caribbean") %>% 
  mutate(country = recode(country, 
                          'Antigua and Barbuda' = 'Barbuda', 
                          'Dominican Republic' = "DR", 
                          'St. Vincent and the Grenadines' = 'St. Vincent', 
                          'Trinidad and Tobago' = "Trinidad")) %>%
  ggplot(aes(year, life_expectancy,color = country)) + 
  geom_line()
  
  

#Observe que la función de recodificación está cambiando todos estos nombres a una versión más corta, y lo hará a lo largo de todo el conjunto de datos, en lugar de uno por uno.

#Una vez que hacemos esto, obtenemos una trama mejor.

#Tenga en cuenta que hay otras funciones similares en el tidyverse.

#Por ejemplo, recode_factorUI y fct_recoder.

#Estos están en la función forcats en el paquete tidyverse.


#Con los datos de gapminder, desea recodificar las abreviaturas de países de más de 12 letras en la región "África central" en una nueva columna, "country_short". ¿Qué código lograría esto?

dat <- gapminder %>% filter(region == "Middle Africa") %>% 
  mutate(country_short = recode(country, 
                                "Central African Republic" = "CAR", 
                                "Congo, Dem. Rep." = "DRC",
                                "Equatorial Guinea" = "Eq. Guinea"))
dat
