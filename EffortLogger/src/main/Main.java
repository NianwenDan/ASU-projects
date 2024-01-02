package main;

import java.sql.*;
import sqlite.*;
import java.util.ArrayList;
import java.util.HashMap;

import encryption.*;

public class Main {

	public static void main(String[] args) {
		
		SQLite sqldb = new SQLiteMain();
		
		System.out.println(sqldb.isFileExists("data.db"));
		
		Connection db = sqldb.getConnect("data.db");
		
		String tableName = "effortLogger_users";
		String[] tableDesc = {
				"username TEXT NOT NULL",
				"password TEXT NOT NULL",
				"role INTEGER DEFAULT 0",
				"disabled INTEGER DEFAULT 0"
		};
		
		sqldb.setNewTable(db, tableName, tableDesc);
		
		// Insert admin user
		sqldb.setInsert(db, tableName, String.format("'admin', '%s', 1, 0", SHA256.hash("password")));
		
		// Update admin user

		sqldb.setUpdate(db, tableName, String.format("password=%s", sqldb.sqlString(SHA256.hash("newPassword"))), "rowid=1");
		
//		sql = String.format("INSERT INTO effortLogger_users VALUES('username', '%s', 2, 0);", SHA256.hash("mypass"));
//		try {
//		stmt = db.createStatement();
//		stmt.executeUpdate(sql);
//		} catch (Exception e) {
//		System.err.println( e.getClass().getName() + ": " + e.getMessage() );
//		}

		// sqldb.setUpdate(db, tableName, String.format("password=%s", sqldb.sqlString(sha.hash("newPassword"))), "rowid=1");
		sqldb.setInsert(db, tableName, String.format("'username', '%s', 2, 0", SHA256.hash("mypass")));

		
		String header = "username, password";
		for (int i = 0; i < 10; ++i) {
			String randUserName = randString();
			String randUserPwd = randNumber();
			String value = String.format("%s, %s", sqldb.sqlString(randUserName), sqldb.sqlString(randUserPwd));
			
			sqldb.setInsert(db, tableName, header, value);
		}
		
		String[] cHeader = {"rowid", "username"};
		String[] condition = {"rowid=1"};
		
		HashMap<Integer, ArrayList<String>> b = sqldb.getData(db, tableName, cHeader, condition);
		
		System.out.println(b);
		
		// Drop Table
		//sqldb.setDropTable(db, tableName);
		
		
		sqldb.setClose(db);
	}
	
	public static String randString() {
		String AlphaNumericStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz0123456789";
		String str = "";
		
		for (int i = 0; i < 5; ++i) {
			int random = 0 + (int)(Math.random() * AlphaNumericStr.length());
			str += AlphaNumericStr.substring(random, random+1);
		}
		return str;
	}
	
	public static String randNumber() {
		String str = "";
		for (int i = 0; i < 14; ++i) {
			int random = 0 + (int)(Math.random() * 10);
			str += String.valueOf(random);
		}
		return str;
	}

}
