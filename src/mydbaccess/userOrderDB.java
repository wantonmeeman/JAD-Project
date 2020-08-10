package mydbaccess;

import java.sql.*;
import myclasses.order;
import myclasses.user;
import myclasses.role;
import java.util.ArrayList;
import java.io.StringWriter;
import java.io.PrintWriter;

public class userOrderDB {

	private PreparedStatement ppst;
	private Statement st;
	private String query;
	private ResultSet rs;
	private Connection conn;

	private String query1 = "";
	private String query2 = "";
	private ResultSet rs2;
	private ResultSet rs1;

	private String sortSuffix = "";
	private String timeSuffix = "";
	private String filterSuffix = "";

	private String orderUsername = "";
	private String orderEmail = "";
	private String orderPhoneNumber = "";

	private String orderProduct = "";

	private String orderDate = "";
	private int orderProductID = 0;
	private int orderUserID = 0;
	private String orderCardNumber = "";
	private String orderCCV = "";
	private String orderExpiryDate = "";
	private String orderAddress = "";
	private String orderZipCode = "";
	private String orderCompany = "";
	private double orderTotal = 0;
	private String orderNotes = "";
	private String orderQuantity = "";

	public ArrayList<user> getAllUser(String userSearch) {// First Tab
		ArrayList<user> users = new ArrayList<user>();
		user userObj = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			return null;
		}
		try {
			if (userSearch == null || userSearch.equals("")) {
				query = "SELECT * FROM users";
				st = conn.createStatement();
				rs = st.executeQuery(query);
			} else {
				query = "SELECT * FROM users WHERE username LIKE ?"; // Change this to a PPst
				ppst = conn.prepareStatement(query);
				ppst.setString(1, "%" + userSearch + "%");
				rs = ppst.executeQuery();
			}
			while (rs.next()) {// rs.next() returns true if there is a row below the current one, and moves to
								// it when called.
				userObj = new user();
				userObj.setUserid(rs.getInt("user_id"));
				userObj.setUsername(rs.getString("username"));
				userObj.setPassword(rs.getString("password"));
				userObj.setEmail(rs.getString("email"));
				userObj.setRole(rs.getString("role"));
				userObj.setFirstname(rs.getString("firstname"));
				userObj.setLastname(rs.getString("lastname"));
				userObj.setPhonenumber(rs.getString("phonenumber"));
				userObj.setCardnumber(rs.getString("cardnumber"));
				userObj.setCcv(rs.getString("ccv"));
				users.add(userObj);
			}
			return users;
		} catch (Exception e) {
			return null;
		}
	}

	public ArrayList<role> getAllRoles() {// Tab2

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
			query = "SELECT * FROM roles";// Second Tab
			st = conn.createStatement();
			rs = st.executeQuery(query);
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

	public ArrayList<order> getAllOrders(String orderSort, String timeSort, String filterValue, String filterCategory) {// Tab3
		ArrayList<order> orders = new ArrayList<order>();
		order orderObj = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn =  DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			return null;
		}

		try {
			query = "SELECT * FROM orders ";
			if (orderSort == null || orderSort.equals("DTime") || orderSort.equals("")) {
				sortSuffix = " ORDER BY date ";
			} else if (orderSort.equals("ATime")) {
				sortSuffix = " ORDER BY date DESC ";
			} else if (orderSort.equals("DTotal")) {
				sortSuffix = " ORDER BY total ";
			} else if (orderSort.equals("ATotal")) {
				sortSuffix = " ORDER BY total DESC ";
			} else if (orderSort.equals("DQuantity")) {
				sortSuffix = " ORDER BY quantity ";
			} else if (orderSort.equals("AQuantity")) {
				sortSuffix = " ORDER BY quantity DESC ";
			}

			if (timeSort == null || timeSort.equals("")) {
				timeSuffix = " ";
			} else if (timeSort.equals("Today")) {
				timeSuffix = "WHERE DATE(orders.date) = CURDATE()";
			} else if (timeSort.equals("Week")) {
				timeSuffix = "WHERE YEARWEEK(orders.date) = YEARWEEK(CURDATE())";
			} else if (timeSort.equals("Month")) {
																																// YearMonth
																																// Function
																																// :(
			}

			if (filterValue == null || filterCategory == null || filterValue.equals("") || filterCategory.equals("")
					|| filterCategory.equals("name") || filterCategory.equals("username")
					|| filterCategory.equals("email") || filterCategory.equals("phonenumber")) {
				filterSuffix = "";
				query = query + timeSuffix + filterSuffix + sortSuffix;
				st = conn.createStatement();
				rs = st.executeQuery(query);
			} else if (timeSort == null) {
				// the column name is not a user input so it should be fine?

				filterSuffix = "WHERE " + filterCategory + " LIKE ?";
				query = query + timeSuffix + filterSuffix + sortSuffix;
				ppst = conn.prepareStatement(query);
				ppst.setString(1, "%" + filterValue + "%");
				rs = ppst.executeQuery();

			} else {

				filterSuffix = "AND " + filterCategory + " LIKE ?";
				query = query + timeSuffix + filterSuffix + sortSuffix;
				ppst = conn.prepareStatement(query);
				ppst.setString(1, "%" + filterValue + "%");
				rs = ppst.executeQuery();
			}

			while (rs.next()) {
				orderObj = new order();
				orderObj.setOrderDate(rs.getString("date"));
				orderObj.setOrderProductID(rs.getInt("fk_productid"));
				orderObj.setOrderUserID(rs.getInt("fk_userid"));
				orderObj.setOrderCardNumber(rs.getString("cardnumber"));
				orderObj.setOrderCCV(rs.getString("CCV"));
				orderObj.setOrderExpiryDate(rs.getString("expirydate"));
				orderObj.setOrderAddress(rs.getString("address"));
				orderObj.setOrderZipCode(rs.getString("zipcode"));
				orderObj.setOrderCompany(rs.getString("company"));
				orderObj.setOrderTotal(rs.getDouble("total"));
				orderObj.setOrderNotes(rs.getString("notes"));
				orderObj.setOrderQuantity(rs.getString("quantity"));

				if (filterCategory == null || !filterCategory.equals("name")) {// if sort by username

					query1 = "SELECT name FROM products where product_id = ?";
					ppst = conn.prepareStatement(query1);
					ppst.setInt(1, rs.getInt("fk_productid"));
					rs1 = ppst.executeQuery();

				} else {
					query1 = "SELECT name FROM products where product_id = ? AND " + filterCategory + " LIKE ?";
					ppst = conn.prepareStatement(query1);
					ppst.setInt(1, rs.getInt("fk_productid"));
					ppst.setString(2, "%" + filterValue + "%");
					rs1 = ppst.executeQuery();

				}

				while (rs1.next()) {
					orderObj.setOrderProduct(rs1.getString("name"));
				}

				if (filterCategory == null || (!filterCategory.equals("username") && !filterCategory.equals("email")
						&& !filterCategory.equals("phonenumber"))) {
					query2 = "SELECT username,email,phonenumber FROM users where user_id = ?";
					ppst = conn.prepareStatement(query2);
					ppst.setInt(1, rs.getInt("fk_productid"));
					rs2 = ppst.executeQuery();

				} else {
					query2 = "SELECT username,email,phonenumber FROM users where user_id = ? AND " + filterCategory
							+ " LIKE ?";
					ppst = conn.prepareStatement(query2);
					ppst.setInt(1, rs.getInt("fk_productid"));
					ppst.setString(2, "%" + filterValue + "%");
					rs2 = ppst.executeQuery();

				}

				while (rs2.next()) {
					orderObj.setOrderUsername(rs2.getString("username"));
					orderObj.setOrderEmail(rs2.getString("Email"));
					orderObj.setOrderPhoneNumber(rs2.getString("phonenumber"));
				}
				if (!(orderObj.getOrderProduct() == null || orderObj.getOrderUsername() == null
						|| orderObj.getOrderEmail() == null || orderObj.getOrderPhoneNumber() == null)) {
					orders.add(orderObj);
				}
			}
			return orders;

		} catch (Exception e) {
			// Use this to return something to debug
//			StringWriter sw = new StringWriter();
//			PrintWriter pw = new PrintWriter(sw);
//			e.printStackTrace(pw);
//			String sStackTrace = sw.toString(); // stack trace as a string
//			orderObj.setOrderCCV(sStackTrace);
//			orders.add(orderObj);
//			return orders;
			return null;
		}

	}

	public ArrayList<user> getMaxUser(String userSearch4) {
		ArrayList<user> users = new ArrayList<user>();
		try {
			conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=root&password=alastair123&serverTimezone=UTC");
			// conn = DriverManager.getConnection("jdbc:mysql://localhost/digitgames?user=admin&password=@dmin1!&serverTimezone=UTC&characterEncoding=latin1");
		} catch (Exception e) {
			return null;
		}
		try {
			query = "SELECT fk_userid,SUM(total) as user_total FROM orders GROUP BY fk_userid order by user_total desc;";
			st = conn.createStatement();
			rs = st.executeQuery(query);
			
			while (rs.next()) {
				user userObj = new user();
				if (userSearch4 == null) {
					query1 = "SELECT username,email,phonenumber FROM users where user_id = ?";
					ppst = conn.prepareStatement(query1);
					ppst.setInt(1, rs.getInt("fk_userid"));
					rs1 = ppst.executeQuery();
				} else {
					query1 = "SELECT username,email,phonenumber FROM users where user_id = ? AND username LIKE ?";
					ppst = conn.prepareStatement(query1);
					ppst.setInt(1, rs.getInt("fk_userid"));
					ppst.setString(2, "%" + userSearch4 + "%");
					rs1 = ppst.executeQuery();
				}

				while (rs1.next()) {
					userObj.setUsername(rs1.getString("username"));
					userObj.setEmail(rs1.getString("Email"));
					userObj.setPhonenumber(rs1.getString("phonenumber"));
				}

				userObj.setTotal(rs.getDouble("user_total"));
				users.add(userObj);
			}
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			PrintWriter pw = new PrintWriter(sw);
//			e.printStackTrace(pw);
//			String sStackTrace = sw.toString(); // stack trace as a string
//			userObj.setUsername(sStackTrace); 
//			users.add(userObj);
//			return users;
			return null;
		}
		return users;

	}
}
