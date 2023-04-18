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

public class AddSolo extends AppCompatActivity {
    String projeto="",alvo="",amostra="",duplicata="",branco="",padrao="",reamostra="",tipo="";
    String datum="",ns="",tipoperfil="",cor="",tipoamostr="",granul="",relevo="",fragmentos="";
    String magnetismo="",vegetacao="",resp="",obs="",tstp="",venuePonto="",la="",lo="",elev="",who="";
    String coletadoint="",esco="";
    double profm=0,peso=0;
    int idd=0;
    int _zone=23;
    int coletadoint2;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_solo);
        Bundle extras = getIntent().getExtras();
        venuePonto = extras.getString("VENUE_AMOSTRA");
        la = extras.getString("VENUE_LAT");
        lo = extras.getString("VENUE_LON");
        who = extras.getString("USU");
        elev=extras.getString("VENUE_ELEV");
        esco=extras.getString("ESCO");
        if(esco.equals("0"))Objects.requireNonNull(getSupportActionBar()).setTitle("INSERIR DADOS AMOSTRA SOLO "+venuePonto);
        else Objects.requireNonNull(getSupportActionBar()).setTitle("EDITAR DADOS AMOSTRA SOLO "+venuePonto);
        EditText textamo =  findViewById(R.id.textPonto);
        textamo.setText(venuePonto);
        textamo.setEnabled(false);
        EditText textla = findViewById(R.id.textLatitude);
        EditText textlo = findViewById(R.id.textLongitude);
        EditText textElev = findViewById(R.id.textElev);
        if(esco.equals("0")){
            textla.setText(la);
            textlo.setText(lo);
            textElev.setText(elev);
            textla.setEnabled(false);
            textlo.setEnabled(false);
            textElev.setEnabled(false);
        }
        SoloDAO dao = new SoloDAO(getBaseContext());
        Cursor cursor = DbGateway.getInstance(getApplication().
                getApplicationContext()).getDatabase().rawQuery("SELECT id,projeto,alvo,amostra," +
                "ponto,duplicata,branco,padrao,reamostra,tipo,utmn,utme,elev,datum,tstp," +
                "_zone,ns,tipoperfil,profm,cor,tipoamostr,granul,relevo,fragmentos,magnetismo," +
                "vegetacao,peso,resp,obs,coletado FROM soil WHERE ponto='"+venuePonto+"'", null);
        while (cursor.moveToNext()) {
            idd = cursor.getInt(cursor.getColumnIndexOrThrow("id"));
            projeto = cursor.getString(cursor.getColumnIndexOrThrow("projeto"));
            alvo = cursor.getString(cursor.getColumnIndexOrThrow("alvo"));
            amostra = cursor.getString(cursor.getColumnIndexOrThrow("amostra"));
            duplicata = cursor.getString(cursor.getColumnIndexOrThrow("duplicata"));
            branco = cursor.getString(cursor.getColumnIndexOrThrow("branco"));
            padrao = cursor.getString(cursor.getColumnIndexOrThrow("padrao"));
            reamostra = cursor.getString(cursor.getColumnIndexOrThrow("reamostra"));
            tipo = cursor.getString(cursor.getColumnIndexOrThrow("tipo"));
            if(esco.equals("1")){
                elev = cursor.getString(cursor.getColumnIndexOrThrow("elev"));
                la = cursor.getString(cursor.getColumnIndexOrThrow("utmn"));
                lo = cursor.getString(cursor.getColumnIndexOrThrow("utme"));
                textla.setText(la);
                textlo.setText(lo);
                textElev.setText(elev);
                textla.setEnabled(false);
                textlo.setEnabled(false);
                textElev.setEnabled(false);
            }
            datum = cursor.getString(cursor.getColumnIndexOrThrow("datum"));
            _zone = cursor.getInt(cursor.getColumnIndexOrThrow("_zone"));
            ns = cursor.getString(cursor.getColumnIndexOrThrow("ns"));
            tipoperfil = cursor.getString(cursor.getColumnIndexOrThrow("tipoperfil"));
            profm = cursor.getDouble(cursor.getColumnIndexOrThrow("profm"));
            cor = cursor.getString(cursor.getColumnIndexOrThrow("cor"));
            tipoamostr = cursor.getString(cursor.getColumnIndexOrThrow("tipoamostr"));
            granul = cursor.getString(cursor.getColumnIndexOrThrow("granul"));
            relevo = cursor.getString(cursor.getColumnIndexOrThrow("relevo"));
            fragmentos = cursor.getString(cursor.getColumnIndexOrThrow("fragmentos"));
            magnetismo = cursor.getString(cursor.getColumnIndexOrThrow("magnetismo"));
            vegetacao = cursor.getString(cursor.getColumnIndexOrThrow("vegetacao"));
            peso = cursor.getDouble(cursor.getColumnIndexOrThrow("peso"));
            resp = who;
            obs = cursor.getString(cursor.getColumnIndexOrThrow("obs"));
            tstp = cursor.getString(cursor.getColumnIndexOrThrow("tstp"));
            coletadoint2 = cursor.getInt(cursor.getColumnIndexOrThrow("coletado"));
        }
        cursor.close();
        EditText textProjeto=findViewById(R.id.textProjeto);
        textProjeto.setText(projeto);
        textProjeto.setEnabled(false);
        EditText textAlvo=findViewById(R.id.textAlvo);
        textAlvo.setText(alvo);
        textAlvo.setEnabled(false);
        EditText textAmostra=findViewById(R.id.textAmostra);
        textAmostra.setText(amostra);
        EditText textDuplicata=findViewById(R.id.textDuplicata);
        textDuplicata.setText(duplicata);
        EditText textBranco=findViewById(R.id.textBranco);
        textBranco.setText(branco);
        EditText textPadrao=findViewById(R.id.textPadrao);
        textPadrao.setText(padrao);
        EditText textReamostra=findViewById(R.id.textReamostra);
        textReamostra.setText(reamostra);
        Spinner rgTipo1 = findViewById(R.id.rgTipo1);
        rgTipo1.setSelection(getIndex(rgTipo1, tipo));
        EditText textDatum=findViewById(R.id.textDatum);
        textDatum.setText(datum);
        textDatum.setEnabled(false);
        EditText textZona=findViewById(R.id.textZona);
        textZona.setText(String.format(Locale.ENGLISH,"%d",_zone));
        textZona.setEnabled(false);
        Spinner rgNs=findViewById(R.id.rgNs);
        rgNs.setSelection(getIndex(rgNs, ns));
        rgNs.setEnabled(false);
        Spinner rgTipoperfil=findViewById(R.id.rgTipoperfil);
        rgTipoperfil.setSelection(getIndex(rgTipoperfil, tipoperfil));
        EditText textProfm=findViewById(R.id.textProfm);
        textProfm.setText(String.format(Locale.ENGLISH,"%f",profm));
        Spinner rgTextCor=findViewById(R.id.rgTextCor);
        rgTextCor.setSelection(getIndex(rgTextCor, cor));
        Spinner rgTipoamostra=findViewById(R.id.rgTipoamostra);
        rgTipoamostra.setSelection(getIndex(rgTipoamostra, tipoamostr));
        Spinner rgGranul=findViewById(R.id.rgGranul);
        rgGranul.setSelection(getIndex(rgGranul, granul));
        Spinner rgRelevo=findViewById(R.id.rgRelevo);
        rgRelevo.setSelection(getIndex(rgRelevo, relevo));
        Spinner rgFrag=findViewById(R.id.rgFrag);
        rgFrag.setSelection(getIndex(rgFrag, fragmentos));
        Spinner rgMag=findViewById(R.id.rgMag);
        rgMag.setSelection(getIndex(rgMag, magnetismo));
        Spinner rgTextVeg=findViewById(R.id.rgTextVeg);
        rgTextVeg.setSelection(getIndex(rgTextVeg, vegetacao));
        EditText textPeso=findViewById(R.id.textPeso);
        textPeso.setText(String.format(Locale.ENGLISH,"%f",peso));
        EditText textResp=findViewById(R.id.textResp);
        textResp.setText(resp);
        textResp.setEnabled(false);
        EditText textObs=findViewById(R.id.textObs);
        textObs.setText(obs);
        Spinner rgColetado=findViewById(R.id.rgColetado);
        if (coletadoint2==0) coletadoint = "NÃO";
        else coletadoint = "SIM";
        rgColetado.setSelection(getIndex(rgColetado, coletadoint));
        Button botafu = findViewById(R.id.insereButton);
        botafu.setOnClickListener(v -> {
            amostra = textAmostra.getText().toString();
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
            if(amostra.equals("") || profm<=0.0 || peso<0.0){
                AlertDialog alertDialog = new AlertDialog.Builder(this).create();
                alertDialog.setTitle("Alerta");
                alertDialog.setMessage("Amostra e Profundidade Obrigatórios,\n Checar valor também");
                alertDialog.setButton(AlertDialog.BUTTON_NEUTRAL, "OK",
                        (dialog, which) -> dialog.dismiss());
                alertDialog.show();
                return;
            }
            boolean sucesso = dao.salvar(1, idd, projeto, alvo, venuePonto, amostra, duplicata,
                    branco, padrao, reamostra, tipo, Double.parseDouble(lo), Double.parseDouble(la),
                    Double.parseDouble(elev), datum, _zone, ns, tipoperfil, profm, cor, tipoamostr, granul, relevo, fragmentos,
                    magnetismo, vegetacao, peso, resp, LocalDate.now().toString(), obs, 1, Calendar.getInstance().getTime().toString(), who);
            if (sucesso) {System.out.println("Vixe Maria Atualizou Massa ");
                Toast.makeText(getApplicationContext(), "Sucesso", Toast.LENGTH_LONG).show();
                finish();
            }else{Toast.makeText(getApplicationContext(), "Erro ao Atualizar dado.Checar Número Amostra",
                    Toast.LENGTH_LONG).show();
                System.out.println("Vixe Maria não Atualizou, melhor checar ");}
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