package Controller;

import Model.Settings;

import java.sql.*;
import java.util.ArrayList;

public class BBDConnection {

    static String userName;
    static String password;
    static String db;
    static int port;
    static String url = "jdbc:mysql://puigpedros.salle.url.edu";

    static java.sql.Connection connPuigpedros;

    private Connection remoteConnection = null;
    static Statement s;

    private boolean connectedPuigpedros;

    private Statement statementLocal = null;
    private Statement statementPuigpedros = null;

    public BBDConnection(String usr, String pass, String db, int port) {
        BBDConnection.userName = usr;
        BBDConnection.password = pass;
        BBDConnection.db = db;
        BBDConnection.port = port;
        BBDConnection.url += ":"+port+"/";
        BBDConnection.url += db;
        BBDConnection.url += "?verifyServerCertificate=false&useSSL=false";
    }


    public boolean connect() {

        try {
            Class.forName("com.mysql.jdbc.Connection");
            remoteConnection = (Connection) DriverManager.getConnection(url, userName, password);
            if (remoteConnection != null) {
                System.out.println("Conexió a base de dades "+url+" ... Ok");
            }
            return true;
        }
        catch(SQLException ex) {
            System.out.println("Problema al connecta-nos a la BBDD --> "+ ex.getSQLState());
        }
        catch(ClassNotFoundException ex) {
            System.out.println(ex);
        }
        return false;

    }

    public static Connection getConnPuigpedros() {
        return connPuigpedros;
    }

    // QUERIES

    public void insertQuery(String query) {
        try {
            s = (Statement) remoteConnection.createStatement();
            s.executeUpdate(query);

        } catch (SQLException ex) {
            System.out.println("Problema al Inserir --> " + ex.getSQLState());
        }
    }

    public void updateQuery(String query) {
        try {
            s = (Statement) remoteConnection.createStatement();
            s.executeUpdate(query);

        } catch (SQLException ex) {
            System.out.println("Problema al Modificar --> " + ex.getSQLState());
        }
    }

    public void deleteQuery(String query) {
        try {
            s = (Statement) remoteConnection.createStatement();
            s.executeUpdate(query);

        } catch (SQLException ex) {
            System.out.println("Problema al Eliminar --> " + ex.getSQLState());
        }

    }

    public ResultSet selectQuery(String query) {
        ResultSet rs = null;
        try {
            s = (Statement) remoteConnection.createStatement();
            rs = s.executeQuery(query);

        } catch (SQLException ex) {
            System.out.println("Problema al Recuperar les dades --> " + ex.getSQLState());
        }
        return rs;
    }

