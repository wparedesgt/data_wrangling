#separate and Unite
library(tidyverse)
library(dslabs)

path <- system.file("extdata", package = "dslabs")
filename <- file.path(path, "life-expectancy-and-fertility-two-countries-example.csv")
raw_dat <- read_csv(filename)
select(raw_dat, 1:5)

dat <- raw_dat %>% gather(key, value, -country)

head(dat)

dat$key[1:5]

#funcion separate()
#Argumentos
# 1 el nombre de la columna a separar
# 2 los nombres usados para las nuevas columnas
# 3 El caracter que separa las variables

#codigo

dat %>% separate(key, c("year", "variable_name"), "_")

#como quitar el error de llenado de columnas

dat %>% separate(key, c("year", "first_variable_name", "second_variable_name"), 
                 fill = "right")

#Separador extra y spread() 

dat %>% separate(key, c("year", "variable_name"), sep = "_", extra = "merge") %>% 
  spread(variable_name, value)


#separando 

dat %>% separate(key, c("year", "first_variable_name", "second_variable_name"), 
                 fill = "right")

#este codigo llena dos columnas en una

dat %>% separate(key, c("year", "first_variable_name", "second_variable_name"), 
                 fill = "right") %>% unite(variable_name, first_variable_name, 
                                           second_variable_name, sep = "_")

#separacion de columnas

dat %>% separate(key, c("year", "first_variable_name", "second_variable_name"), 
                 fill = "right") %>% unite(variable_name, first_variable_name, 
                                           second_variable_name, sep = "_") %>%
  spread(variable_name, value) %>% rename(fertility = fertility_NA)
  
##Ejercicios

d <- read_csv("data/times.csv")

#tidy_data <- d %>% 
#gather(key = "key", value = "value", -age_group) %>% 
#separate(col= key, into = c("year", "variable_name"), sep = ".") %>% 
#spread(key= variable_name, value = value)  

tidy_data <- d %>% 
  gather(key = "key", value = "value", -age_group) %>% 
  separate(col= key, into = c("year", "variable_name"), sep = "_") %>% 
  spread(key= variable_name, value = value)  

#tidy_data <- d %>% 
#  gather(key = "key", value = "value") %>% 
#  separate(col= key, into = c("year", "variable_name"), sep = "_") %>% 
#  spread(key= variable_name, value = value)  

#tidy_data <- d %>% 
#  gather(key = "key", value = "value", -age_group) %>% 
#  separate(col= key, into = "year", sep = "_") %>% 
#  spread(key= year, value = value)  

#No.2

stats <- read_csv("data/stats.csv")

#tidy_data <- stats %>% 
#  separate(col = key, into = c("player", variable_name), sep = "_", extra = "merge") %>%
#  spread(key = variable_name, value = value)

tidy_data <- stats %>% 
  separate(col = key, into = c("player", "variable_name1", "variable_name2"), sep = "_", fill = "right") %>% 
  unite(col = variable_name, variable_name1, variable_name2, sep = "_") %>%
    spread(key = variable_name, value = value)

head(tidy_data)

tidy_data <- stats %>% 
  separate(col = key, into = c("player", "variable_name"), sep = "_") %>% 
  spread(key = variable_name, value = value)
head(tidy_data)
