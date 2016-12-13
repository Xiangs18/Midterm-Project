library(shiny)

# Load back the data
ShinyData <- readRDS("ShinyData.RDS")

shinyUI(

# Use a fluid Bootstrap layout
fluidPage(    
  
  # Give the page a title
  titlePanel("Sentiment Counts by Region"),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("region", "Region:", 
                  choices=colnames(ShinyData)),
      hr(),
      helpText("Data from Twitter API.")
    ),
    
    # Create a spot for the barplot
    mainPanel(
      plotOutput("sentimentPlot")  
    )
    
  )
)
)
