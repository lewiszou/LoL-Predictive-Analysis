library(shinythemes)
library(tidyverse)

# Cleaned worlds_18 for the datatable, didn't in prep due to excessiveness from the four years.

worlds_18 <- readRDS("clean-data/worlds_2018.rds") %>%
  mutate(gamelength = round(gamelength, digits = 3)) %>%
  mutate(fbtime = round(fbtime, digits = 3)) %>%
  mutate(kpm = round(kpm, digits = 3)) %>%
  mutate(okpm = round(okpm, digits = 3)) %>%
  mutate(ckpm = round(ckpm, digits = 3)) %>%
  mutate(fdtime = round(fdtime, digits = 3)) %>%
  mutate(fttime = round(fttime, digits = 3)) %>%
  mutate(fbarontime = round(fbarontime, digits = 3)) %>%
  mutate(dmgtochampsperminute = round(dmgtochampsperminute, digits = 3)) %>%
  mutate(dmgshare = round(dmgshare, digits = 3)) %>%
  mutate(earnedgoldshare = round(earnedgoldshare, digits = 3)) %>%
  mutate(wpm = round(wpm, digits = 3)) %>% 
  mutate(wardshare = round(wardshare, digits = 3)) %>%
  mutate(wcpm = round(wcpm, digits = 3)) %>%
  mutate(visiblewardclearrate = round(visiblewardclearrate, digits = 3)) %>%
  mutate(invisiblewardclearrate = round(invisiblewardclearrate, digits = 3)) %>%
  mutate(earnedgpm = round(earnedgpm, digits = 3)) %>%
  mutate(gspd = round(gspd, digits = 3)) %>%
  mutate(cspm = round(cspm, digits = 3))
definitions <- readRDS("clean-data/definitions.rds")

# Adjusting the Dataset for the interactive graphs in the Intro page

dataset <- worlds_18 %>% 
  filter(position == "Team") %>%
  select(totalgold, team, position, teamkills, teamdragkills, teamtowerkills, teamtowerkills)
x_dataset <- worlds_18 %>%
  filter(position == "Team") %>%
  select(totalgold, goldat10, goldat15)
y_dataset <- dataset %>%
  select(teamkills, teamdragkills, teamtowerkills, teamtowerkills)
position_dataset <- dataset %>%
  select(position)

# Non-team data for the impact gold graphs

non_team <- worlds_18 %>%
  filter(position != "Team")

# Define UI for application that draws a histogram

