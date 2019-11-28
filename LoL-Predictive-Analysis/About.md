---
title: "About"
author: "Lewis Zou"
date: "11/27/2019"
runtime: shiny
output: html_document
---

# League of Legends — A Global Phenomenon

<!--html_preserve--><img src="www/map.jpg" style="display: block; margin-left: auto; margin-right: auto;" height="475px"/><!--/html_preserve--><!--html_preserve--><h6 align="center">Map of a classic League of Legends game</h6><!--/html_preserve-->

League of Legends (LoL) is a multiplayer online battle arena that allows users to fight in either teams of 3 or 5. Each player, or "summoner", controls a champion with unique abilities and item builds, and sets out to destroy the enemy soul point, the "Nexus". LoL games are discrete — the progress a player makes in one game does not translate to the next.

League became the most played PC game in Europe and North America in 2012 (by hour). Riot Games, the LoL developer, estimates that over 100 million users play the game each month. With its immense community, League has grown its entertainment and competitive segments. They maintain strong viewership in streaming and video services like Youtube and Twitch.tv, often ranking first in the number of hours watched. This popularity has developed its competitive scene — competitions exist in the United States, Europe, China, South Korea, and more. These seasonal long regional competitions culminate in a playoffs, in which top teams can move on to the annual world championships.

## League of Legends World Championship

The League of Legends World Championships brings 16 teams from various regions to compete for the "Summoner's Cup". In a format similar to that of traditional sports, teams are seeded and drawn into groups. The 2018 finals were watched by nearly 100 million people, a staggering number that reflects the popularity and impact of LoL. Given its worldwide influence, LA2024, the group that oversees Los Angeles' bid for the summer 2024 Olympic Games, would highly consider including eSports and LoL's virtual reality and entertainment in the games.

I chose the 2018 championships because that was the year my favorite team, SK Telecom of South Korea, failed to make the tournament. As three-time winners of the entire competition (2014, 2016, 2017), I was shocked and disappointed. However, I wanted to better understand the new environment. I wanted to take a deeper look at the statistics that mattered in that specific year. Notably, SK Telecom, although making worlds, placed as a semifinalist. 2018 marks a turning point — I aimed to determine a way to predict the results of games with high accuracy.

## Predictive analytics in sports and eSports.

Sports and eSports generate thousands of data points. Every intricate detail and gain during the progress of a game can be translated into numbers and has led to greater fan involvement. Given the advancements in technology and Big Data, teams are acquiring data quicker and more often. However, its understanding the data and using it to improve teams that remains most difficult.

Sports and eSports teams are bringing in data scientists to help them anaylze which parts of their game are weak. They look at which plays or moves lead to the greatest results, which methods lead to the highest winrate, and present these findings to improve their players understanding and performance in-game. These findings are helping teams scout new players to fit their playstyle, maintain physical and mental health, and much more.

The most important and relevant use-case, however, is to use the data gathered to predict the outcome of the game. ESPN and other analytic companies are attempting to quantify the percentage chance for each team to win. Similarly, eSport fans and teams aim to predict a team's ability to win based on in-game and historical performance.

# This Data

The 2018 World Championships dataset only contains about 1,500 rows. Although this may seem low, this set includes datapoints about every game that occured in the championships. Greater detail about collection and times were not available — this dataset presents the necessary indicators (gold, dragons, barons, etc.) that help predict the result of games.

Notably, I could not use data from Ranked or Normal games (non-tournament). Furthermore, I could not use data from non-Worlds tournament games. The annual World Championship is the most prestigious competition in the game, and teams often bootcamp for weeks in preparation. Using any other data would skew the models, as the difference in dedication, focus, and performance would be clear. Furthermore, Worlds is the only time teams from across the globe compete. Data in all other tournaments would depend heavily on the play style and level of competition in their respective region.

## My use of the data

In this project, I used data on the LoL World Championships. I took data from four years, coming from here:

[2016 Worlds](http://oracleselixir.com/gamedata/2016-complete/)
<br>
[2017 Worlds](http://oracleselixir.com/gamedata/2019-worlds/)
<br>
[2018 Worlds](http://oracleselixir.com/gamedata/2018-worlds/)
<br>
[2019 Worlds](http://oracleselixir.com/gamedata/2017-complete/)
<br>

This data is extensive — it includes datapoints about nearly every part of the game. Starting from the left-most column, the data presents the game id, url, and general time statistics — these columns I will remove in the future, but will keep for now for label purposes. After those, we get into playerid, side, position, player, and team. These points will help keep track of each player and their historical performance, and will be a critical factor in connecting each player with their impact on the potential to win. Diving deeper, we get champions and bans — the draft can often determine the result of a game, and I will use this as part of my calculations.

The data then gets deeper into the actual games that are played. We get game length, kills, deaths, assists, and more. The data includes objective and monster kills, things that help champions progress through the game. Often, there is a high correlation between objective control, gold generation, time, and performance — we will use these datapoints to see if we can in hindsight predict the outcome of the game. The data is extremely comprehensive and includes sections that are not typically relevant to the outcome of the game. Although they are not classically important to the outcome of the game, they can definitely have an impact on a player's ability to move across the map, defend their towers, and generate gold, which can in turn impact the outcome of the game.

I use the results from the 2018 data on the 2016, 2017, and 2019 LoL World Championships to see if there is a correlation and a way to predict the results of games. I aim to use these results on the 2020 World Championships next year.

## About me

My name is Lewis Zou and I am a sophomore and Statistics concentrator at Harvard College. This was the final project for my Gov 1005: Data course. 

#### Source Code
Link to my github: https://github.com/lewiszou/LoL-Predictive-Analysis