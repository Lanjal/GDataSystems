package br.com.amazeone.soiltabosm;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;


import android.database.Cursor;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import java.time.LocalDate;
import java.util.Calendar;
import java.util.Locale;
import java.util.Objects;

public class NewSolo extends AppCompatActivity {
    String projeto="",alvo="",amostra="",duplicata="",branco="",padrao="",reamostra="",tipo="";
    String datum="",ns="",tipoperfil="",cor="",tipoamostr="",granul="",relevo="",fragmentos="";
    String magnetismo="",vegetacao="",resp="",obs="",la="",ponto="",lo="",elev="",who="";
    String coletadoint="";
    double profm=0,peso=0;
    int _zone=23;
    int coletadoint2;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_solo);
        Bundle extras = getIntent().getExtras();
        la = extras.getString("VENUE_LAT");
        lo = extras.getString("VENUE_LON");
        who = extras.getString("USU");
        elev = extras.getString("VENUE_ELEV");
        Objects.requireNonNull(getSupportActionBar()).setTitle("INSERIR NOVO DADO SOLO ");
        EditText textla =  findViewById(R.id.textLatituden);
        textla.setText(la);
        EditText textlo =  findViewById(R.id.textLongituden);
        textlo.setText(lo);
        EditText textElev =  findViewById(R.id.textElevn);
        textElev.setText(elev);
        textla.setEnabled(false);
        textlo.setEnabled(false);
        textElev.setEnabled(false);
        SoloDAO dao = new SoloDAO(getBaseContext());
        EditText textPonto=findViewById(R.id.textPonton);
        Cursor cursor = DbGateway.getInstance(getApplication().
                getApplicationContext()).getDatabase().rawQuery("SELECT projeto,alvo," +
                "datum,_zone,ns FROM soil limit 1", null);
        while (cursor.moveToNext()) {
            projeto=cursor.getString(cursor.getColumnIndexOrThrow("projeto"));
            alvo=cursor.getString(cursor.getColumnIndexOrThrow("alvo"));
            datum=cursor.getString(cursor.getColumnIndexOrThrow("datum"));
            ns=cursor.getString(cursor.getColumnIndexOrThrow("ns"));
            _zone=cursor.getInt(cursor.getColumnIndexOrThrow("_zone"));
        }
        cursor.close();
        EditText textProjeto=findViewById(R.id.textProjeton);
        textProjeto.setText(projeto);
        textProjeto.setEnabled(false);
        EditText textAlvo=findViewById(R.id.textAlvon);
        textAlvo.setText(alvo);
        textAlvo.setEnabled(false);
        EditText textDatum=findViewById(R.id.textDatumn);
        textDatum.setText(datum);
        textDatum.setEnabled(false);
        EditText textZona=findViewById(R.id.textZonan);
        textZona.setText(String.format(Locale.ENGLISH,"%d",_zone));
        textZona.setEnabled(false);
        Spinner rgNs=findViewById(R.id.rgNsn);
        rgNs.setSelection(getIndex(rgNs, ns));
        rgNs.setEnabled(false);
        EditText textAmostra=findViewById(R.id.textAmostran);
        EditText textDuplicata=findViewById(R.id.textDuplicatan);
        EditText textBranco=findViewById(R.id.textBrancon);
        EditText textPadrao=findViewById(R.id.textPadraon);
        EditText textReamostra=findViewById(R.id.textReamostran);
        Spinner rgTipo1 = findViewById(R.id.rgTipo1n);
        Spinner rgTipoperfil=findViewById(R.id.rgTipoperfiln);
        EditText textProfm=findViewById(R.id.textProfmn);
        textProfm.setText(String.format(Locale.ENGLISH,"%f",profm));
        Spinner rgTextCor=findViewById(R.id.rgTextCorn);
        Spinner rgTipoamostra=findViewById(R.id.rgTipoamostran);
        Spinner rgGranul=findViewById(R.id.rgGranuln);
        Spinner rgRelevo=findViewById(R.id.rgRelevon);
        Spinner rgFrag=findViewById(R.id.rgFragn);
        Spinner rgMag=findViewById(R.id.rgMagn);
        Spinner rgTextVeg=findViewById(R.id.rgTextVegn);
        EditText textPeso=findViewById(R.id.textPeson);
        textPeso.setText(String.format(Locale.ENGLISH,"%f",peso));
        EditText textResp=findViewById(R.id.textRespn);
        textResp.setText(who);
        textResp.setEnabled(false);
        EditText textObs=findViewById(R.id.textObsn);
        Spinner rgColetado=findViewById(R.id.rgColetadon);
        Button botafu = findViewById(R.id.insereButtonn);
        botafu.setOnClickListener(v -> {
            projeto=textProjeto.getText().toString();
            alvo=textAlvo.getText().toString();
            ponto=textPonto.getText().toString();
            amostra = textAmostra.getText().toString();
            datum = textDatum.getText().toString();
            //_zone = Integer.getInteger(textZona.getText().toString());
            ns = rgNs.getSelectedItem().toString();
            duplicata = textDuplicata.getText().toString();
            branco = textBranco.getText().toString();
            padrao = textPadrao.getText().toString();
            reamostra = textReamostra.getText().toString();
            elev = textElev.getText().toString();
            if(textProfm.getText().toString().equals(".") || textProfm.getText().toString().equals(""))profm=0.0;
            else profm = Double.parseDouble(textProfm.getText().toString());
            cor = rgTextCor.getSelectedItem().toString();
            vegetacao = rgTextVeg.getSelectedItem().toString();
            resp = textResp.getText().toString();
            if(textPeso.getText().toString().equals(".") || textPeso.getText().toString().equals(""))peso=0.0;
            else peso = Double.parseDouble(textPeso.getText().toString());
            obs = textObs.getText().toString();
            tipo = rgTipo1.getSelectedItem().toString();
            tipoperfil = rgTipoperfil.getSelectedItem().toString();
            tipoamostr = rgTipoamostra.getSelectedItem().toString();
            granul = rgGranul.getSelectedItem().toString();
            relevo = rgRelevo.getSelectedItem().toString();
            fragmentos = rgFrag.getSelectedItem().toString();
            magnetismo = rgMag.getSelectedItem().toString();
            coletadoint = rgColetado.getSelectedItem().toString();
            if (coletadoint.equals("SIM")) coletadoint2 = 1;
            else coletadoint2 = 0;
            if(amostra.equals("") || profm<=0.0 || ponto.equals("")){
                AlertDialog alertDialog = new AlertDialog.Builder(this).create();
                alertDialog.setTitle("Alerta");
                alertDialog.setMessage("Amostra, Ponto e Profundidade Obrigatórios,\n Checar valor Peso também");
                alertDialog.setButton(AlertDialog.BUTTON_NEUTRAL, "OK",
                        (dialog, which) -> dialog.dismiss());
                alertDialog.show();
                return;
            }
            boolean sucesso = dao.salvar(0, projeto, alvo, ponto, amostra, duplicata,
                    branco, padrao, reamostra, tipo, Double.parseDouble(lo), Double.parseDouble(la),
                    Double.parseDouble(elev), datum, _zone, ns, tipoperfil, profm, cor, tipoamostr, granul, relevo, fragmentos,
                    magnetismo, vegetacao, peso, resp, LocalDate.now().toString(), obs, 1, Calendar.getInstance().getTime().toString(), who);
            if (sucesso) {System.out.println("Vixe Maria inseriu Massa ");
                Toast.makeText(getApplicationContext(), "Sucesso", Toast.LENGTH_LONG).show();
                finish();
            }else{Toast.makeText(getApplicationContext(), "Erro ao inserir dado.Checar Número Amostra",
                    Toast.LENGTH_LONG).show();
                System.out.println("Vixe Maria não inseriu, melhor checar ");}
        });
    }
    private int getIndex(Spinner spinner, String myString){
        for (int i=0;i<spinner.getCount();i++){
            if (spinner.getItemAtPosition(i).toString().equalsIgnoreCase(myString)){
                return i;
            }
        }
        return 0;
    }
}