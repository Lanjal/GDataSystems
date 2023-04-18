package br.com.amazeone.sedcortabosm;

import androidx.annotation.NonNull;
import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;


import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.StrictMode;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import com.google.android.material.navigation.NavigationView;
import com.opencsv.CSVReader;
import com.opencsv.CSVWriter;

import org.osmdroid.api.IMapController;
import org.osmdroid.config.Configuration;
import org.osmdroid.shape.ShapeConverter;
import org.osmdroid.tileprovider.MapTileProviderArray;
import org.osmdroid.tileprovider.modules.IArchiveFile;
import org.osmdroid.tileprovider.modules.MBTilesFileArchive;
import org.osmdroid.tileprovider.modules.MapTileFileArchiveProvider;
import org.osmdroid.tileprovider.modules.MapTileModuleProviderBase;
import org.osmdroid.tileprovider.tilesource.XYTileSource;
import org.osmdroid.tileprovider.util.SimpleRegisterReceiver;
import org.osmdroid.util.GeoPoint;
import org.osmdroid.views.MapView;
import org.osmdroid.views.overlay.ItemizedIconOverlay;
import org.osmdroid.views.overlay.Overlay;
import org.osmdroid.views.overlay.OverlayItem;
import org.osmdroid.views.overlay.ScaleBarOverlay;
import org.osmdroid.views.overlay.mylocation.GpsMyLocationProvider;
import org.osmdroid.views.overlay.mylocation.MyLocationNewOverlay;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public class MainActivity extends AppCompatActivity implements  NavigationView.OnNavigationItemSelectedListener{
    private MapView map = null;
    public DrawerLayout drawerLayout;
    public ActionBarDrawerToggle actionBarDrawerToggle;
    LocationManager locationManager;
    Location gps_loc;
    Location final_loc;
    String usu = "";
    String pass = "";
    String dbs="";
    String hos="";
    Dialog myDialog;
    int srid=32723;
    double longitude;
    double latitude;
    double elev;
    MyLocationNewOverlay locationOverlay;
    ArrayList<OverlayItem> pontoColeta;
    ItemizedIconOverlay<OverlayItem> todosPontos;
    SimpleRegisterReceiver simpleReceiver;
    List<Overlay> anm;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Context ctx = getApplicationContext();
        Configuration.getInstance().load(ctx, androidx.preference.PreferenceManager.getDefaultSharedPreferences(ctx));
        setContentView(R.layout.activity_main);
        callLoginDialog();
        checkPermissions();
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitNetwork().build();
        StrictMode.setThreadPolicy(policy);
        map = findViewById(R.id.map);
        simpleReceiver = new SimpleRegisterReceiver(this);
        mapu(3);
        map.setMultiTouchControls(true);
        File exportDir = new File(getExternalFilesDir(null), "dados/");
        try {anm = ShapeConverter.convert(map, new File(exportDir,"dm.shp"));
        } catch (Exception e) {throw new RuntimeException(e);}
        map.getOverlayManager().addAll(anm);
        map.invalidate();
        final Context context = map.getContext();
        final DisplayMetrics dm = context.getResources().getDisplayMetrics();
        ScaleBarOverlay mScaleBarOverlay = new ScaleBarOverlay(map);
        mScaleBarOverlay.setCentred(true);
        mScaleBarOverlay.setScaleBarOffset(dm.widthPixels / 2, 10);
        map.getOverlays().add(mScaleBarOverlay);
        loco();
        IMapController mapController = map.getController();
        mapController.setZoom(15.0);
        GeoPoint startPoint = new GeoPoint(latitude, longitude);
        mapController.setCenter(startPoint);
        GpsMyLocationProvider provider = new GpsMyLocationProvider(this);
        provider.addLocationSource(LocationManager.GPS_PROVIDER);
        locationOverlay = new MyLocationNewOverlay(provider, map);
        locationOverlay.enableFollowLocation();
        locationOverlay.runOnFirstFix(() -> Log.d("MinhaMarca", String.format("Ajuste da primeira localização: %s", locationOverlay.getLastFix())));
        map.getOverlayManager().add(locationOverlay);
        drawerLayout = findViewById(R.id.my_drawer_layout);
        actionBarDrawerToggle = new ActionBarDrawerToggle(this, drawerLayout, R.string.nav_open, R.string.nav_close);
        drawerLayout.addDrawerListener(actionBarDrawerToggle);
        actionBarDrawerToggle.syncState();
        Objects.requireNonNull(getSupportActionBar()).setTitle("Amostragem Sedimento de Corrente");
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        NavigationView navigationView = findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);
    }

    @Override
    public void onResume() {
        super.onResume();
        map.onResume();
        locationOverlay.enableMyLocation();
    }
    @Override
    public void onPause() {
        super.onPause();
        map.onPause();
        locationOverlay.disableMyLocation();
    }
    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        if (actionBarDrawerToggle.onOptionsItemSelected(item)) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        int id = item.getItemId();
        if(id == R.id.nav_carregar) {
            carrega();
        }
        if(id == R.id.nav_marcar) {
            Intent intent = new Intent(MainActivity.this, NewSed.class);
            loco();
            Bundle extras = new Bundle();
            extras.putString("VENUE_LAT", Double.toString(latitude));
            extras.putString("VENUE_LON", Double.toString(longitude));
            extras.putString("USU", usu);
            extras.putString("VENUE_ELEV", Double.toString(elev));
            intent.putExtras(extras);
            startActivity(intent);
        }
        if(id == R.id.nav_baixar) {
            baixa();

        }
        if(id == R.id.nav_subir) {
            sobe();
            if(todosPontos!=null)map.getOverlays().remove(todosPontos);
        }
        if(id == R.id.nav_checar) {
            exportDB();
        }
        if(id == R.id.nav_baixararq) {
            importaDB();
        }
        if(id == R.id.nav_sel) {
            final String[] items = new String[]{"Mapa Base", "Imagem Satélite", "Base Regional"};
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setTitle("Escolha Base ")
                    .setItems(items, (dialog, which) -> {
                        dialog.dismiss();
                        if(which==0)mapu(1);
                        if(which==1)mapu(2);
                        if(which==2)mapu(0);
                    })
                    .show();
        }
        DrawerLayout drawer =  findViewById(R.id.my_drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }
    // TUDO É PERMITIDO-----------------------------------------------------------------------------
    final private int REQUEST_CODE_ASK_MULTIPLE_PERMISSIONS = 124;
    private void checkPermissions() {
        List<String> permissions = new ArrayList<>();
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            permissions.add(android.Manifest.permission.ACCESS_FINE_LOCATION);
        }
        //if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.MANAGE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
           // permissions.add(android.Manifest.permission.MANAGE_EXTERNAL_STORAGE);
        //}
        if (!permissions.isEmpty()) {
            String[] params = permissions.toArray(new String[permissions.size()]);
            requestPermissions(params, REQUEST_CODE_ASK_MULTIPLE_PERMISSIONS);
        }
    }
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (requestCode == REQUEST_CODE_ASK_MULTIPLE_PERMISSIONS) {
            Map<String, Integer> perms = new HashMap<>();
            perms.put(android.Manifest.permission.ACCESS_FINE_LOCATION, PackageManager.PERMISSION_GRANTED);
            //perms.put(Manifest.permission.MANAGE_EXTERNAL_STORAGE, PackageManager.PERMISSION_GRANTED);
            for (int i = 0; i < permissions.length; i++)
                perms.put(permissions[i], grantResults[i]);
            boolean location = perms.get(android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
            if (!location) {
                // Permissão Negada
                Toast.makeText(this, "Não  localiza ou não armazena.", Toast.LENGTH_SHORT).show();
            }
            Configuration.getInstance().load(this, androidx.preference.PreferenceManager.getDefaultSharedPreferences(this));
        } else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }
    //---------------TAREFAS DO APLICATIVO--------------------------------------------------------------
    //-------------------DIÁLOGO LOGIN--------------------------------------------------------------
    private void callLoginDialog() {
        myDialog = new Dialog(this);
        myDialog.setContentView(R.layout.dialog_signin);
        myDialog.setCancelable(false);
        Button login = myDialog.findViewById(R.id.loginButton);
        EditText username = myDialog.findViewById(R.id.username);
        EditText password = myDialog.findViewById(R.id.password);
        EditText db=myDialog.findViewById(R.id.db);
        EditText host=myDialog.findViewById(R.id.host);
        Spinner rgSrid= myDialog.findViewById(R.id.rgSrid);
        myDialog.show();
        login.setOnClickListener(v -> {
            usu = username.getText().toString();
            pass = password.getText().toString();
            dbs = db.getText().toString();
            hos = host.getText().toString();
            String sr=rgSrid.getSelectedItem().toString();
            switch (sr) {
                case "WGS84_24S":
                    srid = 32724;
                    break;
                case "WGS84_22S":
                    srid = 32722;
                    break;
                case "WGS84_21S":
                    srid = 32721;
                    break;
                case "WGS84_20S":
                    srid = 32720;
                    break;
                case "WGS84_22N":
                    srid = 32622;
                    break;
                case "WGS84_21N":
                    srid = 32621;
                    break;
                case "WGS84_20N":
                    srid = 32620;
                    break;
                default:
                    srid = 32723;
                    break;
            }
            myDialog.hide();
        });
    }
    //---------CARREGA LOCALIZAÇÃO NAS VARIÁVEIS latitude longitude---------------------------------
    public void loco() {
        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        try {
            if (ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED ) {
                return;
            }
            gps_loc = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);

        } catch (Exception e) {
            e.printStackTrace();
        }
        if (gps_loc != null) {
            final_loc = gps_loc;
            latitude = final_loc.getLatitude();
            longitude = final_loc.getLongitude();
            boolean hasaltitude = gps_loc.hasAltitude();
            if(hasaltitude)elev = gps_loc.getAltitude();
            else elev=0.0;
        }
        else {
            latitude = 0.0;
            longitude = 0.0;
            elev=0.0;
        }
    }

    //-----------CARREGA DADOS ARMAZENADOS NO BANCO SQLite INTERNO----------------------------------
    public void carrega (){
        if(todosPontos!=null)map.getOverlays().remove(todosPontos);
        pontoColeta = new ArrayList<>();
        Cursor cursor = DbGateway.getInstance(getApplication().
                getApplicationContext()).getDatabase().rawQuery("SELECT ponto,utme,utmn FROM sedcor",
                null);
        while (cursor.moveToNext()) {
            String ponto = cursor.getString(cursor.getColumnIndexOrThrow("ponto"));
            double utmn = cursor.getDouble(cursor.getColumnIndexOrThrow("utmn"));
            double utme = cursor.getDouble(cursor.getColumnIndexOrThrow("utme"));
            pontoColeta.add(new OverlayItem(ponto, ponto, new GeoPoint(utmn, utme)));
        }
        todosPontos = new ItemizedIconOverlay<>(this, pontoColeta, new ItemizedIconOverlay.OnItemGestureListener<OverlayItem>() {
            @Override
            public boolean onItemSingleTapUp(final int index, final OverlayItem item) {
                Intent intent = new Intent(MainActivity.this, AddSed.class);
                loco();
                Bundle extras = new Bundle();
                final String[] items = new String[]{"Executar Coleta", "Editar Coletado"};
                new AlertDialog.Builder(map.getContext())
                        .setSingleChoiceItems(items, 0, null)
                        .setPositiveButton("OK", (dialog, whichButton) -> {
                            dialog.dismiss();
                            int esco = ((AlertDialog) dialog).getListView().getCheckedItemPosition();
                            extras.putString("VENUE_AMOSTRA", pontoColeta.get(index).getTitle());
                            extras.putString("VENUE_LAT", Double.toString(latitude));
                            extras.putString("VENUE_LON", Double.toString(longitude));
                            extras.putString("VENUE_ELEV", Double.toString(elev));
                            extras.putString("USU", usu);
                            extras.putString("ESCO", Integer.toString(esco));//----------------------------------------o bicho ta aqui 0 pega a localizaçao 1 pega o dado tem que valer o alerta
                            intent.putExtras(extras);
                            startActivity(intent);
                        })
                        .show();
                return false;
                //return true;
            }

            @Override
            public boolean onItemLongPress(final int index, final OverlayItem item) {
                return false;
            }
        });
        map.getOverlays().add(todosPontos);
        cursor.close();
    }
    //--------BAIXA DADOS ARMAZENADOS EM SERVIDOOR EXTERNO PARA BANCO SQLite INTERNO----------------
    public void baixa(){
        AlertDialog.Builder builder = new AlertDialog.Builder(findViewById(android.R.id.content).getRootView().getContext());
        builder.setTitle("CONTINUAR?")
                .setMessage("Ao fazer o Download todos os dados serão substituidos neste App!!")
                .setPositiveButton("SIM", (dialog, which) -> {
                    try {
                        Database db = new Database(usu, pass,dbs,hos);
                        Connection conn = db.getExtraConnection();
                        String sql;
                        SedDAO dao = new SedDAO(getBaseContext());
                        dao.excluir();
                        sql = "SELECT id,projeto,alvo,ponto,amostra,duplicata,branco,padrao,reamostra,tipo," +
                                "ST_X(ST_Transform(geom, 4326)) as x,ST_Y(ST_Transform(geom, 4326)) as y,elev," +
                                "datum,_zone,ns,descri,concentrad,fragmentos,matriz,comp_frag, compactaca,ambiente," +
                               "resp,_data,obs, coletado,tstp,who FROM sedcor where coletado=false;";
                        Statement st = conn.createStatement();
                        ResultSet rs = st.executeQuery(sql);
                        while (rs.next()) {
                            int idd = rs.getInt("id");
                            String projeto = rs.getString("projeto");
                            String alvo = rs.getString("alvo");
                            String ponto = rs.getString("ponto");
                            String amostra = rs.getString("amostra");
                            String duplicata = rs.getString("duplicata");
                            String branco = rs.getString("branco");
                            String padrao = rs.getString("padrao");
                            String reamostra = rs.getString("reamostra");
                            String tipo = rs.getString("tipo");
                            double X = rs.getDouble("x");
                            double Y = rs.getDouble("y");
                            double eleva = rs.getDouble("elev");
                            String datum = rs.getString("datum");
                            int _zone = rs.getInt("_zone");
                            String ns = rs.getString("ns");
                            String descri = rs.getString("descri");
                            boolean concetra = rs.getBoolean("concentrad");
                            int concentrad = concetra ? 1 : 0;
                            String fragmentos = rs.getString("fragmentos");
                            String matriz = rs.getString("matriz");
                            String comp_frag = rs.getString("comp_frag");
                            String compactaca = rs.getString("compactaca");
                            String ambiente = rs.getString("ambiente");
                            String resp = rs.getString("resp");
                            String _data = rs.getString("_data");
                            String obs = rs.getString("obs");
                            boolean coletado = rs.getBoolean("coletado");
                            int coletadoint = coletado ? 1 : 0;
                            String tstp = rs.getString("tstp");
                            String who = rs.getString("who");
                            boolean sucesso = dao.salvar(0, idd, projeto, alvo,ponto, amostra, duplicata,
                                    branco, padrao, reamostra, tipo, X, Y, eleva, datum, _zone, ns, descri,
                                    concentrad, fragmentos, matriz, comp_frag, compactaca, ambiente,
                                    resp, _data, obs, coletadoint, tstp, who);
                            if (!sucesso) {Toast.makeText(getApplicationContext(), "Erro ao carregar dados",
                                    Toast.LENGTH_LONG).show();}
                        }
                        carrega();
                        Toast.makeText(getApplicationContext(), "Dados Carregados com sucesso!",
                                Toast.LENGTH_LONG).show();
                        rs.close();
                        st.close();
                        db.closeCon();
                    } catch (Exception e) {
                        e.printStackTrace();
                        System.out.println("Vixe Maria não deu: " + e);
                        Toast.makeText(getApplicationContext(), "Erro extraindo os dados",
                                Toast.LENGTH_LONG).show();
                    }
                })
                .setNegativeButton("Cancelar", null)
                .create()
                .show();
    }
    //----SOBE DADOS DO BANCO SQLite INTERNO PARA ATUALIZAR BANCO DE DADOS Postgis NO SERVIDOR------
    public void sobe(){
        AlertDialog.Builder builder = new AlertDialog.Builder(findViewById(android.R.id.content).getRootView().getContext());
        builder.setTitle("CONTINUAR?")
                .setMessage("Ao fazer o Upload todos os dados serão extraídos deste App!!")
                .setPositiveButton("SIM", (dialog, which) -> {
                    Database db = new Database(usu,pass,dbs,hos);
                    Runnable runnable = () -> {
                        if(db.getStatus()){
                            try{
                                Connection conn=db.getExtraConnection();
                                Cursor cursor = DbGateway.getInstance(getApplication().
                                        getApplicationContext()).getDatabase().rawQuery(
                                        "SELECT * FROM sedcor where coletado=1 and amostra IS NOT NULL",null);
                                while(cursor.moveToNext()){
                                    String projeto = cursor.getString(cursor.getColumnIndexOrThrow("projeto"));
                                    String alvo = cursor.getString(cursor.getColumnIndexOrThrow("alvo"));
                                    String ponto = cursor.getString(cursor.getColumnIndexOrThrow("ponto"));
                                    String amostra = cursor.getString(cursor.getColumnIndexOrThrow("amostra"));
                                    String duplicata = cursor.getString(cursor.getColumnIndexOrThrow("duplicata"));
                                    String branco = cursor.getString(cursor.getColumnIndexOrThrow("branco"));
                                    String padrao = cursor.getString(cursor.getColumnIndexOrThrow("padrao"));
                                    String reamostra = cursor.getString(cursor.getColumnIndexOrThrow("reamostra"));
                                    String tipo = cursor.getString(cursor.getColumnIndexOrThrow("tipo"));
                                    double utme = cursor.getDouble(cursor.getColumnIndexOrThrow("utme"));
                                    double utmn = cursor.getDouble(cursor.getColumnIndexOrThrow("utmn"));
                                    double elev = cursor.getDouble(cursor.getColumnIndexOrThrow("elev"));
                                    String datum = cursor.getString(cursor.getColumnIndexOrThrow("datum"));
                                    int _zone = cursor.getInt(cursor.getColumnIndexOrThrow("_zone"));
                                    String ns = cursor.getString(cursor.getColumnIndexOrThrow("ns"));
                                    String descri = cursor.getString(cursor.getColumnIndexOrThrow("descri"));
                                    int concentrad = cursor.getInt(cursor.getColumnIndexOrThrow("concentrad"));
                                    boolean bobol0=(concentrad==1);
                                    String fragmentos = cursor.getString(cursor.getColumnIndexOrThrow("fragmentos"));
                                    String matriz = cursor.getString(cursor.getColumnIndexOrThrow("matriz"));
                                    String comp_frag = cursor.getString(cursor.getColumnIndexOrThrow("comp_frag"));
                                    String  compactaca = cursor.getString(cursor.getColumnIndexOrThrow("compactaca"));
                                    String ambiente = cursor.getString(cursor.getColumnIndexOrThrow("ambiente"));
                                    String  _data = cursor.getString(cursor.getColumnIndexOrThrow("_data"));
                                    String obs = cursor.getString(cursor.getColumnIndexOrThrow("obs"));
                                    int coletado = cursor.getInt(cursor.getColumnIndexOrThrow("coletado"));
                                    boolean bobol=(coletado==1);
                                    PreparedStatement st = conn.prepareStatement("UPDATE sedcor SET " +
                                            "amostra=?, duplicata=?, branco=?,padrao=?, reamostra=?,tipo=?," +
                                            " geom=ST_Transform(ST_GeomFromText('POINT("+utme+" "+utmn+" "+elev+")',4326),"+srid+")," +
                                            " elev=?, descri=?, concentrad=?, fragmentos=?, matriz=?,comp_frag=?," +
                                            "compactaca=?, ambiente=?," +
                                            "resp=?,_data=?,obs=?,coletado=?, who=? WHERE ponto=? ;");
                                    st.setString(1,amostra);
                                    st.setString(2,duplicata);
                                    st.setString(3,branco);
                                    st.setString(4,padrao);
                                    st.setString(5,reamostra);
                                    st.setString(6,tipo);
                                    st.setDouble(7,elev);
                                    st.setString(8,descri);
                                    st.setBoolean(9,bobol0);
                                    st.setString(10,fragmentos);
                                    st.setString(11,matriz);
                                    st.setString(12,comp_frag);
                                    st.setString(13,compactaca);
                                    st.setString(14,ambiente);
                                    st.setString(15,usu);
                                    st.setDate(16, Date.valueOf(_data));
                                    st.setString(17,obs);
                                    st.setBoolean(18, bobol);
                                    st.setString(19,usu);
                                    st.setString(20,ponto);
                                    st.executeUpdate();
                                    st.close();
                                    PreparedStatement st2 = conn.prepareStatement("INSERT INTO sedcor (projeto,alvo,ponto," +
                                            "amostra, duplicata,branco, padrao,reamostra,tipo,elev,utme,utmn,geom,datum," +
                                            "_zone,ns, descri,concentrad,fragmentos,matriz,comp_frag,compactaca," +
                                            "ambiente,resp,_data,obs,coletado," +
                                            "who)" +
                                            "SELECT ?,?,?,?,?,?,?,?,?,?,0,0," +
                                            "ST_Transform(ST_GeomFromText('POINT("+utme+" "+utmn+" "+elev+")',4326),"+srid+")," +
                                            "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?" +
                                            " WHERE NOT EXISTS (SELECT 1 FROM sedcor WHERE ponto='"+ponto+"')");
                                    st2.setString(1,projeto);
                                    st2.setString(2,alvo);
                                    st2.setString(3,ponto);
                                    st2.setString(4,amostra);
                                    st2.setString(5,duplicata);
                                    st2.setString(6,branco);
                                    st2.setString(7,padrao);
                                    st2.setString(8,reamostra);
                                    st2.setString(9,tipo);
                                    st2.setDouble(10,elev);
                                    st2.setString(11,datum);
                                    st2.setInt(12,_zone);
                                    st2.setString(13,ns);
                                    st2.setString(14,descri);
                                    st2.setBoolean(15,bobol0);
                                    st2.setString(16,fragmentos);
                                    st2.setString(17,matriz);
                                    st2.setString(18,comp_frag);
                                    st2.setString(19,compactaca);
                                    st2.setString(20,ambiente);
                                    st2.setString(21,usu);
                                    st2.setDate(22, Date.valueOf(_data));
                                    st2.setString(23,obs);
                                    st2.setBoolean(24, bobol);
                                    st2.setString(25,usu);
                                    st2.executeUpdate();
                                    st2.close();
                                }
                                PreparedStatement sts = conn.prepareStatement("UPDATE sedcor SET " +
                                        "utmn =st_Y(geom), utme=st_X(geom);");
                                sts.executeUpdate();
                                sts.close();
                                cursor.close();
                                //limpando tabelas sqlite
                                DbGateway.getInstance(getApplication().getApplicationContext()).getDatabase().
                                        delete("sedcor", null, null);
                                db.closeCon();
                                SedDAO dao = new SedDAO(getBaseContext());
                                dao.excluir();
                            }catch (Exception e) {
                                e.printStackTrace();
                                Toast.makeText(getApplicationContext(), "Falha ao Subir Dados Para o Servidor ",
                                        Toast.LENGTH_LONG).show();
                            }
                        }
                    };
                    new Thread(runnable).start();
                })
                .setNegativeButton("Cancelar", null)
                .create()
                .show();
    }
    private void exportDB() {
        Cursor cursor = DbGateway.getInstance(getApplication().
                getApplicationContext()).getDatabase().rawQuery(
                "SELECT * FROM sedcor where coletado=1",null);
        File exportDir = new File(getExternalFilesDir(null), "dados/");
        String fifi="sedcoletado_"+ LocalDate.now().toString()+"_"+usu+".csv";
        File file = new File(exportDir,fifi);
        try
        {
            CSVWriter csvWrite = new CSVWriter(new FileWriter(file));
            csvWrite.writeNext(cursor.getColumnNames());
            while(cursor.moveToNext())
            {
                String[] arrStr = new String[cursor.getColumnCount()];
                for (int i = 0; i < cursor.getColumnCount() - 1; i++){ arrStr[i] = cursor.getString(i);}
                csvWrite.writeNext(arrStr);
            }
            cursor.close();
            csvWrite.close();
            Toast.makeText(getApplicationContext(), "Dados gravados em arquivo "+fifi,
                    Toast.LENGTH_LONG).show();
        }
        catch(Exception sqlEx)
        {
            Log.e("MainActivity", sqlEx.getMessage(), sqlEx);
            Toast.makeText(getApplicationContext(), "Falha ao gravar arquivo "+fifi,
                    Toast.LENGTH_LONG).show();
        }
    }
    private void importaDB() {
        AlertDialog.Builder builder = new AlertDialog.Builder(findViewById(android.R.id.content).getRootView().getContext());
        builder.setTitle("CONTINUAR?")
                .setMessage("Ao Carregar o arquivo todos os dados serão substituidos neste App!!")
                .setPositiveButton("SIM", (dialog, which) -> {
                    SedDAO dao = new SedDAO(getBaseContext());
                    dao.excluir();
                    try {
                        File csvfile = new File(getExternalFilesDir(null) , "dados/dadossedcor.csv");
                        CSVReader reader = new CSVReader(new FileReader(csvfile.getAbsolutePath()));
                        String[] str;
                        reader.readNext();
                        while ((str = reader.readNext()) != null) {
                            String idd = str[0];
                            String projeto = str[1];
                            String alvo = str[2];
                            String ponto = str[3];
                            String amostra = str[4];
                            if(amostra.equals(""))amostra=null;
                            String duplicata = str[5];
                            String branco = str[6];
                            String padrao = str[7];
                            String reamostra = str[8];
                            String tipo = str[9];
                            String X = str[10];
                            String Y = str[11];
                            String eleva =str[12];
                            String datum = str[13];
                            String _zone = str[14];
                            String ns = str[15];
                            String descri = str[16];
                            String concentra = str[17];
                            int concentrad;
                            if(concentra.equals("0"))concentrad =0;
                            else concentrad =1;
                            String fragmentos = str[18];
                            String matriz = str[19];
                            String comp_frag =str[20];
                            String compactaca = str[21];
                            String ambiente = str[22];
                            String resp = str[23];
                            String _data = str[24];
                            String obs = str[25];
                            String coletado = str[26];
                            int coletadoint;
                            if(coletado.equals("0"))coletadoint =0;
                            else coletadoint =1;
                            String tstp = str[27];
                            String who = str[28];
                            boolean sucesso = dao.salvar(0, Integer.parseInt(idd), projeto, alvo,ponto, amostra, duplicata,
                                    branco, padrao, reamostra, tipo, Double.parseDouble(X), Double.parseDouble(Y), Double.parseDouble(eleva), datum, Integer.parseInt(_zone), ns, descri,
                                    concentrad, fragmentos, matriz, comp_frag, compactaca, ambiente,
                                    resp, _data, obs, coletadoint, tstp, who);
                            if (!sucesso) {Toast.makeText(getApplicationContext(), "Erro ao carregar dados",
                                    Toast.LENGTH_LONG).show();}
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                        Toast.makeText(this, "The specified file was not found", Toast.LENGTH_SHORT).show();
                    }
                    carrega();
                    Toast.makeText(getApplicationContext(), "Arquivo Carregado com sucesso!",
                            Toast.LENGTH_LONG).show();
                })
                .setNegativeButton("Cancelar", null)
                .create()
                .show();
    }
    public void mapu(int ma){
        final XYTileSource MBTILESRENDER = new XYTileSource("mbtiles",
                10, 21,96, ".png",
                new String[]{"https://tile.openstreetmap.org/"});

        if(ma==3) {
            map.setTileSource(MBTILESRENDER);
        }
        else{
            File f=new File(this.getDataDir(), "dados/tile2.mbtiles");
            if(ma==0)f= new File(getExternalFilesDir(null), "dados/tile2.mbtiles");
            if(ma==1)f= new File(getExternalFilesDir(null), "dados/tile2ii.mbtiles");
            if(ma==2)f= new File(getExternalFilesDir(null), "dados/tile2i.mbtiles");
            IArchiveFile[] files = { MBTilesFileArchive.getDatabaseFileArchive(f) };
            MapTileModuleProviderBase moduleProvider = new MapTileFileArchiveProvider(simpleReceiver, MBTILESRENDER, files);
            MapTileProviderArray mProvider = new MapTileProviderArray(MBTILESRENDER, null,
                    new MapTileModuleProviderBase[]{moduleProvider}
            );
            map.setTileProvider(mProvider);
        }
    }
}