library(shinythemes)
library(tidyverse)

worlds_18 <- readRDS("clean-data/worlds_2018.rds")
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

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("flatly"),
                
    navbarPage("League of Legends",
               
               tabPanel("About",
                        h1("League of Legends — a global phenomenon"),
                        br(),
                        img(src="map.jpg", 
                            style="display: block; margin-left: auto; margin-right: auto;", 
                            height = "475px"),
                        h5("Map of a classic League of Legends game", align = "center"),
                        HTML(readLines('About.html'))
                        ),
               
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

               tabPanel("2018 Worlds: Deep Dive",
                        HTML(readLines('worlds_dive.html'))
               ),
               
               tabPanel("Analysis Applied",
                        HTML(readLines('applied.html')),
                        
                        ### Prediction Model ###
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
                        
                        
                        
                        ### Important Indicators as a Result of Gold ###
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
    worlds_18[sample(nrow(worlds_18), input$sampleSize),]
  })
  output$interactive_intro <- renderPlot({
    p <- ggplot(dataset(), aes_string(x=input$x, y=input$y)) + geom_point()
    if (input$color != 'None')
      p <- p + aes_string(color=input$color)
    if (input$jitter)
      p <- p + geom_jitter()
    if (input$smooth)
      p <- p + geom_smooth(method = "lm")
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
