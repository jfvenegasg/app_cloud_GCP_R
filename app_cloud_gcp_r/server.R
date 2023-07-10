#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
# Define server logic required to draw a histogram
function(input, output, session) {
  project_id <- "apps-392022"
  
  sql<-"SELECT * from `bigquery-public-data.austin_bikeshare.bikeshare_trips` LIMIT 100"
  
  respuesta <- reactiveValues(data=NULL)
  
  observeEvent(input$boton_descarga, {
    consulta <- bigrquery::bq_project_query(project_id, sql)
    respuesta$datos <-bigrquery::bq_table_download(consulta,n_max = 100)
    write.csv(x =respuesta$datos,file = "trips_austin.csv",row.names = FALSE)
  })
  
  observeEvent(input$boton_carga, {
    respuesta$datos<-read.csv(file = "trips_austin.csv")
  })
  
  output$datos_bigquery<-renderDataTable(
    datatable(respuesta$datos,escape=FALSE,
              options=list(
                pageLength =5,
                 columnDefs = list(list(targets = 9, width = '200px')),
                   scrollX = TRUE)))
  
  #Aca se genera el grafico,de acuerdo a los datos extraidos en la consulta SQL.
  #El grafico muestra en el eje x el tipo de suscriptor y en el eje y la duracion en minutos de los viajes
  output$grafico_bigquery<-renderEcharts4r({
    if(is.null(respuesta$datos)==TRUE){
      
    }else{
      datos_graficos <- respuesta$datos %>%
        group_by(trip_id) %>%
        summarise(duration_minutes = sum(duration_minutes))
      
      datos_graficos |>
        echarts4r::e_chart(trip_id) |>
        echarts4r::e_bar(duration_minutes) |>
        echarts4r::e_theme("walden")   |>
        echarts4r::e_tooltip()
    }
    
  })
}
