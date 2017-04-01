#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
require(shiny)
library(shiny)



data <- read.csv("Precios_de_Combustibles.csv", stringsAsFactors = FALSE)

data$fecharegistro <- as.Date(data$fecharegistro,"%m/%d/%Y")
data$periodo <- as.Date(data$periodo,"%m/%d/%Y")

data.summerised <- ddply(data,c("NombreDepartamento","producto","periodo"), summarise, mean=mean(precio))


shinyServer(function(input, output) {
   
  output$fuelPlot <- renderPlot({
    if (is.null(input$select_departamento))
      return()
    
    
    if (input$Choose==1){
      data.filtered <- data.summerised[data.summerised$NombreDepartamento==input$select_departamento,]
      
      ggplot(data.filtered,aes(x=periodo, y=mean))+geom_line()+facet_wrap(~producto)+(scale_x_date(labels=date_format("%m %Y")))+stat_smooth(method="lm", col="red")+ylim(min(data.filtered$mean)*0.99,max(data.filtered$mean)*1.01)    
      
    }else{
      data.filtered <- data.summerised[data.summerised$producto==input$select_producto,]

      ratio.values <- (max(data.filtered$periodo)-min(data.filtered$periodo)) /(max(data.filtered$mean)- min(data.filtered$mean))
      ggplot(data.filtered,aes(x=periodo, y=mean))+geom_line()+facet_wrap(~NombreDepartamento)+(scale_x_date(labels=date_format("%m %Y")))+stat_smooth(method="lm", col="red")+ylim(min(data.filtered$mean)*0.99,max(data.filtered$mean)*1.01)
      
      
    }
    
  },
  
  width="auto", height = "auto")
  
})
