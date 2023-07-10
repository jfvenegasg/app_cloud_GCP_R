project_id <- "apps-392022"

sql<-"SELECT * from `bigquery-public-data.austin_bikeshare.bikeshare_trips` LIMIT 100"

consulta <- bigrquery::bq_project_query(project_id, sql)
respuesta <-bigrquery::bq_table_download(consulta,n_max = 100)
write.csv(x =respuesta$datos,file = "trips_austin.csv",row.names = FALSE)

datos_graficos <- respuesta %>%
  group_by(trip_id) %>%
  summarise(duration_minutes = sum(duration_minutes))

datos_graficos |>
  echarts4r::e_chart(trip_id) |>
  echarts4r::e_bar(duration_minutes) |>
  echarts4r::e_theme("walden")   |>
  echarts4r::e_tooltip()