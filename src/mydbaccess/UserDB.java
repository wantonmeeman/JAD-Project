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

	public void addUser() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC";
			Connection conn = DriverManager.getConnection(connURL);

			String query = "INSERT INTO users(user_id, username, password, ) VALUES ()";
			PreparedStatement pstmt = conn.prepareStatement(query);

			pstmt.setString(1, name);
			pstmt.setString(2, briefDesc);
			pstmt.setString(3, detailedDesc);
			pstmt.setFloat(4, Float.parseFloat(c_price));
			pstmt.setFloat(5, Float.parseFloat(r_price));
			pstmt.setInt(6, Integer.parseInt(stockQuantity));
			pstmt.setString(7, productCat);
			pstmt.setString(8, sold);

			int rs = pstmt.executeUpdate();

			if (rs != 0) {
				query = "SELECT product_id FROM products WHERE name = ?";
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, name);

				ResultSet productIdRS = pstmt.executeQuery();

				if (productIdRS.next()) {
					productId = productIdRS.getInt("product_id");
				}
			}

			conn.close();

		} catch (Exception e) {
			System.out.println("Error :" + e);
		}
	}

	public user editUser() {
		return null;
	}
}
