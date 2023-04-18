package br.com.amazeone.soiltabosm;

import android.content.ContentValues;
import android.content.Context;


public class SoloDAO {
    private final String TABLE_SOLO = "soil";
    private final DbGateway gw;

    public SoloDAO(Context ctx){
        gw = DbGateway.getInstance(ctx);
    }

    public boolean salvar(int id,String projeto, String alvo, String ponto,String amostra, String duplicata, String branco,
                          String padrao,String reamostra, String tipo, double utme, double utmn, double elev,
                          String datum, int _zone, String ns, String tipoperfil, double profm,
                          String cor, String tipoamostr, String granul, String relevo,String fragmentos,
                          String magnetismo, String vegetacao, double peso, String resp, String _data,
                          String obs, int coletado,String tstp, String who){
        return salvar(0,id, projeto, alvo,ponto,amostra,duplicata,branco,padrao,reamostra,tipo, utme,utmn,
                elev,datum,_zone,ns,tipoperfil,profm,cor,tipoamostr,granul,relevo,fragmentos,
                magnetismo,vegetacao,peso,resp,_data,obs,coletado,tstp,who) ;
    }

    public boolean salvar(int ido,int id,String projeto, String alvo, String ponto,String amostra, String duplicata, String branco,
                          String padrao,String reamostra, String tipo, double utme, double utmn, double elev,
                          String datum, int _zone, String ns, String tipoperfil, double profm,
                          String cor, String tipoamostr, String granul, String relevo,String fragmentos,
                          String magnetismo, String vegetacao, double peso, String resp, String _data,
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
        cv.put("tipoperfil", tipoperfil);
        cv.put("profm", profm);
        cv.put("cor", cor);
        cv.put("tipoamostr", tipoamostr);
        cv.put("granul", granul);
        cv.put("relevo", relevo);
        cv.put("fragmentos", fragmentos);
        cv.put("magnetismo", magnetismo);
        cv.put("vegetacao", vegetacao);
        cv.put("peso", peso);
        cv.put("resp", resp);
        cv.put("_data", _data);
        cv.put("obs", obs);
        cv.put("coletado", coletado);
        cv.put("tstp", tstp);
        cv.put("who", who);
        if (ido > 0) {
            cv.put("id", id);
            return gw.getDatabase().update(TABLE_SOLO, cv, "ponto=?", new String[]{ponto + ""}) > 0;
        }
        else
            return gw.getDatabase().insert(TABLE_SOLO, null, cv) > 0;
    }

    public void excluir(){
        gw.getDatabase().execSQL("delete from "+ TABLE_SOLO);
    }
}
