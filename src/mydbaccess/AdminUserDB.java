package mydbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminUserDB {
	PreparedStatement ppst;
	String query;
	ResultSet rs;
	Connection conn = null;

	// Add User as Admin
	public static int adminAddUser(String username, String password, String email, String role, String firstname,
			String lastname, String phonenumber) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC";
			Connection conn = DriverManager.getConnection(connURL);

			String query = "INSERT INTO users (username, password, email, role, firstname, lastname, phonenumber) VALUES (?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, username);
			pstmt.setString(2, password);
			pstmt.setString(3, email);
			pstmt.setString(4, role);
			pstmt.setString(5, firstname);
			pstmt.setString(6, lastname);
			pstmt.setString(7, phonenumber);

			int rs = pstmt.executeUpdate();

			conn.close();

			return rs;
		} catch (Exception e) {
			System.out.println("Error :" + e);
			return 0;
		}
	}

	// Edit User Details (Admin)
	public boolean adminEditUser(String username, String password, String email, String firstname, String lastname,
			String phonenumber, String expirydate, String ccv, String cardnumber, String country, String zipcode,
			String address, String company, int UserID) {
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(
					"jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn =
			// DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");

		} catch (Exception e) {
			System.out.print(e);
			return false;
		}
		if (conn == null) {
			System.out.print("Conn Error");
			// conn.close();
			return false;
		} else {
			String query = "UPDATE users SET username = ?, password = ?, email = ?, firstname = ?, lastname = ?, phonenumber = ?, expirydate=?, CCV=?, cardnumber = ?, country = ?,  zipcode = ?, address = ?, company = ? WHERE user_id = ?";

			try {
				ppst = conn.prepareStatement(query);
				ppst.setString(1, username);
				ppst.setString(2, password);
				ppst.setString(3, email);
				ppst.setString(4, firstname);
				ppst.setString(5, lastname);
				ppst.setString(6, phonenumber);
				ppst.setString(7, expirydate);
				ppst.setString(8, ccv);
				ppst.setString(9, cardnumber);
				ppst.setString(10, country);
				ppst.setString(11, zipcode);
				ppst.setString(12, address);
				ppst.setString(13, company);
				ppst.setInt(14, UserID);
				int rs = ppst.executeUpdate();

				if (rs == 1) {
					return true;
				}
				return false;

			} catch (Exception e) {
				System.out.print(e);
				return false;
			}
		}
	}

	// Delete User
	public boolean deleteUser(int UserID) {
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			System.out.print(e);
			return false;
		}
		try {

			query = "DELETE FROM orders WHERE fk_userid = ?";
			PreparedStatement ppst = conn.prepareStatement(query);
			ppst.setInt(1, UserID);
			int rs = ppst.executeUpdate();
			query = "DELETE FROM users WHERE user_id = ?";
			ppst = conn.prepareStatement(query);
			ppst.setInt(1, UserID);
			rs = ppst.executeUpdate();
			if (rs != 1) {
				System.out.print(ppst.toString());
				System.out.print("Database Error");
				conn.close();
				return false;
			} else {
				conn.close();
				return true;
			}

		} catch (Exception e) {
			return false;
		}
	}
}
