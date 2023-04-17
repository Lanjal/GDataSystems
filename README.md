# GDataSystems
<img src="/img/oGDSicon.png" width=92>
<h2>Sistema de aquisição de dados de campo em exploração mineral</h2>
<p> O GDataSystems é um sistema para o registro de dados de campo em exploração mineral focado no maomento em:</p>
<li> Amostragem de Solo
<li> Amostragem de Sedimento de Corrente
<p> Em breve será incluído:</p>
<li> Mapeamento Geológico e coleta de amostras de rocha
<li> Resultados geoquímicos
<li> Acompanhamento de Sondagem
<li> Descrição de Sondagem
<p>O sistema utiliza plugins personalizados do QGIS, aplicativos Android e interface web de onde podemos adquirir dados e acessar as ferramentas principais de visualização e exportação dos dados de exploração.</p>
<img  src="img/ogdb1.png" width=500>
<p>Alternativamente o sistema pode funcionar com arquivos ao invés de Banco de dados.</p>
<h1>Instalação</h1>
<h2>Banco de Dados Postgis</h2>
<p>Caso decida usar o banco de dados (<b>recomendado</b>), em um servidor com postgres e postgis cria o seguinte banco de dados usando:</p>
<pre>
createdb nomeBanco --encoding=utf-8
psql nomeBanco -c "CREATE EXTENSION postgis"
</pre>
<p>Onde noBanco é o nome do banco de dados escolhido.</p>
<p>Altere no arquivo os valores de usuariosolo e usuariosed e senhaSecreta de acordo com os usuário que usarão o sistema e em seguida Execute <b>psql -d nomeBanco -f criaTabelas.sql</b>. Não altere os nomes das tablelas e nem dos campos. </p>

