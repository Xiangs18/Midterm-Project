library(shiny)

ShinyData <- readRDS("ShinyData.RDS")

# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  # Fill in the spot we created for a plot
  output$sentimentPlot <- renderPlot({
    
    # Render a barplot
    barplot(ShinyData[,input$region], 
            main=input$region,
            ylab="Number of Counts",
            xlab="Sentiment")
  })
})

