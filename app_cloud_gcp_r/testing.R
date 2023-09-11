project_id <- "apps-392022"
sql<-"SELECT load_id,load_type,load_weight FROM `bigquery-public-data.austin_waste.waste_and_diversion`"
consulta <- bigrquery::bq_project_query(project_id, sql)
respuesta_aw <-bigrquery::bq_table_download(consulta)
write.csv(x =respuesta_aw$datos,file = "waste_austin.csv",row.names = FALSE)


datos_graficos <- respuesta_aw %>%
  group_by(load_type) %>%
  summarise(total = sum(load_id)) %>%
  arrange(desc(total))

datos_graficos |>
  echarts4r::e_chart(load_type) |>
  echarts4r::e_bar(total) |>
  echarts4r::e_theme("walden")   |>
  echarts4r::e_tooltip()

respuesta_at<-read.csv(file = "app_cloud_gcp_r/trips_austin.csv")

datos_graficos<-respuesta_at %>% group_by(trip_id)  %>%
  summarise(duration_minutes = sum(duration_minutes)) %>%
  arrange(desc(duration_minutes))

porcentajes <- datos_graficos %>%
  summarise(percentage = (duration_minutes / sum(duration_minutes)) * 100)

datos<-cbind(datos_graficos,porcentajes)

