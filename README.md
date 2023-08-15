# GDataSystems - Version 0.1.0 (BETA)
<img src="/img/oGDSicon.png" width=92>
<h2>Mineral exploration field data acquisition system</h2>
<p> The data acquisition system GDataSystems involves a central Postgis database that stores sampling points. The database is fed using the apps (GDS-Soil and GDS-StreamSed) developed for Android 11 or superior. Auger drillhole data and geological mapping/sampling in final tests.</p>
<p></p>Each app uses OSM map tiles OSM (Open Street Map) with the programmed sampling points on it. Each collection point is converted into a marker that, when clicked, pops-up a menu particular to each app type. The menu will allow a particular form to be displayed and the data can be loaded internally into the tablet database (offline). The coordinates and elevation data are collected automatically with the tablet GPS and can be edited or adjusted if necessary. After returning from the field all the collected data can be uploaded to the main database located on a remote server using the available internet connection. The app also stores all the data internally using CSV file format as a backup. The system works exclusively using Latitude-Longitude on WGS-84 datum and all conversions is handled automatically by the app during the upload process adjusting them to the defined database datum (database SRID).</p>
<p>The following tools are already realeased</p>
<li> Soil Sampling
<li> Stream Sediment sampling
<li> Auger drilling
<p> Future releases:</p>
<li> Geological mapping/sampling
<li> RC Drilling
<li> DDH Drilling / Core Logging
<h2>Server Setup</h2>
<p>A standard VPS server will be suitable to use GDataSystems if it has a PostgreSQL-Postgis database server, a web server, and a shiny server. The server will be accessed by its IP address or domain name and the connection parameters such as database name, username, and password.</p>
<h2>Configuring the postgis database</h2>
<p>The following instructions presents a standard database, and a customized version can be implemented accordingly with a Project needs. The entire system (apps, WEB, and shiny dashboard) will work integrated with the PostgreSQL-Postgis database.</p>
<p>On your server create a database using the commands below.</p>
<pre>createdb gds --encoding=utf-8
psql gds -c "CREATE EXTENSION postgis"</pre>
<p>The next step is to create the set of tables on your database (example: gds).</p>
<p>The <b>setup.sql</b> can to create your database can be found in the sql folder.</p>

<p><b>gds</b>, <b>secret</b> and <b>gdatasystems</b> are respectively examples of the database name, password and user that are needed for system connection used by apps, QGiS and web interfaces. The Postgis database server IP address or domain name (Host) is necessary as well to make the connections. Adjust your system accordingly</p>


<h2>Installing the Android Apps</h2>
<p>The apps GDS-Soil, GDS-StreamSed and GDS-Auger are available on  Google Play Store.</p>
<h3><a href="https://play.google.com/store/apps/details?id=com.gdatasystems.gds_soil">GDS-Soil</a></h3>
<h3><a href="https://play.google.com/store/apps/details?id=com.gdatasystems.gds_streamsed">GDS-StreamSed</a></h3>
<h3><a href="https://play.google.com/store/apps/details?id=com.gdatasystems.gds_auger">GDS-Auger</a></h3>

<h2>Shiny Dashboard Example</h2>
<p> An example of a shiny dashboard can be found under the shiny folder. </p>

<h2>More info</h2>
<p>More information about the GeoDataSystems can be found in the folder manual.</p>
