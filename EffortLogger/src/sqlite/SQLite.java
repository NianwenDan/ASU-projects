package sqlite;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public interface SQLite {
	
	public boolean isFileExists(String path);
	
	/** 
	 * Connects to database. If database does not exist, it will create one. 
	 * @param path: Path where database is stored. 
	 * @return Connection: Connection object from which you do operations on database. 
	 */
	public Connection getConnect(String path);
	
	/**
	 * Creates new table in the database. 
	 * @param db: Connection object.
	 * @param tbname: Table name. 
	 * @param column: Names columns and settings for a table. Look at String [][] tableDesc for example. 
	 * @return boolean: True if success. 
	 */
	public void setNewTable(Connection db, String tbname, String[] column);
	
	public String typeOf(Connection db, String tbname, String header);
	
	/**
	 * Insertion method. Accepts header and values array (equal length) in order to add values to table. See Main.java for example. 
	 * @param db: Connection object. 
	 * @param tbname: Table name. 
	 * @param header: String array of headers to append to. 
	 * @param values: String array of values to add to said headers. 
	 * @return: Returns True if success. 
	 */
	public void setInsert(Connection db, String tbname, String header, String values);
	
	public void setInsert(Connection db, String tbname, String values);
	
	public void setUpdate(Connection db, String tbname, String setter, String condition);
	
	public HashMap<Integer, ArrayList<String>> getData(Connection db, String tbname, String[] header);
	
	public HashMap<Integer, ArrayList<String>> getData(Connection db, String tbname, String[] header, String[] condition);
	
	public void setDropTable(Connection db, String tbname);
	
	public void setClose(Connection db);
	
	public String sqlString(String s);
}
