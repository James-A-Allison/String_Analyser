#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(rhandsontable)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Survey Column Name Analysis"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(width = 2,
            sliderInput("clusters",
                        "Number of questions:",
                        min = 1,
                        max = 100,
                        value = 30),
            actionButton("button",
                         label = "Run with new names")
        ),

        # Show a plot of the generated distribution
        mainPanel(
         column(width = 4, rHandsontableOutput("string_input")),
         column(width = 4, rHandsontableOutput("strings_modeled")),
         column(width = 4, rHandsontableOutput("result")),
         column(width = 6, plotOutput("plot_h")),
         column(width = 6, plotOutput("plot_k"))
        )
    )
))
