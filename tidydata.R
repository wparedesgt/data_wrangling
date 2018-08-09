#Tidy data
library(tidyverse)
library(dslabs)

data("gapminder")
tidy_data <- gapminder %>% filter(country %in% c("South Korea", "Germany")) %>% 
  select(country, year, fertility)

#Realizando el Plot

tidy_data %>% ggplot(aes(year, fertility, color = country)) + geom_point()

ggsave("plots/corea_alemania.png")


#obteniendo el csv

path <- system.file("extdata", package = "dslabs")
filename <- file.path(path, "fertility-two-countries-example.csv")
wide_data <- read_csv(filename)


#creando un plot

head(tidy_data)

head(wide_data)
