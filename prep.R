library(tidyverse)
library(readxl)
library(fs)

# Using dir_create, I created the two folders to contain the raw-data and the clean-data

dir_create("raw-data")
dir_create("clean-data")

# I used download.file to download the important data into the raw-data folder.

download.file("http://oracleselixir.com/gamedata/2016-spring/",
              mode = "wb",
              destfile = "raw-data/worlds-2016.xlsx")

download.file("http://oracleselixir.com/gamedata/2017-complete/",
              mode = "wb",
              destfile = "raw-data/worlds-2017.xlsx")

download.file("http://oracleselixir.com/gamedata/2018-worlds/",
              mode = "wb",
              destfile = "raw-data/worlds-2018.xlsx")

download.file("http://oracleselixir.com/gamedata/2019-worlds/",
              mode = "wb",
              destfile = "raw-data/worlds-2019.xlsx")

# I read the csv file into worlds for easier use and cleaned it for only the important cols.

worlds_2016 <- read_xlsx("raw-data/worlds-2016.xlsx") %>%
  filter(split == "2016-W") %>% 
  filter(week != "1.1000000000000001" & week != "1.2" & week != "1.3" & week != "1.4" & week != "1.5" & week != "1.6") %>%
  select(-gameid, -url, -league, -split, -date)

worlds_2017 <- read_xlsx("raw-data/worlds-2017.xlsx") %>%
  filter(split == "2017-W") %>%
  filter(week != "1.1000000000000001" & week != "1.2" & week != "1.3" & week != "1.4" & week != "1.5" & week != "1.6") %>%
  select(-gameid, -url, -league, -split, -date)

worlds_2018 <- read_xlsx("raw-data/worlds-2018.xlsx") %>%
  filter(week != "PI-RR" & week != "PI-KO" & week != "PI") %>%
  select(-gameid, -url, -league, -split, -date)

worlds_2019 <- read_xlsx("raw-data/worlds-2019.xlsx") %>%
  filter(week != "PI-RR" & week != "PI-KO" & week != "PI") %>%
  select(-gameid, -url, -league, -split, -date)

# I wrote worlds into the clean-data as a csv file.

write_csv(worlds_2016, "clean-data/worlds-2016.csv")
write_csv(worlds_2017, "clean-data/worlds-2017.csv")
write_csv(worlds_2018, "clean-data/worlds-2018.csv")
write_csv(worlds_2019, "clean-data/worlds-2019.csv")

# I then read it as a csv, in order to be saved as an rds file.

worlds_2016 <- read_csv("clean-data/worlds-2016.csv",
                        col_types = cols(
                          .default = col_double(),
                          week = col_character(),
                          side = col_character(),
                          position = col_character(),
                          player = col_character(),
                          team = col_character(),
                          champion = col_character(),
                          ban1 = col_character(),
                          ban2 = col_character(),
                          ban3 = col_character(),
                          doubles = col_logical(),
                          triples = col_logical(),
                          quadras = col_logical(),
                          pentas = col_logical()
                        ))

worlds_2017 <- read_csv("clean-data/worlds-2017.csv",
                        col_types = cols(
                          .default = col_double(),
                          week = col_character(),
                          side = col_character(),
                          position = col_character(),
                          player = col_character(),
                          team = col_character(),
                          champion = col_character(),
                          ban1 = col_character(),
                          ban2 = col_character(),
                          ban3 = col_character(),
                          doubles = col_logical(),
                          triples = col_logical(),
                          quadras = col_logical(),
                          pentas = col_logical()
                        ))

worlds_2018 <- read_csv("clean-data/worlds-2018.csv",
                        col_types = cols(
                          .default = col_double(),
                          week = col_character(),
                          side = col_character(),
                          position = col_character(),
                          player = col_character(),
                          team = col_character(),
                          champion = col_character(),
                          ban1 = col_character(),
                          ban2 = col_character(),
                          ban3 = col_character(),
                          ban4 = col_character(),
                          ban5 = col_character()
                        ))

worlds_2019 <- read_csv("clean-data/worlds-2019.csv",
                        col_types = cols(
                          .default = col_double(),
                          week = col_character(),
                          side = col_character(),
                          position = col_character(),
                          player = col_character(),
                          team = col_character(),
                          champion = col_character(),
                          ban1 = col_character(),
                          ban2 = col_character(),
                          ban3 = col_character(),
                          ban4 = col_character(),
                          ban5 = col_character()
                        ))

# I then saved these as rds files in the cleaned dataset.

saveRDS(worlds_2016, "clean-data/worlds_2016.rds")
saveRDS(worlds_2017, "clean-data/worlds_2017.rds")
saveRDS(worlds_2018, "clean-data/worlds_2018.rds")
saveRDS(worlds_2019, "clean-data/worlds_2019.rds")

# To remove the unneeded raw data, I used file_delete to delete those files.

file_delete("raw-data/worlds-2016.xlsx")
file_delete("raw-data/worlds-2017.xlsx")
file_delete("raw-data/worlds-2018.xlsx")
file_delete("raw-data/worlds-2019.xlsx")
