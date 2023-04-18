package br.com.amazeone.sedcortabosm;
 //   This program is free software; you can redistribute it and/or modify  *
 //   it under the terms of the is licensed under the BSD 3-Clause "New" or
 //   "Revised" License.

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

public class DbGateway {
    private static DbGateway gw;
    private final SQLiteDatabase db;
    private DbGateway(Context ctx){
        DbHelper helper = new DbHelper(ctx);
        db = helper.getWritableDatabase();
    }

    public static DbGateway getInstance(Context ctx){
        if(gw == null)
            gw = new DbGateway(ctx);
        return gw;
    }

    public SQLiteDatabase getDatabase(){
        return this.db;
    }
}
