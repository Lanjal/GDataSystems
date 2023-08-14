 #   This program is free software; you can redistribute it and/or modify  
 #   it under the terms of the is licensed under the BSD 3-Clause "New" or
 #   "Revised" License.
library(shiny)
library(rgdal)
library(leaflet)
library(leaflet.extras)
library(rpostgis)
library(DT)

#-----------------------------------------------------------------------------------------------------
#--------------------------------------------UI-------------------------------------------------------
#-----------------------------------------------------------------------------------------------------
ui <- navbarPage("GDataSystems (BETA 0.1)",
  tabPanel("Map",
		sidebarLayout(
			sidebarPanel(
				img(src = 'https://amazeone.com.br/img/oGDSicon.png', height = '50px', width = '50px'),
				tags$h4("Project Map")
			,width=2),
			mainPanel(
				tags$h3("A GOOD PROJECT"),
				leafletOutput(outputId = "map", height=800)
			)
		)
 ),
 navbarMenu("Soil",
   	tabPanel("Soil Tables",
		sidebarPanel(
			img(src = 'https://amazeone.com.br/img/oGDSicon.png', height = '50px', width = '50px'),
			tags$h5("Soil Tables")
		,width=2),
		mainPanel(
			tags$h3("Soil Data"),
			DT::dataTableOutput("psolo")
		)
	)	
 ),
 navbarMenu("Stream Sediment",
   	tabPanel("Stream Sediment Tables",
		sidebarPanel(
			img(src = 'http://amazeone.com.br/img/oGDSicon.png', height = '50px', width = '50px'),
			tags$h5("Stream Sediment Tables")
		,width=2),
		mainPanel(
			tags$h3("Stream Sediment Data"),
			DT::dataTableOutput("repo3")
		)
	)
 )
)

