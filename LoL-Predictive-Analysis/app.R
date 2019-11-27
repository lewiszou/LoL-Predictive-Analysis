library(shinythemes)
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("flatly"),
                
    navbarPage("League of Legends",
               
               tabPanel("About"),
               tabPanel("Dataset"),
               tabPanel("2018 Worlds: Intro"),
               tabPanel("2018 Worlds: Deep Dive"),
               tabPanel("Analysis Applied"),
               tabPanel("Conclusion")
               
               )
)

server <- function(input, output) {
}
    

# Run the application 
shinyApp(ui = ui, server = server)
