 library(shiny)
library(rgdal)
library(leaflet)
library(leaflet.extras)
library(rpostgis)
library(DT)
library(shinymanager)
#---------------Credenciais----------------------------------------------------------------------
inactivity <- "function idleTimer() {
var t = setTimeout(logout, 240000);
window.onmousemove = resetTimer; 
window.onmousedown = resetTimer; 
window.onclick = resetTimer;     
window.onscroll = resetTimer;    
window.onkeypress = resetTimer;  
function logout() {
window.close();  //close the window
}
function resetTimer() {
clearTimeout(t);
t = setTimeout(logout, 120000); 
}
}
idleTimer();"
 #substituir usuario e senhadeusuario pelas credenciais de um usuário válido do banco de dados
credentials <- data.frame(
  user = c("usuario"),
  password = c("senhadesteusuario"),
  stringsAsFactors = FALSE
)
#-----------------------------------------------------------------------------------------------------
#--------------------------------------------UI---------------------------------------------------
#-----------------------------------------------------------------------------------------------------
ui <- secure_app(head_auth = tags$script(inactivity), 
language = "pt-BR",
background  = "linear-gradient(rgba(255, 127, 80, 0.1), 
                  rgba(255, 127, 80, 0.1)),
                  url('https://amazeone.com.br/img/icon.png')  no-repeat top fixed;",
 navbarPage("Solo - GDataSystems webApp",id = "tabs",
  tabPanel("Mapa",
		sidebarLayout(
			sidebarPanel(
				tags$h4("Mapa do Projeto"),
			,width=2),
			mainPanel(
				leafletOutput(outputId = "map", height=800)
			)
		)
 ),
 navbarMenu("Dados",
   	tabPanel("Tabelas Solo",
		sidebarPanel(
			tags$h5("Tabela Pontos Amostra de Solo")
		,width=2),
		mainPanel(
			tags$h3("Tabela Pontos Amostra de Solo"),
			DT::dataTableOutput("psolo"),
			tags$h3("Tabela Pontos Amostra de Solo Coletadas"),
			DT::dataTableOutput("psoloc"),
			tags$h3("Tabela Pontos Amostra de Solo a Coletar"),
			DT::dataTableOutput("psoloac")
		)
	),
    tabPanel("Tabelas Sedimento Corrente",
		sidebarPanel(
			tags$h5("Tabela Pontos Amostra de Sedimento de Corrente")
		,width=2),
		mainPanel(
			tags$h3("Tabela Pontos Amostra de Sedimento de Corrente"),
			DT::dataTableOutput("psed"),
			tags$h3("Tabela Pontos Amostra de Sedimento de Corrente Coletadas"),
			DT::dataTableOutput("psedc"),
			tags$h3("Tabela Pontos Amostra de Sedimento de Corrente a Coletar"),
			DT::dataTableOutput("psedac")
		)
	)		
 )
)
)
#-----------------------------------------------------------------------------------------------------
#--------------------------------------------SERVER---------------------------------------------------
#-----------------------------------------------------------------------------------------------------
server <- function(input, output, session) {
result_auth <- secure_server(check_credentials = check_credentials(credentials))
output$res_auth <- renderPrint({
    reactiveValuesToList(result_auth)
  })
con<-dbConnect(dbDriver("PostgreSQL"),host='127.0.0.1',user=credentials$user[1], password=credentials$password[1], dbname='geodbsolo' ,port='5432')
cstr4<-paste("PG:dbname=geodbsolo host=127.0.0.1 user=",credentials$user[1]," password=",credentials$password[1]," port=5432")
  dm <- reactive({
	  co <- readOGR(cstr4, layer="dm")
  })
  sol <- reactive({ 
	  outp<-dbGetQuery(con,"select st_x(st_transform(geom,4326)) as long, st_Y(st_transform(geom,4326)) as lat, amostra,ponto  from soil")
	  data.frame(outp)
  })
  solcol <- reactive({
       outp<-dbGetQuery(con,"select ponto,amostra,resp,_data as data,st_x(st_transform(geom,4326)) as long, st_Y(st_transform(geom,4326)) as lat from soil where amostra IS NOT NULL and coletado=true")
	   data.frame(outp)
  })
  soalacol <- reactive({
	  outp<-dbGetQuery(con,"select st_x(st_transform(geom,4326)) as long, st_Y(st_transform(geom,4326)) as lat, amostra,ponto from soil where amostra IS NULL")
	  data.frame(outp)
  })
  psolo <- dbGetQuery(con,"SELECT id as \"ID\",projeto as \"Projeto\",alvo as \"Alvo\",ponto as \"Ponto\",amostra as \"Amostra\",coletado as \"Coletado\",utme as \"UTM E\",utmn as \"UTM N\",elev as \"Elevação\",
				duplicata as \"Duplicata\",branco as \"Branco\",padrao as \"Padrão\",reamostra as \"Reamostra\",tipo as \"Tipo\",tipoperfil as \"Tipo Perfil\",datum as \"Datum\",_zone as \"Zona\",
				ns as \"Hemisfério\",profm as \"Profundidade\",cor as \"Cor\",tipoamostr as \"Tipo Amostra\",granul as \"Granulometria\",
				relevo as \"Relevo\",fragmentos as \"Fragmentos\",magnetismo as \"Magnetismo\",vegetacao as \"Vegetação\",peso as \"Peso\",obs as \"Observações\",_data as \"Data\",resp as \"Responsável\" FROM soil ORDER BY amostra")
  psoloc <- dbGetQuery(con,"SELECT id as \"ID\",projeto as \"Projeto\",alvo as \"Alvo\",ponto as \"Ponto\",amostra as \"Amostra\",coletado as \"Coletado\",utme as \"UTM E\",utmn as \"UTM N\",elev as \"Elevação\",
				duplicata as \"Duplicata\",branco as \"Branco\",padrao as \"Padrão\",reamostra as \"Reamostra\",tipo as \"Tipo\",tipoperfil as \"Tipo Perfil\",datum as \"Datum\",_zone as \"Zona\",
				ns as \"Hemisfério\",profm as \"Profundidade\",cor as \"Cor\",tipoamostr as \"Tipo Amostra\",granul as \"Granulometria\",
				relevo as \"Relevo\",fragmentos as \"Fragmentos\",magnetismo as \"Magnetismo\",vegetacao as \"Vegetação\",peso as \"Peso\",obs as \"Observações\",_data as \"Data\",resp as \"Responsável\" FROM soil WHERE coletado='true' ORDER BY amostra")
  psoloac <- dbGetQuery(con,"SELECT id as \"ID\",projeto as \"Projeto\",alvo as \"Alvo\",ponto as \"Ponto\",amostra as \"Amostra\",coletado as \"Coletado\",utme as \"UTM E\",utmn as \"UTM N\",elev as \"Elevação\",
				duplicata as \"Duplicata\",branco as \"Branco\",padrao as \"Padrão\",reamostra as \"Reamostra\",tipo as \"Tipo\",tipoperfil as \"Tipo Perfil\",datum as \"Datum\",_zone as \"Zona\",
				ns as \"Hemisfério\",profm as \"Profundidade\",cor as \"Cor\",tipoamostr as \"Tipo Amostra\",granul as \"Granulometria\",
				relevo as \"Relevo\",fragmentos as \"Fragmentos\",magnetismo as \"Magnetismo\",vegetacao as \"Vegetação\",peso as \"Peso\",obs as \"Observações\",_data as \"Data\",resp as \"Responsável\" FROM  soil WHERE coletado='false' ORDER BY amostra")
 
  #_________________________________________________________________________________________________
  output$map <- renderLeaflet({
    mapa<-leaflet() 
      mapa<-addTiles(mapa,group="Cartografia")  
      mapa<-addProviderTiles(mapa,"Esri.WorldImagery", group = "Satelite") 
      mapa<-addPolygons(map<-mapa,data = dm(),group="Direitos Minerários",label=~dsprocesso,
					fillColor = "orange", weight=0.5,color = "grey",
					popup = paste0(
                   "<b>",dm()$dsprocesso,":</b>"
                   , "<br>"
                   , "Nome: <b>", dm()$nome, "</b><br>"
                   , "Substância: <b>",dm()$subs,"</b><br>"
				   , "Fase: <b>",dm()$fase,"</b><br>"
				   , "Área (ha): <b>",dm()$area_ha,"</b><br>"
				   , "Último Evento: <b>",dm()$ult_evento,"</b><br>"
               ))
	  mapa<-addCircleMarkers(map<-mapa,data = sol(), lng = ~long, lat = ~lat,label=~ponto, group="Solo",color="black",radius=2)
	  if(nrow(solcol())>0){mapa<-addCircleMarkers(map<-mapa,data = solcol(), lng = ~long, lat = ~lat,label=~amostra, group="Solo Coletado",color="purple",radius=2,popup = paste0(
                   "<b>",solcol()$ponto,":</b>"
                   , "<br>"
                   , "Amostra: <b>", solcol()$amostra, "</b><br>"
                   , "Data: <b>",solcol()$data,"</b><br>"
				   , "Coletado por: <b>",solcol()$resp,"</b><br>"
               ))}
	  if(nrow(soalacol())>0){mapa<-addCircleMarkers(map<-mapa,data = soalacol(), lng = ~long, lat = ~lat,label=~ponto, group="Solo a Coletar",color="navy",radius=2)}
      if(nrow(solcol())==0 && nrow(soalacol())>0){mapa<-addLayersControl(map<-mapa,baseGroups = c("Cartografia","Satelite"),overlayGroups = c("Direitos Minerários","Solo","Solo a Coletar"),options = layersControlOptions(collapsed = TRUE))}
      else if(nrow(solcol())>0 && nrow(soalacol())==0){mapa<-addLayersControl(map<-mapa,baseGroups = c("Cartografia","Satelite"),overlayGroups = c("Direitos Minerários","Solo","Solo Coletado"),options = layersControlOptions(collapsed = TRUE))}
	  else if(nrow(solcol())>0 && nrow(soalacol())>0){mapa<-addLayersControl(map<-mapa,baseGroups = c("Cartografia","Satelite"),overlayGroups = c("Direitos Minerários","Solo","Solo Coletado","Solo a Coletar"),options = layersControlOptions(collapsed = TRUE))}
	  else{mapa<-addLayersControl(map<-mapa,baseGroups = c("Cartografia","Satelite"),overlayGroups = c("Direitos Minerários","Solo"),options = layersControlOptions(collapsed = TRUE))}
	  mapa<-hideGroup(map<-mapa,c("Solo","Solo Coletado", "Solo a Coletar"))
	  mapa<-addScaleBar(map<-mapa,position='bottomleft',options = scaleBarOptions(imperial=F,maxWidth=250))
  })
  output$psolo<-DT::renderDataTable(psolo,server = FALSE,
    rownames = FALSE, 
    extensions = 'Buttons',
    options = exprToFunction(
      list(dom = 'lBfrtip',
           buttons = list( 
             list(extend = 'print',title="Tabela Pontos Amostra de Solo"),
             list(extend = 'excel',title="Tabela Pontos Amostra de Solo",filename=paste("Tabela","Solo",sep = "-")),
			 list(extend = 'pdf',title="Tabela Pontos Amostra de Solo",orientation="landscape",pageSize="A2",filename=paste("Tabela","Solo",sep = "-"))
		   )
	  )
    )
  )
  output$psoloc<-DT::renderDataTable(psoloc,server = FALSE,
    rownames = FALSE, 
    extensions = 'Buttons',
    options = exprToFunction(
      list(dom = 'lBfrtip',
           buttons = list( 
             list(extend = 'print',title="Tabela Pontos Amostra de Solo"),
             list(extend = 'excel',title="Tabela Pontos Amostra de Solo",filename=paste("Tabela","Solo",sep = "-")),
			 list(extend = 'pdf',title="Tabela Pontos Amostra de Solo",orientation="landscape",pageSize="A2",filename=paste("Tabela","Solo",sep = "-"))
		   )
	  )
    )
  )
 output$psoloac<-DT::renderDataTable(psoloac,server = FALSE,
    rownames = FALSE, 
    extensions = 'Buttons',
    options = exprToFunction(
      list(dom = 'lBfrtip',
           buttons = list( 
             list(extend = 'print',title="Tabela Pontos Amostra de Solo"),
             list(extend = 'excel',title="Tabela Pontos Amostra de Solo",filename=paste("Tabela","Solo",sep = "-")),
			 list(extend = 'pdf',title="Tabela Pontos Amostra de Solo",orientation="landscape",pageSize="A2",filename=paste("Tabela","Solo",sep = "-"))
		   )
	  )
    )
  )  
  #_______________________________________________________________________________________
}
#-----------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------
shinyApp(ui, server)

