import Controller.BBDConnection;
import Model.Importacions;

import java.sql.SQLException;
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) throws SQLException {

        Importacions imp = new Importacions();


        imp.connectarPuigpedros();

        imp.connectarLocal();
        imp.creaBBDDs();
        imp.omplirTaules();





    }
}
