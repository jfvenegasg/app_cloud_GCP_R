#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(htmlwidgets)
library(dplyr)
library(DT)
library(echarts4r)
#library(utils)
library(bs4Dash)
#library(reactable)
#library(MASS)
#library(config)
#library(htmltools)
#library(lubridate)
#library(shinyWidgets)
#library(shinycssloaders)
#library(reticulate)
library(shiny.i18n)
library(bigrquery)
library(echarts4r)
source("traductor.R")

bigrquery::bq_auth(path ="apps-392022-8c353b675061.json")

ui <-  dashboardPage(
  
  dashboardHeader(title = i18n$t("App_cloud_gcp_r")),
  dashboardSidebar(side = "top", visible = FALSE, status = "teal",
                   sidebarMenu(
                     id = "sidebar",
                     menuItem(i18n$t("Inicio"),tabName = "menu1",
                              icon=icon("laptop-medical"),
                              selected = TRUE),
                     
                     bs4Dash::menuItem(i18n$t("Analisis de datos Bigquery"),tabName="menu2",
                                       icon=icon("check-square")),
                     selectInput(inputId = "idioma", label = "Elige idioma", choices = c("Spanish" = "es","English" = "en"))
                     )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "menu1",
              
              fluidRow(width=12,imageOutput("myImage")),
              fluidRow(width=12,
                       bs4Dash::infoBox(width = 12,title = shiny::h3(i18n$t("Analisis de datos Bigquery"), style = 'font-size:30px'),subtitle=i18n$t("Este es un modulo para analisis de datos del servicio Bigquery"), 
                                        icon=shiny::icon("arrow-pointer"), tabName = "menu2",color = "lightblue",fill=FALSE, iconElevation = 2,elevation = 2)),
              
      ), 

      tabItem(tabName = "menu2",
              fluidRow(actionButton(inputId = "boton",label =  "Descarga")),
              fluidRow(width=12,box(dataTableOutput("datos_bigquery",width = "100%"),
                                   width = 6,status = "lightblue",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2),
                               box(title = i18n$t("Datos de set de datos 1"),echarts4rOutput("grafico_bigquery",width = "100%"),
                                   width = 6,status = "lightblue",headerBorder = FALSE,collapsible = FALSE,closable = FALSE,elevation = 2))
                                
              )
    )
    
  ))

