package br.com.amazeone.sedcortabosm;
 //   This program is free software; you can redistribute it and/or modify  *
 //   it under the terms of the is licensed under the BSD 3-Clause "New" or
 //   "Revised" License.
import android.content.ContentValues;
import android.content.Context;

public class SedDAO {
    private final String TABLE_SED = "sedcor";
    private final DbGateway gw;
    public SedDAO(Context ctx){
        gw = DbGateway.getInstance(ctx);
    }

    public boolean salvar(int id,String projeto, String alvo, String ponto,String amostra, String duplicata, String branco,
                          String padrao,String reamostra, String tipo, double utme, double utmn, double elev,
                          String datum, int _zone, String ns, String descri, int concentrad, String fragmentos, String matriz,
                          String comp_frag, String compactaca, String ambiente, String resp, String _data,
                          String obs, int coletado,String tstp, String who){
        return salvar(0,id, projeto, alvo,ponto,amostra,duplicata,branco,padrao,reamostra,tipo, utme,utmn,
                elev,datum,_zone,ns, descri, concentrad, fragmentos, matriz, comp_frag, compactaca, ambiente,resp,_data,obs,coletado,tstp,who) ;
    }

    public boolean salvar(int ido,int id,String projeto, String alvo, String ponto,String amostra, String duplicata, String branco,
                          String padrao,String reamostra, String tipo, double utme, double utmn, double elev,
                          String datum, int _zone, String ns, String descri, int concentrad, String fragmentos, String matriz,
                          String comp_frag, String compactaca, String ambiente,String resp, String _data,
                          String obs, int coletado,String tstp, String who) {
        ContentValues cv = new ContentValues();
        cv.put("projeto", projeto);
        cv.put("alvo", alvo);
        cv.put("ponto", ponto);
        cv.put("amostra", amostra);
        cv.put("duplicata", duplicata);
        cv.put("branco", branco);
        cv.put("padrao", padrao);
        cv.put("reamostra", reamostra);
        cv.put("tipo", tipo);
        cv.put("utme", utme);
        cv.put("utmn", utmn);
        cv.put("elev", elev);
        cv.put("datum", datum);
        cv.put("_zone", _zone);
        cv.put("ns", ns);
        cv.put("descri", descri);
        cv.put("concentrad", concentrad);
        cv.put("fragmentos", fragmentos);
        cv.put("matriz", matriz);
        cv.put("comp_frag", comp_frag);
        cv.put("compactaca", compactaca);
        cv.put("ambiente", ambiente);
        cv.put("resp", resp);
        cv.put("_data", _data);
        cv.put("obs", obs);
        cv.put("coletado", coletado);
        cv.put("tstp", tstp);
        cv.put("who", who);
        if (ido > 0) {
            cv.put("id", id);
            return gw.getDatabase().update(TABLE_SED, cv, "ponto=?", new String[]{ponto + ""}) > 0;
        }
        else
            return gw.getDatabase().insert(TABLE_SED, null, cv) > 0;
    }

    public void excluir(){
        gw.getDatabase().execSQL("delete from "+ TABLE_SED);
    }
}
