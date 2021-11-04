package Model;
import Controller.Controller;
import Controller.LocalConnection;
import Controller.BBDConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.Scanner;


public class Importacions {
    private Scanner sc;
    private String password_local;
    private boolean connectedPuigpedros;
    private BBDConnection connPuigpedros;

    private boolean localConnectat;
    private LocalConnection novaConnLocal;
    private Controller c;

    public Importacions() {
        Scanner sc1;
        this.localConnectat = false;
        this.connectedPuigpedros = false;
        this.sc = new Scanner(System.in);
        ;
        this.password_local = "";

    }

    public void agafaController(Controller c) {
        this.c = c;
    }


    public void connectarPuigpedros() {
        if (!connectedPuigpedros) {
            connPuigpedros = new BBDConnection("lsmotor_user", "lsmotor_bbdd", "F1", 3306);
            connectedPuigpedros = connPuigpedros.connect();
        }
    }

    public void connectarLocal() {
        if (!localConnectat) {
            novaConnLocal = new LocalConnection("root", "lasi2018", "F1_OLTP", 3306);
            localConnectat = novaConnLocal.connect();
        }
    }

    public void creaBBDDs() {
        if (localConnectat) {
            //PRIMER EXECUTAR FITXER AMB ELS DOS STORED PROC QUE CREEN TAULES I L'EVENT COPIA OLTP A OLAP
            //novaConnLocal.cridaProcedure("{CALL F1_OLTP.Create_oltp()}");
            //novaConnLocal.cridaProcedure("{CALL localolap.creaBBDD_olap()}");
        } else {
            System.out.println("Error, no s'ha pogut connectar a la base de dades local");

        }
    }

