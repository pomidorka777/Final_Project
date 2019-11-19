datasets_url_champ <- 'https://api.football-data.org/v2/competitions/2000/matches'
token <- "b2dbe56c7a2c44d7a44abc8b72c177c4"
response_champ <- GET(datasets_url_champ, add_headers("X-Auth-Token" = token))

datasets_champ <- content(response_champ, as = 'text')
datasets_champ <- fromJSON(datasets_champ)

matches <- datasets_champ$matches

empty_list <- list()
for (x in 1:length(matches)) {
  if (matches[[x]]$stage == "GROUP_STAGE") {empty_list <- c(empty_list, matches[[x]])}
}

