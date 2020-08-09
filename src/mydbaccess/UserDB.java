package mydbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import mydbaccess.UserDB;
import myclasses.user;

public class UserDB {

	public user getUser(String userid) {
		user userData = null;
		try {

			Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/jadprac6?user=root&password=alastair123&serverTimezone=UTC";
			Connection conn = DriverManager.getConnection(connURL);
			Statement stmt = conn.createStatement();

			String sqlStr = "SELECT * FROM user_details WHERE userid = '" + userid + "'";
			ResultSet rs = stmt.executeQuery(sqlStr);

			if (rs.next()) {
				userData = new user();
				userData.setUserid(Integer.parseInt(userid));

			}

			conn.close();

		} catch (Exception e) {
			System.out.println("Error :" + e);
		}

		return userData;
	}

	public void addUser(String username, String password, String email) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC";
			Connection conn = DriverManager.getConnection(connURL);

			String query = "INSERT INTO users(username,password,email,role) VALUES('" + username + "','" + password
					+ "','" + email + "','member')";
			Statement st = conn.createStatement();

			int rs = st.executeUpdate(query);
			if (rs != 1) {
				System.out.print("Error");
			}

			String Selectquery = "SELECT user_id FROM users WHERE username = '" + username + "' ORDER BY user_id DESC LIMIT 1";
			Statement Selectst = conn.createStatement();
			ResultSet Selectrs = Selectst.executeQuery(Selectquery);
			while (Selectrs.next()) {
				int userid = Selectrs.getInt("user_id");
				// response.sendRedirect("index.jsp?role=member&userid="+userid);
			}
			conn.close();

		} catch (Exception e) {
			System.out.println("Error :" + e);
		}
	}

	public void editUser(String email, String firstName, String lastName, String phoneNo, int userid) {
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC";
			Connection conn = DriverManager.getConnection(connURL);

			String query = "UPDATE users SET email = '"+email+"',  firstname = '"+firstName+"', lastname = '"+lastName+"', phonenumber = '"+phoneNo+"' WHERE user_id = "+userid;
			Statement st = conn.createStatement();

			int rs = st.executeUpdate(query);
			
			if (rs != 1) {
				System.out.print("Error");
			}

			conn.close();

		} catch (Exception e) {
			System.out.println("Error :" + e);
		}
		
	}
}
