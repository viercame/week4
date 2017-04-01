#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
require(shiny)
library(shiny)
library(plyr)
library(ggplot2)
library(scales)


data <- read.csv("Precios_de_Combustibles.csv", stringsAsFactors = FALSE)

data$fecharegistro <- as.Date(data$fecharegistro,"%m/%d/%Y")
data$periodo <- as.Date(data$periodo,"%m/%d/%Y")

data.summerised <- ddply(data,c("NombreDepartamento","producto","periodo"), summarise, mean=mean(precio))

data.departamentos <- sort(unique(data.summerised$NombreDepartamento),decreasing = FALSE)
data.productos <- sort(unique(data.summerised$producto),decreasing = FALSE)


# Define UI for application 
shinyUI(fluidPage(
  tags$style(type="text/css", "html, body {width:100%;height:100%}"),
  # Application title
  titlePanel("Colombia fuel prices 2016 - 2017"),
  
  fluidRow(
    
    column(2, wellPanel(
      radioButtons ("Choose", label = h4("Filter"), choices=list("State"=1, "Fuel"=2), selected=1)
      
    )),
    
    
    column(3, wellPanel(
    
    conditionalPanel(
      condition = "input.Choose==1",

               selectInput("select_departamento", label= h4("Select State:"), choices = data.departamentos)
      
    ),

    conditionalPanel(
      condition= "input.Choose==2",
      selectInput("select_producto", label= h4("Select fuel:"), choices = data.productos)
      
      
    )
    
      )),
    
    
    column(6, wellPanel(
      
      includeHTML("include.html")
      
    ))
      
  ),
  

    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("fuelPlot")
    )
  )
)
