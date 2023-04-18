package br.com.amazeone.sedcortabosm;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class DbHelper extends SQLiteOpenHelper{
    private static final String DATABASE_NAME = "sedm1.db";
    private static final int DATABASE_VERSION = 1;
    public DbHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        final String CREATE_TABLE = "CREATE TABLE sedcor (id INTEGER PRIMARY KEY AUTOINCREMENT, projeto TEXT,alvo TEXT, " +
                "amostra TEXT ,ponto TEXT NOT NULL, duplicata TEXTO, branco TEXT, padrao TEXT," +
                "reamostra TEXT, tipo TEXT, utme REAL NOT NULL, utmn REAL NOT NULL,"+
                "elev REAL, datum TEXT, _zone INTEGER, ns TEXT, descri TEXT,concentrad INTEGER, "+
                "fragmentos TEXT, matriz TEXT,comp_frag TEXT,compactaca TEXT,ambiente TEXT, "+
                " resp TEXT, _data DATE, obs TEXT, coletado BOOLEAN, tstp DATETIME DEFAULT " +
                "CURRENT_TIMESTAMP,who text NOT NULL,extra1 TEXT,extra2 TEXT,extra3 TEXT, " +
                "extra10 REAL, extra20 REAL, extra30 REAL);";
        db.execSQL(CREATE_TABLE);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
    }
}
