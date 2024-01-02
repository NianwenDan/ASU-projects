package sqlite;

import java.io.File;
import java.sql.*;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

public class SQLiteMain implements SQLite {
	
	@Override
	public boolean isFileExists(String path) {
		File f = new File(path);
		if (f.exists() && !f.isDirectory()) {
			return true;
		}
		return false;
	}

	@Override
	public Connection getConnect(String path) {
		Connection c = null;
		path = "jdbc:sqlite:" + path;
		
	    try {
	      c = DriverManager.getConnection(path);
	    } catch (Exception e) {
	      System.err.println( e.getClass().getName() + ": " + e.getMessage() );
	      System.exit(0);
	    }
	    System.out.println("Opened database successfully");
		return c;
	}

	@Override
	public void setNewTable(Connection db, String tbname, String[] column) {
		Statement stmt = null;
		// Build SQL query
		String sql = "CREATE TABLE IF NOT EXISTS " + tbname + " (";
		for (int i = 0; i < column.length; ++i) {
			if (i != 0) {
				sql += ",";
			}
			sql += column[i];
		}
		sql += ");";
		System.out.println(sql);
		
		try {
			stmt = db.createStatement();
			// Execute SQL query
			stmt.executeUpdate(sql);
			stmt.close();
		} catch (Exception e) {
			System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
	}
	
	@Override
	public String typeOf(Connection db, String tbname, String header){
		String type = null;
		Statement stmt = null;
		String sql = String.format("SELECT typeof(%s) AS type from %s LIMIT 1;", header, tbname);
		try {
			stmt = db.createStatement();
			// Execute SQL query
			ResultSet rs = stmt.executeQuery(sql);
		    type = rs.getString("type");
			stmt.close();
		} catch (Exception e) {
			System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
		return type;
	}
	
	@Override
	public void setInsert(Connection db, String tbname, String header, String values) {
		Statement stmt = null;
		String sql = String.format("INSERT INTO %s (%s) VALUES (%s);", tbname, header, values);
		System.out.println(sql);
		
		try {
			stmt = db.createStatement();
			stmt.executeUpdate(sql);
		} catch (Exception e) {
			System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
	}
	
	@Override
	public void setInsert(Connection db, String tbname, String values) {
		Statement stmt = null;
		String sql = String.format("INSERT INTO %s VALUES (%s);", tbname, values);
		System.out.println(sql);
		
		try {
			stmt = db.createStatement();
			stmt.executeUpdate(sql);
		} catch (Exception e) {
			System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
	}
	
	@Override
	public void setUpdate(Connection db, String tbname, String setter, String condition) {
		Statement stmt = null;
		String sql = String.format("UPDATE %s SET %s WHERE %s;", tbname, setter, condition);
		System.out.println(sql);
		
		try {
			stmt = db.createStatement();
			stmt.executeUpdate(sql);
		} catch (Exception e) {
			System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
	}
	
	@Override
	public HashMap<Integer, ArrayList<String>> getData(Connection db, String tbname, String[] header) {
		Statement stmt = null;
		HashMap<Integer, ArrayList<String>> retuenVal = new HashMap<>();
		// Build SQL query
		String sqlHeader = buildSql(header);
		String sql = String.format("SELECT %s FROM %s;", sqlHeader, tbname);
		System.out.println(sql);
		try {
			stmt = db.createStatement();
			ResultSet rs = stmt.executeQuery(sql);
			int counter = 0;
			while (rs.next()) {
				// Create a new map
				retuenVal.put(counter, new ArrayList<String>());
				for (String i : header) {
					// Add values to the ArrayList in current map
					retuenVal.get(counter).add(rs.getString(i));
				}
				++counter;
			}
			rs.close();
			stmt.close();
		} catch (Exception e) {
			System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
		return retuenVal;
	}

	@Override
	public HashMap<Integer, ArrayList<String>> getData(Connection db, String tbname, String[] header, String[] condition) {
		Statement stmt = null;
		HashMap<Integer, ArrayList<String>> retuenVal = new HashMap<>();
		// Build SQL query
		String sqlHeader = buildSql(header);
		String sqlCondition = buildSql(condition);
		String sql = String.format("SELECT %s FROM %s WHERE %s;", sqlHeader, tbname, sqlCondition);
		System.out.println(sql);
		try {
			stmt = db.createStatement();
			ResultSet rs = stmt.executeQuery(sql);
			int counter = 0;
			while (rs.next()) {
				// Create a new map
				retuenVal.put(counter, new ArrayList<String>());
				for (String i : header) {
					// Add values to the ArrayList in current map
					retuenVal.get(counter).add(rs.getString(i));
				}
				++counter;
			}
			rs.close();
			stmt.close();
		} catch (Exception e) {
			System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
		return retuenVal;
	}
	
	@Override
	public void setDropTable(Connection db, String tbname) {
		Statement stmt = null;
		
		String sql = String.format("DROP TABLE %s", tbname);
		System.out.println(sql);
		try {
			stmt = db.createStatement();
			stmt.executeUpdate(sql);
		} catch (Exception e) {
			System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
	}

	@Override
	public void setClose(Connection db) {
		try {
			db.close();
		} catch (Exception e) {
			System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
		System.out.println("Database successfully closed");
	}
	
	public String sqlString(String s) {
		return "'" + s + "'";
	}
	
	public String buildSql(String[] s) {
		String returnString = "";
		for (int i = 0; i < s.length; ++i) {
			if (i != 0) {
				returnString += ",";
			}
			returnString += s[i];
		}
		return returnString;
	}
	
}
