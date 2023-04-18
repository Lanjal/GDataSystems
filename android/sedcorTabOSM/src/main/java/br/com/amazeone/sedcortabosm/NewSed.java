package br.com.amazeone.sedcortabosm;

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

public class NewSed extends AppCompatActivity {

    String ponto="",projeto="",alvo="",amostra="",duplicata="",branco="",padrao="",reamostra="",tipo="";
    String datum="",ns="",descri="",concentrad="",fragmentos="",matriz="",comp_frag="",ambiente="";
    String compactaca="",resp="",obs="",la="",lo="",elev="",who="";
    String coletadoint="";
    int _zone=23;
    int coletadoint2,concentrad2;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_sed);
        Bundle extras = getIntent().getExtras();
        la = extras.getString("VENUE_LAT");
        lo = extras.getString("VENUE_LON");
        who = extras.getString("USU");
        elev = extras.getString("VENUE_ELEV");
        Objects.requireNonNull(getSupportActionBar()).setTitle("INSERIR NOVO DADO SEDIMENTO ");
        EditText textla =  findViewById(R.id.textLatituden);
        textla.setText(la);
        EditText textlo =  findViewById(R.id.textLongituden);
        textlo.setText(lo);
        EditText textElev =  findViewById(R.id.textElevn);
        textElev.setText(elev);
        textla.setEnabled(false);
        textlo.setEnabled(false);
        textElev.setEnabled(false);
        SedDAO dao = new SedDAO(getBaseContext());
        EditText textPonto=findViewById(R.id.textPonton);
        Cursor cursor = DbGateway.getInstance(getApplication().
                getApplicationContext()).getDatabase().rawQuery("SELECT projeto,alvo," +
                "datum,_zone,ns FROM sedcor limit 1", null);
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
        EditText textAmostra=findViewById(R.id.textAmostran);
        textAmostra.setText(amostra);
        EditText textDuplicata=findViewById(R.id.textDuplicatan);
        textDuplicata.setText(duplicata);
        EditText textBranco=findViewById(R.id.textBrancon);
        textBranco.setText(branco);
        EditText textPadrao=findViewById(R.id.textPadraon);
        textPadrao.setText(padrao);
        EditText textReamostra=findViewById(R.id.textReamostran);
        textReamostra.setText(reamostra);
        Spinner rgTipo1 = findViewById(R.id.rgTipo1n);
        rgTipo1.setSelection(getIndex(rgTipo1, tipo));
        EditText textDatum=findViewById(R.id.textDatumn);
        textDatum.setText(datum);
        textDatum.setEnabled(false);
        EditText textZona=findViewById(R.id.textZonan);
        textZona.setText(String.format(Locale.ENGLISH,"%d",_zone));
        textZona.setEnabled(false);
        Spinner rgNs=findViewById(R.id.rgNsn);
        rgNs.setSelection(getIndex(rgNs, ns));
        rgNs.setEnabled(false);
        EditText textDescri=findViewById(R.id.textDescrin);
        textDescri.setText(descri);
        Spinner rgConc=findViewById(R.id.rgConcn);
        rgConc.setSelection(getIndex(rgConc, concentrad));
        EditText textFrag=findViewById(R.id.textFragn);
        textFrag.setText(fragmentos);
        EditText textMatriz=findViewById(R.id.textMatrizn);
        textMatriz.setText(matriz);
        EditText textCompFrag=findViewById(R.id.textcompfragn);
        textCompFrag.setText(comp_frag);
        EditText textCompactaca=findViewById(R.id.textCompacn);
        textCompactaca.setText(compactaca);
        EditText textAmbiente=findViewById(R.id.textAmbienten);
        textAmbiente.setText(ambiente);
        EditText textResp=findViewById(R.id.textRespn);
        textResp.setText(resp);
        textResp.setEnabled(false);
        EditText textObs=findViewById(R.id.textObsn);
        textObs.setText(obs);
        Spinner rgColetado=findViewById(R.id.rgColetadon);
        if (coletadoint2==0) coletadoint = "NÃO";
        else coletadoint = "SIM";
        rgColetado.setSelection(getIndex(rgColetado, coletadoint));
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
            boolean sucesso = dao.salvar(0, projeto, alvo, ponto, amostra, duplicata,
                    branco, padrao, reamostra, tipo, Double.parseDouble(lo), Double.parseDouble(la),
                    Double.parseDouble(elev), datum, _zone, ns,  descri, concentrad2, fragmentos, matriz, comp_frag, compactaca, ambiente,
                    resp, LocalDate.now().toString(), obs, 1, Calendar.getInstance().getTime().toString(), who);
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