    public void disconnect() {
        try {
            remoteConnection.close();
            System.out.println("Desconnectat!");
        } catch (SQLException e) {
            System.out.println("Problema al tancar la connexió --> " + e.getSQLState());
        }
    }





/*
        aux2=smtRemote.executeQuery("SELECT * FROM constructorResults;");
        System.out.println("OMPLINT CIRCUITS...");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO constructorResults(constructorResultsId,raceId, constructorId, points, status)"+" VALUES(?,?,?,?,?;");
            //incializar!!
            pstmt.setInt(1,aux2.getInt("constructorResultsId"));
            pstmt.setInt(2,aux2.getInt("raceId"));
            pstmt.setInt(3,aux2.getInt("constructorId"));
            pstmt.setInt(4,aux2.getDouble("points"));
            pstmt.setString(5,aux2.getString("status"));
            pstmt.execute();
        }

        aux2=smtRemote.executeQuery("SELECT * FROM constructorStandings;");
        System.out.println("OMPLINT CIRCUITS...");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO constructorStandings(constructorStandingsId,raceId, constructorId, points, position, positionText, wins)"+" VALUES(?,?,?,?,?,?,?;");
            //incializar!!
            pstmt.setInt(1,aux2.getInt("constructorStandingsId"));
            pstmt.setInt(2,aux2.getInt("raceId"));
            pstmt.setInt(3,aux2.getInt("constructorId"));
            pstmt.setInt(4,aux2.getDouble("points");
            pstmt.setInt(5,aux2.getInt("position"));
            pstmt.setString(6,aux2.getString("positionText"));
            pstmt.setInt(7,aux2.getInt("wins"));

            pstmt.execute();
        }

        aux2=smtRemote.executeQuery("SELECT * FROM drivers;");
        System.out.println("OMPLINT DRIVERS...");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO drivers(driverId,driverRef, number, code, forename, surname, dob, nationality, url)"+" VALUES(?,?,?,?,?,?,?,?,?;");
            //incializar!!
            pstmt.setInt(1,aux2.getInt("driverId"));
            pstmt.setString(6,aux2.getString("driverRef"));
            pstmt.setInt(3,aux2.getInt("number"));
            pstmt.setString(4,aux2.getString("code"));
            pstmt.setString(5,aux2.getString("forename"));
            pstmt.setString(6,aux2.getString("surname"));
            pstmt.setInt(7,aux2.getDate("dob"));
            pstmt.setString(8,aux2.getString("nationality"));
            pstmt.setString(9,aux2.getString("url"));

            pstmt.execute();
        }

        aux2=smtRemote.executeQuery("SELECT * FROM driverStandings;");
        System.out.println("OMPLINT DRIVERS...");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO driverStandings(driverStandingsId,raceId, driverId, points, position, positionText, wins)"+" VALUES(?,?,?,?,?,?,?;");
            //incializar!!
            pstmt.setInt(1,aux2.getInt("driverStandingsId"));
            pstmt.setInt(2,aux2.getInt("raceId"));
            pstmt.setInt(3,aux2.getInt("driverId"));
            pstmt.setInt(4,aux2.getDouble("points");
            pstmt.setInt(5,aux2.getInt("position"));
            pstmt.setString(6,aux2.getString("code"));
            pstmt.setString(7,aux2.getString("positionText"));
            pstmt.setInt(8,aux2.getInt("wins"));

            pstmt.execute();
        }

        aux2=smtRemote.executeQuery("SELECT * FROM lapTimes;");
        System.out.println("OMPLINT DRIVERS...");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO lapTimes(raceId, driverId, lap, position, time, milliseconds)"+" VALUES(?,?,?,?,?,?,?;");
            //incializar!!

            pstmt.setInt(1,aux2.getInt("raceId"));
            pstmt.setInt(2,aux2.getInt("driverId"));
            pstmt.setInt(3,aux2.getInt("lap"));
            pstmt.setInt(4,aux2.getInt("position"));
            pstmt.setString(5,aux2.getString("time"));
            pstmt.setInt(6,aux2.getInt("milliseconds"));

            pstmt.execute();
        }

        aux2=smtRemote.executeQuery("SELECT * FROM pitStops;");
        System.out.println("OMPLINT DRIVERS...");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO pitStops(raceId, driverId, stop, lap, time, duration, milliseconds)"+" VALUES(?,?,?,?,?,?,?;");
            //incializar!!

            pstmt.setInt(1,aux2.getInt("raceId"));
            pstmt.setInt(2,aux2.getInt("driverId"));
            pstmt.setInt(3,aux2.getInt("stop"));
            pstmt.setInt(4,aux2.getInt("lap"));
            pstmt.setString(5,aux2.getTime("time"));
            pstmt.setString(6,aux2.getString("duration"));
            pstmt.setInt(7,aux2.getInt("milliseconds"));

            pstmt.execute();
        }

        aux2=smtRemote.executeQuery("SELECT * FROM qualifying;");
        System.out.println("OMPLINT DRIVERS...");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO qualifying(qualifyId, raceId, driverId, constructorId, number, position, q1, q2, q3)"+" VALUES(?,?,?,?,?,?,?, ?, ?;");
            //incializar!!
            pstmt.setInt(1,aux2.getInt("qualifyId"));
            pstmt.setInt(2,aux2.getInt("raceId"));
            pstmt.setInt(3,aux2.getInt("driverId"));
            pstmt.setInt(4,aux2.getInt("constructorId"));
            pstmt.setInt(5,aux2.getInt("number"));
            pstmt.setInt(6,aux2.getInt("position"));
            pstmt.setString(7,aux2.getString("q1"));
            pstmt.setString(8,aux2.getString("q2"));
            pstmt.setString(9,aux2.getString("q3"));


            pstmt.execute();
        }

        aux2=smtRemote.executeQuery("SELECT * FROM results;");
        System.out.println("OMPLINT DRIVERS...");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO results(resultId, raceId, driverId, constructorId, number, grid, position, positionText, positionOrder, " +
                    "points, laps, time, milliseconds, fasterLap, rank, fastestLapTime, fastestLapSpeed, statusId,)"+" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?;");
            //incializar!!
            pstmt.setInt(1,aux2.getInt("resultId"));
            pstmt.setInt(2,aux2.getInt("raceId"));
            pstmt.setInt(3,aux2.getInt("driverId"));
            pstmt.setInt(4,aux2.getInt("constructorId"));
            pstmt.setInt(5,aux2.getInt("number"));
            pstmt.setInt(6,aux2.getInt("grid"));
            pstmt.setInt(7,aux2.getInt("position"));
            pstmt.setString(8,aux2.getString("positionText"));
            pstmt.setInt(9,aux2.getInt("positionOrder"));
            pstmt.setInt(10,aux2.getDouble("points");
            pstmt.setInt(11,aux2.getInt("laps"));
            pstmt.setString(12,aux2.getString("time"));
            pstmt.setInt(13,aux2.getInt("milliseconds"));
            pstmt.setInt(14,aux2.getInt("fastestLap"));
            pstmt.setInt(15,aux2.getInt("rank"));
            pstmt.setString(16,aux2.getString("fastestLapTime"));
            pstmt.setString(17,aux2.getString("fastestLapSpeed"));
            pstmt.setInt(17,aux2.getInt("statusId"));



            pstmt.execute();
        }

        aux2=smtRemote.executeQuery("SELECT * FROM seasons;");
        System.out.println("OMPLINT DRIVERS...");
        while (aux2.next()){
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO seasons(year, url)"+" VALUES(?,?;");
            //incializar!!
            pstmt.setInt(1,aux2.getInt("year"));
            pstmt.setString(2,aux2.getString("url"));
            pstmt.execute();
        }


    }
*/


}




