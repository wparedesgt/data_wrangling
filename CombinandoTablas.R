#Combinando tablas
#left_joint()
library(tidyverse)
library(dslabs)
library(ggrepel)

data("murders")
data("polls_us_election_2016")

identical(murders$state, results_us_election_2016$state)

tab <- left_join(murders, results_us_election_2016, by = "state")

head(tab)

tab %>% ggplot(aes(population/10^6, electoral_votes, label = abb)) +
  geom_point() +  
  geom_text_repel() +
  scale_x_continuous(trans = "log2") +
  scale_y_continuous(trans = "log2") +
  geom_smooth(method = "lm", se = FALSE)

tab1 <- slice(murders, 1:6) %>% select(state, population)  
tab2 <- slice(results_us_election_2016, c(1:3, 5, 7:8)) %>% 
  select(state, electoral_votes)
  



left_join(tab1, tab2)

#NA a la izquierda
tab1 %>% left_join(tab2)

#NA a la derecha

tab1 %>% right_join(tab2)

#Sin NA, unicamente los datos que esten completos en ambas columnas

inner_join(tab1, tab2)

#manteniendo todos los NA de ambas columnas

full_join(tab1, tab2)

#La función de semi_join nos permite mantener la parte de la primera tabla para la cual tener información en el segundo. No agrega las columnas del segundo.

semi_join(tab1, tab2)

#esta funcion hace lo opuesto de semi_join Mantiene los elementos de la primera tabla para los cuales hay no hay información en el segundo

anti_join(tab1, tab2)

#Ejercicios

#No1. 

dim(tab1)
dim(tab2)

dat <- left_join(tab1, tab2, by = "state")

dim(dat)


#N0.2

dat <- right_join(tab1, tab2, by = "state")

dim(dat)

dat <- full_join(tab1, tab2, by = "state")

dim(dat)

dat <- inner_join(tab1, tab2, by = "state")

dim(dat)

dat <- semi_join(tab1, tab2, by = "state")

dim(dat)
