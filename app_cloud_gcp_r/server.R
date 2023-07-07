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
  
  sql<-"SELECT subscriber_type,bikeid,start_time,start_station_name,end_station_name,duration_minutes from `bigquery-public-data.austin_bikeshare.bikeshare_trips` LIMIT 100"
  
  respuesta <- reactiveValues(data=NULL)
  
  observeEvent(input$boton, {
    consulta <- bigrquery::bq_project_query(project_id, sql)
    respuesta$datos <-bigrquery::bq_table_download(consulta,n_max = 100)
  })

  
  output$datos_bigquery<-renderDataTable({
    datatable(respuesta$datos)
    },options=list(pageLength =10))
  
  #Aca se genera el grafico,de acuerdo a los datos extraidos en la consulta SQL.
  #El grafico muestra en el eje x el tipo de suscriptor y en el eje y la duracion en minutos de los viajes
  output$grafico_bigquery<-renderEcharts4r({
    if(is.null(respuesta$datos)==TRUE){
      
    }else{
      datos_graficos <- respuesta$datos %>%
        group_by(subscriber_type) %>%
        summarise(duration_minutes = sum(duration_minutes))
      
      datos_graficos |>
        echarts4r::e_chart(subscriber_type) |>
        echarts4r::e_bar(duration_minutes) |>
        echarts4r::e_theme("walden")   |>
        echarts4r::e_tooltip()
    }
    
  })
}
