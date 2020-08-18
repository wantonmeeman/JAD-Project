package mydbaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import myclasses.role;

public class RoleDB {
	PreparedStatement ppst;
	String query;
	ResultSet rs;
	Connection conn = null;
	Statement st;
	
	// Get All Roles
	public ArrayList<role> getAllRoles() {

		ArrayList<role> roles = new ArrayList<role>();
		role roleObj = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			return null;
		}
		try {
			query = "SELECT * FROM roles";
			ppst = conn.prepareStatement(query);
			rs = ppst.executeQuery();
			roleObj = null;

			while (rs.next()) {// rs.next() returns true if there is a row below the current one, and moves to
								// it when called.
				roleObj = new role();
				roleObj.setRoleid(rs.getString("role_id"));
				roleObj.setRolename(rs.getString("role_name"));
				roles.add(roleObj);
			}
			return roles;

		} catch (Exception E) {
			return null;
		}

	}

	// Get Role by roleID
	public role getRoleDetails(int RoleID) {
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			System.out.print(e);
			System.out.print("Stuff");
			return null;
		}
		if (conn == null) {
			System.out.print("Conn Error");
			// conn.close();
			return null;
		} else {
			role roleObj = new role();
			query = "SELECT * FROM roles where role_id = ? ";
			try {
				ppst = conn.prepareStatement(query);
				ppst.setInt(1, RoleID);
				rs = ppst.executeQuery();
				while (rs.next()) {
					roleObj.setRolename(rs.getString("role_name"));
					roleObj.setRoleid(rs.getString("role_id"));
				}
				System.out.print(roleObj.getRoleid());
				return roleObj;
			} catch (Exception e) {
				System.out.print(e);
				System.out.print("Stuff");
				return null;
			}
		}
	}

	// Get Number of Roles
	public int getTotalRoles() {
		int total_roles = 0;
		try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		}catch(Exception e){
			return 0;
		}
		try {
			query = "SELECT COUNT(*) as 'total_roles' FROM roles ";
			st = conn.createStatement();
			rs = st.executeQuery(query);
			while(rs.next()) {
				total_roles = rs.getInt("total_roles");
			}
			return total_roles;
		}catch(Exception e) {
			return 0;
		}
	}
	
	public ArrayList<role> getRoles(int page) {
		
		ArrayList<role> roles = new ArrayList<role>();
		role roleObj = null;
		try{
		  	Class.forName("com.mysql.jdbc.Driver");
		  	conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
		  	// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		}catch(Exception e){
			return null;
		}
		try {
		query = "SELECT * FROM roles LIMIT ? ,5";//Second Tab
		ppst = conn.prepareStatement(query);
		ppst.setInt(1,(page-1)*5);
	    rs = ppst.executeQuery();
		roleObj = null;
		
		
		while (rs.next()){//rs.next() returns true if there is a row below the current one, and moves to it when called.
			roleObj = new role();
			roleObj.setRoleid(rs.getString("role_id"));
	    	roleObj.setRolename(rs.getString("role_name"));
	    	roles.add(roleObj);
		}
		return roles;
		
		}catch(Exception E) {
			return null;
		}
		
	}
	
	public static int addRole(String roleName) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String connURL = "jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC";
			Connection conn = DriverManager.getConnection(connURL);

			String query = "INSERT INTO roles (role_name) VALUES (?)";
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, roleName);
			int rs = pstmt.executeUpdate();

			conn.close();

			return rs;
		} catch (Exception e) {
			System.out.println("Error :" + e);
			return 0;
		}
	}

	// Edit Role
	public boolean editRoleDetails(String role_name, int RoleID) {
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			System.out.print(e);
			return false;
		}
		if (conn == null) {
			System.out.print("Conn Error");
			// conn.close();
			return false;
		} else {
			// should we add null error redirecting? This involves a stupidly long if
			// statement.
			String query = "UPDATE roles SET role_name = ? WHERE role_id = ?";

			try {
				ppst = conn.prepareStatement(query);
				ppst.setString(1, role_name);
				ppst.setInt(2, RoleID);
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

	// Delete Role
	public boolean deleteRole(int RoleID) {
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
			String query = "DELETE FROM roles WHERE role_id = ?";
			PreparedStatement ppst = conn.prepareStatement(query);
			ppst.setInt(1, RoleID);
			int rs = ppst.executeUpdate();
			conn.close();
			if (rs != 1) {
				System.out.print("Database Error");
				return false;
			} else {
				return true;
			}

		} catch (Exception e) {
			return false;
		}
	}

}
