library(shinythemes)
library(shiny)

worlds_18 <- readRDS("clean-data/worlds_2018.rds")
definitions <- readRDS("clean-data/definitions.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("flatly"),
                
    navbarPage("League of Legends",
               
               tabPanel("About",
                        HTML(readLines('About.html'))),
               
               tabPanel("Dataset",
                        sidebarLayout(
                          sidebarPanel(
                            selectInput("select", label = h3("Select word"), 
                                        choices = definitions)
                          ),
                          mainPanel(
                            br(),
                            h3("Definition"),
                            fluidRow(column(10, textOutput("select"))),
                          )
                        ),
                        

                        
                        
                        
                        
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
                                        DT::dataTableOutput("table"), style = "overflow-x: scroll;")),),
               
               tabPanel("2018 Worlds: Intro"),
               
               tabPanel("2018 Worlds: Deep Dive"),
               
               tabPanel("Analysis Applied"),
               
               tabPanel("Conclusion")

               
               )
)

server <- function(input, output) {

    
  # About Section
  
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
  
  # Dataset
  
  output$select <- renderText({input$select})
  
}

# Run the application 
shinyApp(ui = ui, server = server)
