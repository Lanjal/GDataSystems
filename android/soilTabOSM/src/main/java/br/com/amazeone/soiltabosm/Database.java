package br.com.amazeone.soiltabosm;
 //   This program is free software; you can redistribute it and/or modify  *
 //   it under the terms of the is licensed under the BSD 3-Clause "New" or
 //   "Revised" License.
import java.sql.Connection;
import java.sql.DriverManager;

public class Database {
    private Connection connection;
    private final String user;
    private final String pass;
    private String url = "jdbc:postgresql://%s:%d/%s";
    private boolean status;

    public Database(String u,String p,String db,String hos) {
        user=u;
        pass=p;
        int port = 5432;
        this.url = String.format(this.url, hos, port, db);
        connect();
    }

    private void connect() {
        Thread thread = new Thread(() -> {
            try {
                Class.forName("org.postgresql.Driver");
                connection = DriverManager.getConnection(url, user, pass);
                status = true;
            } catch (Exception e) {
                status = false;
                e.printStackTrace();
            }
        });
        thread.start();
        try {
            thread.join();
        } catch (Exception e) {
            e.printStackTrace();
            this.status = false;
        }
    }

    public Connection getExtraConnection(){
        return connection;
    }

    public void closeCon(){
        try{connection.close();
        } catch (Exception e) {
            status = false;
            e.printStackTrace();
        }
    }

    public boolean getStatus(){
        return status;
    }
}
