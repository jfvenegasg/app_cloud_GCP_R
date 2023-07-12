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
  
  #### Modulo analisis de datos Austin Trips ####
  
  respuesta_at <- reactiveValues(data=NULL)
  
  observeEvent(input$boton_descarga_at, {
    project_id <- "apps-392022"
    sql<-"SELECT * from `bigquery-public-data.austin_bikeshare.bikeshare_trips`"
    consulta <- bigrquery::bq_project_query(project_id, sql)
    respuesta_at$datos <-bigrquery::bq_table_download(consulta)
    write.csv(x =respuesta_at$datos,file = "trips_austin.csv",row.names = FALSE)
  })
  
  observeEvent(input$boton_carga_at, {
    respuesta_at$datos<-read.csv(file = "trips_austin.csv")
  })
  
  output$datos_bigquery_at<-renderDataTable(
    datatable(respuesta_at$datos,escape=FALSE,
              options=list(
                pageLength =5,
                 columnDefs = list(list(targets = 9, width = '200px')),
                   scrollX = TRUE))
    )
  
  #Aca se genera el grafico,de acuerdo a los datos extraidos en la consulta SQL.
  #El grafico muestra en el eje x el tipo de suscriptor y en el eje y la duracion en minutos de los viajes
  output$grafico_bigquery_at<-renderEcharts4r({
    if(is.null(respuesta_at$datos)==TRUE){
      
    }else{
      datos_graficos <- respuesta_at$datos %>%
        group_by(trip_id) %>%
        summarise(duration_minutes = sum(duration_minutes)) %>%
        arrange(desc(duration_minutes))
      
      datos_graficos |>
        echarts4r::e_chart(trip_id) |>
        echarts4r::e_bar(duration_minutes) |>
        echarts4r::e_theme("walden")   |>
        echarts4r::e_tooltip()
    }
  })
  
  #### Modulo analisis de datos Austin Crimes ####
  
  respuesta_ac <- reactiveValues(data=NULL)
  
  observeEvent(input$boton_descarga_ac, {
    project_id <- "apps-392022"
    sql<-"SELECT address,description,latitude,longitude,timestamp,year FROM `bigquery-public-data.austin_crime.crime`"
    consulta <- bigrquery::bq_project_query(project_id, sql)
    respuesta_ac$datos <-bigrquery::bq_table_download(consulta)
    write.csv(x =respuesta_ac$datos,file = "crime_austin.csv",row.names = FALSE)
  })
  
  observeEvent(input$boton_carga_ac, {
    respuesta_ac$datos<-read.csv(file = "crime_austin.csv")
  })
  
  output$datos_bigquery_ac<-renderDataTable(
    datatable(respuesta_ac$datos,escape=FALSE,
              options=list(
                pageLength =5,
                columnDefs = list(list(targets = 6, width = '200px')),
                scrollX = TRUE))
  )
  
  #Aca se genera el grafico,de acuerdo a los datos extraidos en la consulta SQL.
  #El grafico muestra en el eje x el tipo de suscriptor y en el eje y la duracion en minutos de los viajes
  output$grafico_bigquery_ac<-renderEcharts4r({
    if(is.null(respuesta_ac$datos)==TRUE){

    }else{
      datos_graficos <- respuesta_ac$datos %>%
        group_by(description) %>%
        summarise(total = n()) %>%
        arrange(desc(total))

      datos_graficos |>
        echarts4r::e_chart(description) |>
        echarts4r::e_bar(total) |>
        echarts4r::e_theme("walden")   |>
        echarts4r::e_tooltip()
    }
  })
  
  #### Modulo analisis de datos Austin Waste ####
  
  respuesta_aw <- reactiveValues(data=NULL)
  
  observeEvent(input$boton_descarga_aw, {
    project_id <- "apps-392022"
    sql<-"SELECT load_id,load_type,load_weight FROM `bigquery-public-data.austin_waste.waste_and_diversion`"
    consulta <- bigrquery::bq_project_query(project_id, sql)
    respuesta_aw$datos <-bigrquery::bq_table_download(consulta)
    write.csv(x =respuesta_aw$datos,file = "waste_austin.csv",row.names = FALSE)
  })
  
  observeEvent(input$boton_carga_aw, {
    respuesta_aw$datos<-read.csv(file = "waste_austin.csv")
  })
  
  output$datos_bigquery_aw<-renderDataTable(
    datatable(respuesta_aw$datos,escape=FALSE,
              options=list(
                pageLength =5,
                columnDefs = list(list(targets = 3, width = '200px')),
                scrollX = TRUE))
  )
  
  #Aca se genera el grafico,de acuerdo a los datos extraidos en la consulta SQL.
  #El grafico muestra en el eje x el tipo de suscriptor y en el eje y la duracion en minutos de los viajes
  output$grafico_bigquery_aw<-renderEcharts4r({
    if(is.null(respuesta_aw$datos)==TRUE){
      
    }else{
      datos_graficos <- respuesta_aw$datos %>%
        group_by(load_type) %>%
        summarise(total = sum(load_id)) %>%
        arrange(desc(total))
      
      datos_graficos |>
        echarts4r::e_chart(load_type) |>
        echarts4r::e_bar(total) |>
        echarts4r::e_theme("walden")   |>
        echarts4r::e_tooltip()
    }
  })
}
