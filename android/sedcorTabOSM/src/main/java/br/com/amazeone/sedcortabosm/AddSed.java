package br.com.amazeone.sedcortabosm;
 //   This program is free software; you can redistribute it and/or modify  *
 //   it under the terms of the is licensed under the BSD 3-Clause "New" or
 //   "Revised" License.
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

public class AddSed extends AppCompatActivity {

    String projeto="",alvo="",amostra="",duplicata="",branco="",padrao="",reamostra="",tipo="";
    String datum="",ns="",descri="",concentrad="",fragmentos="",matriz="",comp_frag="",ambiente="";
    String compactaca="",resp="",obs="",tstp="",venuePonto="",la="",lo="",elev="",who="";
    String coletadoint="",esco="";
    int idd=0;
    int _zone=23;
    int coletadoint2,concentrad2;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_sed);
        Bundle extras = getIntent().getExtras();
        venuePonto = extras.getString("VENUE_AMOSTRA");
        la = extras.getString("VENUE_LAT");
        lo = extras.getString("VENUE_LON");
        who = extras.getString("USU");
        elev=extras.getString("VENUE_ELEV");
        esco=extras.getString("ESCO");
        if(esco.equals("0")) Objects.requireNonNull(getSupportActionBar()).setTitle("INSERIR DADOS AMOSTRA SEDIMENTO "+venuePonto);
        else Objects.requireNonNull(getSupportActionBar()).setTitle("EDITAR DADOS AMOSTRA SEDIMENTO "+venuePonto);
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
        SedDAO dao = new SedDAO(getBaseContext());
        Cursor cursor = DbGateway.getInstance(getApplication().
                getApplicationContext()).getDatabase().rawQuery("SELECT id,projeto,alvo,amostra," +
                "ponto,duplicata,branco,padrao,reamostra,tipo,utmn,utme,elev,datum,tstp," +
                "_zone,ns,descri,concentrad,fragmentos,matriz,comp_frag,compactaca,ambiente," +
                "resp,obs,coletado FROM sedcor WHERE ponto='"+venuePonto+"'", null);
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
            descri = cursor.getString(cursor.getColumnIndexOrThrow("descri"));
            concentrad2 = cursor.getInt(cursor.getColumnIndexOrThrow("concentrad"));
            fragmentos = cursor.getString(cursor.getColumnIndexOrThrow("fragmentos"));
            matriz = cursor.getString(cursor.getColumnIndexOrThrow("matriz"));
            comp_frag = cursor.getString(cursor.getColumnIndexOrThrow("comp_frag"));
            compactaca = cursor.getString(cursor.getColumnIndexOrThrow("compactaca"));
            ambiente = cursor.getString(cursor.getColumnIndexOrThrow("ambiente"));
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
        EditText textDescri=findViewById(R.id.textDescri);
        textDescri.setText(descri);
        Spinner rgConc=findViewById(R.id.rgConc);
        rgConc.setSelection(getIndex(rgConc, concentrad));
        EditText textFrag=findViewById(R.id.textFrag);
        textFrag.setText(fragmentos);
        EditText textMatriz=findViewById(R.id.textMatriz);
        textMatriz.setText(matriz);
        EditText textCompFrag=findViewById(R.id.textcompfrag);
        textCompFrag.setText(comp_frag);
        EditText textCompactaca=findViewById(R.id.textCompac);
        textCompactaca.setText(compactaca);
        EditText textAmbiente=findViewById(R.id.textAmbiente);
        textAmbiente.setText(ambiente);
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
            descri = textDescri.getText().toString();
            fragmentos = textFrag.getText().toString();
            matriz = textMatriz.getText().toString();
            comp_frag = textCompFrag.getText().toString();
            compactaca = textCompactaca.getText().toString();
            resp = textResp.getText().toString();
            obs = textObs.getText().toString();
            tipo = rgTipo1.getSelectedItem().toString();
            ambiente = textAmbiente.getText().toString();
            coletadoint = rgColetado.getSelectedItem().toString();
            if (coletadoint.equals("SIM")) coletadoint2 = 1;
            else coletadoint2 = 0;
            if (concentrad.equals("SIM")) concentrad2 = 1;
            else concentrad2 = 0;
            if(amostra.equals("")){
                AlertDialog alertDialog = new AlertDialog.Builder(this).create();
                alertDialog.setTitle("Alerta");
                alertDialog.setMessage("Amostra  Obrigatório,\n Checar valor");
                alertDialog.setButton(AlertDialog.BUTTON_NEUTRAL, "OK",
                        (dialog, which) -> dialog.dismiss());
                alertDialog.show();
                return;
            }
            boolean sucesso = dao.salvar(1, idd, projeto, alvo, venuePonto, amostra, duplicata,
                    branco, padrao, reamostra, tipo, Double.parseDouble(lo), Double.parseDouble(la),
                    Double.parseDouble(elev), datum, _zone, ns, descri, concentrad2, fragmentos, matriz, comp_frag, compactaca, ambiente,
                     resp, LocalDate.now().toString(), obs, 1, Calendar.getInstance().getTime().toString(), who);
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
