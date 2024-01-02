package application;
	
import java.sql.Connection;

import encryption.SHA256;
import javafx.application.Application;
import javafx.stage.Stage;
import scenes.Scenes;
import sqlite.SQLite;
import sqlite.SQLiteMain;
import javafx.scene.Scene;


public class Main extends Application {
	@Override
	public void start(Stage primaryStage) {
		SQLite sqldb = new SQLiteMain();
		Connection db = sqldb.getConnect("data.db");
		Scenes process = new Scenes(); 
		try {
			Scene scene = process.getLogin(db, primaryStage);
			primaryStage.setScene(scene);
			primaryStage.show();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void dbInit() {
		String dbName = "data.db";
		String tableName01 = "effortLogger_users";
		String[] tableDesc01 = {
				"username TEXT NOT NULL",
				"password TEXT NOT NULL",
				"role INTEGER DEFAULT 0",
				"owner INTEGER DEFAULT 0",
				"disabled INTEGER DEFAULT 0"
		};
		String tableName02 = "effortLogger_logs";
		String[] tableDesc02 = {
				"user TEXT NOT NULL",
				"project TEXT NOT NULL",
				"lifecycle TEXT NOT NULL",
				"catagory TEXT NOT NULL",
				"time TEXT NOT NULL",
		};
		SQLite sqldb = new SQLiteMain();
		if (!sqldb.isFileExists(dbName)) {
			System.out.println(String.format("Database %s DOES NOT EXIST, a new database is created!", dbName));
			Connection db = sqldb.getConnect(dbName);
			
			// Create a new table
			sqldb.setNewTable(db, tableName01, tableDesc01);
			sqldb.setNewTable(db, tableName02, tableDesc02);
			
			// Insert admin user
			sqldb.setInsert(db, tableName01, String.format("'admin', '%s', 1, -1, 0", SHA256.hash("password")));
			
			// Insert normal user
			sqldb.setInsert(db, tableName01, String.format("'manager', '%s', 2, 1, 0", SHA256.hash("password")));
			String val = String.format("'%s','%s','%s','%s','%s'", "Jordan", "Project B", "Step C", "Category A", "Time Duration: 00:03:02");
			sqldb.setInsert(db, tableName02, val);
			
			sqldb.setClose(db);
		}
		
	}
	
	public static void main(String[] args) {
		dbInit();
		launch(args);
	}
}
