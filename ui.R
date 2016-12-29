
library(shiny)
library(shinydashboard)


shinyUI(dashboardPage(skin = "green",
                      
                      dashboardHeader(title="My country",dropdownMenuOutput("messageMenu")),
                      dashboardSidebar(
                        
                        
                        
                        sidebarMenu(
                          id= "tabs" ,
                          
                          
                          menuItem("About",tabName = "acc",icon=icon("exclamation-circle") ),
                          
                          menuItem("Import dataset",tabName = "Import",icon=icon("database")),
                          
                          
                          menuItem("Data explore",tabName = "chart" ,icon=icon("area-chart "),
                                   menuSubItem("bar chart",tabName = "bar",icon=icon("bar-chart")),
                                   menuSubItem("pie chart",tabName = "pie",icon=icon("pie-chart"))),
                          
                          
                          
                          
                          
                          menuItem("Classification",tabName = "Classification",icon=icon("tasks")),
                          
                          
                          menuItem("Mapping",tabName = "menu",icon=icon("map")),
                          menuItem("Text mining",tabName = "Text",icon=icon("file-text-o"))
                          
                        )),
                      
                      
                      
                      
                      dashboardBody(
                        
                        tabItems(
                          
                          
                          tabItem(tabName = "acc",h1("Welcome to our application ! "),textOutput("about")),
                          
                          tabItem(tabName = "Import",
                                  
                                  fluidRow(
                                    box(
                                      width = 3, status = "primary",solidHeader = TRUE,
                                      title = "Download manager",
                                      helpText(tags$b("Please uplaod .csv")),
                                      tags$hr(),
                                      fileInput('csv_file1', 'Choose file to upload',
                                                accept = c(
                                                  'text/csv',
                                                  'text/comma-separated-values',
                                                  'text/tab-separated-values',
                                                  'text/plain',
                                                  '.csv',
                                                  '.tsv'
                                                )
                                      ),
                                      tags$hr(),
                                      checkboxInput('header1', 'Header', TRUE),
                                      radioButtons('sep1', 'Separator',
                                                   c(
                                                     Semicolon=';',
                                                     Comma=',',
                                                     Tab='\t'),
                                                   ';'),
                                      radioButtons('dec', 'Decimal',
                                                   c(comma=',',
                                                     
                                                     Tab='\t'),
                                                   ',')
                                      
                                      
                                      
                                      
                                    ),
                                    box(width = 9,status = "primary",solidHeader = TRUE,
                                        title = "Data",
                                        DT::dataTableOutput("Import")
                                    ))
                          ),
                          tabItem("Classification",
                                  fluidRow(
                                    
                                    box(status = "primary",solidHeader = TRUE,uiOutput("clusters")),
                                    valueBoxOutput("Box",width=6),
                                    box(status = "primary",solidHeader = TRUE,title = "Classification",plotOutput("class")),
                                    box(status = "primary",solidHeader = TRUE,title = "Optimal Number of clusters",plotOutput("nbrClust"))
                                    
                                  )),
                          
                          
                          
                          tabItem("bar" ,
                                  fluidRow(
                                    
                                    box(status = "primary",solidHeader = TRUE,
                                        width = 3,
                                        helpText(tags$b("Please choose a variable")),
                                        tags$hr(),
                                        uiOutput("pays1"),
                                        uiOutput("pays2"),
                                        uiOutput("pays3")
                                    ),
                                    box(status = "primary",solidHeader = TRUE,title = "Bar chart",
                                        width=8,
                                        htmlOutput("Plot")))),
                          tabItem("pie" ,
                                  fluidRow(
                                    
                                    box(status = "primary",solidHeader = TRUE,
                                        width = 5,
                                        helpText(tags$b("Please choose a variable")),
                                        tags$hr(),
                                        uiOutput("pays4")
                                    ),
                                    box(status = "primary",solidHeader = TRUE,title = "Pie chart",
                                        plotOutput("Plot1")))),
                          
                          
                          
                          tabItem("Text" ,
                                  fluidRow(
                                    box(
                                      width = 7, status = "primary",solidHeader = TRUE,
                                      title = "Download manager",
                                      helpText(tags$b("Please uplaod .txt")),
                                      tags$hr(),
                                      fileInput('txt_file', 'Choose file to upload',
                                                accept = 
                                                  'text/txt')),
                                    box(status = "primary",solidHeader = TRUE,title = "wordcloud",
                                        plotOutput("text")),
                                    box(status = "primary",solidHeader = TRUE,title = "word occurence's",
                                        plotOutput("text1")))),
                          tabItem("menu" ,
                                  fluidRow(
                                    box(status = "primary",solidHeader = TRUE,
                                        width = 3,
                                        title = "Download manager",
                                        helpText(tags$b("Please uplaod .shp")),
                                        tags$hr(),
                                        fileInput('shp_file', 'Choose file to upload',accept=c('.shp','.dbf','.sbn','.sbx','.shx','.prj'), multiple=TRUE),
                                        tags$hr(),
                                        helpText(tags$b("Please choose a variable")),
                                        tags$hr(),
                                        uiOutput("pays")
                                    ),
                                    box(status = "primary",width=9, solidHeader = TRUE,title = "Mapping ",
                                        plotOutput("distPlot"))))
                          
                        )
                      )
)
)



