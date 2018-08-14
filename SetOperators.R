#Operadores 

library(tidyverse)
library(dslabs)

#Comencemos con intersect(). Puedes tomar la intersección de vectores numéricos
#por ejemplo, como este o vectores de caracteres.

intersect(1:10, 6:15)

intersect(c("a","b","c"), c("b","c","d"))


#Pero con dplyr cargado, también podemos hacer esto para las tablas.
#Tomará la intersección de las filas para las tablas que tienen los mismos nombres #de columna.

data("murders")
data("polls_us_election_2016")

tab <- left_join(murders, results_us_election_2016, by = "state")

tab1 <- tab[1:5,]
tab2 <- tab[3:7,]

intersect(tab1, tab2)

#Union

#Del mismo modo, la unión toma la unión. 
#Si lo aplicas a vectores, obtienes la unión así.
#Pero con dplyr cargado, también podemos hacer esto para las tablas que tienen los mismos nombres de la columna

union(1:10, 6:15)
union(c("a","b","c"), c("b","c","d"))

#ahora con dplyr cargado

tab1 <- tab[1:5,]
tab2 <- tab[3:7,]

union(tab1, tab2)


#También podemos tomar las diferencias establecidas usando la función setdiff.
#A diferencia de intersect y union, esta función no es simétrica.
#Por ejemplo, 

setdiff(1:10, 6:15)

#tenga en cuenta que obtiene dos respuestas diferentes si cambias los argumentos

setdiff(6:15, 1:10)


#Y de nuevo, con dplyr cargado, podemos aplicar esto a los marcos de datos.
#Mira lo que sucede cuando tomamos el archivo tab1 y tab2.

tab1 <- tab[1:5,]
tab2 <- tab[3:7,]

setdiff(tab1,tab2)

setdiff(tab2, tab1)


#Finalmente, la función setequal nos dice si dos conjuntos
#son lo mismo independientemente del orden.
#Entonces, por ejemplo, si configuro los valores de uno a cinco y de uno a seis,
#es falso, porque no son los mismos vectores.

setequal(1:6, 1:5)

#FALSO

setequal(5:1, 1:5)

#Verdadero

#Cuando se aplica a marcos de datos que no son iguales, independientemente del orden, proporciona un mensaje útil que nos permite saber cómo los conjuntos son diferentes.

tab1 <- tab[1:5,]
tab2 <- tab[3:7,]

setequal(tab1, tab2)

#FALSE: Rows in x but not y: 2, 1. Rows in y but not x: 4, 5. 

#ejercicio

df1 <- bind_cols(x = c("a","b"),y = c("a", "a"))
df2 <- bind_cols(x = c("a","a"),y = c("a", "b"))

union(df1, df2)
setdiff(df1,df2)
setdiff(df2, df1)
intersect(df1,df2)
