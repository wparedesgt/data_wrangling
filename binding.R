#Uniendo o fundiendo

#La función dplyr bind_cols une dos objetos colocando las columnas de cada uno juntos en una tabla

bind_cols(a = 1:3, b= 4:6)


#Tenga en cuenta que hay una función basada en r, cbind, que realiza la misma #función pero crea objetos que no sean tibbles, ya sean matrices o marcos de datos,
#algo más.

#Bind_cols también puede enlazar marcos de datos.

data("murders")
data("polls_us_election_2016")

tab <- left_join(murders, results_us_election_2016, by = "state")


tab1 <- tab[,1:3]
tab2 <- tab[, 4:6]
tab3 <- tab[, 7:9]

new_tab <- bind_cols(tab1, tab2, tab3)

head(new_tab)


#Bind_rows es similar, pero enlaza filas en lugar de columnas.
#Mostraremos un ejemplo simple donde tomamos los primeros dos
#filas, y la tercera y cuarta filas, y luego unirlas para obtener las filas 1
#a través de 4.
#Este se basa en una función basada en r llamada rbind.

tab1 <- tab[1:2,]
tab2 <- tab[3:4,]

head(tab1)
head(tab2)

bind_rows(tab1, tab2)