    public void omplirTaules() throws SQLException {

        ResultSet aux2;
        ResultSet rs;

        aux2 = connPuigpedros.selectQuery("SELECT * FROM races;");
        System.out.println("OMPLINT races...");
        while (aux2.next()) {


            if (aux2.getTime("time") == null) {
                String query = ("INSERT INTO races(raceId, year, round, circuitid, name, date, time, url)" + " VALUES ( " + aux2.getInt("raceId")  + "," + aux2.getInt("year") + ","
                        + aux2.getInt("round") + "," + aux2.getInt("circuitId") + ",'" + aux2.getString("name") + "','"
                        + aux2.getDate("date") + "',"
                        + "null" + ",'" + aux2.getString("url") + "' )");

                novaConnLocal.insertQuery(query);
            } else {
                String query = ("INSERT INTO races(raceId, year, round, circuitid, name, date, time, url)" + " VALUES ( "+ aux2.getInt("raceId")  + "," + aux2.getInt("year") + ","
                        + aux2.getInt("round") + "," + aux2.getInt("circuitId") + ",'" + aux2.getString("name") + "','"
                        + aux2.getDate("date") + "','"
                        + aux2.getTime("time") + "','" + aux2.getString("url") + "' )");

                novaConnLocal.insertQuery(query);
            }


        }

        aux2 = connPuigpedros.selectQuery("SELECT * FROM seasons;");
        System.out.println("OMPLINT seasons...");
        while (aux2.next()) {

            String query = ("INSERT INTO seasons(year, url)" + " VALUES ( " + aux2.getInt("year") + ",'" + aux2.getString("url") + "')");

            novaConnLocal.insertQuery(query);

        }


        aux2 = connPuigpedros.selectQuery("SELECT * FROM circuits;");
        System.out.println("OMPLINT circuits...");
        while (aux2.next()) {

            String query = ("INSERT INTO circuits(circuitId, circuitRef, name, location, country, lat, lng, alt, url)" +
                    " VALUES ( " + aux2.getInt("circuitId") + ",'" + aux2.getString("circuitRef") + "','"
                    + aux2.getString("name") + "','" + aux2.getString("location") + "','" + aux2.getString("country") + "'," +
                    aux2.getFloat("lat") + "," + aux2.getFloat("lng")
                    + "," + aux2.getInt("alt") + ",'" + aux2.getString("url") + "' )");

            novaConnLocal.insertQuery(query);

        }

        aux2 = connPuigpedros.selectQuery("SELECT * FROM constructors;");
        System.out.println("OMPLINT constructors...");
        while (aux2.next()) {

            String query = ("INSERT INTO constructors(constructorId, constructorRef, name, nationality, url)" + " VALUES ( " + aux2.getInt("constructorId") + ",'" + aux2.getString("constructorRef") + "','"
                    + aux2.getString("name") + "','" + aux2.getString("nationality") + "','" + aux2.getString("url") + "' )" +
                    "ON DUPLICATE KEY UPDATE constructorId=constructorId ");

            novaConnLocal.insertQuery(query);
        }

        aux2 = connPuigpedros.selectQuery("SELECT * FROM drivers;");
        System.out.println("OMPLINT drivers...");
        while (aux2.next()) {

            String query = ("INSERT INTO drivers(driverId, driverRef, number, code, forename, surname, dob, nationality, url)" + " VALUES ( "+ aux2.getInt("driverId") + ",\" " + aux2.getString("driverRef") + "\","
                    + aux2.getInt("number") + ",'" + aux2.getString("code") + "',\"" + aux2.getString("forename") +
                    "\",\"" + aux2.getString("surname") + "\",'" + aux2.getDate("dob") +
                    "','" + aux2.getString("nationality") + "','" + aux2.getString("url") + "' )" );

            novaConnLocal.insertQuery(query);

        }

        aux2 = connPuigpedros.selectQuery("SELECT * FROM results;");
        System.out.println("OMPLINT results...");
        while (aux2.next()) {


            String query = ("INSERT INTO results(resultId, raceId, driverId, constructorId, number, grid, position, positionText, positionOrder, " +
                    "points, laps, time, milliseconds, fastestLap, rank, fastestLapTime, fastestLapSpeed, statusId)" + " VALUES ( " + aux2.getInt("resultId") +
                    "," + aux2.getInt("raceId") + "," + aux2.getInt("driverId") + ","
                    + aux2.getInt("constructorId") + "," + aux2.getInt("number") + "," + aux2.getInt("grid") + "," + aux2.getInt("position")
                    + ",\"" + aux2.getString("positionText") + "\"," + aux2.getInt("positionOrder") +  "," + aux2.getFloat("points") +  "," + aux2.getInt("laps") +
                    ",\"" + aux2.getString("time") + "\"," + aux2.getInt("milliseconds") + "," + aux2.getInt("fastestLap")
                    + "," + aux2.getInt("rank") + ",\"" + aux2.getString("fastestLapTime")
                    + "\",\"" + aux2.getString("fastestLapSpeed")
                    + "\"," + aux2.getInt("statusId") + ")");

            novaConnLocal.insertQuery(query);

        }

        aux2 = connPuigpedros.selectQuery("SELECT * FROM qualifying;");
        System.out.println("OMPLINT qualifying...");
        while (aux2.next()) {

            String query = ("INSERT INTO qualifying(qualifyId, raceId, driverId, constructorId, number, position, q1, q2, q3)" + " VALUES ( " + aux2.getInt("qualifyId")  + "," + aux2.getInt("raceId") + "," + aux2.getInt("driverId") + ","
                    + aux2.getInt("constructorId") + "," + aux2.getInt("number") + "," + aux2.getInt("position")
                    + ",'" + aux2.getString("q1") +
                    "','" + aux2.getString("q2") + "','" + aux2.getString("q3") + "')");

            novaConnLocal.insertQuery(query);

        }

        aux2 = connPuigpedros.selectQuery("SELECT * FROM driverStandings;");
        System.out.println("OMPLINT driverStandings...");
        while (aux2.next()) {

            String query = ("INSERT INTO driverStandings(raceId, driverId, points, position, positionText, wins)" + " VALUES ( " + aux2.getInt("raceId") + "," + aux2.getInt("driverId") + ","
                    + aux2.getFloat("points") + "," + aux2.getInt("position") + ",'" + aux2.getString("positionText") +
                    "'," + aux2.getInt("wins") + ")");

            novaConnLocal.insertQuery(query);

        }

        aux2 = connPuigpedros.selectQuery("SELECT * FROM constructorResults;");
        System.out.println("OMPLINT constructorResults...");
        while (aux2.next()){

            String query = ("INSERT INTO constructorResults(raceId, constructorId, points, status)" + " VALUES ( " + aux2.getInt("raceId") + ","
                    + aux2.getInt("constructorId") + "," + aux2.getFloat("points") + ",'" + aux2.getString("status") + "' )" );

            novaConnLocal.insertQuery(query);


        }

        aux2 = connPuigpedros.selectQuery("SELECT * FROM constructorStandings;");
        System.out.println("OMPLINT constructorStandings...");
        while (aux2.next()){

            String query = ("INSERT INTO constructorStandings(raceId, constructorId, points, position, positionText, wins)" + " VALUES ( " + aux2.getInt("raceId") + "," + aux2.getInt("constructorId") + ","
                    + aux2.getFloat("points") + "," + aux2.getInt("position") + ",'" + aux2.getString("positionText") + "'," + aux2.getInt("wins") + ")" );

            novaConnLocal.insertQuery(query);



        }

        aux2 = connPuigpedros.selectQuery("SELECT * FROM lapTimes;");
        System.out.println("OMPLINT lapTimes...");
        while (aux2.next()) {

            String query = ("INSERT INTO lapTimes(raceId, driverId, lap, position, time, milliseconds)" + " VALUES ( " + aux2.getInt("raceId") + "," + aux2.getInt("driverId") + ","
                    + aux2.getInt("lap") + "," + aux2.getInt("position") + ",'" + aux2.getString("time") +
                    "'," + aux2.getInt("milliseconds") + ")");

            novaConnLocal.insertQuery(query);

        }

        aux2 = connPuigpedros.selectQuery("SELECT * FROM pitStops;");
        System.out.println("OMPLINT pitStops...");
        while (aux2.next()) {

            String query = ("INSERT INTO pitStops(raceId, driverId, stop, lap, time, duration, milliseconds)" + " VALUES ( " + aux2.getInt("raceId") + "," + aux2.getInt("driverId") + ","
                    + aux2.getInt("stop") + "," + aux2.getInt("lap") + ",'" + aux2.getString("time") +
                    "','" + aux2.getString("duration") + "'," + aux2.getInt("milliseconds") + ")");

            novaConnLocal.insertQuery(query);

        }

        aux2 = connPuigpedros.selectQuery("SELECT * FROM status;");
        System.out.println("OMPLINT status...");
        while (aux2.next()) {

            String query = ("INSERT INTO status(statusId, status)" + " VALUES ( " + aux2.getInt("statusId") + ",'" + aux2.getString("status") + "')");

            novaConnLocal.insertQuery(query);

        }


    }

}