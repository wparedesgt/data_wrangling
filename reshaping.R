#Reshaping Data
library(tidyverse)
library(dslabs)

#gather() funcion para convertir data en tidy data

data("gapminder")
tidy_data <- gapminder %>% filter(country %in% c("South Korea", "Germany")) %>% 
  select(country, year, fertility)

path <- system.file("extdata", package = "dslabs")
filename <- file.path(path, "fertility-two-countries-example.csv")
wide_data <- read_csv(filename)

new_tidy_data <- wide_data %>% gather(year, fertilily, '1960':'2015')

new_tidy_data <- wide_data %>% gather(year, fertilily, -country)

class(tidy_data$year)
class(new_tidy_data$year)


new_tidy_data <- wide_data %>% gather(year, fertilily, -country, convert = TRUE)

class(tidy_data$year)
class(new_tidy_data$year)

new_tidy_data %>% ggplot(aes(year, fertilily, color = country)) + geom_point()

#spread() funcion es la inversa que gather()

new_wide_data <- new_tidy_data %>% spread(year, fertilily)
select(new_wide_data,country, '1960':'1967')

#Ejercicios

d <- read_csv("data/times.csv")

data("us_contagious_diseases")

datos <- us_contagious_diseases

dat_wide <- datos %>% spread(disease,state, fill= NA, drop = TRUE)



