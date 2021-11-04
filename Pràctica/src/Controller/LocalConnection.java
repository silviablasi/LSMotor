package Controller;

import Model.Settings;

import java.sql.*;

public class LocalConnection {

    private static String userName;
    private static String password;
    private static String db;
    private static int port;
    private static String url = "jdbc:mysql://localhost";
    private static Connection conn;
    private static Statement s;
    private static LocalConnection instance;

    public LocalConnection(String usr, String pass, String db, int port) {
        this.userName = usr;
        this.password = pass;
        this.db = db;
        this.port = port;
        this.url += ":"+port+"/";
        this.url += db;
        this.instance = null;
    }

    public void desconnectar(){
        try {
            conn.close();
            System.out.println("Desconnectat!");
        } catch (SQLException e) {
            System.out.println("Problema al tancar la connexió --> " + e.getSQLState());
        }
    }
/*
    public LocalConnection getInstance(){
        if(instance == null){
            instance = new LocalConnection("root", "002431", "oltp", 3306);
            instance.connect();
        }
        return  instance;
    }*/

    public boolean connect() {
        boolean connec = false;

        try {
            Class.forName("com.mysql.jdbc.Connection");
            conn = (Connection) DriverManager.getConnection(url, userName, password);
            if (conn != null) {
                System.out.println("Connexió a base de dades "+url+" ... Ok");
                connec = true;
            }
        }
        catch(SQLException ex) {
            System.out.println("Problema al connecta-nos a la BBDD --> "+ex.getSQLState() + " " + ex.getMessage());
            connec = false;
        }
        catch(ClassNotFoundException ex) {
            System.out.println(ex);
            connec = false;
        }
        return connec;
    }




    public void insertQuery(String query){
        try {
            s =(Statement) conn.createStatement();
            s.executeUpdate(query);

        } catch (SQLException ex) {
            System.out.println("Problema al Inserir --> " + ex.getSQLState());
            System.out.println(query);
            System.out.println(ex.getErrorCode());
            System.out.println(ex.getMessage());
            System.out.println(ex.getLocalizedMessage());
        }

    }

    public void updateQuery(String query){
        try {
            s =(Statement) conn.createStatement();
            s.executeUpdate(query);

        } catch (SQLException ex) {
            System.out.println("Problema al Modificar --> " + ex.getSQLState());
        }
    }

    public void deleteQuery(String query){
        try {
            s =(Statement) conn.createStatement();
            s.executeUpdate(query);

        } catch (SQLException ex) {
            System.out.println("Problema al Eliminar --> " + ex.getSQLState());
        }

    }

    public ResultSet selectQuery(String query){
        ResultSet rs = null;
        try {
            s =(Statement) conn.createStatement();
            rs = s.executeQuery (query);

        } catch (SQLException ex) {
            System.out.println("Problema al Recuperar les dades --> " + ex.getSQLState());
        }
        return rs;
    }

    public void disconnect(){
        try {
            conn.close();
            System.out.println("Desconnectat!");
        } catch (SQLException e) {
            System.out.println("Problema al desconnectar --> " + e.getSQLState());
        }
    }


    public void cridaProcedure(String procedure){
        CallableStatement stmt;
        try {
            stmt = conn.prepareCall(procedure);
            System.out.println(procedure + " en procés...");
            stmt.executeQuery();
            System.out.println("El següent procediment ha acabat amb èxit " + procedure);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