ui <- fluidPage(theme = shinytheme("flatly"),
                
    # Creating the navbar page for League of Legends
    
    navbarPage("League of Legends",
               
               # About page — giving an introduction to the LoL and my project
               # I essentially made the title and League map, then included the html.
               # The About.Rmd contains the important information and graphs.
               
               tabPanel("About",
                        h1("League of Legends — a global phenomenon"),
                        br(),
                        img(src="map.jpg", 
                            style="display: block; margin-left: auto; margin-right: auto;", 
                            height = "475px"),
                        h5("Map of a classic League of Legends game", align = "center"),
                        HTML(readLines('About.html'))
                        ),
               
               # Dataset page — I first set up the definitions table.
               # I created a selection tab that then displays the definition in the main panel.
               # I included the actual dataset, with 3 options to select and order the data.
               # I included the data output, with a scroll to fix the extended slider past the width.
               
               tabPanel("Dataset",
                        sidebarLayout(
                          sidebarPanel(
                            selectInput("select", 
                                        label = h3("Select Column Name"), 
                                        choices = definitions)),
                          mainPanel(
                            br(),
                            h3("Definition"),
                            fluidRow(column(10, textOutput("select"))),)),
                        
                        tabPanel("Explore the Data",
                                 column(4,
                                        selectInput("team",
                                                    "Team:",
                                                    c("All",
                                                      unique(worlds_18$team)))),
                                 column(4,
                                        selectInput("result",
                                                    "Result:",
                                                    c("All",
                                                      unique(worlds_18$result)))),
                                 column(4,
                                        selectInput("position",
                                                    "Position:",
                                                    c("All",
                                                      unique(worlds_18$position)))),
                                 
                                 # Create a new row for the table.
                                 
                                 column(width = 12,
                                        DT::dataTableOutput("table"), style = "overflow-x: scroll;"))
               ),
               
               # 2018 Worlds Intro page — I gave an introduction to the 2018 Worlds.
               # I added the worlds_intro.html, who includes all the important graphs.
               # I then added a extended grapher with multiple inputs.
               # It has different dataset columns that allow the user to see how gold is affected.
               
               tabPanel("2018 Worlds: Intro",
                        h1("Introduction to the 2018 World Championships"),
                        br(),
                        img(src="worlds_2018.jpg", 
                            style="display: block; margin-left: auto; margin-right: auto;", 
                            height = "475px"),
                        h5("2018 World Championships Finals", align = "center"),
                        HTML(readLines('worlds_intro.html')),
                        
                        # Dataset Table for Interaction
                        
                        fluidRow(
                          column(3,
                                 h4("Gold Explorer"),
                                 sliderInput('sampleSize', 'Sample Size',
                                             min=1, max=nrow(dataset),
                                             value=min(1000, nrow(dataset)),
                                             step=10, round=0)),
                          column(4, offset = 1,
                                 selectInput('x', 'X', names(x_dataset)),
                                 selectInput('y', 'Y', names(y_dataset), names(y_dataset)[[2]])),
                          column(4,
                                 selectInput('color', 'Color', c('None', names(dataset))),
                                 checkboxInput('jitter', 'Jitter'),
                                 checkboxInput('smooth', 'Smooth'))),
                          plotOutput('interactive_intro')
               ),

               # 2018 Worlds Deep Dive page — I included the important graphs in the worlds_dive.html.
               
               tabPanel("2018 Worlds: Deep Dive",
                        HTML(readLines('worlds_dive.html'))
               ),
               
               # Analysis Applied page — I included the initial applied.html graphs.
               # I added my prediction models, using tableOutput, and included sliders.
               # The sliders gave the year options with an animation to show the change over the years.
               # I then included other important graphs that demonstrate indicators as a result of gold.
               
               tabPanel("Analysis Applied",
                        HTML(readLines('applied.html')),
                        
                        # Prediction Model
                        
                        h2("Predicting the Results of Games"),
                        h4("Gold Difference at 10 and 15 minutes (left) and Dragons and Barons (right)"),
                        sidebarLayout(
                          sidebarPanel(
                            sliderInput(inputId = "model", 
                                        label = "Year:",
                                        min = 16, max = 19,
                                        value = 16, step = 1,
                                        animate = animationOptions(interval = 2000, loop = TRUE)),
                            h6("Accuracy of the models side by side")),
                          mainPanel(
                            tableOutput("predict_table"))),
                        
                        # Important Indicators as a Result of Gold
                        
                        h2("Important Indicators as a Result of Gold"),
                        sidebarLayout(
                          sidebarPanel(
                            sliderInput(inputId = "year", 
                                        label = "Year:",
                                        min = 16, max = 19,
                                        value = 16, step = 1,
                                        animate = animationOptions(interval = 1200, loop = TRUE)),
                            h6("Select through 2016-2019, or animate to see the change."),
                            selectInput(
                              inputId = "type",
                              label = "Choose a stat:",
                              choices = c("Wins",
                                          "Dragons",
                                          "Barons",
                                          "Wards")),
                            h6("Select to get graphs on team wins, dragons kills, barons kills, and wards placed.")),
                          mainPanel(
                            plotOutput("plotfour")))
               ),
               
               # Conclusion page — I added the conclusion.html which holds the important ideas.
               
               tabPanel("Conclusion",
                        HTML(readLines('conclusion.html')))
               )
)

