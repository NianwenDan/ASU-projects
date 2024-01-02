package scenes;

import encryption.*;
import java.sql.*;
import java.time.LocalDateTime;

import sqlite.*;
import java.util.ArrayList;

import javafx.scene.layout.VBox;
import javafx.geometry.Pos;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.util.Duration;
import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.paint.Color;
import javafx.stage.Stage;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.time.temporal.ChronoUnit; 

public class Scenes {
	private SQLite sqldb = new SQLiteMain();
	private int role = 0; //cookies for login data
	private String user = "";
	private int id = 0;
	private LocalDateTime startTime; // Start time of activity
	private long elapsedTime; // Elapsed time of activity in seconds
	private String totalTime(long timeSpent) { // Format total time 
	    long hours = timeSpent / 3600;
	    long minutes = (timeSpent % 3600) / 60;
	    long seconds = timeSpent % 60;
	    String formattedTime = String.format("%02d:%02d:%02d", hours, minutes, seconds);
	    return "Time Duration: " + formattedTime;
	  }
	
	public Scene getAdmin(Connection db, Stage primaryStage) {
		TextArea console; // Text area to display console output
		ComboBox < String > dropdown1; // Dropdown for project selection
		ComboBox < String > dropdown2; // Dropdown for lifecycle step selection
		ComboBox < String > getDropDown; // Dropdown for effort category selection
		Label timerLabel; // Label to display elapsed time
	
		LocalDateTime startTime; // Start time of activity
		long elapsedTime; // Elapsed time of activity in seconds
		
		console = new TextArea();
	    console.setEditable(false); // Make the console uneditable
	    
	    String sql = String.format("select rowid, * from effortLogger_users where owner=%s;", Integer.toString(id)); 
		System.out.println(sql); //selects all users owned by the currecnt user and prints them to the console
		try {
		Statement stmt = db.createStatement();
		ResultSet rs = stmt.executeQuery(sql);
		while(rs.next())
		{
			String role; //converting numbers into role names
			if (rs.getInt("role") == 1) {
	    		role = "Admin";
	    	}
	    	else if (rs.getInt("role") == 2) {
	    		role = "Manager";
	    	}
	    	else {
	    		role = "Employee";
	    	}
			String s = String.format("username: %s, role: %s, enabled: %s\n", rs.getString("username"), role, rs.getInt("disabled") == 0?"Yes":"No");
			console.appendText(s);
		}
		} catch (Exception e) {
		System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
		
	    Label usertest = new Label("Create New User"); //creating console for creating new users
		TextField usernameField = new TextField();
		usernameField.setPromptText("Username");
		
		TextField passwordField = new TextField();
		passwordField.setPromptText("Password");
		
		dropdown1 = new ComboBox < > ();
	    dropdown1.getItems().addAll("Employee", "Manager", "Admin");
	    dropdown1.getSelectionModel().selectFirst();
	    dropdown2 = new ComboBox < > ();
	    dropdown2.getItems().addAll("Enabled", "Disabled");
	    dropdown2.getSelectionModel().selectFirst();
	    
	    Button submit = new Button("+");
	    submit.setOnAction(event -> {
	    	String value = "";
	    	String disabled = dropdown2.getValue().equals("Enabled")?"0" : "1";
	    	String username = usernameField.getText();
	    	String password = SHA256.hash(passwordField.getText());
	    	String owner = Integer.toString(id);
	    	String role;
	    	if (dropdown1.getValue().equals("Admin")) {
	    		role = "1";
	    	}
	    	else if (dropdown1.getValue().equals("Manager")) {
	    		role = "2";
	    	}
	    	else {
	    		role = "3";
	    	}
	    	value = String.format("'%s','%s',%s,%s,%s", username, password, role, owner, disabled);
	    	sqldb.setInsert(db, "effortLogger_users", value); 
	    	Scene scene = getManager(db, primaryStage);
			primaryStage.setScene(scene);
			primaryStage.show();
	    });
	    
	    HBox dropdownBox = new HBox(10, usertest, usernameField, passwordField, dropdown1, dropdown2, submit);
	    dropdownBox.setAlignment(Pos.CENTER);
	    Button consoleButton = new Button("Console");
	      consoleButton.setOnAction(nevent -> {
		    	//tOdo
		    	Scene scene = getConsole(db, primaryStage);
				primaryStage.setScene(scene);
				primaryStage.show();
		    });
	    BorderPane borderPane = new BorderPane(); // Create the BorderPane layout and set the nodes
	    borderPane.setTop(dropdownBox);
	    borderPane.setCenter(console);
	    borderPane.setBottom(consoleButton);

	    Scene scene = new Scene(borderPane, 800, 600); // Create the scene, set it to the primaryStage and display

	    return scene;
	}
	public Scene getManager(Connection db, Stage primaryStage) { //Returns Manager Page to create employees same as Admin with less options
		TextArea console; // Text area to display console output
		ComboBox < String > dropdown1; // Dropdown for project selection
		ComboBox < String > dropdown2; // Dropdown for lifecycle step selection
		ComboBox < String > getDropDown; // Dropdown for effort category selection
		Label timerLabel; // Label to display elapsed time
	
		LocalDateTime startTime; // Start time of activity
		long elapsedTime; // Elapsed time of activity in seconds
		
		console = new TextArea();
	    console.setEditable(false); // Make the console uneditable
	    Label usertest = new Label("Create New User");
		TextField usernameField = new TextField();
		usernameField.setPromptText("Username");
		
		TextField passwordField = new TextField();
		passwordField.setPromptText("Password");
		
		dropdown1 = new ComboBox < > ();
	    dropdown1.getItems().addAll("Employee");
	    dropdown1.getSelectionModel().selectFirst();
	    dropdown2 = new ComboBox < > ();
	    dropdown2.getItems().addAll("Enabled", "Disabled");
	    dropdown2.getSelectionModel().selectFirst();
	    
		String sql = String.format("select rowid, * from effortLogger_users where owner=%s;", Integer.toString(id));
		System.out.println(sql);
		try {
		Statement stmt = db.createStatement();
		ResultSet rs = stmt.executeQuery(sql);
		while(rs.next())
		{
			String role;
			if (rs.getInt("role") == 1) {
	    		role = "Admin";
	    	}
	    	else if (rs.getInt("role") == 2) {
	    		role = "Manager";
	    	}
	    	else {
	    		role = "Employee";
	    	}
			String s = String.format("username: %s, role: %s, enabled: %s\n", rs.getString("username"), role, rs.getInt("disabled") == 0?"Yes":"No");
			console.appendText(s);
		}
		} catch (Exception e) {
		System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		}
			
	    
	    Button submit = new Button("+");
	    submit.setOnAction(event -> {
	    	String value = "";
	    	String disabled = dropdown2.getValue().equals("Enabled")?"0" : "1";
	    	String username = usernameField.getText();
	    	String password = SHA256.hash(passwordField.getText());
	    	String owner = Integer.toString(id);
	    	String role;
	    	if (dropdown2.getValue().equals("Admin")) {
	    		role = "1";
	    	}
	    	else if (dropdown2.getValue().equals("Manager")) {
	    		role = "2";
	    	}
	    	else {
	    		role = "3";
	    	}
	    	value = String.format("'%s','%s',%s,%s,%s", username, password, role, owner, disabled);
	    	sqldb.setInsert(db, "effortLogger_users", value); 
	    	Scene scene = getManager(db, primaryStage);
			primaryStage.setScene(scene);
			primaryStage.show();
	    });
	    
	    HBox dropdownBox = new HBox(10, usertest, usernameField, passwordField, dropdown1, dropdown2, submit);
	    dropdownBox.setAlignment(Pos.CENTER);
	    Button consoleButton = new Button("Console");
	      consoleButton.setOnAction(nevent -> {
		    	//tOdo
		    	Scene scene = getConsole(db, primaryStage);
				primaryStage.setScene(scene);
				primaryStage.show();
		    });
	    BorderPane borderPane = new BorderPane(); // Create the BorderPane layout and set the nodes
	    borderPane.setTop(dropdownBox);
	    borderPane.setCenter(console);
	    borderPane.setBottom(consoleButton);
	    Scene scene = new Scene(borderPane, 800, 600); // Create the scene, set it to the primaryStage and display

	    return scene;
	}
	public Scene getConsole(Connection db, Stage primaryStage){
		TextArea console; // Text area to display console output
		ComboBox < String > dropdown1; // Dropdown for project selection
		ComboBox < String > dropdown2; // Dropdown for lifecycle step selection
		ComboBox < String > getDropDown; // Dropdown for effort category selection
		Label timerLabel; // Label to display elapsed time
		
		console = new TextArea();
	    console.setEditable(false); // Make the console uneditable

	    Label projectLabel = new Label("Select a project:");
	    Label usertest = new Label("Hello, " + user + "!");
	    Label roletest = new Label(Integer.toString(role));
	    dropdown1 = new ComboBox < > ();
	    dropdown1.getItems().addAll("Development Project A", "Development Project B", "Development Project C");

	    Label effortLabel = new Label("Life Cycle Step:");
	    dropdown2 = new ComboBox < > ();
	    dropdown2.getItems().addAll("Step A", "Step B", "Step C");

	    Label categoryLabel = new Label("Select an effort category:");
	    getDropDown = new ComboBox < > ();
	    getDropDown.getItems().addAll("Category A", "Category B", "Category C");

	    timerLabel = new Label("00:00:00"); // Initialize timer label

	    Button startButton = new Button("Start an Activity");
	    startButton.setOnAction(event -> {
	        startTime = LocalDateTime.now(); // Set start time to current time
	        elapsedTime = 0; // Reset elapsed time
	        console.appendText(user + " started activity for " +
	          dropdown1.getValue() + ", " +
	          dropdown2.getValue() + ", " +
	          getDropDown.getValue() + "\n"); // Update console with activity start message
	      });
	    
	    Button stopButton = new Button("Stop Activity");
	    stopButton.setOnAction(event -> {
	        if (startTime != null) {
	          LocalDateTime endTime = LocalDateTime.now(); // Get current time as end time
	          elapsedTime = ChronoUnit.SECONDS.between(startTime, endTime); // Calculate elapsed time
	          console.appendText(user + " stopped activity. " + totalTime(elapsedTime) + "\n"); // Update console with activity stop message and elapsed time
	          String value = String.format("'%s','%s','%s','%s','%s'", user, dropdown1.getValue(), dropdown2.getValue(), getDropDown.getValue(), totalTime(elapsedTime));
	          sqldb.setInsert(db, "effortLogger_logs", value); 
	          startTime = null; // Reset start time
	          elapsedTime = 0; // Reset elapsed time
	          
	        }
	      });
	    
	    Button managerButton = new Button("Manager");
	    Button adminButton = new Button("Admin");
	    
	    managerButton.setOnAction(event -> {
	    	//tOdo
	    	Scene scene = getManager(db, primaryStage);
			primaryStage.setScene(scene);
			primaryStage.show();
	    });
	    
	    adminButton.setOnAction(event -> {
	    	//tOdo
	    	Scene scene = getAdmin(db, primaryStage);
			primaryStage.setScene(scene);
			primaryStage.show();
	    });
	    
	    Button logButton = new Button("Show Logs"); // Button to show console logs
	    logButton.setOnAction(event -> {
	    	//tOdo
	      TextArea logConsole = new TextArea();
	      logConsole.setEditable(false);
	      logConsole.setText(console.getText()); // Set the text in the new console to be the same as the main console
	      String sql = String.format("select rowid, * from effortLogger_logs where user='%s';", user); //gets all logs owned by user
	      System.out.println(sql);
	      try {
	    	  Statement stmt = db.createStatement();
	    	  ResultSet rs = stmt.executeQuery(sql);
	    	  while(rs.next())
	    	  {
	    		  String logUser = rs.getString(2); //reprints all the logs from the query
	    		  String logProj = rs.getString(3);
	    		  String logCycle = rs.getString(4);
	    		  String logCatagory = rs.getString(5);
	    		  String logTime = rs.getString(6);
	    		  logConsole.appendText(logUser + " started activity for " +
	    		          logProj + ", " +
	    		          logCycle + ", " +
	    		          logCatagory + "\n");
	    	      logConsole.appendText(logUser + " stopped activity. " + logTime + "\n");
	    	  }
			} catch (Exception e) {
				System.err.println( e.getClass().getName() + ": " + e.getMessage() );
			}
	      
	      Button consoleButton = new Button("Console");
	      consoleButton.setOnAction(nevent -> {
		    	//tOdo
		    	Scene scene = getConsole(db, primaryStage);
				primaryStage.setScene(scene);
				primaryStage.show();
		    });
	      
	      VBox logBox = new VBox(logConsole, consoleButton);
	      Scene logScene = new Scene(logBox, 800, 600);
	      primaryStage.setScene(logScene);
	      primaryStage.show();
	      
	    });

	    HBox buttonBox = new HBox();
	    if (role == 1) {
		    buttonBox.getChildren().addAll(startButton, stopButton, logButton, adminButton); // Add all buttons to the button box + admin
	    }
	    else if (role == 2) {
		    buttonBox.getChildren().addAll(startButton, stopButton, logButton, managerButton); // Add all buttons to the button box + manager
	    }
	    else {
		    buttonBox.getChildren().addAll(startButton, stopButton, logButton); // Add all buttons to the button box
	    }
	    buttonBox.setSpacing(10); // Button alignment set to left
	    buttonBox.setAlignment(Pos.CENTER_LEFT); // buttonBox.setAlignment(Pos.CENTER_LEFT);
	    
	    HBox dropdownBox = new HBox(10, usertest, projectLabel, dropdown1, // Dropdown boxes alignment set to center
  		      effortLabel, dropdown2,
  		      categoryLabel, getDropDown);
	    dropdownBox.setAlignment(Pos.CENTER);

	    BorderPane borderPane = new BorderPane(); // Create the BorderPane layout and set the nodes
	    borderPane.setTop(dropdownBox);
	    borderPane.setCenter(console);
	    borderPane.setBottom(buttonBox);
	    borderPane.setRight(timerLabel);

	    Scene scene = new Scene(borderPane, 800, 600); // Create the scene, set it to the primaryStage and display
	    
	    Timeline timeline = new Timeline(new KeyFrame(Duration.seconds(1), event -> { // Update timer label every second
	        if (startTime != null) {
	          LocalDateTime now = LocalDateTime.now();
	          elapsedTime = ChronoUnit.SECONDS.between(startTime, now);
	          timerLabel.setText("" + totalTime(elapsedTime));
	        }
	      }));
	      timeline.setCycleCount(Timeline.INDEFINITE);
	      timeline.play();
	      
	    return scene;
	}
	public Scene getLogin(Connection db, Stage primaryStage){
		
		BorderPane borderPane; 
		GridPane loginPane;
		HBox box;
		
		Label usernameLabel;
		Label passwordLabel;
		Label loginStatus;
		
		TextField usernameField;
		PasswordField passwordField;
		
		Button loginButton;
		
		String username = "username";
		String password = "password";
		
	    final int WINSIZE_X = 400, WINSIZE_Y = 200;

		borderPane = new BorderPane();
		borderPane.setPadding(new Insets(20,20,20,30));
		

		box = new HBox();
		box.setPadding(new Insets(20,20,20,30));
		
		
		loginPane = new GridPane();
		loginPane.setPadding(new Insets(20,20,20,20));
		loginPane.setHgap(5);
		loginPane.setVgap(5);


		
		usernameLabel = new Label("Username");
		usernameField = new TextField();
		
		passwordLabel = new Label("Password");
		passwordField = new PasswordField();
		
		loginButton = new Button("Login");
		
		loginStatus = new Label("");
		loginPane.add(usernameLabel, 0, 0);
		loginPane.add(usernameField, 1, 0);
		loginPane.add(passwordLabel, 0, 1);
		loginPane.add(passwordField, 1, 1);
		loginPane.add(loginButton, 2, 1);
		loginPane.add(loginStatus, 1, 2);
		

		loginButton.setOnAction(new EventHandler<ActionEvent>()
		{
			public void handle(ActionEvent even)
			{
				String usernameInput = usernameField.getText().toString(); 
				String passwordInput = passwordField.getText().toString();
				String regex = "^[a-zA-Z0-9_]*$";
				Pattern pattern = Pattern.compile(regex);
			    Matcher matcher = pattern.matcher(usernameInput);
			    boolean bool = matcher.matches();
			    matcher = pattern.matcher(passwordInput);
			    bool = bool || matcher.matches();
			    
			    if(!bool) {
			    	loginStatus.setText("Login Attempt Failed");
					loginStatus.setTextFill(Color.RED);
					passwordField.clear();
			    }
			    else {
				String sql = String.format("SELECT rowid, * FROM effortLogger_users WHERE username = '%s' AND password = '%s' AND disabled = 0;", usernameInput, SHA256.hash(passwordInput));
				System.out.println(sql); //logs in with sha256 hash of password
				try {
				Statement stmt = db.createStatement();
				ResultSet rs = stmt.executeQuery(sql);
				if(rs.next())
				{
					loginStatus.setText("Login Attempt Successful");
					loginStatus.setTextFill(Color.GREEN);
					usernameField.clear();
					passwordField.clear();
					role = rs.getInt(4);
					user = rs.getString(2);
					id = rs.getInt(1);
					Scene scene = getConsole(db, primaryStage);
					primaryStage.setScene(scene);
					primaryStage.show();
					
				}
				else
				{
					loginStatus.setText("Login Attempt Failed");
					loginStatus.setTextFill(Color.RED);
					passwordField.clear();
				}
				} catch (Exception e) {
				System.err.println( e.getClass().getName() + ": " + e.getMessage() );
				}
				
			}
			    }
		});
		
		borderPane.setTop(box);
		borderPane.setCenter(loginPane);
		
		Scene scene = new Scene(borderPane, WINSIZE_X, WINSIZE_Y);
		return scene;
	}
}
