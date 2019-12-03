library(httr)
library(jsonlite)
library(dplyr)
library(tidyr)
library(ggplot2)

datasets_url_champ <- 'https://api.football-data.org/v2/competitions/2000/matches'
token <- "b2dbe56c7a2c44d7a44abc8b72c177c4"
response_champ <- GET(datasets_url_champ, add_headers("X-Auth-Token" = token))

datasets_champ <- content(response_champ, as = 'text')
datasets_champ <- fromJSON(datasets_champ)

matches <- datasets_champ$matches

data <- data.frame(stage = matches$stage, group = matches$group, 
                   scoreHT1 = matches$score$halfTime$homeTeam,
                   scoreHT2 = matches$score$halfTime$awayTeam,
                   scoreFT1 = matches$score$fullTime$homeTeam,
                   scoreFT2 = matches$score$fullTime$awayTeam)

data2 <- data.frame(mutate(data, goalsHT = scoreHT1 + scoreHT2, goalsFT = scoreFT1 + scoreFT2))
preclean_data <- filter(data2, stage == 'GROUP_STAGE')
clean_data <- preclean_data[c('group','goalsHT','goalsFT')] %>% 
  group_by(group) %>% summarise(half = sum(goalsHT), full = sum(goalsFT))
the_cleanest_data <- gather(clean_data, 'time', 'goals', 2:3)

axes <- ggplot(
  data=the_cleanest_data,
  mapping=aes(x=group, y=goals, group=time, fill=time))

axes + geom_bar(stat = 'identity') + labs(title = "Total number of goals scored in each group in FIFA 2018 World Cup group stage")