server <- function(input, output) {
    
  # Dataset Page — Datatable
  
  output$table <- DT::renderDataTable(DT::datatable({
    data <- worlds_18
    if (input$team != "All") {
      data <- data[data$team == input$team,]
    }
    if (input$result != "All") {
      data <- data[data$result == input$result,]
    }
    if (input$position != "All") {
      data <- data[data$position == input$position,]
    }
    data
    }))
  
  # Dataset Page — Definitions
  
  output$select <- renderText({input$select})
  
  # Intro Page — Graphing
  
  dataset <- reactive({
    non_team[sample(nrow(non_team), input$sampleSize),]
  })
  output$interactive_intro <- renderPlot({
    p <- ggplot(dataset(), aes_string(x=input$x, y=input$y)) + geom_point()
    if (input$color != 'None')
      p <- p + aes_string(color=input$color)
    if (input$jitter)
      p <- p + geom_jitter()
    if (input$smooth)
      p <- p + geom_smooth(method = "lm", se = FALSE)
    print(p)
  })
  
  # Analysis Applied — Prediction Models
  
  predict_model <- reactive({
    if ( 16 %in% input$model) return(c(readRDS(file = "graphics/model_gg_16.rds"), readRDS(file = "graphics/model_db_16.rds")))
    if ( 17 %in% input$model) return(c(readRDS(file = "graphics/model_gg_17.rds"), readRDS(file = "graphics/model_db_17.rds")))
    if ( 18 %in% input$model) return(c(readRDS(file = "graphics/model_gg_18.rds"), readRDS(file = "graphics/model_db_18.rds")))
    if ( 19 %in% input$model) return(c(readRDS(file = "graphics/model_gg_19.rds"), readRDS(file = "graphics/model_db_19.rds")))
  })
  output$predict_table <- renderTable({   
    barplots = predict_model()
    barplots
  })
  
  # Analysis Applied — Transition Graphs
  
  graphf <- reactive({
    if ( 16 %in% input$year & "Wins" %in% input$type) return(readRDS(file = "graphics/wins_tg_2016.rds"))
    if ( 17 %in% input$year & "Wins" %in% input$type) return(readRDS(file = "graphics/wins_tg_2017.rds"))
    if ( 18 %in% input$year & "Wins" %in% input$type) return(readRDS(file = "graphics/wins_tg_2018.rds"))
    if ( 19 %in% input$year & "Wins" %in% input$type) return(readRDS(file = "graphics/wins_tg_2019.rds"))
    if ( 16 %in% input$year & "Dragons" %in% input$type) return(readRDS(file = "graphics/dragons_tg_2016.rds"))
    if ( 17 %in% input$year & "Dragons" %in% input$type) return(readRDS(file = "graphics/dragons_tg_2017.rds"))
    if ( 18 %in% input$year & "Dragons" %in% input$type) return(readRDS(file = "graphics/dragons_tg_2018.rds"))
    if ( 19 %in% input$year & "Dragons" %in% input$type) return(readRDS(file = "graphics/dragons_tg_2019.rds"))
    if ( 16 %in% input$year & "Barons" %in% input$type) return(readRDS(file = "graphics/barons_tg_2016.rds"))
    if ( 17 %in% input$year & "Barons" %in% input$type) return(readRDS(file = "graphics/barons_tg_2017.rds"))
    if ( 18 %in% input$year & "Barons" %in% input$type) return(readRDS(file = "graphics/barons_tg_2018.rds"))
    if ( 19 %in% input$year & "Barons" %in% input$type) return(readRDS(file = "graphics/barons_tg_2019.rds"))
    if ( 16 %in% input$year & "Wards" %in% input$type) return(readRDS(file = "graphics/wards_tg_2016.rds"))
    if ( 17 %in% input$year & "Wards" %in% input$type) return(readRDS(file = "graphics/wards_tg_2017.rds"))
    if ( 18 %in% input$year & "Wards" %in% input$type) return(readRDS(file = "graphics/wards_tg_2018.rds"))
    if ( 19 %in% input$year & "Wards" %in% input$type) return(readRDS(file = "graphics/wards_tg_2019.rds"))
  })
  output$plotfour <- renderPlot({   
    barplots = graphf()
    print(barplots)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