#-----------------------------------------------------------------------------------------------------
#--------------------------------------------SERVER---------------------------------------------------
#-----------------------------------------------------------------------------------------------------
server <- function(input, output, session) {
con<-dbConnect(PostgreSQL(),host='127.0.0.1',user='gdatasystems', password='secret', dbname='gds' ,port='5432')
cstr4<-paste("PG:dbname=gds host=127.0.0.1 user=gdatasystems password=secret port=5432")
  aoi <- reactive({
	  aoi <- readOGR(cstr4, layer="aoi")
  })
  gridpoints <- reactive({
	  co <- spTransform(readOGR(cstr4, layer="gridpoints"),CRS("+init=epsg:4326"))
  })
  stream <- reactive({
	  stream <- readOGR(cstr4, layer="stream")
  })
  sol <- reactive({ 
	  outp<-dbGetQuery(con,"select st_x(st_transform(geom,4326)) as long, st_Y(st_transform(geom,4326)) as lat,point,sample,depthm,target,weight,_date as date,type0,colour,sampletype,granul,morpho,fragments,magnetism,vegetation,who  from soil")
	  data.frame(outp)
  })
  strm <- reactive({ 
	  outp<-dbGetQuery(con,"select st_x(st_transform(geom,4326)) as long, st_Y(st_transform(geom,4326)) as lat,point,sample,target,_date as date,type0,descr,concentrad,fragments,matrix,comp_frag,compactatn,environ,who  from strmsed ")
	  data.frame(outp)
  })
   psol <- dbGetQuery(con,"SELECT project as \"Project\",target as \"Target\",point as \"Point\",sample as \"Sample\",duplicate as \"Duplicate\",blank as \"Blank\",standard as \"Standard\",resample as \"Resample\",type0 as \"Type\",utme as \"UTM-E\",utmn as \"UTM-N\",elev as \"Elevation\",datum  as \"Datum\",_zone as \"Zone\",ns as \"Hemisphere\",prfltype as \"Profile Type\",depthm as \"Depth(m)\",colour as \"Colour\",sampletype as \"Sample Type\",granul as \"Granulometry\",morpho as \"Morphology\",Fragments as \"Fragments\",magnetism as \"Magnetism\",vegetation as \"Vegetation\",weight as \"Weight\",_date as \"Date\",obs as \"Observation\",sampled as \"Sampled\"  from soil")
   psed <- dbGetQuery(con,"SELECT project as \"Project\",target as \"Target\",point as \"Point\",sample as \"Sample\",duplicate as \"Duplicate\",blank as \"Blank\",standard as \"Standard\",resample as \"Resample\",type0 as \"Type\",utme as \"UTM-E\",utmn as \"UTM-N\",elev as \"Elevation\",datum  as \"Datum\",_zone as \"Zone\",ns as \"Hemisphere\",descr as \"Description\",concentrad as \"Concentrated\",fragments as \"Fragments\",matrix as \"Matrix\",ns as \"Hemisphere\",comp_frag as \"Frag. Composition\",compactatn as \"Compactation\",ns as \"Hemisphere\",environ as \"Environment\",_date as \"Date\",obs as \"Observation\",sampled as \"Sampled\" from strmsed")  
  #_________________________________________________________________________________________________
  output$map <- renderLeaflet({
    mapa<-leaflet(width = "100%",height = "100%") 
      mapa<-addTiles(mapa,group="Map") 
      mapa<-addProviderTiles(mapa,"Esri.WorldImagery", group = "Satellite Image",options = providerTileOptions(minZoom = 8, maxZoom = 17)) 
      mapa<-addPolygons(map<-mapa,data = aoi(),group="Area of Interest",fillColor = "orange", weight=0.5,color = "grey")
	  mapa<-addCircleMarkers(map<-mapa,data = gridpoints(),group="Soil Location",color="red",radius=0)
	  mapa<-addCircleMarkers(map<-mapa,data = stream(),group="Stream Sed Location",color="pink",radius=0)
	  mapa<-addCircleMarkers(map<-mapa,data = sol(), lng = ~long, lat = ~lat,label=~point, group="Soil Collected",color="purple",radius=4,
					popup = paste0(
                   "<table border='1' width='250px' cellpadding='5px'><tr><th bgcolor='lightgrey' colspan='2'>SOIL SAMPLE: ",sol()$sample,"</th></tr>"
                   , "<tr><td bgcolor='LightBlue'>Point: </td><td bgcolor='Ivory'>", sol()$point, "</td></tr>"
                   , "<tr><td bgcolor='LightBlue'>Target: </td><td bgcolor='Ivory'>",sol()$target,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Depth (m): </td><td bgcolor='Ivory'>",sol()$depthm,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Weight (kg): </td><td bgcolor='Ivory'>",sol()$weight,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Date: </td><td bgcolor='Ivory'>",sol()$date,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Type: </td><td bgcolor='Ivory'>",sol()$type0,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Colour: </td><td bgcolor='Ivory'>",sol()$colour,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Sample Type: </td><td bgcolor='Ivory'>",sol()$sampletype,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Granulometry: </td><td bgcolor='Ivory'>",sol()$granul,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Morphology: </td><td bgcolor='Ivory'>",sol()$morpho,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Fragments: </td><td bgcolor='Ivory'>",sol()$fragments,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Magnetism: </td><td bgcolor='Ivory'>",sol()$magnetism,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Vegetation: </td><td bgcolor='Ivory'>",sol()$vegetation,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Collected by: </td><td bgcolor='Ivory'>",sol()$who,"</td></tr></table>"
               ))
	  mapa<-addCircleMarkers(map<-mapa,data = strm(), lng = ~long, lat = ~lat,label=~point, group="Stream Sed Collected",color="blue",radius=4,
					popup = paste0(
                   "<table border='1' width='250px' cellpadding='5px'><tr><th bgcolor='lightgrey' colspan='2'>STREAM SEDIMENT SAMPLE: ",strm()$sample,"</th></tr>"
                   , "<tr><td bgcolor='LightBlue'>Point: </td><td bgcolor='Ivory'>", strm()$point, "</td></tr>"
                   , "<tr><td bgcolor='LightBlue'>Target: </td><td bgcolor='Ivory'>",strm()$target,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Date: </td><td bgcolor='Ivory'>",strm()$date,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Type: </td><td bgcolor='Ivory'>",strm()$type0,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Description: </td><td bgcolor='Ivory'>",strm()$descr,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Concentrate: </td><td bgcolor='Ivory'>",strm()$concentrad,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Fragments: </td><td bgcolor='Ivory'>",strm()$fragments,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Matrix: </td><td bgcolor='Ivory'>",strm()$matrix,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Frag. composition: </td><td bgcolor='Ivory'>",strm()$comp_frag,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Compactation: </td><td bgcolor='Ivory'>",strm()$compactatn,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Environment: </td><td bgcolor='Ivory'>",strm()$environ,"</td></tr>"
				   , "<tr><td bgcolor='LightBlue'>Collected by: </td><td bgcolor='Ivory'>",strm()$who,"</td></tr></table>"
               ))
	  mapa<-addLayersControl(map<-mapa,baseGroups = c("Satellite Image","Map"),overlayGroups = c("Area of Interest","Soil Location","Stream Sed Location","Soil Collected","Stream Sed Collected"),options = layersControlOptions(collapsed = TRUE)) 
	  mapa<-addScaleBar(map<-mapa,position='bottomleft',options = scaleBarOptions(imperial=F,maxWidth=250))
  })
  output$psolo<-DT::renderDataTable(psol,server = FALSE,
    rownames = FALSE, 
    extensions = 'Buttons',
    options = exprToFunction(
      list(dom = 'lBfrtip',
           buttons = list( 
             list(extend = 'print',title="Soil Executed Table"),
			 list(extend = 'csv',filename=paste("Soil","Executed",sep = "_")),
             list(extend = 'excel',title="Soil Executed Table",filename=paste("Soil","Executed",date(),sep = "_")),
			 list(extend = 'pdf',title="Soil Executed Table",orientation="landscape",pageSize="A2",filename=paste("Soil","Executed",date(),sep = "_"))
		   )
	  )
    )
  )
 
output$repo3<-DT::renderDataTable(psed,server = FALSE,
    rownames = FALSE,
    extensions = 'Buttons',
    options = exprToFunction(
      list(dom = 'lBfrtip',pageLength = 15,
			 lengthMenu = c(15, 50, 100,500),
           buttons = list( 
             list(extend = 'print',title="Executed Stream Sed Table"),
			 list(extend = 'csv',filename=paste("StreamSed","Executed",sep = "_")),
             list(extend = 'excel',title="Executed Stream Sed Table",filename=paste("StreamSed","Executed",sep = "-")),
			 list(extend = 'pdf',title="Executed Stream Sed Table",orientation="landscape",pageSize="A2",filename=paste("StreamSed","Executed",sep = "-"))
		   )
	  )
	)
  )



#_______________________________________________________________________________________
}
#-----------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------
shinyApp(ui, server)
