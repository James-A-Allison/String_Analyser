#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(rhandsontable)
library(GrpString)
library(tidyverse)

inital_string <- readRDS("string.RDS")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    values <- reactiveValues()
    values$string <- inital_string
    
    output$string_input <- renderRHandsontable({
        data <- tibble(`Column names` = c(values$string, ""))
        rhandsontable(data, height = 500)
    })
    
    observeEvent(input$button,{
        # output <- list()
        # browser()
        values$string <- hot_to_r(input$string_input) %>%
            pull
        
        # output$data <- data
        # output$plot <- plot(data)
        # return(output)
    }#, ignoreNULL = FALSE
    )
    
    clusters <- reactive({
        output <- list()
        # browser()
        # if(is.null(new_strings()$data)) {
        #     strings_in <- strings
        # } else {
            # strings_in <- new_strings()$data
        # }
        data <- values$string %>%
            StrHclust(., input$clusters) %>%
            rename(Question = Cluster,
                   `Column names` = Strings) %>%
            select(`Column names`, Question) %>%
            mutate(Question = as.factor(Question))
        output$data <- data
        return(output)
    })
    
    output$strings_modeled <- renderRHandsontable({
        data <- clusters()$data
        rhandsontable(data, height = 500)
    })
    
    output$result <- renderRHandsontable({
        
    })

    output$plot_h <- renderPlot({
        # new_data()$plot
        d <- utils::adist(values$string)
        c <- stats::hclust(stats::as.dist(d))
        graphics::plot(c)
    })
    
    output$plot_k <- renderPlot({
        # new_data()$plot
        d <- utils::adist(values$string)
        c <- stats::kmeans(d, centers = input$clusters, nstart = 1)
        cluster::clusplot(d, c$cluster, color = TRUE, shade = FALSE, 
                          labels = 2, lines = 0, main = "Cluster plot")
    })

})
