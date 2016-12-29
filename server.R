library(rsconnect)
rsconnect::setAccountInfo(name='saoussen',
                          token='5A6482FE7918F12078AC86081D1F078C',
                          secret='<SECRET>')
deployApp()
library(shiny)
require(vegan)
library(maps)
library(wordcloud)
library(tm)
library(mapdata)
library(sp)
library(maptools)
library(ggfortify)
library(maps)
library(mapproj)
library(DT)
library(googleVis)
library(classInt)
library(shapefiles)
library(ggplot2)
library(rgeos)
library(plotrix)
library(NbClust)
library(FactoMineR)
library(devtools)
library(ggplot2)
library(factoextra)
library(knitr)
library(car)
library(rgl)
require(RWeka)
require(SnowballC)
library(factoextra)
library(NbClust)
library(rgdal)
library(mclust)

shinyServer(function(input, output) {
  
  output$about=renderText({
    
    "Our application is a web platform for a visualization and a study of a countryâs demographic data also for analyse a text or a political discourse.
    The advantage of this platform is to provide a tool for manipulating demographic data and to perform statistical processing in a simple and efficient manner without programming requirements.
    In the first place, the application allows to import and visualize the database, also to explore it with 'bar chart' and 'pie chart'.
    Secondly, it makes it possible to classify the governorates according to their demographic characteristics.  Then, we can visualize the data on the country map.  
    Finally, we can analyse a text."
    
  })
  
  output$Box <- renderValueBox({
    require(vegan)
    fit <- cascadeKM(scale(data()[,c(-1,-2)], center = TRUE,  scale = TRUE), 1, 10, iter = 1000)
    calinski.best <- as.numeric(which.max(fit$results[2,]))
    valueBox(calinski.best, "Optimal number of clusters", icon = icon("list"),
             color = "purple"
    )
  })
  
  output$clusters=renderUI({
    numericInput("select","Select number of clusters", 
                 value = 1)
  }) 
  
  
  output$pays=renderUI({
    D=data()[,c(-1,-2)]
    selectInput("var", "",choices=names(D))
  })
  output$pays1=renderUI({
    D=data()[,c(-1,-2)]
    selectInput("var1", "",choices=names(D))
    
    
  })
  
  output$pays2=renderUI({
    D=data()[,c(-1,-2)]
    selectInput("var2", "",choices=names(D))
  })
  
  output$pays3=renderUI({
    D=data()[,c(-1,-2)]
    selectInput("var3", "",choices=names(D))
  })
  
  output$pays4=renderUI({
    D=data()[,c(-1,-2)]
    selectInput("var4", "",choices=names(D))
  })
  
  
  output$distPlot = renderPlot({
    myshape <- input$shp_file 
    if (is.null(myshape)){
      return(NULL)}
    dir<-dirname(myshape[1,4])
    
    for ( i in 1:nrow(myshape)) {
      file.rename(myshape[i,4], paste0(dir,"/",myshape[i,1]))}
    
    getshp <- list.files(dir, pattern="*.shp", full.names=TRUE)
    shape<-readShapePoly(getshp)
    test<-match(shape$ID_1,data()$ID_1)
    plotvar <- data()[[input$var]]
    shape@data <- data.frame(shape@data, data()[test,])
    shape@data$var <- shape@data[[input$var]]
    var <- as.vector(na.omit(shape@data$var))
    nclr <- 5
    plotclr <- brewer.pal(nclr,"YlOrRd")
    class <- classIntervals(var, nclr, style="quantile")$brks
    colcode <- plotclr[(findInterval(shape$var, class, all.inside = TRUE))]
    par(bg = "lightblue")
    plot(shape,col=colcode)
    legend(x = "topright", legend = leglabs(round(class, 2)),fill =  plotclr, bty = "n", pt.cex = 1.2, cex = 0.9)
    
  })
  
  data <- reactive({
    inFile <- input$csv_file1 
    if (is.null(inFile)){
      return(NULL)}
    data <- read.csv(inFile$datapath, header = input$header1, sep = input$sep1, dec=input$dec )
    
    data
    
  })
  data1 <- reactive({
    inFile1 <- input$txt_file 
    if (is.null(inFile1)){
      return(NULL)}
    data1 <- readLines(inFile1$datapath) 
    
    data1
    
  })
  
  
  output$Import= DT::renderDataTable({
    data()
    
    
  }, options = list(scrollX = TRUE))
  
 
  output$nbrClust=renderPlot({
    set.seed(1234)
    M<-scale(data()[,c(-1,-2)])
    fviz_nbclust(M, kmeans, method =  "silhouette")
  })
  
  
  output$class=renderPlot({
    M<-scale(data()[,c(-1,-2)])
    km.res <- kmeans(M, input$select, nstart = 25)
    fviz_cluster(km.res,data=M)
    
  })
  
  
  output$text1=renderPlot({
    txt <- removePunctuation(data1())
    txt <- removeNumbers(txt)
    txt <- txt[-which(txt=="")]
    for(i in 1:length(txt)) txt[i]=tolower(txt[i])
    txt <- removeWords(txt,stopwords("fr"))
    txt <- removeWords(txt,c("the","and","percent","that","the","has","have","the","this","are"))
    corpus1 <- Corpus(VectorSource(txt))
    tdm1 <- TermDocumentMatrix(corpus1, control=list(stemming=TRUE))
    freq.terms1 <- findFreqTerms(tdm1, lowfreq = 6)
    term.freq1 <- rowSums(as.matrix(tdm1))
    term.freq1 <- subset(term.freq1, term.freq1 >= 6)
    df1 <- data.frame(term = names(term.freq1), freq = term.freq1)
    ggplot(df1, aes(x=term, y=freq)) + geom_bar(stat="identity")+ xlab("Terms") + ylab("Count") + coord_flip()+theme(axis.text=element_text(size=7))
  })
  
  output$text=renderPlot({
    txt <- removePunctuation(data1())
    txt <- removeNumbers(txt)
    txt <- txt[-which(txt=="")]
    for(i in 1:length(txt)) txt[i]=tolower(txt[i])
    txt <- removeWords(txt,stopwords("fr"))
    txt <- removeWords(txt,c("the","and","percent","that","the","has","have","the","this","are"))
    corpus <- Corpus(VectorSource(txt))
    tdm <- TermDocumentMatrix(corpus,control = list(minWordLength=3))
    m <- as.matrix(tdm)
    freqWords=rowSums(m)
    v=sort(freqWords,d=T)
    dt=data.frame(word=names(v),freq=v)
    
    pal2 <- brewer.pal(8,"Dark2")
    
    wordcloud(dt$word,dt$freq,min.freq = 3,stack=T,random.order = F,colors=pal2)
  })
  
  
  output$Plot <- renderGvis({
    suppressPackageStartupMessages(library(googleVis))
    df1=data.frame(data())
    Bar <- gvisBarChart(df1,xvar="Gouvernorat",yvar=c(input$var1,input$var2,input$var3),options=list(width=700, height=700,bar="{groupWidth:'100%'}"))
    
    return(Bar)
  })
  output$Plot1 <- renderPlot({
    library(RColorBrewer)
    attach(data())
    darkcols <- display.brewer.all()
    
    pie=pie3D(data()[[input$var4]],radius=1,height=0.1,theta=pi/6,start=1,labels=Gouvernorat,border=par("fg"),labelcol=par("fg"),labelcex=1.1, sector.order=NULL,explode=0.2,shade=0.8,mar=c(4,4,4,4))
    
  })
})
