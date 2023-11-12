package org.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MufawtarDB {

    private static MufawtarDB instance;
    private Connection connection;
    private String url = "jdbc:mysql://127.0.0.1:3306/DBconn";
    private String username = "root"; // or your username
    private String password = "Saleh2035371"; // or your password

    private MufawtarDB() {
        try {
            this.connection = DriverManager.getConnection(url, username, password);
        } catch (SQLException e) {
            System.out.println("Database Creation Failed : " + e.getMessage());
        }
    }

    public Connection getConnection() {
        return connection;
    }

    public static MufawtarDB getInstance() {
        if (instance == null) {
            instance = new MufawtarDB();

        }

        return instance;
    }
}
