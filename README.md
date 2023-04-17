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
<h2>Criando o Banco de Dados Postgis</h2>
<p>Caso decida usar o banco de dados (<b>recomendado</b>), em um servidor com postgres e postgis cria o seguinte banco de dados usando:</p>
<pre>
createdb nomeBanco --encoding=utf-8
psql nomeBanco -c "CREATE EXTENSION postgis"
</pre>
<p>Onde noBanco é o nome do banco de dados escolhido.</p>
<p>Altere no arquivo os valores de usuariosolo e usuariosed e também senhaSecreta de acordo com os usuário que usarão o sistema e em seguida e execute: <pre> <b>psql -d nomeBanco -f criaTabelas.sql</b></pre><p> Não altere os nomes das tablelas e nem dos campos nesse arquivo, somente usuários e senhas. </p>
<p> Os campos de acesso a serem usados pelos plugins QGIS e Aplicativos android serão:</p>
<li> SERVIDOR - IP ou nome de domínio do servidor com o banco de dados
<li> USUÁRIO - nome do usuário 
<li> SENHA - senha definida para o usuário
<li> NOMEdoBANCO - Nome do baco de dados criado
<lI> SRID - Número do sistema de coordanada usado
<h2>Instalando Plugins do QGIS</h2>
<p>Para instalar o Plugin siga as intruções abaixo de acordo com o sistema operacional rodando o QGIS.</p>
<h4>Windows</h4>
<p></p>
<h4>Lunux</h4>
<p></p>
<h4>OSX</h4>
<p></p>
<h2>Baixando os aplicativos</h2>
<p>Os aplicativos SoloTabOSM e SedcorTabOSM estão disponíveis na Google Play Store.</p>
<h2>Mairoes informações</h2>
<p>Informações mais detalhadas do sistema podem ser enconradas na pasta manual.</p>
