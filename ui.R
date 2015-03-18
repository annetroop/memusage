library(shiny)
shinyUI(fluidPage(
  sidebarLayout(
   sidebarPanel(
   h4("Make selections then hit submit to see data on memory usage for our servers"),
     checkboxGroupInput('id2', "Display data for:",       
         c("machine1" = "1", "machine2" = "2", "machine3" = "3", "machine4" = "4"),
         selected = c(1)
              ),
     checkboxInput('flip',"Graph side by side"),
     dateInput("begin", "Begin date:", value = "2015-01-01", min = "2015-01-01", max = "2015-03-15"),
     dateInput("end", "End date:"),
     submitButton('Submit')
        ),
   mainPanel(
    plotOutput("distPlot")
   )
  )
))