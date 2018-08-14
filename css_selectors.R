#Selectores de CSS

#El aspecto predeterminado de la página web hecha con el HTML más básico es bastante poco atractivo. Las páginas estéticamente agradables que vemos hoy están hechas usando CSS. CSS se usa para agregar estilo a las páginas web. El hecho de que todas las páginas de una empresa tengan el mismo estilo suele ser el resultado de que todas usan el mismo archivo CSS. La forma general en que funcionan estos archivos CSS es definiendo cómo se verá cada uno de los elementos de una página web. El título, los títulos, las listas detalladas, las tablas y los enlaces, por ejemplo, reciben su propio estilo, incluidos la fuente, el color, el tamaño y la distancia desde el margen, entre otros.

#Para hacer esto, CSS aprovecha los patrones utilizados para definir estos elementos, a los que se hace referencia como selectores. Un ejemplo de patrón que usamos en un video anterior es la tabla, pero hay muchos muchos más. Si queremos obtener datos de una página web y conocemos un selector que es exclusivo de la parte de la página, podemos usar la función html_nodes.

#Sin embargo, saber qué selector utilizar puede ser bastante complicado. Para demostrar esto trataremos de extraer el nombre de la receta, el tiempo total de preparación y la lista de ingredientes de esta receta de guacamole. Al observar el código de esta página, parece que la tarea es increíblemente compleja. Sin embargo, los gadgets de selector realmente lo hacen posible. SelectorGadget es una pieza de software que le permite determinar interactivamente qué selector de CSS necesita para extraer componentes específicos de la página web. Si planea raspar datos que no sean tablas, le recomendamos encarecidamente que lo instale. Hay una extensión de Chrome disponible que le permite encender el gadget resaltando partes de la página mientras hace clic, mostrando el selector necesario para extraer esos segmentos.

#Para la página de recetas de guacamole ya lo hemos hecho y hemos determinado que necesitamos los siguientes selectores:

library(tidyverse)
library(rvest)
library(httr)

h <- read_html("http://www.foodnetwork.com/recipes/alton-brown/guacamole-recipe-1940609")

recipe <- h %>% html_node(".o-AssetTitle__a-HeadlineText") %>% html_text(trim = TRUE)

prep_time <- h %>% html_node(".o-RecipeInfo__a-Description--Total") %>% 
html_text(trim = TRUE) %>% trimws()

ingredients <- h %>% html_nodes(".o-Ingredients__a-ListItemText") %>% html_text(trim = TRUE) %>% strsplit(split = "\n") %>% sapply(trimws)


#Puedes ver qué tan complejos son los selectores. En cualquier caso, ahora estamos listos para extraer lo que queremos y crear una lista:
  
guacamole <- list (recipe, prep_time, ingredients)
guacamole

#Dado que las páginas de recetas de este sitio web siguen este diseño general, podemos usar este código para crear una función que extraiga esta información:
  
get_recipe <- function (url) {
    h <- read_html (url)
    recipe <- h%>% html_node (". o-AssetTitle__a-HeadlineText")%>% html_text ()
    prep_time <- h%>% html_node (". o-RecipeInfo__a-Description - Total")%>% html_text ()
    ingredients <- h%>% html_nodes (". o-Ingredients__a-ListItemText")%>% html_text ()
    return (list (receta = receta, prep_time = prep_time, ingredients = ingredients))
  }

#y luego úselo en cualquiera de sus páginas web:
  
  get_recipe ("http://www.foodnetwork.com/recipes/food-network-kitchen/pancakes-recipe-1913844")


#Hay otras herramientas poderosas proporcionadas por rvest. Por ejemplo, las funciones html_form, set_values y submit_form le permiten consultar una página web desde R. Este es un tema más avanzado que no se trata aquí.
  
  
  